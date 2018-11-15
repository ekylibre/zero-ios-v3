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

  func test_checkPeronsName_withoutExistingPersonsAndALastName_shouldReturnFalse() {
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
}
