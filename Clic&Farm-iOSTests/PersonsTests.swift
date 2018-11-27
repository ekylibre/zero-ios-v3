//
//  PersonsTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
import CoreData
@testable import Clic_Farm_iOS

class PersonsTests: XCTestCase {
  
  var addInterventionVC: AddInterventionViewController!
  var sut: StorageManager!
  let managedObjectModel: NSManagedObjectModel = {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    return managedObjectModel
  }()
  lazy var mockPersistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MockedContainer", managedObjectModel: managedObjectModel)
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { (description, error) in
      precondition(description.type == NSInMemoryStoreType)

      if let error = error {
        fatalError("Create an in-mem coordinator failed \(error)")
      }
    }
    return container
  }()

  override func setUp() {
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    addInterventionVC = storyboard.instantiateViewController(withIdentifier: "AddInterventionVC") as? AddInterventionViewController
    let _ = addInterventionVC.view
    sut = StorageManager(container: mockPersistentContainer)
  }

  override func tearDown() {
    addInterventionVC = nil
    sut = nil
    super.tearDown()
  }

  func test_checkPersonName_withValidNames_shouldReturnTrue() {
    // Given
    let firstName = "Sample first name"
    let lastName = "Sample last name"

    // When
    addInterventionVC.personsSelectionView.persons.removeAll()
    XCTAssertEqual(addInterventionVC.personsSelectionView.persons.count, 0, "persons must be empty")
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    // Then
    XCTAssertTrue(addInterventionVC.personsSelectionView.checkPersonName(),
                  "checkPersonName must return true when firstName and lastName are valid")
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.firstNameErrorLabel.isHidden,
                  "firstNameErrorLabel must be hidden when there is not any error")
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.lastNameErrorLabel.isHidden,
                  "lastNameErrorLabel must be hidden when there is not any error")
  }

  func test_checkPersonName_withEmptyFirstName_shouldReturnFalse() {
    // Given
    let firstName = ""
    let lastName = "Sample last name"

    // When
    addInterventionVC.personsSelectionView.persons.removeAll()
    XCTAssertEqual(addInterventionVC.personsSelectionView.persons.count, 0, "persons must be empty")
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    // Then
    XCTAssertFalse(addInterventionVC.personsSelectionView.checkPersonName(),
                   "checkPersonName must return false when fistName is empty")
    XCTAssertFalse(addInterventionVC.personsSelectionView.creationView.firstNameErrorLabel.isHidden,
                   "firstNameErrorLabel must not be hidden when firstName is empty")
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.lastNameErrorLabel.isHidden,
                  "lastNameErrorLabel must be hidden when lastName is not empty")
  }

  func test_checkPersonName_withEmptyLastName_shouldReturnFalse() {
    // Given
    let firstName = "Sample first name"
    let lastName = ""

    // When
    addInterventionVC.personsSelectionView.persons.removeAll()
    XCTAssertEqual(addInterventionVC.personsSelectionView.persons.count, 0, "persons must be empty")
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    // Then
    XCTAssertEqual(addInterventionVC.personsSelectionView.checkPersonName(), false,
                   "checkPersonName must return false when lastName is empty")
    XCTAssertTrue(addInterventionVC.personsSelectionView.creationView.firstNameErrorLabel.isHidden,
                  "firstNameErrorLabel must be hidden when firstName is not empty")
    XCTAssertFalse(addInterventionVC.personsSelectionView.creationView.lastNameErrorLabel.isHidden,
                   "lastNameErrorLabel must not be hidden when lastName is empty")
  }

  func test_checkPersonName_withEmptyNames_shouldReturnFalse() {
    // Given
    let firstName = ""
    let lastName = ""

    // When
    addInterventionVC.personsSelectionView.persons.removeAll()
    XCTAssertEqual(addInterventionVC.personsSelectionView.persons.count, 0, "persons must be empty")
    addInterventionVC.personsSelectionView.creationView.firstNameTextField.text = firstName
    addInterventionVC.personsSelectionView.creationView.lastNameTextField.text = lastName

    // Then
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

  func test_personsCountLabel_withoutSelectedPersons_shouldBeHidden() {
    // When
    addInterventionVC.selectedPersons[0].removeAll()
    XCTAssertEqual(addInterventionVC.selectedPersons[0].count, 0, "selectedPersons must be empty")
    addInterventionVC.tapPersonsView()
    addInterventionVC.tapPersonsView()

    // Then
    XCTAssertTrue(addInterventionVC.personsCountLabel.isHidden,
                  "personsCountLabel must be hidden if selectedPersons is empty")
  }

  func test_personsCountLabel_withSingleSelectedPerson_shouldBeDisplayed() {
    // Given
    let person = sut.insertObject(entityName: "Person") as! Person

    // When
    addInterventionVC.selectedPersons[0].removeAll()
    XCTAssertEqual(addInterventionVC.selectedPersons[0].count, 0, "selectedPersons must be empty")
    addInterventionVC.selectedPersons[0].append(person)
    XCTAssertEqual(addInterventionVC.selectedPersons[0].count, 1, "selectedPersons must contain new person")
    addInterventionVC.tapPersonsView()
    addInterventionVC.tapPersonsView()

    // Then
    XCTAssertFalse(addInterventionVC.personsCountLabel.isHidden,
                   "personsCountLabel must not be hidden if selectedPersons is not empty")
    XCTAssertEqual(addInterventionVC.personsCountLabel.text, "person".localized,
                   "personsCountLabel text must be 'person' when only one person is selected")
  }

  func test_personsCountLabel_withMultipleSelectedPersons_shouldBeDisplayed() {
    // Given
    let firstPerson = sut.insertObject(entityName: "Person") as! Person
    let secondPerson = sut.insertObject(entityName: "Person") as! Person
    let thirdPerson = sut.insertObject(entityName: "Person") as! Person
    let fourthPerson = sut.insertObject(entityName: "Person") as! Person

    // When
    addInterventionVC.selectedPersons[0].removeAll()
    XCTAssertEqual(addInterventionVC.selectedPersons[0].count, 0, "selectedPersons must be empty")
    addInterventionVC.selectedPersons[0].append(firstPerson)
    addInterventionVC.selectedPersons[0].append(secondPerson)
    addInterventionVC.selectedPersons[0].append(thirdPerson)
    addInterventionVC.selectedPersons[0].append(fourthPerson)
    XCTAssertEqual(addInterventionVC.selectedPersons[0].count, 4, "selectedPersons must contain new persons")
    addInterventionVC.tapPersonsView()
    addInterventionVC.tapPersonsView()

    // Then
    XCTAssertFalse(addInterventionVC.personsCountLabel.isHidden,
                   "personsCountLabel must not be hidden if selectedPersons is not empty")
    XCTAssertEqual(addInterventionVC.personsCountLabel.text, String(format: "persons".localized, 4),
                   "personsCountLabel text must be 'persons' when multiple persons are selected")
  }
}
