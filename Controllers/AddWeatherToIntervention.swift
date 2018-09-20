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

  func initializeWeatherView() {
    cloudyButton.layer.borderColor = UIColor.lightGray.cgColor
    cloudyButton.layer.borderWidth = 2
    cloudyButton.layer.cornerRadius = 5

    cloudyPassageButton.layer.borderColor = UIColor.lightGray.cgColor
    cloudyPassageButton.layer.borderWidth = 2
    cloudyPassageButton.layer.cornerRadius = 5

    fogyButton.layer.borderColor = UIColor.lightGray.cgColor
    fogyButton.layer.borderWidth = 2
    fogyButton.layer.cornerRadius = 5

    rainButton.layer.borderColor = UIColor.lightGray.cgColor
    rainButton.layer.borderWidth = 2
    rainButton.layer.cornerRadius = 5

    rainFallButton.layer.borderColor = UIColor.lightGray.cgColor
    rainFallButton.layer.borderWidth = 2
    rainFallButton.layer.cornerRadius = 5

    snowButton.layer.borderColor = UIColor.lightGray.cgColor
    snowButton.layer.borderWidth = 2
    snowButton.layer.cornerRadius = 5

    stormButton.layer.borderColor = UIColor.lightGray.cgColor
    stormButton.layer.borderWidth = 2
    stormButton.layer.cornerRadius = 5

    sunnyButton.layer.borderColor = UIColor.lightGray.cgColor
    sunnyButton.layer.borderWidth = 2
    sunnyButton.layer.cornerRadius = 5
  }

  func defineWeathers() -> [UIButton] {
    var weathers = [UIButton]()

    weathers.append(cloudyButton)
    weathers.append(cloudyPassageButton)
    weathers.append(fogyButton)
    weathers.append(rainButton)
    weathers.append(rainFallButton)
    weathers.append(snowButton)
    weathers.append(stormButton)
    weathers.append(sunnyButton)
    return weathers
  }

  // MARK: - Actions

  func hideWeatherItems(_ state: Bool) {
    cloudyButton.isHidden = state
    cloudyPassageButton.isHidden = state
    fogyButton.isHidden = state
    rainButton.isHidden = state
    rainFallButton.isHidden = state
    snowButton.isHidden = state
    stormButton.isHidden = state
    sunnyButton.isHidden = state
    windSpeedTextField.isHidden = state
    temperatureTextField.isHidden = state
  }

  @IBAction func collapseOrExpandWeatherView(_ sender: Any) {
    if weatherViewHeightConstraint.constant == 70 {
      weatherViewHeightConstraint.constant = 300
      currentWeatherLabel.isHidden = true
      weatherCollapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      hideWeatherItems(false)
    } else {
      weatherViewHeightConstraint.constant = 70
      currentWeatherLabel.isHidden = false
      hideWeatherItems(true)
      weatherCollapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
    }
  }

  @IBAction func selectWeather(_ sender: UIButton) {
    if weatherIsSelected && sender.layer.borderColor == AppColor.cgColor.LightGray {
      for weather in weathers {
        if weather.layer.borderColor == AppColor.cgColor.Green {
          weather.layer.borderColor = AppColor.cgColor.LightGray
        }
      }
      sender.layer.borderColor = AppColor.cgColor.Green
      weather[0].setValue(sender.titleLabel?.text, forKey: "weatherDescription")
    } else if weatherIsSelected {
      sender.layer.borderColor = AppColor.cgColor.LightGray
      weatherIsSelected = false
    } else {
      sender.layer.borderColor = AppColor.cgColor.Green
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
      currentWeatherLabel.text = (temperatureTextField.text == "" ? "not_filled_in".localized : "\(temperatureTextField.text!) °C")
    case windSpeedTextField:
      weather[0].setValue((windSpeedTextField.text! as NSString).doubleValue, forKey: "windSpeed")
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
    let weathers = NSEntityDescription.entity(forEntityName: "Weather", in: managedContext)!
    let weatherEntity = NSManagedObject(entity: weathers, insertInto: managedContext)

    weatherEntity.setValue(windSpeed, forKey: "windSpeed")
    weatherEntity.setValue(temperature, forKey: "temperature")
    weatherEntity.setValue(weatherDescription, forKey: "weatherDescription")

    do {
      try managedContext.save()
      weather.append(weatherEntity)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}
