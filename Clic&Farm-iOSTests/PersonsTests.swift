//
//  PersonsTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class PersonsTests: XCTestCase {
  
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

  func test_checkPeronsName_withValidNames_shouldReturnTrue() {
    //Given
    let firstName = "Sample first name"
    let lastName = "Sample last name"

    //When
    addInterventionVC.personsSelectionView.persons.removeAll()
    XCTAssertEqual(addInterventionVC.personsSelectionView.persons.count, 0, "persons must be empty")
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    //Then
    XCTAssertTrue(addInterventionVC.personsSelectionView.checkPersonName(),
                  "checkPersonName must return true when firstName and lastName are valid")
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.firstNameErrorLabel.isHidden,
                  "firstNameErrorLabel must be hidden when there is not any error")
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.lastNameErrorLabel.isHidden,
                  "lastNameErrorLabel must be hidden when there is not any error")
  }

  func test_checkPeronsName_withEmptyFirstName_shouldReturnFalse() {
    //Given
    let firstName = ""
    let lastName = "Sample last name"

    //When
    addInterventionVC.personsSelectionView.persons.removeAll()
    XCTAssertEqual(addInterventionVC.personsSelectionView.persons.count, 0, "persons must be empty")
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    //Then
    XCTAssertFalse(addInterventionVC.personsSelectionView.checkPersonName(),
                   "checkPersonName must return false when fistName is empty")
    XCTAssertFalse(addInterventionVC.personsSelectionView.creationView.firstNameErrorLabel.isHidden,
                   "firstNameErrorLabel must not be hidden when firstName is empty")
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.lastNameErrorLabel.isHidden,
                  "lastNameErrorLabel must be hidden when lastName is not empty")
  }

  func test_checkPeronsName_withEmptyLastName_shouldReturnFalse() {
    //Given
    let firstName = "Sample first name"
    let lastName = ""

    //When
    addInterventionVC.personsSelectionView.persons.removeAll()
    XCTAssertEqual(addInterventionVC.personsSelectionView.persons.count, 0, "persons must be empty")
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    //Then
    XCTAssertEqual(addInterventionVC.personsSelectionView.checkPersonName(), false,
                   "checkPersonName must return false when lastName is empty")
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.firstNameErrorLabel.isHidden,
                  "firstNameErrorLabel must be hidden when firstName is not empty")
    XCTAssertFalse(addInterventionVC.personsSelectionView.creationView.lastNameErrorLabel.isHidden,
                   "lastNameErrorLabel must not be hidden when lastName is empty")
  }

  func test_checkPeronsName_withEmptyNames_shouldReturnFalse() {
    //Given
    let firstName = ""
    let lastName = ""

    //When
    addInterventionVC.personsSelectionView.persons.removeAll()
    XCTAssertEqual(addInterventionVC.personsSelectionView.persons.count, 0, "persons must be empty")
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    //Then
    XCTAssertFalse(addInterventionVC.personsSelectionView.checkPersonName(),
                   "checkPersonName must return false when firstName and lastName are empty")
    XCTAssertFalse(addInterventionVC.personsSelectionView.creationView.firstNameErrorLabel.isHidden,
                   "firstNameErrorLabel must not be hidden when firstName is empty")
    XCTAssertFalse(addInterventionVC.personsSelectionView.creationView.lastNameErrorLabel.isHidden,
                   "lastNameErrorLabel must not be hidden when lastName is empty")
  }

  func test_firstNameDidChange_shouldHide() {
    // Given
    addInterventionVC.personsSelectionView.creationView.firstNameErrorLabel.isHidden = false

    // When
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.sendActions(for: .editingChanged)

    // Then
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.firstNameErrorLabel.isHidden, "Should be hidden")
  }

  func test_lastNameDidChange_shouldHide() {
    // Given
    addInterventionVC.personsSelectionView.creationView.lastNameErrorLabel.isHidden = false

    // When
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.sendActions(for: .editingChanged)

    // Then
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.lastNameErrorLabel.isHidden, "Should be hidden")
  }

  func test_openCreationView_shouldDisplay() {
    // Given
    addInterventionVC.personsSelectionView.creationView.isHidden = true
    addInterventionVC.personsSelectionView.dimView.isHidden = true

    // When
    addInterventionVC.personsSelectionView.createButton.sendActions(for: .touchUpInside)

    // Then
    XCTAssertFalse(addInterventionVC.personsSelectionView.creationView.isHidden, "Should be displayed")
    XCTAssertFalse(addInterventionVC.personsSelectionView.dimView.isHidden, "Should be displayed")
  }

  func test_cancelCreation_shouldCloseView() {
    // Given
    addInterventionVC.personsSelectionView.creationView.isHidden = false
    addInterventionVC.personsSelectionView.dimView.isHidden = false
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = "First name test"
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = "Last name test"

    // When
    addInterventionVC.personsSelectionView.creationView.cancelButton.sendActions(for: .touchUpInside)

    // Then
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.isHidden, "Should be hidden")
    XCTAssertTrue(addInterventionVC.personsSelectionView.dimView.isHidden, "Should be hidden")
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.isHidden, "Should be hidden")
    XCTAssertEqual(addInterventionVC.personsSelectionView.creationView.firstNameTextField.text, "", "Should be empty")
    XCTAssertEqual(addInterventionVC.personsSelectionView.creationView.lastNameTextField.text, "", "Should be empty")
  }
}
