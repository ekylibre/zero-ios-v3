//
//  DetailedInterventionViewController+Weather.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 07/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController {

  // MARK: - Initialization

  func setupWeatherView() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let weather = Weather(context: managedContext)

    weather.windSpeed = nil
    weather.temperature = nil
    self.weather = weather
    temperatureTextField.layer.borderWidth = 0.5
    temperatureTextField.layer.borderColor = UIColor.lightGray.cgColor
    temperatureTextField.layer.cornerRadius = 5
    temperatureTextField.clipsToBounds = true
    temperatureTextField.delegate = self
    windSpeedTextField.layer.borderWidth = 0.5
    windSpeedTextField.layer.borderColor = UIColor.lightGray.cgColor
    windSpeedTextField.layer.cornerRadius = 5
    windSpeedTextField.clipsToBounds = true
    windSpeedTextField.delegate = self
    initializeWeatherButtons()
    setupWeatherActions()
  }

  private func initializeWeatherButtons() {
    weatherButtons = [brokenClouds, clearSky, fewClouds, lightRain, mist, showerRain, snow, thunderstorm]

    for index in 0..<weatherButtons.count {
      let image = weatherButtons[index].imageView?.image?.withRenderingMode(.alwaysTemplate)

      weatherButtons[index].imageView?.tintColor = AppColor.TextColors.Blue
      weatherButtons[index].imageView?.image = image
      weatherButtons[index].layer.borderColor = UIColor.lightGray.cgColor
      weatherButtons[index].layer.borderWidth = 1
      weatherButtons[index].layer.cornerRadius = 5
      weatherButtons[index].tag = index
    }
    temperatureSign.backgroundColor = AppColor.ThemeColors.DarkWhite
    temperatureSign.layer.borderColor = UIColor.lightGray.cgColor
    temperatureSign.layer.borderWidth = 1
    temperatureSign.layer.cornerRadius = 4
  }

  private func setupWeatherActions() {
    temperatureTextField.addTarget(self, action: #selector(saveCurrentWeather), for: .editingChanged)
    windSpeedTextField.addTarget(self, action: #selector(saveCurrentWeather), for: .editingChanged)
  }

  // MARK: - Actions

  func loadWeatherInEditableMode() {
    for index in 0..<weatherDescriptions.count {
      if weather.weatherDescription == weatherDescriptions[index] {
        weatherButtons[index].layer.borderColor = AppColor.BarColors.Green.cgColor
        weatherButtons[index].layer.borderWidth = 3
        weatherIsSelected = true
      }
    }
    if weather.temperature != nil {
      temperatureTextField.text = (weather.temperature as NSNumber?)?.stringValue
    }
    if weather.windSpeed != nil {
      windSpeedTextField.text = (weather.windSpeed as NSNumber?)?.stringValue
    }
    saveCurrentWeather()
  }

  func loadWeatherInReadOnlyMode() {
    temperatureTextField.placeholder = (weather.temperature as NSNumber?)?.stringValue
    windSpeedTextField.placeholder = (weather.windSpeed as NSNumber?)?.stringValue

    for index in 0..<weatherDescriptions.count {
      if weather.weatherDescription?.uppercased() == weatherDescriptions[index] {
        weatherButtons[index].layer.borderColor = AppColor.BarColors.Green.cgColor
        weatherButtons[index].layer.borderWidth = 3
        weatherIsSelected = true
      }
    }
    if temperatureTextField.placeholder == nil && windSpeedTextField.placeholder == nil {
      currentWeatherLabel.text = "not_filled_in".localized
    } else {
      let temperature = (temperatureTextField.placeholder != nil ? temperatureTextField.placeholder : "--")
      let wind = (windSpeedTextField.placeholder != nil ? windSpeedTextField.placeholder : "--")
      let currentTemperature = String(format: "temp".localized, temperature!)
      let currentWind = String(format: "wind".localized, wind!)
      currentWeatherLabel.text = currentTemperature + currentWind
    }
    if temperatureTextField.placeholder != nil {
      weather.temperature = (temperatureTextField.placeholder! as NSString).doubleValue as NSNumber
    }
    if windSpeedTextField.placeholder != nil {
      weather.windSpeed = (windSpeedTextField.placeholder! as NSString).doubleValue as NSNumber
    }
  }

  @IBAction private func setTemperatureToNegative(_ sender: UIButton) {
    if temperatureSign.title(for: .normal) == "-" {
      temperatureSign.setTitle("+", for: .normal)
    } else {
      temperatureSign.setTitle("-", for: .normal)
    }
    saveCurrentWeather()
  }

  private func resetTemperatureTextFieldIfNotConform() {
    if temperatureTextField.text == "-." || temperatureTextField.text == "-" {
      temperatureTextField.text = nil
      temperatureTextField.placeholder = "0"
    }
  }

  private func checkTemperatureTextField() {
    let temperature = temperatureTextField.text!

    if temperature.count > 0 {
      if temperatureSign.title(for: .normal) == "-" && !temperatureTextField.text!.contains("-") {
        temperatureTextField.text?.insert("-", at: temperatureTextField.text!.startIndex)
      } else if temperatureSign.title(for: .normal) == "+" && temperatureTextField.text!.contains("-") {
        temperatureTextField.text = String(temperatureTextField.text!.dropFirst())
      }
      resetTemperatureTextFieldIfNotConform()
    }
  }

  @IBAction func tapWeatherView(_ sender: Any) {
    let shouldExpand: Bool = (weatherViewHeightConstraint.constant == 70)

    view.endEditing(true)
    weatherViewHeightConstraint.constant = shouldExpand ? 350 : 70
    currentWeatherLabel.isHidden = shouldExpand
    temperatureSign.isHidden = !shouldExpand
    temperatureTextField.isHidden = !shouldExpand
    weatherExpandImageView.transform = weatherExpandImageView.transform.rotated(by: CGFloat.pi)
    saveCurrentWeather()
  }

  private func resetSelectedWeather() {
    for weatherButton in weatherButtons {
      weatherButton.layer.borderWidth = 1
      weatherButton.layer.borderColor = UIColor.lightGray.cgColor
    }
  }

  @IBAction private func selectWeather(_ sender: UIButton) {
    if sender.layer.borderColor == UIColor.lightGray.cgColor {
      resetSelectedWeather()
      weatherIsSelected = true
      weather.weatherDescription = weatherDescriptions[sender.tag]
      sender.layer.borderColor = AppColor.BarColors.Green.cgColor
      sender.layer.borderWidth = 3
    } else {
      resetSelectedWeather()
      weatherIsSelected = false
      weather.weatherDescription = nil
    }
  }

  @objc private func saveCurrentWeather() {
    checkTemperatureTextField()
    if temperatureTextField.text == "" && windSpeedTextField.text == "" {
      if weather.weatherDescription != nil {
        currentWeatherLabel.text = weather.weatherDescription?.lowercased().localized
      } else {
        currentWeatherLabel.text = "not_filled_in".localized
      }
    } else {
      let temperature = (temperatureTextField.text != "" ? temperatureTextField.text : "--")
      let wind = (windSpeedTextField.text != "" ? windSpeedTextField.text : "--")
      let currentTemperature = String(format: "temp".localized, temperature!)
      let currentWind = String(format: "wind".localized, wind!)

      currentWeatherLabel.text = currentTemperature + currentWind
      weather.temperature = (temperatureTextField.text! as NSString).doubleValue as NSNumber
      weather.windSpeed = (windSpeedTextField.text! as NSString).doubleValue as NSNumber
    }
  }
}
