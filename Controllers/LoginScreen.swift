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
      self.authentifyTheUser()
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
  
  func checkLoggedStatus(loggedStatus: Bool, token: String?, error: OAuth2Error?) {
    if (!loggedStatus) || (loggedStatus && token == nil) {
      if error?.description == "The Internet connection appears to be offline." {
        self.performSegue(withIdentifier: "SegueNoInternetOnFirstConnection", sender: self)
      } else {
        let alert = UIAlertController(title: "Veuillez réessayer", message: "Identifiant inconnu ou mot de passe incorrect.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
      }
    } else if loggedStatus && token != nil {
      self.performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
    }
  }
  
  func authentifyTheUser() {
    if !entityIsEmpty(entity: "Users") {
      let _ = authentificationService?.authorize(presenting: self)
      var token = self.authentificationService?.oauth2.accessToken
      var loggedStatus = self.getLoggedStatus()
      
      authentificationService?.oauth2.afterAuthorizeOrFail = { authParameters, error in
        token = self.authentificationService?.oauth2.accessToken
        loggedStatus = self.getLoggedStatus()
        self.checkLoggedStatus(loggedStatus: loggedStatus, token: token, error: error)
      }
      if loggedStatus && token != nil {
        self.performSegue(withIdentifier: "SegueFromLogScreenToConnected", sender: self)
      }
    } else {
      let _ = authentificationService?.authorize(presenting: self)
      authentifyTheUser()
    }
  }
  
  @IBAction func checkAuthentification(sender: UIButton) {
    authentificationService = AuthentificationService(username: tfUsername.text!, password: tfPassword.text!)
    authentifyTheUser()
  }
  
  @IBAction func openForgottenPasswordLink(sender: UIButton) {
    if UIApplication.shared.canOpenURL(URL(string: "https://ekylibre.com/password/new")!) {
      UIApplication.shared.open(URL(string: "https://ekylibre.com/password/new")!, options: [:], completionHandler: nil)
    }
  }
}
