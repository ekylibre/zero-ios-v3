//
//  MaterialsTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class MaterialsTests: XCTestCase {

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

  func test_checkMaterialName_withValidName_shouldReturnTrue() {
    //Given
    let name = "Sample material"

    //When
    addInterventionVC.materialsSelectionView.materials.removeAll()
    XCTAssertEqual(addInterventionVC.materialsSelectionView.materials.count, 0, "materials must be empty")
    addInterventionVC.materialsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertTrue(addInterventionVC.materialsSelectionView.checkMaterialName(),
                  "checkMaterialName must return true when the name is valid")
    XCTAssertTrue(addInterventionVC.materialsSelectionView.creationView.errorLabel.isHidden,
                   "errorLabel must be hidden when there is not any error")
  }

  func test_checkMaterialName_withEmptyName_shouldReturnFalse() {
    //Given
    let name = ""

    //When
    addInterventionVC.materialsSelectionView.materials.removeAll()
    XCTAssertEqual(addInterventionVC.materialsSelectionView.materials.count, 0, "materials must be empty")
    addInterventionVC.materialsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertFalse(addInterventionVC.materialsSelectionView.checkMaterialName(),
                  "checkMaterialName must return true when the name is empty")
    XCTAssertFalse(addInterventionVC.materialsSelectionView.creationView.errorLabel.isHidden,
                   "errorLabel must not be hidden when there is an error")
  }

  func test_updateMaterialsCountLabelWithoutEquipment_shouldNotChange() {
    //When
    addInterventionVC.selectedMaterials[0].removeAll()
    addInterventionVC.updateMaterialsCountLabel()

    //Then
    XCTAssertEqual(addInterventionVC.materialsCountLabel.text, "none".localized, "Should have no materials")
  }
}
