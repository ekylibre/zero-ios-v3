//
//  AddInterventionVCTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 15/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class AddInterventionVCTests: XCTestCase {
  
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

  func test_setupViewsAccordingInterventionType_withCareType() {
    // When
    addInterventionVC.interventionType = InterventionType.Care.rawValue
    addInterventionVC.setupViewsAccordingInterventionType()

    // Then
    XCTAssertFalse(addInterventionVC.materialsView.isHidden, "Materials view should be displayed")
    XCTAssertFalse(addInterventionVC.materialsSeparatorView.isHidden, "Materials separator view should be displayed")
  }

  func test_setupViewsAccordingInterventionType_withCropProtectionType() {
    // When
    addInterventionVC.interventionType = InterventionType.CropProtection.rawValue
    addInterventionVC.setupViewsAccordingInterventionType()

    // Then
    XCTAssertEqual(addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex, 1,
                   "Phytos selection view should appear first")
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.title(for: .normal),
                   "create_new_phyto".localized.uppercased(), "Create button should have right title")
  }

  func test_setupViewsAccordingInterventionType_withFertilizationType() {
    // When
    addInterventionVC.interventionType = InterventionType.Fertilization.rawValue
    addInterventionVC.setupViewsAccordingInterventionType()

    // Then
    XCTAssertEqual(addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex, 2,
                   "Fertilizers selection view should appear first")
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.title(for: .normal),
                   "create_new_ferti".localized.uppercased(), "Create button should have right title")
  }

  func test_setupViewsAccordingInterventionType_withGroundWorkType() {
    // When
    addInterventionVC.interventionType = InterventionType.GroundWork.rawValue
    addInterventionVC.setupViewsAccordingInterventionType()

    // Then
    XCTAssertTrue(addInterventionVC.inputsView.isHidden, "Inputs view should be hidden")
    XCTAssertTrue(addInterventionVC.inputsSeparatorView.isHidden, "Inputs separator view should be hidden")
  }

  func test_setupViewsAccordingInterventionType_withHarvestType() {
    // When
    addInterventionVC.interventionType = InterventionType.Harvest.rawValue
    addInterventionVC.setupViewsAccordingInterventionType()

    // Then
    XCTAssertFalse(addInterventionVC.harvestView.isHidden, "Harvest view should be displayed")
    XCTAssertFalse(addInterventionVC.harvestSeparatorView.isHidden, "Harvest separator view should be displayed")
    XCTAssertTrue(addInterventionVC.inputsView.isHidden, "Inputs view should be hidden")
    XCTAssertTrue(addInterventionVC.inputsSeparatorView.isHidden, "Inputs separator view should be hidden")
  }

  func test_setupViewsAccordingInterventionType_withIrrigationType() {
    // When
    addInterventionVC.interventionType = InterventionType.Irrigation.rawValue
    addInterventionVC.setupViewsAccordingInterventionType()

    // Then
    XCTAssertFalse(addInterventionVC.irrigationView.isHidden, "Irrigation view should be displayed")
    XCTAssertFalse(addInterventionVC.irrigationSeparatorView.isHidden, "Irrigation separator view should be displayed")
  }
}
