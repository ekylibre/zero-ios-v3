//
//  CropsTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Guillaume Roux on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class CropsTests: XCTestCase {

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

  func test_totalLabel_withoutSelection_shouldNotChange() {
    //When
    XCTAssertEqual(addInterventionVC.totalLabel.text, "select_crops".localized.uppercased(),
                   "Total label should be select_crops before sendActions")
    addInterventionVC.cropsView.validateButton.sendActions(for: .touchUpInside)

    //Then
    XCTAssertEqual(addInterventionVC.totalLabel.text, "select_crops".localized.uppercased(),
                   "Total label should not change if no crop have been selected")
  }

  func test_totalLabel_withSelection_shouldChange() {
    //Given
    let cropsCount = 12
    let surfaceArea: Float = 284.225

    //When
    XCTAssertEqual(addInterventionVC.totalLabel.text, "select_crops".localized.uppercased(),
                   "Total label should be select_crops before sendActions")
    addInterventionVC.cropsView.selectedCropsCount = cropsCount
    addInterventionVC.cropsView.selectedSurfaceArea = surfaceArea
    addInterventionVC.cropsView.updateSelectedCropsLabel()
    addInterventionVC.cropsView.validateButton.sendActions(for: .touchUpInside)

    //Then
    XCTAssertEqual(addInterventionVC.totalLabel.text, addInterventionVC.cropsView.selectedCropsLabel.text,
                   "Total label should change if crop(s) have been selected")
  }
}
