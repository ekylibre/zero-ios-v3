//
//  EquipmentsTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class EquipmentsTests: XCTestCase {

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
                   "errorLabel must be hidden when there is an error")
  }

  func test_updateEquipmentsCountLabelWithoutEquipment_shouldNotChange() {
    //When
    addInterventionVC.selectedEquipments.removeAll()
    addInterventionVC.updateEquipmentsCountLabel()

    //Then
    XCTAssertEqual(addInterventionVC.equipmentsCountLabel.text, "none".localized, "Should have no equipments")
  }
}
