//
//  ApolloQuery.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 17/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import Apollo

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

  func tryQuerySomeData() {
    initializeApolloClient()
    apollo?.fetch(query: ProfileQuery()) { (result, error) in
      guard let data = result?.data else {
        print("\nError: \(String(describing: error))")
        return
      }

      print(data.profile.firstName!)
    }
  }
}
