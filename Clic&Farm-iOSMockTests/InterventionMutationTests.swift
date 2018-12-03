//
//  InterventionMutationTests.swift
//  Clic&Farm-iOSMockTests
//
//  Created by Jonathan DE HAAY on 30/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS
import Apollo

class InterventionMutationTests: XCTestCase {

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

  func defineTargetAttributes() -> [InterventionTargetAttributes] {
    let cropID = "6165E585-2068-430E-8B59-E5C243E718D1"
    let targetAttribute = InterventionTargetAttributes(cropId: cropID, workAreaPercentage: 100)

    return [targetAttribute]
  }

  func defineWorkingDays() -> [InterventionWorkingDayAttributes] {
    let workingDay = InterventionWorkingDayAttributes(executionDate: Date(), hourDuration: 7.9)

    return [workingDay]
  }

  func defineOutputAttributes() -> [InterventionOutputAttributes] {
    let outputAttribute = InterventionOutputAttributes(
      quantity: nil,
      nature: nil,
      unit: nil,
      approximative: nil,
      loads: nil)

    return [outputAttribute]
  }

  func defineEquipmentAttributes() -> [InterventionToolAttributes] {
    let equipmentAttributes = InterventionToolAttributes(equipmentId: "546")

    return [equipmentAttributes]
  }

  func defineOperatorAttributes() -> [InterventionOperatorAttributes] {
    let operatorAttributes = InterventionOperatorAttributes(
      personId: "1076",
      role: OperatorRoleEnum(rawValue: "OPERATOR"))

    return [operatorAttributes]
  }

  func defineWeatherAttributes() -> WeatherAttributes {
    let weatherAttributes = WeatherAttributes(
      windSpeed: 42,
      temperature: 24,
      description: WeatherEnum(rawValue: "THUNDERSTORM"))

    return weatherAttributes
  }

  func test_1_pushNewIntervention_shouldPushIt() {
    // Given
    let expectation = self.expectation(description: "Pushing intervention")
    let mutation = PushInterMutation(
      farmId: farmID,
      procedure: .irrigation,
      cropList: defineTargetAttributes(),
      workingDays: defineWorkingDays(),
      waterQuantity: 52,
      waterUnit: InterventionWaterVolumeUnitEnum(rawValue: "HECTOLITER"),
      inputs: [InterventionInputAttributes](),
      outputs: [InterventionOutputAttributes](),
      globalOutputs: false,
      tools: defineEquipmentAttributes(),
      operators: defineOperatorAttributes(),
      weather: defineWeatherAttributes(),
      description: "Intervention pushed from unit test")

    // When
    let _ = client.clearCache()
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

  func fetchLastInterventionToRemoveIt() -> String? {
    let query = InterventionQuery()
    let expectation = self.expectation(description: "Fetching profile query")
    var interventionID: String?

    let _ = client.clearCache()
    client.fetch(query: query, resultHandler: { (result, error) in
      defer { expectation.fulfill() }

      if let error = error {
        print("Got an error: \(error)")
      } else if let resultError = result?.errors {
        print("Got an result error: \(resultError)")
      } else {
        interventionID = result!.data!.farms.first!.interventions.last!.id
      }
    })
    waitForExpectations(timeout: 30, handler: nil)
    return interventionID
  }

  func test_2_removePushedIntervention_shouldRemoveIt() {
    let interventionEkyID = fetchLastInterventionToRemoveIt()

    if interventionEkyID != nil {
      // Given
      let mutation = DeleteInterMutation(id: interventionEkyID!, farmId: farmID)
      let expectation = self.expectation(description: "Deleting intervention")

      // When
      let _ = client.clearCache()
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
    } else {
      XCTFail("No intervention to remove")
    }
  }
}