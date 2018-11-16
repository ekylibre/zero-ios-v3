//
//  InputsTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 16/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
import CoreData
@testable import Clic_Farm_iOS

class InputsTests: XCTestCase {

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

  func test_inputsCountLabel_withSingleSelectedInput_shouldBeDisplayed() {
    // Given
    let seed = sut.insertObject(entityName: "Seed") as! Seed

    // When
    addInterventionVC.selectedInputs.removeAll()
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 0, "selectedInputs must be empty")
    addInterventionVC.selectedInputs.append(seed)
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 1, "selectedInputs must contain new seed")
    addInterventionVC.tapInputsView()
    addInterventionVC.tapInputsView()

    // Then
    XCTAssertFalse(addInterventionVC.inputsCountLabel.isHidden,
                   "inputsCountLabel must not be hidden if selectedInputs is not empty")
    XCTAssertEqual(addInterventionVC.inputsCountLabel.text, "input".localized,
                   "inputsCountLabel text must be 'input' when only one input is selected")
  }

  func test_inputsCountLabel_withMultipleSelectedInputs_shouldBeDisplayed() {
    // Given
    let firstInput = sut.insertObject(entityName: "Fertilizer") as! Fertilizer
    let secondInput = sut.insertObject(entityName: "Phyto") as! Phyto

    // When
    addInterventionVC.selectedInputs.removeAll()
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 0, "selectedInputs must be empty")
    addInterventionVC.selectedInputs.append(firstInput)
    addInterventionVC.selectedInputs.append(secondInput)
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 2, "selectedInputs must contain new inputs")
    addInterventionVC.tapInputsView()
    addInterventionVC.tapInputsView()

    // Then
    XCTAssertFalse(addInterventionVC.inputsCountLabel.isHidden,
                   "inputsCountLabel must not be hidden if selectedInputs is not empty")
    XCTAssertEqual(addInterventionVC.inputsCountLabel.text, String(format: "inputs".localized, 2),
                   "inputsCountLabel text must be 'inputs' when multiple inputs are selected")
  }

  func test_inputsCountLabel_withoutSelectedInputs_shouldBeHidden() {
    // When
    addInterventionVC.selectedInputs.removeAll()
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 0, "selectedInputs must be empty")
    addInterventionVC.tapInputsView()
    addInterventionVC.tapInputsView()

    // Then
    XCTAssertTrue(addInterventionVC.inputsCountLabel.isHidden,
                  "inputsCountLabel must be hidden if selectedInputs is empty")
  }
}
