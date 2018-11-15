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

  func test_checkEquipmentName_withoutExistingEquipmentAndAName_shouldNotDisplayError() {
    //Given
    let name = "Sample material"

    //When
    addInterventionVC.equipmentsSelectionView.equipments.removeAll()
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.checkEquipmentName(), true,
                   "Should not display error label")
  }

  func test_checkEquipmentName_withoutExistingEquipmentAndNoName_shouldDisplayError() {
    //When
    addInterventionVC.equipmentsSelectionView.equipments.removeAll()
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = nil
    let _ = addInterventionVC.equipmentsSelectionView.checkEquipmentName()

    //Then
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.creationView.errorLabel.text, "equipment_name_is_empty".localized,
                   "Should display empty name error label")
  }

  func test_checkEquipmentName_withAExistingEquipmentAndASameName_shouldDisplayError() {
    //Given
    let name = "Sample equipment 1"

    //When
    addInterventionVC.equipmentsSelectionView.createEquipment(name: "Sample equipment 1", number: "1")
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = name
    let _ = addInterventionVC.equipmentsSelectionView.checkEquipmentName()

    //Then
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.creationView.errorLabel.text, "equipment_name_not_available".localized,
                   "Should display same name error label")
  }

  func test_checkEquipmentName_withAExistingEquipmentAndAName_shouldNotDisplayError() {
    //Given
    let name = "Useless equipment"

    //When
    addInterventionVC.equipmentsSelectionView.createEquipment(name: "Sample equipment 1", number: "1")
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.checkEquipmentName(), true,
                   "Should not display error label")
  }

  func test_checkEquipmentName_withExistingEquipmentsAndASameName_shouldDisplayError() {
    //Given
    let name = "Sample equipment 1"

    //When
    addInterventionVC.equipmentsSelectionView.createEquipment(name: "Sample equipment 1", number: "1")
    addInterventionVC.equipmentsSelectionView.createEquipment(name: "Sample equipment 2", number: "42")
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = name
    let _ = addInterventionVC.equipmentsSelectionView.checkEquipmentName()

    //Then
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.creationView.errorLabel.text, "equipment_name_not_available".localized,
                   "Should display same name error label")
  }

  func test_checkEquipmentName_withExistingEquipmentsAndAName_shouldNotDisplayError() {
    //Given
    let name = "Basic equipment"

    //When
    addInterventionVC.equipmentsSelectionView.createEquipment(name: "Sample equipment 1", number: "1")
    addInterventionVC.equipmentsSelectionView.createEquipment(name: "Sample equipment 1", number: "42")
    addInterventionVC.equipmentsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertEqual(addInterventionVC.equipmentsSelectionView.checkEquipmentName(), true,
                   "Should not display error label")
  }
}
