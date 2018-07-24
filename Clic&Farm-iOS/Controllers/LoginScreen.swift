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

    var profileAutorized: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfUsername.delegate = self

        if entityIsEmpty(entity: "Users") {
            addNewUser(userName: "jdehaay@ekylibre.com")
       }
    }

    @IBAction func openForgottenPasswordLink(sender: UIButton) {
        if UIApplication.shared.canOpenURL(URL(string: "https://ekylibre.com/password/new")!) {
            UIApplication.shared.open(URL(string: "https://ekylibre.com/password/new")!, options: [:], completionHandler: nil)
        }
    }

    func savePassword() {
        if (tfPassword.text?.count)! > 0 {
            let token = KeychainService.stringToNSDATA(string: tfPassword.text!)
        
            KeychainService.save(key: tfUsername.text!, data: token)
        }
    }

    func getPasswordIfExist() -> Bool {
        if let token = KeychainService.load(key: tfUsername.text!) {
            let loadedPassword = KeychainService.NSDATAtoString(data: token)
            
            if tfPassword.text == loadedPassword {
                return true
            }
        } else {
            savePassword()
        }
        return false
    }

    func checkUser() {
        if getPasswordIfExist() {
            profileAutorized = true
            self.performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
        }
    }
    
    @IBAction func checkAuthentification(sender: UIButton) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if tfUsername.text == data.value(forKey: "userName") as? String {
                    checkUser()
                }
            }
        } catch {
            print("Fetch failed")
        }
    }
}
