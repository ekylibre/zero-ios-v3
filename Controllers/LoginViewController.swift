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

  var authenticationService: AuthenticationService?

  // MARK: - Initialization

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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

    authenticationService = AuthenticationService()
    authenticationService?.setupOauthPasswordGrant(username: nil, password: nil)
    if !UserDefaults.userIsLogged() && authenticationService?.oauth2?.accessToken != nil {
      authenticationService?.logout()
    }
    authentifyUser(calledFromUserInteraction: false)
  }

  // MARK: - Navigation

  private func checkLoggedStatus(token: String?) {
    if token == nil || !(authenticationService?.oauth2?.hasUnexpiredAccessToken())! {
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
    } else if token != nil && (authenticationService?.oauth2?.hasUnexpiredAccessToken())! {
      let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
      let interventionVC = mainStoryboard.instantiateViewController(withIdentifier: "InterventionViewController")
        as UIViewController

      tfUsername.text = nil
      tfPassword.text = nil
      navigationController?.pushViewController(interventionVC, animated: true)
    }
  }

  @IBAction private func unwindToLoginVC(_ segue: UIStoryboardSegue) {}

  // MARK: - Text Field Delegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == tfUsername {
      tfPassword.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
      checkAuthentication(sender: self)
    }
    return false
  }

  // MARK: - Actions

  private func checkAuthenticationSuccessOrFailure(firstLoggin: Bool) {
    var token: String?

    if firstLoggin || (authenticationService?.oauth2 != nil &&
      !authenticationService!.oauth2!.hasUnexpiredAccessToken()) {
      authenticationService?.authorize(presenting: self)
      authenticationService?.oauth2?.afterAuthorizeOrFail = { authParameters, error in
        token = self.authenticationService?.oauth2?.accessToken
        self.checkLoggedStatus(token: token)
      }
    } else {
      authenticationService?.authorize(presenting: self)
      token = self.authenticationService?.oauth2?.accessToken
      checkLoggedStatus(token: token)
    }
  }

  private func authentifyUser(calledFromUserInteraction: Bool) {
    if UserDefaults.userIsLogged() {
      checkAuthenticationSuccessOrFailure(firstLoggin: false)
    } else if calledFromUserInteraction {
      checkAuthenticationSuccessOrFailure(firstLoggin: true)
    }
  }

  @IBAction private func checkAuthentication(sender: Any) {
    authenticationService = AuthenticationService()
    authenticationService?.setupOauthPasswordGrant(username: tfUsername.text, password: tfPassword.text)
    authentifyUser(calledFromUserInteraction: true)
  }

  @IBAction private func openForgottenPasswordLink(sender: UIButton) {
    if let path = Bundle.main.path(forResource: "oauthInfo", ofType: "plist") {
      let keys = NSDictionary(contentsOfFile: path)
      #if DEBUG
      let url = keys?["testURL"]
      #else
      let url = keys?["releasedURL"]
      #endif
      if url != nil && UIApplication.shared.canOpenURL(URL(string: "\(url!)/password/new")!) {
        UIApplication.shared.open(
          URL(string: "\(url!)/password/new")!,
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
