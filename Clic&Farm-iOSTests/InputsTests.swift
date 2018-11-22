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

  func test_tapInputsView_withoutSelectedInputs_shouldCollapse() {
    // Given
    addInterventionVC.inputsHeightConstraint.constant = 70

    // When
    addInterventionVC.selectedInputs.removeAll()
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 0, "selectedInputs must be empty")
    addInterventionVC.tapInputsView()
    //addInterventionVC.tapInputsView()

    // Then
    XCTAssertEqual(addInterventionVC.inputsHeightConstraint.constant, 70,
                   "inputsHeightConstraint should be 70 if selectedInputs is empty")
    XCTAssertTrue(addInterventionVC.inputsCountLabel.isHidden,
                  "inputsCountLabel must be hidden if selectedInputs is empty")
  }

  func test_tapInputsView_withMultiplesSelectedInputs_shouldExpand() {
    // Given
    let firstInput = sut.insertObject(entityName: "Fertilizer") as! Fertilizer
    let secondInput = sut.insertObject(entityName: "Phyto") as! Phyto
    let thirdInput = sut.insertObject(entityName: "Seed") as! Seed

    addInterventionVC.inputsHeightConstraint.constant = 70

    // When
    addInterventionVC.selectedInputs.removeAll()
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 0, "selectedInputs must be empty")
    addInterventionVC.selectedInputs.append(firstInput)
    addInterventionVC.selectedInputs.append(secondInput)
    addInterventionVC.selectedInputs.append(thirdInput)
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 3, "selectedInputs must contain new inputs")
    addInterventionVC.tapInputsView()

    // Then
    XCTAssertEqual(addInterventionVC.inputsHeightConstraint.constant, 430,
                   "inputsHeightConstraint should be 420 if selectedInputs contains 3 inputs")
    XCTAssertFalse(addInterventionVC.inputsAddButton.isHidden,
                   "inputsAddButton must be displayed if inputsView is expand")
    XCTAssertTrue(addInterventionVC.inputsCountLabel.isHidden,
                  "inputsCountLabel must be hidden if inputsView is expand")
  }

  func addSampleInputsForTests(_ inputsNumber: Int) {
    var index = 0
    let entityName = [0: "Seed", 1: "Phyto", 2: "Fertilizer"]

    while index != inputsNumber {
      let rand = Int.random(in: 0..<3)
      switch entityName[rand] {
      case "Seed":
        let input = sut.insertObject(entityName: entityName[rand]!) as! Seed
        addInterventionVC.selectedInputs.append(input)
      case "Phyto":
        let input = sut.insertObject(entityName: entityName[rand]!) as! Phyto
        addInterventionVC.selectedInputs.append(input)
      case "Fertilizer":
        let input = sut.insertObject(entityName: entityName[rand]!) as! Fertilizer
        addInterventionVC.selectedInputs.append(input)
      default:
        return
      }
      index += 1
    }
  }

  func test_tapInputsView_withElevenSelectedInputs_shouldExpand() {
    // Given
    addInterventionVC.inputsHeightConstraint.constant = 70

    // When
    addInterventionVC.selectedInputs.removeAll()
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 0, "selectedInputs must be empty")
    addSampleInputsForTests(11)
    XCTAssertEqual(addInterventionVC.selectedInputs.count, 11, "selectedInputs must contain new inputs")
    addInterventionVC.tapInputsView()

    // Then
    XCTAssertEqual(addInterventionVC.inputsHeightConstraint.constant, 1200,
                   "inputsHeightConstraint should be 1200 if selectedInputs contains 10 inputs or more")
    XCTAssertFalse(addInterventionVC.inputsAddButton.isHidden,
                   "inputsAddButton must be displayed if inputsView is expand")
    XCTAssertTrue(addInterventionVC.inputsCountLabel.isHidden,
                  "inputsCountLabel must be hidden if inputsView is expand")
  }

  func test_inputsCreateButton_withDefaultValue_shouldNotChange() {
    //When
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_seed".localized.uppercased(),
                   "createButton title default value must be 'create_new_seed'")
    addInterventionVC.inputsAddButton.sendActions(for: .touchUpInside)

    //Then
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_seed".localized.uppercased(), "createButton title must not change")
  }

  func test_inputsCreateButton_withSegmentChangedToPhyto_shouldChange() {
    //When
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_seed".localized.uppercased(),
                   "createButton title default value must be 'create_new_seed'")
    addInterventionVC.inputsAddButton.sendActions(for: .touchUpInside)
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_seed".localized.uppercased(), "createButton title must not change after opening")
    addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex = 1
    addInterventionVC.inputsSelectionView.segmentedControl.sendActions(for: .valueChanged)

    //Then
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_phyto".localized.uppercased(),
                   "createButton title must be 'create_new_phyto' when selectedSegmentIndex is 1")
  }

  func test_inputsCreateButton_withSegmentChangedToFertilizer_shouldChange() {
    //When
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_seed".localized.uppercased(),
                   "createButton title default value must be 'create_new_seed'")
    addInterventionVC.inputsAddButton.sendActions(for: .touchUpInside)
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_seed".localized.uppercased(), "createButton title must not change after opening")
    addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex = 2
    addInterventionVC.inputsSelectionView.segmentedControl.sendActions(for: .valueChanged)

    //Then
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_ferti".localized.uppercased(),
                   "createButton title must be 'create_new_ferti' when selectedSegmentIndex is 2")
  }

  func test_selectedSegment_withImplantationType_shouldBeFirst() {
    //Given
    let interventionType = InterventionType.Implantation.rawValue

    //When
    XCTAssertEqual(addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex, 0,
                   "selectedSegment must be first before changing intervnetionType")
    addInterventionVC.interventionType = interventionType
    addInterventionVC.setupViewsAccordingInterventionType()

    //Then
    XCTAssertEqual(addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex, 0,
                   "selectedSegment must be first for implantation interventions")
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_seed".localized.uppercased(),
                   "createButton title must be 'create_new_seed' when selectedSegmentIndex == 0")
  }

  func test_selectedSegment_withCropProtectionType_shouldBeSecond() {
    //Given
    let interventionType = InterventionType.CropProtection.rawValue

    //When
    XCTAssertEqual(addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex, 0,
                   "selectedSegment must be first before changing intervnetionType")
    addInterventionVC.interventionType = interventionType
    addInterventionVC.setupViewsAccordingInterventionType()

    //Then
    XCTAssertEqual(addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex, 1,
                   "selectedSegment must be second for cropProtection interventions")
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_phyto".localized.uppercased(),
                   "createButton title must be 'create_new_phyto' when selectedSegmentIndex == 1")
  }

  func test_selectedSegment_withFertilizationType_shouldBeThird() {
    //Given
    let interventionType = InterventionType.Fertilization.rawValue

    //When
    XCTAssertEqual(addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex, 0,
                   "selectedSegment must be first before changing intervnetionType")
    addInterventionVC.interventionType = interventionType
    addInterventionVC.setupViewsAccordingInterventionType()

    //Then
    XCTAssertEqual(addInterventionVC.inputsSelectionView.segmentedControl.selectedSegmentIndex, 2,
                   "selectedSegment must be third for fertilization interventions")
    XCTAssertEqual(addInterventionVC.inputsSelectionView.createButton.titleLabel?.text,
                   "create_new_ferti".localized.uppercased(),
                   "createButton title must be 'create_new_ferti' when selectedSegmentIndex == 2")
  }
}
