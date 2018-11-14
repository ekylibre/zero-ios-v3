//
//  WorkingPeriodTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Guillaume Roux on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class WorkingPeriodTests: XCTestCase {

  var addInterventionVC: AddInterventionViewController!

  override func setUp() {
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    addInterventionVC = storyboard.instantiateViewController(withIdentifier: "AddInterventionVC") as? AddInterventionViewController
  }

  override func tearDown() {
    addInterventionVC = nil
    super.tearDown()
  }

  func test_unit_withDurationLesserThanOrEqualTo1_shouldBeSingular() {
    //Given
    let _ = addInterventionVC.view
    let duration = "1.00"

    //When
    XCTAssertEqual(addInterventionVC.workingPeriodUnitLabel.text, "hours".localized,
                   "Working period unit should be plural before sendActions")
    addInterventionVC.workingPeriodDurationTextField.text = duration
    addInterventionVC.workingPeriodDurationTextField.sendActions(for: .editingChanged)

    //Then
    XCTAssertEqual(addInterventionVC.workingPeriodUnitLabel.text, "hour".localized,
                   "Working period unit label not updated correctly when duration is <= 1")
  }

  func test_unit_withDurationGreaterThan1_shouldBePlural() {
    //Given
    let _ = addInterventionVC.view
    let duration = "1000"

    //When
    XCTAssertEqual(addInterventionVC.workingPeriodUnitLabel.text, "hours".localized,
                   "Working period unit should be plural before sendActions")
    addInterventionVC.workingPeriodDurationTextField.text = duration
    addInterventionVC.workingPeriodDurationTextField.sendActions(for: .editingChanged)

    //Then
    XCTAssertEqual(addInterventionVC.workingPeriodUnitLabel.text, "hours".localized,
                   "Working period unit label not updated correctly when duration is > 1")
  }
}
