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

  let apollo: ApolloClient = {
    let configuration = URLSessionConfiguration.default
    var keys: NSDictionary!

    if let path = Bundle.main.path(forResource: "oauthInfo", ofType: "plist") {
      keys = NSDictionary(contentsOfFile: path)
    }
    let token = keys["parseClientSecret"]!
    let url = URL(string: keys["graphQLServURL"] as! String)!

    configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
  }()

  func tryQuerySomeData() {
    apollo.fetch(query: ProfileQuery()) { (result, error) in
      guard let data = result?.data?.profile else {
        print("\nError: \(String(describing: error))")
        return
      }

      print("\nData: \(data.firstName!)")
    }
  }
}
