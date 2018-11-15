//
//  Clic_Farm_iOSUITests.swift
//  Clic&Farm-iOSUITests
//
//  Created by Jonathan DE HAAY on 15/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class Clic_Farm_iOSUITests: XCTestCase {

  var app: XCUIApplication!
  var interventionVC: InterventionViewController!


  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    interventionVC = storyboard.instantiateViewController(withIdentifier: "InterventionViewController") as? InterventionViewController
    let _ = interventionVC.view
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    app = XCUIApplication()
    app.launch()

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    interventionVC = nil
    super.tearDown()
  }

  func test_AddNewIntervention_ofTypeIrrigation() {
    // Given
    let newIntervention = app.buttons["REGISTER AN INTERVENTION"]

    //When
    newIntervention.tap()

    // Then
    XCTAssertTrue(interventionVC.createInterventionButton.isHidden, "Should be hidden")
    XCTAssertEqual(interventionVC.heightConstraint.constant, 220, "VC Height constraint should be 220")
    XCTAssertFalse(interventionVC.dimView.isHidden, "Dim view should be displayed")
    for interventionButton in interventionVC.interventionButtons {
      XCTAssertFalse(interventionButton.isHidden, "Button should be displayed")
    }
  }
}
