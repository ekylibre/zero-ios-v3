//
//  InterventionVCTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Jonathan DE HAAY on 15/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class InterventionVCTests: XCTestCase {

  var interventionVC: InterventionViewController!

  override func setUp() {
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    interventionVC = storyboard.instantiateViewController(withIdentifier: "InterventionViewController") as? InterventionViewController
    let _ = interventionVC.view
  }

  override func tearDown() {
    interventionVC = nil
    super.tearDown()
  }

  func test_transformDate_withTodayDate_shouldDisplayToday() {
    //Given
    let today = Date()

    //Then
    XCTAssertEqual(interventionVC.transformDate(date: today), "today".localized.lowercased(), "Should display today")
  }

  func test_transformDate_withYesterdayDate_shouldDisplayYesterday() {
    //Given
    let yesterday = Date(timeIntervalSinceNow: -86400)

    //Then
    XCTAssertEqual(interventionVC.transformDate(date: yesterday), "yesterday".localized.lowercased(), "Should display yesterday")
  }

  func test_transformDate_withADate_shouldDisplayDateWithYear() {
    //Given
    let date = Date(timeIntervalSince1970: 946547333)
    let expectedDate: String = {
      let expectedDate: String!

      if "locale".localized == "fr_FR" {
        expectedDate = "30 décembre 1999"
      } else {
        expectedDate = "30 December 1999"
      }
      return expectedDate
    }()

    //Then
    XCTAssertEqual(interventionVC.transformDate(date: date), expectedDate, "Should display day, mounth and year")
  }

  func test_transformDate_withDateEqualTwoDaysAgo_shouldDisplayDateWithoutYear() {
    //Given
    let date = Date(timeIntervalSinceNow: -172800)
    let expectedDate: String = {
      let dateFormatter = DateFormatter()

      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMMM"
      return dateFormatter.string(from: date)
    }()

    //Then
    XCTAssertEqual(interventionVC.transformDate(date: date), expectedDate, "Should display day and mounth")
  }

  func test_hideInterventionAdd_shouldHideButtons() {
    // When
    interventionVC.hideInterventionAdd()

    //Then
    for interventionButton in interventionVC.interventionButtons {
      XCTAssertTrue(interventionButton.isHidden, "Should be hidden")
    }
    XCTAssertTrue(interventionVC.dimView.isHidden, "Should be hidden")
    XCTAssertFalse(interventionVC.createInterventionButton.isHidden, "Should be displayed")
    XCTAssertEqual(interventionVC.heightConstraint.constant, 60, "Height constraint should be 60")
  }

  func test_updateSynchronisationLabel_withoutSync() {
    // When
    UserDefaults.standard.setValue(0, forKey: "lastSyncDate")
    interventionVC.updateSynchronisationLabel()

    // Then
    XCTAssertEqual(interventionVC.synchroLabel.text, "no_synchronization_listed".localized,
                   "Should have no synchronization listed")
  }

  func test_updateSynchronisationLabel_withASyncToday() {
    // Given
    let date = Date()
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()

    dateFormatter.locale = Locale(identifier: "locale".localized)
    dateFormatter.dateFormat = "d MMMM"
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)
    let expectedDate = String(format: "today_last_synchronization".localized, hour, minute)

    // When
    UserDefaults.standard.setValue(date, forKey: "lastSyncDate")
    interventionVC.updateSynchronisationLabel()

    // Then
    XCTAssertEqual(interventionVC.synchroLabel.text, expectedDate, "Should have a synchronization listed")
  }

  func test_updateSynchronisationLabel_withASyncYesterday() {
    // Given
    let date = Date(timeIntervalSinceNow: -86400)
    let dateFormatter = DateFormatter()

    dateFormatter.locale = Locale(identifier: "locale".localized)
    dateFormatter.dateFormat = "d MMMM"
    let expectedDate = "last_synchronization".localized + dateFormatter.string(from: date)

    // When
    UserDefaults.standard.setValue(date, forKey: "lastSyncDate")
    interventionVC.updateSynchronisationLabel()

    // Then
    XCTAssertEqual(interventionVC.synchroLabel.text, expectedDate, "Should have a synchronization listed")
  }
}
