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

  // MARK: - Properties

  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var tfUsername: UITextField!
  @IBOutlet weak var tfPassword: UITextField!
  @IBOutlet weak var forgottenPassword: UIButton!

  var authentificationService: AuthentificationService?
  var buttonIsPressed: Bool = false

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    tfUsername.delegate = self
    tfPassword.delegate = self
    textView.text = "appli_description".localized
    forgottenPassword.setTitle("forgotten_password".localized, for: .normal)
    forgottenPassword.underline()

    struct staticIndex {
      static var firstLaunch = false
    }
    if !staticIndex.firstLaunch {
      authentificationService = AuthentificationService(username: "", password: "")
      if entityIsEmpty(entity: "Users") {
        authentificationService?.logout()
      }
      self.authentifyUser()
      staticIndex.firstLaunch = true
    }
  }

  // MARK: - Navigation

  func checkLoggedStatus(token: String?) {
    if token == nil || !(authentificationService?.oauth2.hasUnexpiredAccessToken())! {
      if !Connectivity.isConnectedToInternet() {
        performSegue(withIdentifier: "SegueNoInternetOnFirstConnection", sender: self)
      } else {
        let alert = UIAlertController(
          title: "please_try_again".localized,
          message: "unknown_username_or_incorrect_password".localized,
          preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
      }
    } else if token != nil && (authentificationService?.oauth2.hasUnexpiredAccessToken())! {
      performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
    }
  }

  // MARK: - Actions

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
    } else if buttonIsPressed && tfUsername.text!.count > 0 {
      authentificationService?.addNewUser(userName: tfUsername.text!)
      authentifyUser()
    }
  }

  @IBAction func checkAuthentification(sender: UIButton) {
    buttonIsPressed = true
    authentificationService = AuthentificationService(username: tfUsername.text!, password: tfPassword.text!)
    authentifyUser()
    buttonIsPressed = false
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
