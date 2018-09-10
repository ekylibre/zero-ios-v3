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
    } else if weatherIsSelected {
      sender.layer.borderColor = AppColor.cgColor.LightGray
    } else {
      sender.layer.borderColor = AppColor.cgColor.Green
      weatherIsSelected = true
    }
  }
}

