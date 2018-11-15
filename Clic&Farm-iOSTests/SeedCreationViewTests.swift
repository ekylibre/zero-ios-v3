//
//  SeedCreationViewTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 15/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class SeedCreationViewTests: XCTestCase {

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

  func test_textFieldShouldReturn_shouldReturnFalse() {
    // Given
    let textField = UITextField()

    // Then
    XCTAssertFalse(addInterventionVC.inputsSelectionView.seedView.textFieldShouldReturn(textField),
                  "Should return false")
  }

  func test_closeView_withSenderIsCancelButton() {
    // When
    addInterventionVC.inputsSelectionView.seedView.cancelButton.sendActions(for: .touchUpInside)

    // Then
    let specie = addInterventionVC.inputsSelectionView.seedView.specieButton.title(for: .normal)
    XCTAssertEqual(specie, addInterventionVC.inputsSelectionView.seedView.firstSpecie.localized,
                   "Should be first specie")
    XCTAssertTrue(addInterventionVC.inputsSelectionView.seedView.isHidden, "Seed creation view should be hidden")
  }

  func test_closeView_withSenderIsCreateButton() {
    // When
    addInterventionVC.inputsSelectionView.seedView.createButton.sendActions(for: .touchUpInside)

    // Then
    XCTAssertTrue(addInterventionVC.inputsSelectionView.seedView.isHidden, "Seed creation view should be hidden")
  }
}
