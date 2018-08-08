//
//  Authentification.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 25/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import OAuth2
import CoreData

open class AuthentificationService {

  // MARK: Properties

  public var oauth2: OAuth2PasswordGrant
  let appDelegate = UIApplication.shared.delegate as! AppDelegate

  // MARK: Initialization

  public init(username: String, password: String) {
    var keys: NSDictionary!
    if let path = Bundle.main.path(forResource: "oauthInfo", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    oauth2 = OAuth2PasswordGrant(settings: [
      "client_id": keys["parseClientId"]!,
      "client_secret": keys["parseClientSecret"]!,
      "token_uri": "\(keys["parseUrl"]!)/oauth/token",
      "username": username,
      "password": password,
      "grant_type": "password",
      "scope": "public read:profile read:lexicon read:plots read:crops read:interventions write:interventions read:equipment write:equipment read:articles write:articles read:person write:person",
      "verbose": true
      ] as OAuth2JSON)
  }

  // MARK: Actions

  func emptyUsersList() {
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        context.delete(data)
      }
      try context.save()
    } catch {
      print("Remove failed")
    }
  }

  public func authorize(presenting view: UIViewController) {
    oauth2.authorizeEmbedded(from: view) { (authParameters, error) in
      if let _ = authParameters {
        print("Authrorization succed")
      }
      else {
        print("Authorization was canceled or went wrong: \(String(describing: error?.description))")
      }
      self.appDelegate.saveContext()
    }
  }

  public func logout() {
    oauth2.username = nil
    oauth2.password = nil
    oauth2.forgetTokens()
  }
}
