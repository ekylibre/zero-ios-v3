//
//  LoginScreen.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import OAuth2
import CoreData

class LoginScreen: UsersDatabase, UITextFieldDelegate {

  // MARK: Properties

  @IBOutlet var tfUsername: UITextField!
  @IBOutlet var tfPassword: UITextField!

  var authentificationService: AuthentificationService?

  // MARK: Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    tfUsername.delegate = self
    tfPassword.delegate = self

    struct staticIndex {
      static var firstLaunch = false
    }
    if !staticIndex.firstLaunch {
      authentificationService = AuthentificationService(username: "", password: "")
      self.authentifyUser()
      staticIndex.firstLaunch = true
    }
  }

  // MARK: Actions

  func getLoggedStatus() -> Bool {
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

    request.returnsObjectsAsFaults = false
    var usersInfo = [NSManagedObject]()

    do {
      usersInfo = try context.fetch(request) as! [NSManagedObject]
    } catch {
      print("Fetch failed")
    }
    let loggedStatus: Bool = (usersInfo[(usersInfo.count) - 1].value(forKey: "loggedStatus") != nil)

    return loggedStatus
  }

  func checkLoggedStatus(token: String?) {
    if token == nil || !(authentificationService?.oauth2.hasUnexpiredAccessToken())! {
      if !Connectivity.isConnectedToInternet() {
        performSegue(withIdentifier: "SegueNoInternetOnFirstConnection", sender: self)
      } else {
        let alert = UIAlertController(title: "Veuillez réessayer", message: "Identifiant inconnu ou mot de passe incorrect.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
      }
    } else if token != nil && (authentificationService?.oauth2.hasUnexpiredAccessToken())! {
      performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
    }
  }

  func authentifyUser() {
    if !entityIsEmpty(entity: "Users") {
      authentificationService?.authorize(presenting: self)

      var token = authentificationService?.oauth2.accessToken

      authentificationService?.oauth2.afterAuthorizeOrFail = { authParameters, error in
        token = self.authentificationService?.oauth2.accessToken
        self.checkLoggedStatus(token: token)
      }
      if token != nil && (authentificationService?.oauth2.hasUnexpiredAccessToken())! {
        performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
      }
    } else {
      authentificationService?.authorize(presenting: self)
      authentifyUser()
    }
  }

  @IBAction func checkAuthentification(sender: UIButton) {
    authentificationService = AuthentificationService(username: tfUsername.text!, password: tfPassword.text!)
    authentifyUser()
  }

  @IBAction func openForgottenPasswordLink(sender: UIButton) {
    var keys: NSDictionary!
    if let path = Bundle.main.path(forResource: "oauthInfo", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    if UIApplication.shared.canOpenURL(URL(string: "\(keys["parseUrl"]!)/password/new")!) {
      UIApplication.shared.open(URL(string: "\(keys["parseUrl"]!)/password/new")!, options: [:], completionHandler: nil)
    }
  }
}
