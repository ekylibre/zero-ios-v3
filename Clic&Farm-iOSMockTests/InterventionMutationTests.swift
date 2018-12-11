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
    let authService = AuthenticationService()

    authService.setupOauthPasswordGrant(username: nil, password: nil)
    if let token = authService.oauth2?.accessToken {
      configuation.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
      return HTTPNetworkTransport(url: url, configuration: configuation)
    }
    return HTTPNetworkTransport(url: url, configuration: configuation)
  }()

  override func setUp() {
    client = ApolloClient(networkTransport: networkTransport)
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    interventionVC = storyboard.instantiateViewController(withIdentifier: "InterventionViewController")
      as? InterventionViewController
    let _ = interventionVC.view
  }

  override func tearDown() {
    client = nil
    interventionVC = nil
  }

  func defineTargetAttributes(cropsNumber: Int) -> [InterventionTargetAttributes] {
    var targetsAttributes = [InterventionTargetAttributes]()
    let cropsID = ["2C1879A1-6A17-4CDF-9FD6-67F0B29F696D", "E79DC921-EC4A-4029-B161-64A229607427",
                   "A09AB0A6-CA2A-4805-9964-226987EA91E3", "841A2F30-BE08-43BF-B2A0-06AA577211FF"]

    for index in 0..<cropsNumber {
      targetsAttributes.append(InterventionTargetAttributes(cropId: cropsID[index], workAreaPercentage: 100))
    }
    return targetsAttributes
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

  func defineEquipmentAttributes(equipmentsNumber: Int) -> [InterventionToolAttributes] {
    var equipmentsAttributes = [InterventionToolAttributes]()
    let equipmentsID = ["545", "546"]

    for index in 0..<equipmentsNumber {
      equipmentsAttributes.append(InterventionToolAttributes(equipmentId: equipmentsID[index]))
    }
    return equipmentsAttributes
  }

  func defineOperatorAttributes(personsNumber: Int) -> [InterventionOperatorAttributes] {
    var operatorsAttributes = [InterventionOperatorAttributes]()
    let personsID = ["1076", "1078", "1079", "1103", "1104"]

    for index in 0..<personsNumber {
      let role = (Int.random(in: 0..<1) == 0 ? "OPERATOR" : "DRIVER")

      operatorsAttributes.append(InterventionOperatorAttributes(
        personId: personsID[index], role: OperatorRoleEnum(rawValue: role)))
    }
    return operatorsAttributes
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
      cropList: defineTargetAttributes(cropsNumber: 1),
      workingDays: defineWorkingDays(),
      waterQuantity: 52,
      waterUnit: InterventionWaterVolumeUnitEnum(rawValue: "HECTOLITER"),
      inputs: [InterventionInputAttributes](),
      outputs: [InterventionOutputAttributes](),
      globalOutputs: false,
      tools: defineEquipmentAttributes(equipmentsNumber: 1),
      operators: defineOperatorAttributes(personsNumber: 2),
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

  func test_2_pushCareIntervention_shouldPushIt() {
    // Given
    let expectation = self.expectation(description: "Pushing intervention")
    let mutation = PushInterMutation(
      farmId: farmID,
      procedure: .care,
      cropList: defineTargetAttributes(cropsNumber: 4),
      workingDays: defineWorkingDays(),
      waterQuantity: nil,
      waterUnit: nil,
      inputs: [InterventionInputAttributes](),
      outputs: [InterventionOutputAttributes](),
      globalOutputs: false,
      tools: defineEquipmentAttributes(equipmentsNumber: 2),
      operators: defineOperatorAttributes(personsNumber: 5),
      weather: defineWeatherAttributes(),
      description: "Care intervention pushed from unit test")

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

  func test_3_removePushedInterventions_shouldRemoveIt() {
    let interventionEkyID = fetchLastInterventionToRemoveIt()

    if interventionEkyID.count > 0 {
      // Given
      for ekyID in interventionEkyID {
        let mutation = DeleteInterMutation(id: ekyID!, farmId: farmID)
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
      }
      waitForExpectations(timeout: 30, handler: nil)
    } else {
      XCTFail("No intervention to remove")
    }
  }

  func fetchLastInterventionToRemoveIt() -> [String?] {
    let query = InterventionQuery()
    let expectation = self.expectation(description: "Fetching profile query")
    var interventionsID = [String?]()

    let _ = client.clearCache()
    client.fetch(query: query, resultHandler: { (result, error) in
      defer { expectation.fulfill() }

      if let error = error {
        print("Got an error: \(error)")
      } else if let resultError = result?.errors {
        print("Got an result error: \(resultError)")
      } else {
        let interventions = result?.data?.farms.first?.interventions

        if interventions != nil && interventions!.count > 1 {
          interventionsID.append(interventions?[interventions!.count - 1].id)
          interventionsID.append(interventions?[interventions!.count - 2].id)
        } else if interventions != nil && interventions!.count > 0 {
          interventionsID.append(interventions?[interventions!.count].id)
        }
      }
    })
    waitForExpectations(timeout: 30, handler: nil)
    return interventionsID
  }
}
