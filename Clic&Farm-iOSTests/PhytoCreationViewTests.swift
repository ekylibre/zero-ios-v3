//
//  PhytoCreationViewTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 15/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class PhytoCreationViewTests: XCTestCase {

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

  func test_textFieldShouldReturn_withMaaTextField_shouldReturnFalse() {
    // Then
    XCTAssertFalse(addInterventionVC.inputsSelectionView.phytoView.textFieldShouldReturn(
      addInterventionVC.inputsSelectionView.phytoView.maaTextField))
  }

  func test_closeView_withSenderIsCancelButton() {
    // When
    addInterventionVC.inputsSelectionView.phytoView.cancelButton.sendActions(for: .touchUpInside)

    // Then
    let text = addInterventionVC.inputsSelectionView.phytoView.nameTextField.text
    XCTAssertEqual(text, "", "Text field should be empty")
    XCTAssertTrue(addInterventionVC.inputsSelectionView.phytoView.isHidden, "Phyto creation view should be hidden")
  }

  func test_closeView_withSenderIsCreateButton() {
    // When
    addInterventionVC.inputsSelectionView.phytoView.createButton.sendActions(for: .touchUpInside)

    // Then
    XCTAssertTrue(addInterventionVC.inputsSelectionView.phytoView.isHidden, "Seed creation view should be hidden")
  }
}
