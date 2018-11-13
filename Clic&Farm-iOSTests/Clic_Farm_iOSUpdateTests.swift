//
//  Clic_Farm_iOSUpdateTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Guillaume Roux on 13/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class Clic_Farm_iOSUpdateTests: XCTestCase {

  var addInterventionVC: AddInterventionViewController!

  override func setUp() {
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: self.classForCoder))
    addInterventionVC = storyboard.instantiateViewController(withIdentifier: "AddInterventionVC") as? AddInterventionViewController
  }

  override func tearDown() {
    addInterventionVC = nil
    super.tearDown()
  }

  func test_irrigationErrorLabel_isUpdated() {
    //Given
    let _ = addInterventionVC.view
    let volume = "1.0230"
    let unit = "hl"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.irrigationVolumeTextField.text = volume
    addInterventionVC.irrigationUnitButton.setTitle(unit, for: .normal)

    //Then
    let expectedString = String(format: "input_quantity_per_surface".localized, volume, unit)
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString, "Wrong error label text")
  }
}
