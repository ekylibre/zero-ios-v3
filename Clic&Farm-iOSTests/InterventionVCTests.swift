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

  var InterventionVC: InterventionViewController!

  override func setUp() {
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    InterventionVC = storyboard.instantiateViewController(withIdentifier: "InterventionViewController") as? InterventionViewController
    let _ = InterventionVC.view
  }

  override func tearDown() {
    InterventionVC = nil
    super.tearDown()
  }

  func test_transformDate_withTodayDate_shouldDisplayToday() {
    //Given
    let today = Date()

    //Then
    XCTAssertEqual(InterventionVC.transformDate(date: today), "today".localized.lowercased())
  }

  func test_transformDate_withYesterdayDate_shouldDisplayYesterday() {
    //Given
    let yesterday = Date(timeIntervalSinceNow: -86400)

    //Then
    XCTAssertEqual(InterventionVC.transformDate(date: yesterday), "yesterday".localized.lowercased())
  }

  func test_transformDate_withADate_shouldDisplayDateWithYear() {
    //Given
    let date = Date(timeIntervalSince1970: 946547333)

    //Then
    var expectedDate: String!
    if "locale".localized == "fr_FR" {
      expectedDate = "30 décembre 1999"
    } else {
      expectedDate = "30 December 1999"
    }
    XCTAssertEqual(InterventionVC.transformDate(date: date), expectedDate)
  }

  func test_transformDate_withDateEqualTwoDaysAgo_shouldDisplayDateWithoutYear() {
    //Given
    let date = Date(timeIntervalSinceNow: -172800)

    //Then
    let dateFormatter = DateFormatter()

    dateFormatter.locale = Locale(identifier: "locale".localized)
    dateFormatter.dateFormat = "d MMMM"
    let expectedDate = Date(timeIntervalSinceNow: -172800)
    XCTAssertEqual(InterventionVC.transformDate(date: date), dateFormatter.string(from: expectedDate))
  }
}
