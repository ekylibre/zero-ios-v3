//
//  ApolloTests.swift
//  Clic&Farm-iOSMockTests
//
//  Created by Guillaume Roux on 26/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS
import Apollo

class ApolloTests: XCTestCase {

  var client: ApolloClient!
  let networkTransport: HTTPNetworkTransport = {
    let url = URL(string: "https://api.ekylibre-test.com/v1/graphql")!
    let configuation = URLSessionConfiguration.default
    let authService = AuthentificationService(username: "", password: "")
    let token = authService.oauth2.accessToken!
    configuation.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    return HTTPNetworkTransport(url: url, configuration: configuation)
  }()
  let store = ApolloStore(cache: InMemoryNormalizedCache(records: [
    "QUERY_ROOT": ["hero": Reference(key: "hero")],
    "hero": ["__typename": "Droid", "name": "R2-D2"]
    ]))

  override func setUp() {
    client = ApolloClient(networkTransport: networkTransport, store: store)
  }

  override func tearDown() {
    client = nil
  }

  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
}
