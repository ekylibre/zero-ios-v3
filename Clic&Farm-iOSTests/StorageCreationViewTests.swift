//
//  StorageCreationViewTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 15/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class StorageCreationViewTests: XCTestCase {

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
    XCTAssertFalse(addInterventionVC.storageCreationView.textFieldShouldReturn(textField), "Should return false")
  }

  func test_nameDidChange_withErrorLabelIsDisplayed() {
    // Given
    addInterventionVC.storageCreationView.errorLabel.isHidden = false

    // When
    addInterventionVC.storageCreationView.nameTextField.sendActions(for: .editingChanged)

    // Then
    XCTAssertTrue(addInterventionVC.storageCreationView.errorLabel.isHidden,
                  "Error label should be hidden after editing name text field")
  }
}
