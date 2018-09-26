//
//  AddWeatherToIntervention.swift
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
      weatherButtons[index].layer.borderColor = UIColor.lightGray.cgColor
      weatherButtons[index].layer.borderWidth = 2
      weatherButtons[index].layer.cornerRadius = 5
    }
  }

  // MARK: - Actions

  func hideWeatherItems(_ state: Bool) {
    for index in 0..<weatherButtons.count {
      weatherButtons[index].isHidden = state
    }
    windSpeedTextField.isHidden = state
    temperatureTextField.isHidden = state
  }

  @IBAction func collapseOrExpandWeatherView(_ sender: Any) {
    let shouldExpand: Bool = (weatherViewHeightConstraint.constant == 70)

    weatherViewHeightConstraint.constant = shouldExpand ? 300 : 70
    currentWeatherLabel.isHidden = shouldExpand
    weatherCollapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    hideWeatherItems(!shouldExpand)
  }


  @IBAction func selectWeather(_ sender: UIButton) {
    if weatherIsSelected && sender.layer.borderColor == UIColor.lightGray.cgColor {
      for weather in weatherButtons {
        if weather.layer.borderColor == AppColor.BarColors.Green.cgColor {
          weather.layer.borderColor = UIColor.lightGray.cgColor
        }
      }
      sender.layer.borderColor = AppColor.BarColors.Green.cgColor
      weather[0].setValue(sender.titleLabel?.text, forKey: "weatherDescription")
    } else if weatherIsSelected {
      sender.layer.borderColor = UIColor.lightGray.cgColor
      weatherIsSelected = false
    } else {
      sender.layer.borderColor = AppColor.BarColors.Green.cgColor
      weather[0].setValue(sender.titleLabel?.text, forKey: "weatherDescription")
      weatherIsSelected = true
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let containsADot = textField.text?.contains(".")
    var invalidCharacters: CharacterSet!

    if containsADot! {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789").inverted
    } else {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789.").inverted
    }

    switch textField {
    case temperatureTextField:
      return string.rangeOfCharacter(
        from: invalidCharacters,
        options: [],
        range: string.startIndex ..< string.endIndex
        ) == nil
    case windSpeedTextField:
      return string.rangeOfCharacter(
        from: invalidCharacters,
        options: [],
        range: string.startIndex ..< string.endIndex
        ) == nil
    default:
      return true
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    switch textField {
    case temperatureTextField:
      weather[0].setValue((temperatureTextField.text! as NSString).doubleValue, forKey: "temperature")
      if temperatureTextField.text == "" && windSpeedTextField.text == "" {
        currentWeatherLabel.text = "not_filled_in".localized
      } else {
        let temperature = (temperatureTextField.text != "" ? temperatureTextField.text : "--")
        let wind = (windSpeedTextField.text != "" ? windSpeedTextField.text : "--")
        let currentTemp = String(format: "temp".localized, temperature!)
        let currentWind = String(format: "wind".localized, wind!)

        currentWeatherLabel.text = currentTemp + currentWind
      }
    case windSpeedTextField:
      weather[0].setValue((windSpeedTextField.text! as NSString).doubleValue, forKey: "windSpeed")
      if temperatureTextField.text == "" && windSpeedTextField.text == "" {
        currentWeatherLabel.text = "not_filled_in".localized
      } else {
        let temperature = (temperatureTextField.text != "" ? temperatureTextField.text : "--")
        let wind = (windSpeedTextField.text != "" ? windSpeedTextField.text : "--")
        let currentTemp = String(format: "temp".localized, temperature!)
        let currentWind = String(format: "wind".localized, wind!)

        currentWeatherLabel.text = currentTemp + currentWind
      }
    default:
      return false
    }
    return false
  }

  func saveWeather(windSpeed: Double, temperature: Double, weatherDescription: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let weatherEntity = Weather(context: managedContext)

    weatherEntity.windSpeed = windSpeed
    weatherEntity.temperature = temperature
    weatherEntity.weatherDescription = weatherDescription

    do {
      try managedContext.save()
      weather.append(weatherEntity)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}
