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
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    addInterventionVC = storyboard.instantiateViewController(withIdentifier: "AddInterventionVC") as? AddInterventionViewController
  }

  override func tearDown() {
    addInterventionVC = nil
    super.tearDown()
  }

  func test_irrigationErrorLabel_isUpdated() {
    //Given
    let _ = addInterventionVC.view
    let volume = 1.0530
    let unit = "HECTOLITER"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.totalLabel.text = "selected"
    addInterventionVC.irrigationVolumeTextField.text = String(volume)
    addInterventionVC.irrigationUnitButton.setTitle(unit, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString = String(format: "input_quantity_per_surface".localized, volume, unit.localized)
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString, "Wrong error label text")
  }

  func test_irrigationErrorLabel_withNoCropSelected_shouldNotUpdate() {
    //Given
    let _ = addInterventionVC.view
    let volume = 1.0230
    let unit = "HECTOLITER"

    //When
    addInterventionVC.irrigationVolumeTextField.text = String(volume)
    addInterventionVC.irrigationUnitButton.setTitle(unit, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString = "no_crop_selected".localized
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString, "Wrong error label text")
  }

  func test_irrigationErrorLabel_withoutVolume_shouldNotUpdate() {
    //Given
    let _ = addInterventionVC.view
    let unit = "HECTOLITER"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.totalLabel.text = "selected"
    addInterventionVC.irrigationVolumeTextField.text = nil
    addInterventionVC.irrigationUnitButton.setTitle(unit, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString = "volume_cannot_be_null".localized
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString, "Wrong error label text")
  }

  func test_irrigationErrorLabel_withVolumeEqualZero_shouldNotUpdate() {
    //Given
    let _ = addInterventionVC.view
    let volume = 0
    let unit = "HECTOLITER"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.totalLabel.text = "selected"
    addInterventionVC.irrigationVolumeTextField.text = String(volume)
    addInterventionVC.irrigationUnitButton.setTitle(unit, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString = "volume_cannot_be_null".localized
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString, "Wrong error label text")
  }
}
