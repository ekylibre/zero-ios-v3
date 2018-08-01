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

    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!

    var authentificationService: AuthentificationService?
    var profileAutorized: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfUsername.delegate = self
        self.tfPassword.delegate = self

        struct staticIndex {
            static var index: Int = 0
        }
        if staticIndex.index == 0 {
            authentificationService = AuthentificationService(username: "", password: "")
            self.checkLoginStatus()
            staticIndex.index = 1
        }
    }

    @IBAction func openForgottenPasswordLink(sender: UIButton) {
        if UIApplication.shared.canOpenURL(URL(string: "https://ekylibre.com/password/new")!) {
            UIApplication.shared.open(URL(string: "https://ekylibre.com/password/new")!, options: [:], completionHandler: nil)
        }
    }

    func changeViewController(segueId: String) {
        self.performSegue(withIdentifier: segueId, sender: self)
    }

    func checkLoginStatus() {
        let userLoggedIn = UserDefaults.standard.bool(forKey: "LOGGED_IN")
        let token = authentificationService?.oauth2.accessToken

        if (!userLoggedIn) || (userLoggedIn && token == nil) {
            print("Not loged in or token has expired")
            authentificationService?.authorize(presenting: self)
        } else if userLoggedIn && token != nil {
            self.performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
            print("Loged in")
        }
    }

    @IBAction func checkAuthentification(sender: UIButton) {
        authentificationService = AuthentificationService(username: tfUsername.text!, password: tfPassword.text!)
        checkLoginStatus()
    }
}
