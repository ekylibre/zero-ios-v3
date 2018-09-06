//
//  WeatherView.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 06/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class WeatherView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  lazy var temperatureLabel: UILabel = {
    let temperatureLabel = UILabel(frame: CGRect.zero)

    temperatureLabel.font = UIFont.systemFont(ofSize: 15)
    temperatureLabel.textColor = AppColor.TextColors.DarkGray
    temperatureLabel.text = "temperature".localized
    return temperatureLabel
  }()

  lazy var temperatureTextField: UITextField = {
    let temperatureTextField = UITextField(frame: CGRect.zero)

    temperatureTextField.backgroundColor = AppColor.ThemeColors.DarkWhite
    temperatureTextField.layer.borderColor = UIColor.lightGray.cgColor
    temperatureTextField.layer.borderWidth = 1
    temperatureTextField.layer.cornerRadius = 5
    temperatureTextField.delegate = self
    temperatureTextField.text = ""
    temperatureTextField.keyboardType = .decimalPad
    temperatureTextField.textAlignment = .left
    temperatureTextField.translatesAutoresizingMaskIntoConstraints = false
    return temperatureTextField
  }()

  lazy var temperatureUnit: UILabel = {
    let temperatureUnit = UILabel(frame: CGRect.zero)

    temperatureUnit.font = UIFont.systemFont(ofSize: 15)
    temperatureUnit.textColor = AppColor.TextColors.DarkGray
    temperatureUnit.text = "°C"
    return temperatureUnit
  }()

  lazy var windSpeedLabel: UILabel = {
    let windSpeedLabel = UILabel(frame: CGRect.zero)

    windSpeedLabel.font = UIFont.systemFont(ofSize: 15)
    windSpeedLabel.textColor = AppColor.TextColors.DarkGray
    windSpeedLabel.text = "wind_speed".localized
    return windSpeedLabel
  }()

  lazy var windSpeedTextField: UITextField = {
    let windSpeedTextField = UITextField(frame: CGRect.zero)

    windSpeedTextField.backgroundColor = AppColor.ThemeColors.DarkWhite
    windSpeedTextField.layer.borderColor = UIColor.lightGray.cgColor
    windSpeedTextField.layer.borderWidth = 1
    windSpeedTextField.layer.cornerRadius = 5
    windSpeedTextField.delegate = self
    windSpeedTextField.text = ""
    windSpeedTextField.keyboardType = .decimalPad
    windSpeedTextField.textAlignment = .left
    windSpeedTextField.translatesAutoresizingMaskIntoConstraints = false
    return windSpeedTextField
  }()

  lazy var windSpeedUnit: UILabel = {
    let windSpeedUnit = UILabel(frame: CGRect.zero)

    windSpeedUnit.font = UIFont.systemFont(ofSize: 15)
    windSpeedUnit.textColor = AppColor.TextColors.DarkGray
    windSpeedUnit.text = "km/h"
    return windSpeedUnit
  }()

  lazy var cloudyButton: UIButton = {
    let cloudyButton = UIButton(frame: CGRect.zero)

    cloudyButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    cloudyButton.layer.borderColor = UIColor.lightGray.cgColor
    cloudyButton.layer.borderWidth = 1
    cloudyButton.layer.cornerRadius = 5
    cloudyButton.setImage(#imageLiteral(resourceName: "nuages"), for: .normal)
    return cloudyButton
  }()

  lazy var sunnyButton: UIButton = {
    let sunnyButton = UIButton(frame: CGRect.zero)

    sunnyButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    sunnyButton.layer.borderColor = UIColor.lightGray.cgColor
    sunnyButton.layer.borderWidth = 1
    sunnyButton.layer.cornerRadius = 5
    sunnyButton.setImage(#imageLiteral(resourceName: "soleil"), for: .normal)
    return sunnyButton
  }()

  lazy var cloudyPassageButton: UIButton = {
    let cloudyPassageButton = UIButton(frame: CGRect.zero)

    cloudyPassageButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    cloudyPassageButton.layer.borderColor = UIColor.lightGray.cgColor
    cloudyPassageButton.layer.borderWidth = 1
    cloudyPassageButton.layer.cornerRadius = 5
    cloudyPassageButton.setImage(#imageLiteral(resourceName: "passages-nuageux"), for: .normal)
    return cloudyPassageButton
  }()

  lazy var rainFallButton: UIButton = {
    let rainFallButton = UIButton(frame: CGRect.zero)

    rainFallButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    rainFallButton.layer.borderColor = UIColor.lightGray.cgColor
    rainFallButton.layer.borderWidth = 1
    rainFallButton.layer.cornerRadius = 5
    rainFallButton.setImage(#imageLiteral(resourceName: "averses"), for: .normal)
    return rainFallButton
  }()

  lazy var fogButton: UIButton = {
    let fogButton = UIButton(frame: CGRect.zero)

    fogButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    fogButton.layer.borderColor = UIColor.lightGray.cgColor
    fogButton.layer.borderWidth = 1
    fogButton.layer.cornerRadius = 5
    fogButton.setImage(#imageLiteral(resourceName: "brouillard"), for: .normal)
    return fogButton
  }()

  lazy var rainButton: UIButton = {
    let rainButton = UIButton(frame: CGRect.zero)

    rainButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    rainButton.layer.borderColor = UIColor.lightGray.cgColor
    rainButton.layer.borderWidth = 1
    rainButton.layer.cornerRadius = 5
    rainButton.setImage(#imageLiteral(resourceName: "pluie"), for: .normal)
    return rainButton
  }()

  lazy var snowButton: UIButton = {
    let snowButton = UIButton(frame: CGRect.zero)

    snowButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    snowButton.layer.borderColor = UIColor.lightGray.cgColor
    snowButton.layer.borderWidth = 1
    snowButton.layer.cornerRadius = 5
    snowButton.setImage(#imageLiteral(resourceName: "neige"), for: .normal)
    return snowButton
  }()

  lazy var stormButton: UIButton = {
    let stormButton = UIButton(frame: CGRect.zero)

    stormButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    stormButton.layer.borderColor = UIColor.lightGray.cgColor
    stormButton.layer.borderWidth = 1
    stormButton.layer.cornerRadius = 5
    stormButton.setImage(#imageLiteral(resourceName: "orage"), for: .normal)
    return stormButton
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    backgroundColor = AppColor.ThemeColors.white
    addSubview(temperatureLabel)
    addSubview(temperatureTextField)
    addSubview(temperatureUnit)
    addSubview(windSpeedLabel)
    addSubview(windSpeedTextField)
    addSubview(windSpeedUnit)
    addSubview(cloudyButton)
    addSubview(sunnyButton)
    addSubview(cloudyPassageButton)
    addSubview(rainFallButton)
    addSubview(fogButton)
    addSubview(rainButton)
    addSubview(snowButton)
    addSubview(stormButton)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
