//
//  LoginScreen.swift
//  ClickAndFarm-IOS
//
//  Created by Jonathan DE HAAY on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import SQLite3
import CoreData

class LoginScreen: UsersDatabase, UITextFieldDelegate {

    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!

    var db: OpaquePointer?
    var profileAutorized: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfUsername.delegate = self

        if entityIsEmpty(entity: "Users") {
            addNewUser(userName: "jdehaay@ekylibre.com")
       }
    }

    @IBAction func testFetching(sender: UIButton) {
        fetchData(entity: "Users", dataToFetch: "userName")
    }

    @IBAction func openForgottenPasswordLink(sender: UIButton) {
        if UIApplication.shared.canOpenURL(URL(string: "https://ekylibre.com/password/new")!) {
            UIApplication.shared.open(URL(string: "https://ekylibre.com/password/new")!, options: [:], completionHandler: nil)
        }
    }
}
