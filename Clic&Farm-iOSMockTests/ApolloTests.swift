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

  let farmID = "884263ee-49a4-424e-ac1e-6043370eeadd"
  var interventionVC: InterventionViewController!
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
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    interventionVC = storyboard.instantiateViewController(withIdentifier: "InterventionViewController")
      as? InterventionViewController
    let _ = interventionVC.view
  }

  override func tearDown() {
    client = nil
    interventionVC = nil
  }

  func test_queryFarmID_shouldHaveResult() {
    // Given
    let query = ProfileQuery()
    let expectation = self.expectation(description: "Fetching profile query")

    // When
    let _ = client.clearCache()
    client.fetch(query: query, resultHandler: { (result, error) in
      defer { expectation.fulfill() }

      if let error = error {
        XCTFail("Got an error: \(error)")
      } else if let resultError = result?.errors {
        XCTFail("Got an result error: \(resultError)")
      } else {
        XCTAssertNotNil(result?.data?.farms.first?.id, "FarmID should be populated")
      }
    })
    waitForExpectations(timeout: 30, handler: nil)
  }

  func test_queryFarmLabel_shouldHaveResult() {
    // Given
    let query = ProfileQuery()
    let expectation = self.expectation(description: "Fetching profile query")

    // When
    let _ = client.clearCache()
    client.fetch(query: query, resultHandler: { (result, error) in
      defer { expectation.fulfill() }

      if let error = error {
        XCTFail("Got an error: \(error)")
      } else if let resultError = result?.errors {
        XCTFail("Got an result error: \(resultError)")
      } else {
        XCTAssertNotNil(result?.data?.farms.first?.label, "Farm label should be populated")
      }
    })
    waitForExpectations(timeout: 30, handler: nil)
  }

  func test_equipmentMutation_withAnEquipment_shouldSaveIt() {
    // Given
    let expectation = self.expectation(description: "Mutating equipment")
    let mutation = PushEquipmentMutation(
      farmId: farmID,
      type: .tractor,
      name: "tracteur apollo",
      number: "1000",
      indicator1: "1",
      indicator2: nil)

    // When
    let _ = client.clearCache()
    client.perform(mutation: mutation, resultHandler: { (result, error) in
      defer { expectation.fulfill() }

      if let error = error {
        XCTFail("Got an error: \(error)")
      } else if let resultError = result?.errors {
        XCTFail("Got an result error: \(resultError)")
      } else {
        XCTAssertNotNil(result?.data?.createEquipment?.equipment?.id, "EquipmentID should be populated")
      }
    })
    waitForExpectations(timeout: 30, handler: nil)
  }

  func test_queryCrops_shouldHaveResult() {
    // Given
    let query = FarmQuery()
    let expectation = self.expectation(description: "Fetching crops")

    // When
    let _ = client.clearCache()
    client.fetch(query: query, resultHandler: { (result, error) in
      defer { expectation.fulfill() }

      if let error = error {
        XCTFail("Got an error: \(error)")
      } else if let resultError = result?.errors {
        XCTFail("Got an result error: \(resultError)")
      } else {
        for crop in result!.data!.farms.first!.crops {
          XCTAssertNotNil(crop.uuid, "Crops uuid should be populated")
        }
      }
    })
    waitForExpectations(timeout: 30, handler: nil)
  }

  func test_personMutation_withValidPerson_shouldSaveIt() {
    // Given
    let expectation = self.expectation(description: "Mutating person")
    let mutation = PushPersonMutation(
      farmId: farmID,
      firstName: "Person",
      lastName: "apollo")

    // When
    let _ = client.clearCache()
    client.perform(mutation: mutation, resultHandler: { (result, error) in
      defer { expectation.fulfill() }

      if let error = error {
        XCTFail("Got an error: \(error)")
      } else if let resultError = result?.errors {
        XCTFail("Got an result error: \(resultError)")
      } else {
        XCTAssertNotNil(result?.data?.createPerson?.person?.id, "PersonID should be populated")
      }
    })
    waitForExpectations(timeout: 30, handler: nil)
  }
}
