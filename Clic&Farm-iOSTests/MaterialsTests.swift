//
//  MaterialsTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
import CoreData
@testable import Clic_Farm_iOS

class MaterialsTests: XCTestCase {

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

  func test_checkMaterialName_withValidName_shouldReturnTrue() {
    // Given
    let name = "Sample material"

    // When
    addInterventionVC.materialsSelectionView.materials.removeAll()
    XCTAssertEqual(addInterventionVC.materialsSelectionView.materials.count, 0, "materials must be empty")
    addInterventionVC.materialsSelectionView.creationView.nameTextField.text = name

    // Then
    XCTAssertTrue(addInterventionVC.materialsSelectionView.checkMaterialName(),
                  "checkMaterialName must return true when the name is valid")
    XCTAssertTrue(addInterventionVC.materialsSelectionView.creationView.errorLabel.isHidden,
                  "errorLabel must be hidden when there is not any error")
  }

  func test_checkMaterialName_withEmptyName_shouldReturnFalse() {
    // Given
    let name = ""

    // When
    addInterventionVC.materialsSelectionView.materials.removeAll()
    XCTAssertEqual(addInterventionVC.materialsSelectionView.materials.count, 0, "materials must be empty")
    addInterventionVC.materialsSelectionView.creationView.nameTextField.text = name

    // Then
    XCTAssertFalse(addInterventionVC.materialsSelectionView.checkMaterialName(),
                   "checkMaterialName must return true when the name is empty")
    XCTAssertFalse(addInterventionVC.materialsSelectionView.creationView.errorLabel.isHidden,
                   "errorLabel must not be hidden when there is an error")
  }

  func test_checkMaterialName_withUniqueName_shouldReturnTrue() {
    // Given
    let material = sut.insertObject(entityName: "Material") as! Material
    let name = "Sample"

    // When
    addInterventionVC.materialsSelectionView.materials.removeAll()
    XCTAssertEqual(addInterventionVC.materialsSelectionView.materials.count, 0, "materials must be empty")
    material.name = "Sample material"
    addInterventionVC.materialsSelectionView.materials.append(material)
    XCTAssertEqual(addInterventionVC.materialsSelectionView.materials.count, 1,
                   "materials must contain newly created material")
    addInterventionVC.materialsSelectionView.creationView.nameTextField.text = name

    // Then
    XCTAssertTrue(addInterventionVC.materialsSelectionView.checkMaterialName(),
                  "checkMaterialName must return true when there is not an existing material with this same name")
    XCTAssertTrue(addInterventionVC.materialsSelectionView.creationView.errorLabel.isHidden,
                  "errorLabel must be hidden when there is not any error")
  }

  func test_checkMaterialName_withExistingName_shouldReturnFalse() {
    // Given
    let material = sut.insertObject(entityName: "Material") as! Material
    let name = "Sample material"

    // When
    addInterventionVC.materialsSelectionView.materials.removeAll()
    XCTAssertEqual(addInterventionVC.materialsSelectionView.materials.count, 0, "materials must be empty")
    material.name = "Sample material"
    addInterventionVC.materialsSelectionView.materials.append(material)
    XCTAssertEqual(addInterventionVC.materialsSelectionView.materials.count, 1,
                   "materials must contain newly created material")
    addInterventionVC.materialsSelectionView.creationView.nameTextField.text = name

    // Then
    XCTAssertFalse(addInterventionVC.materialsSelectionView.checkMaterialName(),
                   "checkMaterialName must return false when the name is already taken by a material")
    XCTAssertFalse(addInterventionVC.materialsSelectionView.creationView.errorLabel.isHidden,
                   "errorLabel must not be hidden when there is an error")
  }

  func test_searchBarCancelButtonClicked() {
    // Given
    let searchBar = addInterventionVC.materialsSelectionView.searchBar
    addInterventionVC.materialsSelectionView.isSearching = true

    // Then
    addInterventionVC.materialsSelectionView.searchBarCancelButtonClicked(searchBar)

    // When
    XCTAssertFalse(addInterventionVC.materialsSelectionView.isSearching, "Shouldn't searching")
  }

  func test_materialsCountLabel_withoutSelectedMaterials_shouldBeHidden() {
    // When
    addInterventionVC.selectedMaterials[0].removeAll()
    XCTAssertEqual(addInterventionVC.selectedMaterials[0].count, 0, "selectedMaterials must be empty")
    addInterventionVC.tapMaterialsView()
    addInterventionVC.tapMaterialsView()

    // Then
    XCTAssertTrue(addInterventionVC.materialsCountLabel.isHidden,
                  "materialsCountLabel must be hidden if selectedMaterials is empty")
  }

  func test_materialsCountLabel_withSingleSelectedMaterial_shouldBeDisplayed() {
    // Given
    let material = sut.insertObject(entityName: "Material") as! Material

    // When
    addInterventionVC.selectedMaterials[0].removeAll()
    XCTAssertEqual(addInterventionVC.selectedMaterials[0].count, 0, "selectedMaterials must be empty")
    addInterventionVC.selectedMaterials[0].append(material)
    XCTAssertEqual(addInterventionVC.selectedMaterials[0].count, 1, "selectedMaterials must contain new material")
    addInterventionVC.tapMaterialsView()
    addInterventionVC.tapMaterialsView()

    // Then
    XCTAssertFalse(addInterventionVC.materialsCountLabel.isHidden,
                   "materialsCountLabel must not be hidden if selectedMaterials is not empty")
    XCTAssertEqual(addInterventionVC.materialsCountLabel.text, "material".localized,
                   "materialsCountLabel text must be 'material' when only one material is selected")
  }

  func test_materialsCountLabel_withMultipleSelectedMaterials_shouldBeDisplayed() {
    // Given
    let firstMaterial = sut.insertObject(entityName: "Material") as! Material
    let secondMaterial = sut.insertObject(entityName: "Material") as! Material

    // When
    addInterventionVC.selectedMaterials[0].removeAll()
    XCTAssertEqual(addInterventionVC.selectedMaterials[0].count, 0, "selectedMaterials must be empty")
    addInterventionVC.selectedMaterials[0].append(firstMaterial)
    addInterventionVC.selectedMaterials[0].append(secondMaterial)
    XCTAssertEqual(addInterventionVC.selectedMaterials[0].count, 2, "selectedMaterials must contain new materials")
    addInterventionVC.tapMaterialsView()
    addInterventionVC.tapMaterialsView()

    // Then
    XCTAssertFalse(addInterventionVC.materialsCountLabel.isHidden,
                   "materialsCountLabel must not be hidden if selectedMaterials is not empty")
    XCTAssertEqual(addInterventionVC.materialsCountLabel.text, String(format: "materials".localized, 2),
                   "materialsCountLabel text must be 'materials' when multiple materials are selected")
  }
}
