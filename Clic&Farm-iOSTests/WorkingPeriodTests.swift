//
//  WorkingPeriodTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Guillaume Roux on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class WorkingPeriodTests: XCTestCase {

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

  func test_selectedWorkingPeriodLabel_withDefaultValues_shouldNotChange() {
    // Given
    let expectedDate: String = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: Date())
    }()

    // When
    var expectedString = String(format: "%@ • 7 h", "today".localized.lowercased())
    XCTAssertEqual(addInterventionVC.selectedWorkingPeriodLabel.text, expectedString,
                   "SelectedWorkingPeriodLabel text should be this one before expanding the view")
    addInterventionVC.tapWorkingPeriodView(self)
    addInterventionVC.tapWorkingPeriodView(self)

    // Then
    expectedString = String(format: "%@ • 7 h", expectedDate)
    XCTAssertEqual(addInterventionVC.selectedWorkingPeriodLabel.text, expectedString,
                   "Today word must be replaced by today's date with current format: 'd MMM'")
  }

  func test_selectedWorkingPeriodLabel_withDurationChanged_shouldChange() {
    // Given
    let duration = "0,10"
    let expectedDate: String = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: Date())
    }()

    // When
    var expectedString = String(format: "%@ • 7 h", "today".localized.lowercased())
    XCTAssertEqual(addInterventionVC.selectedWorkingPeriodLabel.text, expectedString,
                   "SelectedWorkingPeriodLabel text should be this one before expanding the view")
    addInterventionVC.workingPeriodDurationTextField.text = duration
    addInterventionVC.tapWorkingPeriodView(self)
    addInterventionVC.tapWorkingPeriodView(self)

    // Then
    expectedString = String(format: "%@ • 0.1 h", expectedDate)
    XCTAssertEqual(addInterventionVC.selectedWorkingPeriodLabel.text, expectedString,
                   "Label must contain new duration value")
  }

  func test_selectedWorkingPeriodLabel_withDateChanged_shouldChange() {
    // Given
    let date: Date = {
      let calendar = Calendar(identifier: .gregorian)
      var dateComponents = DateComponents()
      dateComponents.year = 2010
      dateComponents.month = 6
      dateComponents.day = 29
      guard let date = calendar.date(from: dateComponents) else { XCTFail("Date initialization error"); return Date() }
      return date
    }()
    let dateString: String = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: date)
    }()

    // When
    var expectedString = String(format: "%@ • 7 h", "today".localized.lowercased())
    XCTAssertEqual(addInterventionVC.selectedWorkingPeriodLabel.text, expectedString,
                   "SelectedWorkingPeriodLabel text should be this one before expanding the view")
    addInterventionVC.workingPeriodDateButton.setTitle(dateString, for: .normal)
    addInterventionVC.tapWorkingPeriodView(self)
    addInterventionVC.tapWorkingPeriodView(self)

    // Then
    expectedString = String(format: "%@ • 7 h", dateString)
    XCTAssertEqual(addInterventionVC.selectedWorkingPeriodLabel.text, expectedString,
                   "Label must contain new date value")
  }

  func test_selectedWorkingPeriodLabel_withDateAndDurationChanged_shouldChange() {
    // Given
    let date: Date = {
      let calendar = Calendar(identifier: .gregorian)
      var dateComponents = DateComponents()
      dateComponents.year = 2010
      dateComponents.month = 6
      dateComponents.day = 29
      guard let date = calendar.date(from: dateComponents) else { XCTFail("Date initialization error"); return Date() }
      return date
    }()
    let dateString: String = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: date)
    }()
    let duration = "3.052"

    // When
    var expectedString = String(format: "%@ • 7 h", "today".localized.lowercased())
    XCTAssertEqual(addInterventionVC.selectedWorkingPeriodLabel.text, expectedString,
                   "SelectedWorkingPeriodLabel text should be this one before expanding the view")
    addInterventionVC.workingPeriodDurationTextField.text = duration
    addInterventionVC.workingPeriodDateButton.setTitle(dateString, for: .normal)
    addInterventionVC.tapWorkingPeriodView(self)
    addInterventionVC.tapWorkingPeriodView(self)

    // Then
    expectedString = String(format: "%@ • 3.1 h", dateString)
    XCTAssertEqual(addInterventionVC.selectedWorkingPeriodLabel.text, expectedString,
                   "Label must contain new date and duration values")
  }

  func test_dateButton_withTouchUpInside_shouldDisplaySelectDateView() {
    // When
    XCTAssertTrue(addInterventionVC.selectDateView.isHidden,
                  "Select date view must be hidden before sendActions")
    addInterventionVC.workingPeriodDateButton.sendActions(for: .touchUpInside)

    // Then
    XCTAssertFalse(addInterventionVC.selectDateView.isHidden,
                   "Select date view must not be hidden after sendActions")
  }

  func test_selectDateView_withValidateAction_shouldHideView() {
    // Given
    let expectedDate: String = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: Date())
    }()

    // When
    XCTAssertTrue(addInterventionVC.selectDateView.isHidden,
                  "Select date view must be hidden before touching dateButton")
    addInterventionVC.workingPeriodDateButton.sendActions(for: .touchUpInside)
    XCTAssertFalse(addInterventionVC.selectDateView.isHidden,
                   "Select date view must not be hidden after touching dateButton")
    addInterventionVC.selectDateView.validateButton.sendActions(for: .touchUpInside)

    // Then
    XCTAssertTrue(addInterventionVC.selectDateView.isHidden,
                  "Select date view must be hidden after touching touching validateButton")
    XCTAssertEqual(addInterventionVC.workingPeriodDateButton.titleLabel?.text, expectedDate,
                   "dateButton title must be today's date after touching touching validateButton")
  }

  func test_selectDateView_withDateChanged_shouldUpdateDateButton() {
    // Given
    let date: Date = {
      let calendar = Calendar(identifier: .gregorian)
      var dateComponents = DateComponents()
      dateComponents.year = 2015
      dateComponents.month = 3
      dateComponents.day = 8
      guard let date = calendar.date(from: dateComponents) else { XCTFail("Date initialization error"); return Date() }
      return date
    }()
    let expectedTitle: String = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: date)
    }()

    // When
    XCTAssertTrue(addInterventionVC.selectDateView.isHidden,
                  "Select date view must be hidden before touching dateButton")
    addInterventionVC.workingPeriodDateButton.sendActions(for: .touchUpInside)
    XCTAssertFalse(addInterventionVC.selectDateView.isHidden,
                   "Select date view must not be hidden after touching dateButton")
    addInterventionVC.selectDateView.datePicker.date = date
    addInterventionVC.selectDateView.validateButton.sendActions(for: .touchUpInside)

    // Then
    XCTAssertTrue(addInterventionVC.selectDateView.isHidden,
                  "Select date view must be hidden after touching touching validateButton")
    XCTAssertEqual(addInterventionVC.workingPeriodDateButton.titleLabel?.text, expectedTitle,
                   "dateButton title must be custom date after touching touching validateButton")
  }

  func test_unitLabel_withDurationLesserThanOrEqualTo1_shouldBeSingular() {
    // Given
    let duration = "1.00"

    // When
    XCTAssertEqual(addInterventionVC.workingPeriodUnitLabel.text, "hours".localized,
                   "Working period unit should be plural before sendActions")
    addInterventionVC.workingPeriodDurationTextField.text = duration
    addInterventionVC.workingPeriodDurationTextField.sendActions(for: .editingChanged)

    // Then
    XCTAssertEqual(addInterventionVC.workingPeriodUnitLabel.text, "hour".localized,
                   "Working period unit label not updated correctly when duration is <= 1")
  }

  func test_unitLabel_withDurationGreaterThan1_shouldBePlural() {
    // Given
    let duration = "1000"

    // When
    XCTAssertEqual(addInterventionVC.workingPeriodUnitLabel.text, "hours".localized,
                   "Working period unit should be plural before sendActions")
    addInterventionVC.workingPeriodDurationTextField.text = duration
    addInterventionVC.workingPeriodDurationTextField.sendActions(for: .editingChanged)

    // Then
    XCTAssertEqual(addInterventionVC.workingPeriodUnitLabel.text, "hours".localized,
                   "Working period unit label not updated correctly when duration is > 1")
  }
}
