//
//  LoginViewController.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import OAuth2
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

  // MARK: - Properties

  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var tfUsername: UITextField!
  @IBOutlet weak var tfPassword: UITextField!
  @IBOutlet weak var forgottenPassword: UIButton!

  var authentificationService: AuthentificationService?

  // MARK: - Initialization

  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

    tfUsername.delegate = self
    tfPassword.delegate = self
    textView.text = "welcome_text".localized
    forgottenPassword.setTitle("forgotten_password".localized, for: .normal)
    forgottenPassword.underline()

    authentificationService = AuthentificationService()
    authentificationService?.setupOauthPasswordGrant(username: nil, password: nil)
    if !UserDefaults.userIsLogged() && authentificationService?.oauth2?.accessToken != nil {
      authentificationService?.logout()
    }
    authentifyUser(calledFromUserInteraction: false)
  }

  // MARK: - Navigation

  private func checkLoggedStatus(token: String?) {
    if token == nil || !(authentificationService?.oauth2?.hasUnexpiredAccessToken())! {
      if !Connectivity.isConnectedToInternet() {
        navigationController?.navigationBar.isHidden = false
        performSegue(withIdentifier: "showNoInternetVC", sender: self)
      } else {
        let alert = UIAlertController(
          title: "login_failure".localized,
          message: nil,
          preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil))
        present(alert, animated: true)
      }
    } else if token != nil && (authentificationService?.oauth2?.hasUnexpiredAccessToken())! {
      let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
      let interventionVC = mainStoryboard.instantiateViewController(withIdentifier: "InterventionViewController")
        as UIViewController

      tfUsername.text = nil
      tfPassword.text = nil
      navigationController?.pushViewController(interventionVC, animated: true)
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

  func checkAuthentificationSuccessOrFailure(firstLoggin: Bool) {
    var token: String?

    if firstLoggin {
      authentificationService?.authorize(presenting: self)
      authentificationService?.oauth2?.afterAuthorizeOrFail = { authParameters, error in
        token = self.authentificationService?.oauth2?.accessToken
        self.checkLoggedStatus(token: token)
      }
    } else {
       authentificationService?.authorize(presenting: self)
       token = self.authentificationService?.oauth2?.accessToken
       checkLoggedStatus(token: token)
    }
  }

  private func authentifyUser(calledFromUserInteraction: Bool) {
    if UserDefaults.userIsLogged() {
      checkAuthentificationSuccessOrFailure(firstLoggin: false)
    } else if calledFromUserInteraction {
      checkAuthentificationSuccessOrFailure(firstLoggin: true)
    }
  }

  @IBAction func checkAuthentification(sender: Any) {
    authentificationService = AuthentificationService()
    authentificationService?.setupOauthPasswordGrant(username: tfUsername.text, password: tfPassword.text)
    authentifyUser(calledFromUserInteraction: true)
  }

  @IBAction func openForgottenPasswordLink(sender: UIButton) {
    var keys: NSDictionary!

    if let path = Bundle.main.path(forResource: "oauthInfo", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
      if UIApplication.shared.canOpenURL(URL(string: "\(keys["parseUrl"]!)/password/new")!) {
        UIApplication.shared.open(
          URL(string: "\(keys["parseUrl"]!)/password/new")!,
          options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil
        )
      }
    }
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any])
  -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {
      key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)
    })
}
