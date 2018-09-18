//
//  ApolloQuery.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 17/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import Apollo
import CoreData

class ApolloQuery {

  var token: String?
  var apollo: ApolloClient?
  let authentificationService = AuthentificationService(username: "", password: "")

  func initializeApolloClient() {
    let configuration = URLSessionConfiguration.default
    var keys: NSDictionary!

    if let path = Bundle.main.path(forResource: "oauthInfo", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    let token = authentificationService.oauth2.accessToken
    let url = URL(string: keys["graphQLServURL"] as! String)!

    configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token!)"]
    apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
  }

  func saveFarmNameAndID(name: String?, id: String?) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let farmsEntity = NSEntityDescription.entity(forEntityName: "Farms", in: managedContext)!
    let farm = NSManagedObject(entity: farmsEntity, insertInto: managedContext)

    farm.setValue(name, forKey: "name")
    farm.setValue(id, forKey: "farmID")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func defineFarmNameAndID(completion: @escaping (_ success: Bool) -> Void) {
    apollo?.fetch(query: ProfileQuery()) { (result, error) in
      guard let farms = result?.data?.farms else {
        print("Error: \(String(describing: error))")
        return
      }

      for farm in farms {
        self.saveFarmNameAndID(name: farm.label, id: farm.id)
      }
      completion(true)
    }
  }
}
