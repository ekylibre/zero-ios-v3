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

  func test_checkPeronsName_withNoExistingPersonsAndAFirstNameAndALastName_shouldReturnTrue() {
    //Given
    let firstName = "Sample fist name"
    let lastName = "Sample last name"

    //When
    addInterventionVC.personsSelectionView.persons.removeAll()
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    //Then
    XCTAssertEqual(addInterventionVC.personsSelectionView.checkPersonName(), true,
                   "Should return true")
  }

  func test_checkPeronsName_withNoExistingPersonsAndAFirstName_shouldReturnFalse() {
    //Given
    let firstName = "Sample fist name"

    //When
    addInterventionVC.personsSelectionView.persons.removeAll()
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName

    //Then
    XCTAssertEqual(addInterventionVC.personsSelectionView.checkPersonName(), false,
                   "Should return false")
  }

  func test_checkPeronsName_withNoExistingPersonsAndALastName_shouldReturnFalse() {
    //Given
    let lastName = "Sample last name"

    //When
    addInterventionVC.personsSelectionView.persons.removeAll()
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    //Then
    XCTAssertEqual(addInterventionVC.personsSelectionView.checkPersonName(), false,
                   "Should return false")
  }

  func test_checkPeronsName_withNoExistingPersonsAndNoName_shouldReturnFalse() {
    //When
    addInterventionVC.personsSelectionView.persons.removeAll()
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = nil

    //Then
    XCTAssertEqual(addInterventionVC.personsSelectionView.checkPersonName(), false,
                   "Should return false")
  }
}
