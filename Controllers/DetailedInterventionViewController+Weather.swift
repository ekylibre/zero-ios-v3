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

  func initializeWeatherButtons() {
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
    negativeTemperature.backgroundColor = AppColor.ThemeColors.DarkWhite
    negativeTemperature.layer.borderColor = UIColor.lightGray.cgColor
    negativeTemperature.layer.borderWidth = 1
    negativeTemperature.layer.cornerRadius = 4
  }

  func setupWeatherActions() {
    temperatureTextField.addTarget(self, action: #selector(saveCurrentWeather), for: .editingChanged)
    windSpeedTextField.addTarget(self, action: #selector(saveCurrentWeather), for: .editingChanged)
  }

  // MARK: - Actions

  @IBAction func setTemperatureToNegative(_ sender: UIButton) {
    if negativeTemperature.title(for: .normal) == "-" {
      negativeTemperature.setTitle("+", for: .normal)
    } else {
      negativeTemperature.setTitle("-", for: .normal)
    }
    saveCurrentWeather(self)
  }

  func resetTemperatureTextFieldIfNotConform() {
    if temperatureTextField.text == "-0" || temperatureTextField.text == "0" || temperatureTextField.text == "-" {
      temperatureTextField.text = nil
      temperatureTextField.placeholder = "0"
    }
  }

  func checkTemperatureTextField() {
    let temperature = temperatureTextField.text!

    if temperature.count > 0 {
      if negativeTemperature.title(for: .normal) == "-" && !temperatureTextField.text!.contains("-") {
        temperatureTextField.text = "-" + temperatureTextField.text!
      } else if negativeTemperature.title(for: .normal) == "+" && temperatureTextField.text!.contains("-") {
        let index = temperatureTextField.text!.index(temperatureTextField.text!.startIndex, offsetBy: 1)

        temperatureTextField.text = String(temperatureTextField.text![index...])
      }
      resetTemperatureTextFieldIfNotConform()
    }
  }

  func hideWeatherItems(_ state: Bool) {
    for index in 0..<weatherButtons.count {
      weatherButtons[index].isHidden = state
    }
    windSpeedTextField.isHidden = state
    temperatureTextField.isHidden = state
    negativeTemperature.isHidden = state
  }

  @IBAction private func tapWeatherView(_ sender: Any) {
    let shouldExpand: Bool = (weatherViewHeightConstraint.constant == 70)

    weatherViewHeightConstraint.constant = shouldExpand ? 350 : 70
    currentWeatherLabel.isHidden = shouldExpand
    weatherExpandImageView.transform = weatherExpandImageView.transform.rotated(by: CGFloat.pi)
    hideWeatherItems(!shouldExpand)
    saveCurrentWeather(self)
  }

  func resetSelectedWeather() {
    for weatherButton in weatherButtons {
      weatherButton.layer.borderWidth = 1
      weatherButton.layer.borderColor = UIColor.lightGray.cgColor
    }
  }

  @IBAction func selectWeather(_ sender: UIButton) {
    let weatherDescriptions = ["BROKEN_CLOUDS", "CLEAR_SKY", "FEW_CLOUDS", "LIGHT_RAIN", "MIST", "SHOWER_RAIN", "SNOW", "THUNDERSTORM"]

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

  @objc func saveCurrentWeather(_ sender: Any) {
    checkTemperatureTextField()
    if temperatureTextField.text == "" && windSpeedTextField.text == "" {
      currentWeatherLabel.text = "not_filled_in".localized
    } else {
      let temperature = (temperatureTextField.text != "" ? temperatureTextField.text : "")
      let wind = (windSpeedTextField.text != "" ? windSpeedTextField.text : "--")
      let currentTemperature = String(format: "temp".localized, temperature!)
      let currentWind = String(format: "wind".localized, wind!)

      currentWeatherLabel.text = currentTemperature + currentWind
    }
    weather.temperature = (temperatureTextField.text! as NSString).doubleValue as NSNumber
    weather.windSpeed = (windSpeedTextField.text! as NSString).doubleValue as NSNumber
  }

  func initWeather() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let weather = Weather(context: managedContext)

    self.weather = weather
  }
}
