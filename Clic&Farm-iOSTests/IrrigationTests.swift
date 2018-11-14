//
//  IrrigationTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Guillaume Roux on 13/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class IrrigationTests: XCTestCase {

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

  func test_errorLabel_withIntegerVolume_shouldBeUpdated() {
    //Given
    let _ = addInterventionVC.view
    let volume: Float = 34359293
    let unit = "HECTOLITER"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.totalLabel.text = "selected"
    addInterventionVC.irrigationVolumeTextField.text = String(volume)
    addInterventionVC.irrigationUnitButton.setTitle(unit.localized, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString = String(format: "input_quantity_per_surface".localized, volume, unit.localized)
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString, "Volume is an integer")
  }

  func test_errorLabel_withDecimalVolume_shouldBeUpdated() {
    //Given
    let _ = addInterventionVC.view
    let volume = 1.0530
    let unit = "HECTOLITER"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.totalLabel.text = "selected"
    addInterventionVC.irrigationVolumeTextField.text = String(volume)
    addInterventionVC.irrigationUnitButton.setTitle(unit.localized, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString = String(format: "input_quantity_per_surface".localized, volume, unit.localized)
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString, "Volume is a decimal")
  }

  func test_irrigationErrorLabel_withoutSelectedCrop_shouldNotUpdate() {
    //Given
    let _ = addInterventionVC.view
    let volume = 1.0530
    let unit = "HECTOLITER"

    //When
    addInterventionVC.irrigationVolumeTextField.text = String(volume)
    addInterventionVC.irrigationUnitButton.setTitle(unit.localized, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString = "no_crop_selected".localized
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString,
                   "Need to have at least one crop selected")
  }

  func test_errorLabel_withoutVolume_shouldNotUpdate() {
    //Given
    let _ = addInterventionVC.view
    let unit = "HECTOLITER"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.totalLabel.text = "selected"
    addInterventionVC.irrigationVolumeTextField.text = nil
    addInterventionVC.irrigationUnitButton.setTitle(unit.localized, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString = "volume_cannot_be_null".localized
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString, "Voulume shoud not be null")
  }

  func test_errorLabel_withVolumeEqualZero_shouldNotUpdate() {
    //Given
    let _ = addInterventionVC.view
    let volume = 0
    let unit = "HECTOLITER"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.totalLabel.text = "selected"
    addInterventionVC.irrigationVolumeTextField.text = String(volume)
    addInterventionVC.irrigationUnitButton.setTitle(unit.localized, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString = "volume_cannot_be_null".localized
    XCTAssertEqual(addInterventionVC.irrigationErrorLabel.text, expectedString, "Voulume shoud not be null")
  }

  func test_selectedIrrigationLabel_withoutVolume_shouldNotUpdate() {
    //Given
    let unit = "LITER"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.totalLabel.text = "selected"
    addInterventionVC.irrigationVolumeTextField.text = nil
    addInterventionVC.irrigationUnitButton.setTitle(unit.localized, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString =  String(format: "%@ • %g %@", "volume".localized, 0.0, unit.localized)
    XCTAssertEqual(addInterventionVC.selectedIrrigationLabel.text, expectedString, "Label should show volume without value")
  }

  func test_selectedIrrigationLabel_withVolume_shouldNotUpdate() {
    //Given
    let volume: Double = 42
    let unit = "LITER"

    //When
    addInterventionVC.cropsView.selectedCropsCount = 1
    addInterventionVC.cropsView.selectedSurfaceArea = 1
    addInterventionVC.totalLabel.text = "selected"
    addInterventionVC.irrigationVolumeTextField.text = String(volume)
    addInterventionVC.irrigationUnitButton.setTitle(unit.localized, for: .normal)
    addInterventionVC.irrigationVolumeTextField.sendActions(for: .editingChanged)

    //Then
    let expectedString =  String(format: "%@ • %g %@", "volume".localized, volume, unit.localized)
    XCTAssertEqual(addInterventionVC.selectedIrrigationLabel.text, expectedString,
                   "Label should be updated with volume when text fields is edited")
  }
}
