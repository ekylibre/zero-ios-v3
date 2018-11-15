//
//  EquipmentsTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
import CoreData
@testable import Clic_Farm_iOS

class EquipmentsTests: XCTestCase {

  var addInterventionVC: AddInterventionViewController!
  var sut: StorageManager!
  let managedObjectModel: NSManagedObjectModel = {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    return managedObjectModel
  }()
  lazy var mockPersistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MockedContainer", managedObjectModel: self.managedObjectModel)
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

  func test_checkEquipmentName_withValidName_shouldReturnTrue() {
    //Given
    let name = "Sample equipment"

    //When
    addInterventionVC.equipmentsSelectionView.equipments.removeAll()
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.equipments.count, 0, "equipments must be empty")
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertTrue(addInterventionVC.equipmentsSelectionView.checkEquipmentName(),
                  "checkEquipmentName must return true when the name is valid")
    XCTAssertTrue(addInterventionVC.equipmentsSelectionView.creationView.errorLabel.isHidden,
                   "errorLabel must be hidden when there is not any error")
  }

  func test_checkEquipmentName_withEmptyName_shouldReturnFalse() {
    //Given
    let name = ""

    //When
    addInterventionVC.equipmentsSelectionView.equipments.removeAll()
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.equipments.count, 0, "equipments must be empty")
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertFalse(addInterventionVC.equipmentsSelectionView.checkEquipmentName(),
                  "checkEquipmentName must return false when the name is empty")
    XCTAssertFalse(addInterventionVC.equipmentsSelectionView.creationView.errorLabel.isHidden,
                   "errorLabel must not be hidden when there is an error")
  }

  func test_checkEquipmentName_withUniqueName_shouldReturnTrue() {
    //Given
    let equipment = sut.insertObject(entityName: "Equipment") as! Equipment
    let name = "Sample"

    //When
    addInterventionVC.equipmentsSelectionView.equipments.removeAll()
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.equipments.count, 0, "equipments must be empty")
    equipment.name = "Sample equipment"
    addInterventionVC.equipmentsSelectionView.equipments.append(equipment)
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.equipments.count, 1,
                   "equipments must contain newly created equipment")
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertTrue(addInterventionVC.equipmentsSelectionView.checkEquipmentName(),
                  "checkEquipmentName must return true when there is not an existing equipment with this same name")
    XCTAssertTrue(addInterventionVC.equipmentsSelectionView.creationView.errorLabel.isHidden,
                   "errorLabel must be hidden when there is not any error")
  }

  func test_checkEquipmentName_withExistingName_shouldReturnFalse() {
    //Given
    let equipment = sut.insertObject(entityName: "Equipment") as! Equipment
    let name = "Sample equipment"

    //When
    addInterventionVC.equipmentsSelectionView.equipments.removeAll()
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.equipments.count, 0, "equipments must be empty")
    equipment.name = "Sample equipment"
    addInterventionVC.equipmentsSelectionView.equipments.append(equipment)
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.equipments.count, 1,
                   "equipments must contain newly created equipment")
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertFalse(addInterventionVC.equipmentsSelectionView.checkEquipmentName(),
                  "checkEquipmentName must return false when the name is already taken by an equipment")
    XCTAssertFalse(addInterventionVC.equipmentsSelectionView.creationView.errorLabel.isHidden,
                   "errorLabel must not be hidden when there is an error")
  }

  func test_equipmentsCountLabel_withoutSelectedEquipments_shouldBeHidden() {
    //When
    addInterventionVC.selectedEquipments.removeAll()
    XCTAssertEqual(addInterventionVC.selectedEquipments.count, 0, "selectedEquipments must be empty")
    addInterventionVC.tapEquipmentsView()
    addInterventionVC.tapEquipmentsView()

    //Then
    XCTAssertTrue(addInterventionVC.equipmentsCountLabel.isHidden,
                  "equipmentsCountLabel must be hidden if selectedEquipments is empty")
  }

  func test_equipmentsCountLabel_withSingleSelectedEquipment_shouldBeDisplayed() {
    //Given
    let equipment = sut.insertObject(entityName: "Equipment") as! Equipment

    //When
    addInterventionVC.selectedEquipments.removeAll()
    XCTAssertEqual(addInterventionVC.selectedEquipments.count, 0, "selectedEquipments must be empty")
    addInterventionVC.selectedEquipments.append(equipment)
    XCTAssertEqual(addInterventionVC.selectedEquipments.count, 1, "selectedEquipments must contain new equipment")
    addInterventionVC.tapEquipmentsView()
    addInterventionVC.tapEquipmentsView()

    //Then
    XCTAssertFalse(addInterventionVC.equipmentsCountLabel.isHidden,
                   "equipmentsCountLabel must not be hidden if selectedEquipments is not empty")
    XCTAssertEqual(addInterventionVC.equipmentsCountLabel.text, "equipment".localized,
                   "equipmentsCountLabel text must be 'equipment' when only one equipment is selected")
  }

  func test_equipmentsCountLabel_withMultipleSelectedEquipments_shouldBeDisplayed() {
    //Given
    let firstEquipment = sut.insertObject(entityName: "Equipment") as! Equipment
    let secondEquipment = sut.insertObject(entityName: "Equipment") as! Equipment
    let thirdEquipment = sut.insertObject(entityName: "Equipment") as! Equipment

    //When
    addInterventionVC.selectedEquipments.removeAll()
    XCTAssertEqual(addInterventionVC.selectedEquipments.count, 0, "selectedEquipments must be empty")
    addInterventionVC.selectedEquipments.append(firstEquipment)
    addInterventionVC.selectedEquipments.append(secondEquipment)
    addInterventionVC.selectedEquipments.append(thirdEquipment)
    XCTAssertEqual(addInterventionVC.selectedEquipments.count, 3, "selectedEquipments must contain new equipments")
    addInterventionVC.tapEquipmentsView()
    addInterventionVC.tapEquipmentsView()

    //Then
    XCTAssertFalse(addInterventionVC.equipmentsCountLabel.isHidden,
                   "equipmentsCountLabel must not be hidden if selectedEquipments is not empty")
    XCTAssertEqual(addInterventionVC.equipmentsCountLabel.text, String(format: "equipments".localized, 3),
                   "equipmentsCountLabel text must be 'equipments' when multiple equipments are selected")
  }
}
