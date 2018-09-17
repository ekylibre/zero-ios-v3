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
    configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(keys["parseClientSecret"]!)"]

    let url = URL(string: keys["parseUrl"] as! String)!

    return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
  }()

  func tryQuerySomeData() {
    apollo.fetch(query: ProfileQuery()) { (result, error) in
      guard let data = result?.data?.profile else {
        print("\nNo result: \(String(describing: error))")
        return
      }

      print("\nData: \(data.firstName!)")
    }
  }
}
