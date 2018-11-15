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

  func test_checkMaterialName_withoutExistingMaterialAndAName_shouldNotDisplayError() {
    //Given
    let name = "Sample material"

    //When
    addInterventionVC.materialsSelectionView.materials.removeAll()
    addInterventionVC.materialsSelectionView.creationView.nameTextField.text = name

    //Then
    XCTAssertEqual(addInterventionVC.materialsSelectionView.checkMaterialName(), true,
                                "Should not display error label")
  }

  func test_checkMaterialName_withoutExistingMaterialAndNoName_shouldDisplayError() {
    //When
    addInterventionVC.materialsSelectionView.materials.removeAll()
    addInterventionVC.materialsSelectionView.creationView.nameTextField.text = nil
    let _ = addInterventionVC.materialsSelectionView.checkMaterialName()

    //Then
    XCTAssertEqual(addInterventionVC.materialsSelectionView.creationView.errorLabel.text, "material_name_is_empty".localized,
                   "Should display empty name error label")
  }
}
