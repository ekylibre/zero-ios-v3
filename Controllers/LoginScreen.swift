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

  @IBOutlet weak var tfUsername: UITextField!
  @IBOutlet weak var tfPassword: UITextField!

  var authentificationService: AuthentificationService?
  var buttonIsPressed: Bool = false

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    tfUsername.delegate = self
    tfPassword.delegate = self

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
          title: "Veuillez réessayer",
          message: "Identifiant inconnu ou mot de passe incorrect.",
          preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
      }
    } else if token != nil && (authentificationService?.oauth2.hasUnexpiredAccessToken())! {
      performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
    }
  }

  // MARK: - Text Field Delegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.frame.origin.y = 0
    textField.resignFirstResponder()
    switch textField {
    case tfUsername:
      tfPassword.becomeFirstResponder()
      return false
    case tfPassword:
      checkAuthentification(sender: self)
      return false
    default:
      return false
    }
  }

  @objc func keyboardWillShow(notification: NSNotification) {
    let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)!.cgRectValue
    let offset = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue

    if keyboardSize.height == offset.height {
      if view.frame.origin.y == 0 {
        UIView.animate(withDuration: 0.1, animations: {
          self.view.frame.origin.y -= keyboardSize.height
        })
      }
    } else {
      UIView.animate(withDuration: 0.1, animations: {
        self.view.frame.origin.y += keyboardSize.height - offset.height
      })
    }
  }

  @objc func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y += keyboardSize.height
      }
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

  @IBAction func checkAuthentification(sender: Any) {
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
      UIApplication.shared.open(URL(string: "\(keys["parseUrl"]!)/password/new")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
