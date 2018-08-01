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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfUsername.delegate = self
        self.tfPassword.delegate = self

        struct staticIndex {
            static var index: Int = 0
        }
        if staticIndex.index == 0 {
            authentificationService = AuthentificationService(username: "", password: "")
            self.checkLoggedStatus()
            staticIndex.index = 1
        }
    }

    func getLoggedStatus() -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

        request.returnsObjectsAsFaults = false
        var usersInfo = [NSManagedObject]()
        
        do {
            usersInfo = try context.fetch(request) as! [NSManagedObject]
        } catch {
            print("Fetch failed")
        }
        let loggedStatus: Bool = (usersInfo[(usersInfo.count) - 1].value(forKey: "loggedStatus") != nil)

        return loggedStatus
    }

    func checkLoggedStatus() {
        if !entityIsEmpty(entity: "Users") {
            var token = authentificationService?.oauth2.accessToken
            var loggedStatus = getLoggedStatus()

            if (!loggedStatus) || (loggedStatus && token == nil) {
                authentificationService?.authorize(presenting: self)
                token = authentificationService?.oauth2.accessToken
                loggedStatus = getLoggedStatus()
                if !loggedStatus {
                    let alert = UIAlertController(title: "Veuillez réessayer", message: "Identifiant inconnu ou mot de passe incorrect.", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else if loggedStatus && token != nil {
                    self.performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
                }
            } else if loggedStatus && token != nil {
                self.performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
            }
        } else {
            authentificationService?.authorize(presenting: self)
        }
    }

    @IBAction func checkAuthentification(sender: UIButton) {
        authentificationService = AuthentificationService(username: tfUsername.text!, password: tfPassword.text!)
        checkLoggedStatus()
    }

    @IBAction func openForgottenPasswordLink(sender: UIButton) {
        if UIApplication.shared.canOpenURL(URL(string: "https://ekylibre.com/password/new")!) {
            UIApplication.shared.open(URL(string: "https://ekylibre.com/password/new")!, options: [:], completionHandler: nil)
        }
    }
}
