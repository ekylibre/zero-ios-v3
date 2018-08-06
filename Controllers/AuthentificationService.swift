//
//  Authentification.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 25/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation
import UIKit
import OAuth2
import CoreData

open class AuthentificationService {

  public var oauth2: OAuth2PasswordGrant
  let appDelegate = UIApplication.shared.delegate as! AppDelegate

  public init(username: String, password: String) {
    var keys: NSDictionary!
    if let path = Bundle.main.path(forResource: "oauthInfo", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    oauth2 = OAuth2PasswordGrant(settings: [
      "client_id": keys["parseClientId"]!,
      "client_secret": keys["parseClientSecret"]!,
      "token_uri": keys["parseTokenUrl"]!,
      "username": username,
      "password": password,
      "grant_type": "password",
      "scope": "public read:profile read:lexicon read:plots read:crops read:interventions write:interventions read:equipment write:equipment read:articles write:articles read:person write:person",
      "verbose": true
      ] as OAuth2JSON)
  }

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
    emptyUsersList()
    let context = appDelegate.persistentContainer.viewContext
    let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context) as! Users

    oauth2.authorizeEmbedded(from: view) { (authParameters, error) in
      if let _ = authParameters {
        print("\n\(authParameters!)\n")
        newUser.loggedStatus = true
      }
      else {
        newUser.loggedStatus = false
        print("\nAuthorization was canceled or went wrong: \(String(describing: error?.description))\n")
      }
      self.appDelegate.saveContext()
    }
  }

  public func logout() {
    emptyUsersList()
    oauth2.username = nil
    oauth2.password = nil
    oauth2.forgetTokens()
  }
}
