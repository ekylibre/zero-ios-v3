//
//  LoginScreen.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class LoginScreen: UsersDatabase, UITextFieldDelegate {

    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!

    var profileAutorized: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfUsername.delegate = self

        if entityIsEmpty(entity: "Users") {
            addNewUser(userName: "jdehaay@gmail.com")
            addNewUser(userName: "toto@yahoo.gouv")
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

    func checkUser(data: NSManagedObject) {
        if tfUsername.text == data.value(forKey: "userName") as? String {
            if getPasswordIfExist() {
                profileAutorized = true
                if data.value(forKey: "firstConnection") as? Bool == true && !Connectivity.isConnectedToInternet() {
                    self.performSegue(withIdentifier: "SegueNoInternetOnFirstConnection", sender: self)
                } else {
                    self.performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
                    data.setValue(false, forKey: "firstConnection")
                }
            }
        }
    }

    @IBAction func checkAuthentification(sender: UIButton) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

        //authentificate(username: tfUsername.text!, password: tfPassword.text!)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                checkUser(data: data)
            }
        } catch {
            print("Fetch failed")
        }
        if !profileAutorized {
            let alert = UIAlertController(title: "Veuillez réessayer", message: "Identifiant inconnu ou mot de passe incorrect.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
