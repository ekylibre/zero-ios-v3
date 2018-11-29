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
    interventionVC = storyboard.instantiateViewController(withIdentifier: "InterventionViewController") as? InterventionViewController
    let _ = interventionVC.view
  }

  override func tearDown() {
    client = nil
    interventionVC = nil
  }

  func test_queryFarmID_shouldHaveResult() {
    let query = ProfileQuery()
    let expectation = self.expectation(description: "Fetching profile query")

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
    let query = ProfileQuery()
    let expectation = self.expectation(description: "Fetching profile query")

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
    let expectation = self.expectation(description: "Mutating equipment")
    let mutation = PushEquipmentMutation(
      farmId: farmID,
      type: .tractor,
      name: "tracteur apollo",
      number: "1000",
      indicator1: "1",
      indicator2: nil)

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
    let query = FarmQuery()
    let expectation = self.expectation(description: "Fetchin crops")

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

  func defineTargetAttributes() -> [InterventionTargetAttributes] {
    let cropID = "6165E585-2068-430E-8B59-E5C243E718D1"
    let targetAttribute = InterventionTargetAttributes(cropId: cropID, workAreaPercentage: 100)

    return [targetAttribute]
  }

  func defineWorkingDays() -> [InterventionWorkingDayAttributes] {
    let workingDay = InterventionWorkingDayAttributes(executionDate: Date(), hourDuration: 7.9)

    return [workingDay]
  }

  func test_pushNewIntervention_shouldPushIt() {
    let expectation = self.expectation(description: "Pushing intervention")
    let mutation = PushInterMutation(
      farmId: farmID,
      procedure: .irrigation,
      cropList: defineTargetAttributes(),
      workingDays: defineWorkingDays(),
      waterQuantity: 52,
      waterUnit: InterventionWaterVolumeUnitEnum(rawValue: "HECTOLITER"),
      inputs: nil,
      outputs: nil,
      globalOutputs: false,
      tools: nil,
      operators: nil,
      weather: nil,
      description: "Pushing intervention from unit test")

    client.perform(mutation: mutation, resultHandler: { (result, error) in
      defer { expectation.fulfill() }

      if let error = error {
        XCTFail("Got an error: \(error)")
      } else if let resultError = result?.errors {
        XCTFail("Got an result error: \(resultError)")
      } else {
        XCTAssertNotNil(result?.data?.createIntervention?.intervention?.id, "InterventionID should be populated")
      }
    })
    waitForExpectations(timeout: 30, handler: nil)
  }

  func test_removePushedIntervention_shouldRemoveIt() {
    let interventionEkyID = "1602"
    let mutation = DeleteInterMutation(id: interventionEkyID, farmId: farmID)
    let expectation = self.expectation(description: "Deleting intervention")

    client.perform(mutation: mutation, resultHandler: { (result, error) in
      defer { expectation.fulfill() }

      if let error = error {
        XCTFail("Got an error: \(error)")
      } else if let resultError = result?.errors {
        XCTFail("Got an result error: \(resultError)")
      } else {
        XCTAssertNotNil(result?.data, "Data should be populated")
      }
    })
    waitForExpectations(timeout: 30, handler: nil)
  }

  func test_personMutation_withValidPerson_shouldSaveIt() {
    let expectation = self.expectation(description: "Mutating person")
    let mutation = PushPersonMutation(
      farmId: farmID,
      firstName: "personne",
      lastName: "apollo")

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
