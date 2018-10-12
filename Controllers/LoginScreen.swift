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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()
    super.moveViewWhenKeyboardAppears()

    tfUsername.delegate = self
    tfPassword.delegate = self
    textView.text = "welcome_text".localized
    forgottenPassword.setTitle("forgotten_password".localized, for: .normal)
    forgottenPassword.underline()
  }

  // MARK: - Navigation

  func checkLoggedStatus(token: String?) {
    if token == nil || !(authentificationService?.oauth2.hasUnexpiredAccessToken())! {
      if !Connectivity.isConnectedToInternet() {
        performSegue(withIdentifier: "ShowNoInternetVC", sender: self)
      } else {
        let alert = UIAlertController(
          title: nil,
          message: "login_failure".localized,
          preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil))
        self.present(alert, animated: true)
      }
    } else if token != nil && (authentificationService?.oauth2.hasUnexpiredAccessToken())! {
      performSegue(withIdentifier: "ShowInterventionVC", sender: self)
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
        performSegue(withIdentifier: "ShowInterventionVC", sender: self)
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
