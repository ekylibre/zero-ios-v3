//
//  ReadOnlyInputsTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 15/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class ReadOnlyInputsTests: XCTestCase {

  var addInterventionVC: AddInterventionViewController!

  override func setUp() {
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    addInterventionVC = storyboard.instantiateViewController(withIdentifier: "AddInterventionVC") as? AddInterventionViewController
    let _ = addInterventionVC.view
  }

  override func tearDown() {
    addInterventionVC = nil
    super.tearDown()
  }

  func test_updateInputsCountLabelWithoutEquipment_shouldNotChange() {
    // When
    addInterventionVC.selectedInputs.removeAll()
    addInterventionVC.updateInputsCountLabel()

    // Then
    XCTAssertEqual(addInterventionVC.inputsCountLabel.text, "none".localized, "Should have no input")
  }
}
