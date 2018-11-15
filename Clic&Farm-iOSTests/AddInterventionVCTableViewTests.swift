//
//  AddInterventionVCTableViewTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 15/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class AddInterventionVCTableViewTests: XCTestCase {

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

  func test_tableViewNumberOfRowsInSection_withSelectedInputsTableViewAndNoData_shouldReturnZero() {
    //When
    addInterventionVC.selectedInputs.removeAll()
    addInterventionVC.selectedInputsTableView.reloadData()

    //Then
    let numberOfRowsInSection = addInterventionVC.tableView(
      addInterventionVC.selectedInputsTableView,
      numberOfRowsInSection: addInterventionVC.selectedInputs.count)

    XCTAssertEqual(numberOfRowsInSection, 0, "Should have no inputs")
  }

  func test_tableViewNumberOfRowsInSection_withSelectedMaterialsTableViewAndNoData_shouldReturnZero() {
    //When
    addInterventionVC.selectedMaterials[0].removeAll()
    addInterventionVC.selectedMaterialsTableView.reloadData()

    //Then
    let numberOfRowsInSection = addInterventionVC.tableView(
      addInterventionVC.selectedMaterialsTableView,
      numberOfRowsInSection: addInterventionVC.selectedMaterials[0].count)

    XCTAssertEqual(numberOfRowsInSection, 0, "Should have no materials")
  }

  func test_tableViewNumberOfRowsInSection_withSelectedEquipmentsTableViewAndNoData_shouldReturnZero() {
    //When
    addInterventionVC.selectedEquipments.removeAll()
    addInterventionVC.selectedEquipmentsTableView.reloadData()

    //Then
    let numberOfRowsInSection = addInterventionVC.tableView(
      addInterventionVC.selectedEquipmentsTableView,
      numberOfRowsInSection: addInterventionVC.selectedEquipments.count)

    XCTAssertEqual(numberOfRowsInSection, 0, "Should have no equipments")
  }

  func test_tableViewNumberOfRowsInSection_withSelectedPersonsTableViewAndNoData_shouldReturnZero() {
    //When
    addInterventionVC.selectedPersons[0].removeAll()
    addInterventionVC.selectedPersonsTableView.reloadData()

    //Then
    let numberOfRowsInSection = addInterventionVC.tableView(
      addInterventionVC.selectedPersonsTableView,
      numberOfRowsInSection: addInterventionVC.selectedPersons[0].count)

    XCTAssertEqual(numberOfRowsInSection, 0, "Should have no persons")
  }

  func test_tableViewNumberOfRowsInSection_withHarvestTableViewAndNoData_shouldReturnZero() {
    //When
    addInterventionVC.harvests.removeAll()
    addInterventionVC.harvestTableView.reloadData()

    //Then
    let numberOfRowsInSection = addInterventionVC.tableView(
      addInterventionVC.harvestTableView,
      numberOfRowsInSection: addInterventionVC.harvests.count)

    XCTAssertEqual(numberOfRowsInSection, 0, "Should have no harvests")
  }

  func test_tableViewNumberOfRowsInSection_withRandomTableViewAndNoData_shouldReturnOne() {
    //Given
    let tableView = UITableView()

    //Then
    let numberOfRowsInSection = addInterventionVC.tableView(
      tableView,
      numberOfRowsInSection: 0)

    XCTAssertEqual(numberOfRowsInSection, 1, "Should return one")
  }

  func test_tableViewHeightForRowAndEstimatedHeightForRow_withHarvestTableView() {
    //Given
    let indexPath = IndexPath(row: 0, section: 0)
    let heightForRow = addInterventionVC.tableView(
      addInterventionVC.harvestTableView,
      heightForRowAt: indexPath)
    let estimatedHeight = addInterventionVC.tableView(
      addInterventionVC.harvestTableView,
      estimatedHeightForRowAt: indexPath)

    //Then
    XCTAssertEqual(heightForRow, 150, "Height should be 150")
    XCTAssertEqual(estimatedHeight, 150, "Estimated height should be 150")
  }

  func test_tableViewHeightForRowAndEstimatedHeightForRow_withSelectedInputsTableView() {
    //Given
    let indexPath = IndexPath(row: 0, section: 0)
    let heightForRow = addInterventionVC.tableView(
      addInterventionVC.selectedInputsTableView,
      heightForRowAt: indexPath)
    let estimatedHeight = addInterventionVC.tableView(
      addInterventionVC.selectedInputsTableView,
      estimatedHeightForRowAt: indexPath)

    //Then
    XCTAssertEqual(heightForRow, 110, "Height should be 110")
    XCTAssertEqual(estimatedHeight, 110, "Estimated height should be 110")
  }

  func test_tableViewHeightForRowAndEstimatedHeightForRow_withSelectedMaterialsTableView() {
    //Given
    let indexPath = IndexPath(row: 0, section: 0)
    let heightForRow = addInterventionVC.tableView(
      addInterventionVC.selectedMaterialsTableView,
      heightForRowAt: indexPath)
    let estimatedHeight = addInterventionVC.tableView(
      addInterventionVC.selectedMaterialsTableView,
      estimatedHeightForRowAt: indexPath)

    //Then
    XCTAssertEqual(heightForRow, 80, "Height should be 80")
    XCTAssertEqual(estimatedHeight, 80, "Estimated height should be 80")
  }

  func test_tableViewHeightForRowAndEstimatedHeightForRow_withSelectedEquipmentsTableView() {
    //Given
    let indexPath = IndexPath(row: 0, section: 0)
    let heightForRow = addInterventionVC.tableView(
      addInterventionVC.selectedEquipmentsTableView,
      heightForRowAt: indexPath)
    let estimatedHeight = addInterventionVC.tableView(
      addInterventionVC.selectedEquipmentsTableView,
      estimatedHeightForRowAt: indexPath)

    //Then
    XCTAssertEqual(heightForRow, 55, "Height should be 55")
    XCTAssertEqual(estimatedHeight, 55, "Estimated height should be 55")
  }

  func test_tableViewHeightForRowAndEstimatedHeightForRow_withSelectedPersonsTableView() {
    //Given
    let indexPath = IndexPath(row: 0, section: 0)
    let heightForRow = addInterventionVC.tableView(
      addInterventionVC.selectedPersonsTableView,
      heightForRowAt: indexPath)
    let estimatedHeight = addInterventionVC.tableView(
      addInterventionVC.selectedPersonsTableView,
      estimatedHeightForRowAt: indexPath)

    //Then
    XCTAssertEqual(heightForRow, 65, "Height should be 65")
    XCTAssertEqual(estimatedHeight, 65, "Estimated height should be 65")
  }

  func test_tableViewHeightForRowAndEstimatedHeightForRow_withRandomTableView() {
    //Given
    let tableView = UITableView()
    let indexPath = IndexPath(row: 0, section: 0)
    let heightForRow = addInterventionVC.tableView(tableView, heightForRowAt: indexPath)
    let estimatedHeight = addInterventionVC.tableView(tableView, estimatedHeightForRowAt: indexPath)

    //Then
    XCTAssertEqual(heightForRow, 60, "Height should be 60")
    XCTAssertEqual(estimatedHeight, 60, "Estimated height should be 60")
  }
}
