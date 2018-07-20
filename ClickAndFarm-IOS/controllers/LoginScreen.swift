//
//  LoginScreen.swift
//  ClickAndFarm-IOS
//
//  Created by Jonathan DE HAAY on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import SQLite3

class LoginScreen: UIViewController, UITextFieldDelegate {

    @IBOutlet var tfAccount: UITextField!
    @IBOutlet var tfPassword: UITextField!

    var db: OpaquePointer?
    var profileAutorized: Bool = false
    var accountList = [Account]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfAccount.delegate = self

        let dataBaseUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("AccountDatabase.sqlite")

        if sqlite3_open(dataBaseUrl.path, &db) != SQLITE_OK {
            print("Error on opening database.")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Accounts (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
        }
        addTempAccountToDataBase()
    }

    func createDataBase() {
        let email = tfAccount.text
        let password = tfPassword.text
        var statement: OpaquePointer?
        let queryString = "INSERT INTO Accounts (email, password) VALUES (?,?)"

        if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert: \(errmsg)")
            return
        }
        if sqlite3_bind_text(statement, 1, email, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding email: \(errmsg)")
            return
        }
        if sqlite3_bind_text(statement, 2, password, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure binding password: \(errmsg)")
            return
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failure inserting account: \(errmsg)")
            return
        }
    }

    class Account {
        var id: Int
        var email: String
        var password: String
        var firstConnection: Bool

        init(id: Int, email: String, password: String, firstConnection: Bool) {
            self.id = id
            self.email = email
            self.password = password
            self.firstConnection = firstConnection
        }
    }

    func addTempAccountToDataBase() {
        print("Numbers of items: \(accountList.count)")
        if accountList.count == 0 {
            createDataBase()
            accountList.append(Account(id: 0, email: "toto@ekylibre.com", password: "Totodu33", firstConnection: true))
            accountList.append(Account(id: 1, email: "jdehaay@ekylibre.com", password: "Jonathandu33", firstConnection: true))
            accountList.append(Account(id: 2, email: "jdehaay@yahoo.org", password: "Jonathandu33", firstConnection: true))
            print("New items added")
        }
    }

    @IBAction func checkAuthentification(sender: UIButton) {
        for accountList in accountList {
            if tfAccount.text! == accountList.email && tfPassword.text! == accountList.password {
                profileAutorized = true
                if accountList.firstConnection && !Connectivity.isConnectedToInternet() {
                    self.performSegue(withIdentifier: "SegueNoInternetOnFirstConnection", sender: self)
                    break
                } else {
                    self.performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
                    accountList.firstConnection = false
                    break
                }
            }
        }
        if !profileAutorized {
            let alert = UIAlertController(title: "Veuillez réessayer", message: "Identifiant inconnu ou mot de passe incorrect.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    @IBAction func savePasswordIfProfileAutorized(_ sender: Any) {
        if profileAutorized {
            let stringValue = KeychainService.stringToNSDATA(string: tfPassword.text!)

            KeychainService.save(key: tfAccount.text!, data: stringValue)
        }
    }

   func loadPasswordIfSaved() {
        if let RecievedStringValueAfterSave = KeychainService.load(key: tfAccount.text!) {
            let NSDATAtoString = KeychainService.NSDATAtoString(data: RecievedStringValueAfterSave)
            tfPassword.text = NSDATAtoString
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfAccount.resignFirstResponder()
        loadPasswordIfSaved()
        return true
    }

    @IBAction func openForgottenPasswordLink(sender: UIButton) {
        if UIApplication.shared.canOpenURL(URL(string: "https://ekylibre.com/password/new")!) {
            UIApplication.shared.open(URL(string: "https://ekylibre.com/password/new")!, options: [:], completionHandler: nil)
        }
    }
}
