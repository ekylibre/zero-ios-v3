//
//  WeatherTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Guillaume Roux on 14/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
@testable import Clic_Farm_iOS

class WeatherTests: XCTestCase {

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

  func test_currentWeatherLabel_withoutChange_shouldNotChange() {
    //When
    XCTAssertEqual(addInterventionVC.currentWeatherLabel.text, "not_filled_in".localized,
                   "Current weather must be 'not_filled_in' before expanding view")
    addInterventionVC.tapWeatherView(self)
    addInterventionVC.tapWeatherView(self)

    //Then
    XCTAssertEqual(addInterventionVC.currentWeatherLabel.text, "not_filled_in".localized,
                   "Current weather must be 'not_filled_in' before expanding view")
  }

  func test_currentWeatherLabel_withTemperatureChanged_shouldChange() {
    //Given
    let temperature = "15"

    //When
    XCTAssertEqual(addInterventionVC.currentWeatherLabel.text, "not_filled_in".localized,
                   "Current weather must be 'not_filled_in' before expanding view")
    addInterventionVC.temperatureTextField.text = temperature
    addInterventionVC.tapWeatherView(self)
    addInterventionVC.tapWeatherView(self)

    //Then
    let expectedString = String(format: "temp".localized, temperature) + String(format: "wind".localized, "--")
    XCTAssertEqual(addInterventionVC.currentWeatherLabel.text, expectedString,
                   "Current weather must contain new temperature value")
  }

  func test_currentWeatherLabel_withWindSpeedChanged_shouldChange() {
    //Given
    let windSpeed = "10"

    //When
    XCTAssertEqual(addInterventionVC.currentWeatherLabel.text, "not_filled_in".localized,
                   "Current weather must be 'not_filled_in' before expanding view")
    addInterventionVC.windSpeedTextField.text = windSpeed
    addInterventionVC.tapWeatherView(self)
    addInterventionVC.tapWeatherView(self)

    //Then
    let expectedString = String(format: "temp".localized, "--") + String(format: "wind".localized, windSpeed)
    XCTAssertEqual(addInterventionVC.currentWeatherLabel.text, expectedString,
                   "Current weather must contain new windSpeed value")
  }

  func test_currentWeatherLabel_withTemperatureAndWindSpeedChanged_shouldChange() {
    //Given
    let temperature = "31.50"
    let windSpeed = "90"

    //When
    XCTAssertEqual(addInterventionVC.currentWeatherLabel.text, "not_filled_in".localized,
                   "Current weather must be 'not_filled_in' before expanding view")
    addInterventionVC.temperatureTextField.text = temperature
    addInterventionVC.windSpeedTextField.text = windSpeed
    addInterventionVC.tapWeatherView(self)
    addInterventionVC.tapWeatherView(self)

    //Then
    let expectedString = String(format: "temp".localized, temperature) + String(format: "wind".localized, windSpeed)
    XCTAssertEqual(addInterventionVC.currentWeatherLabel.text, expectedString,
                   "Current weather must contain new temperature and windSpeed values")
  }
}
