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

  var addInterventionViewController: AddInterventionViewController?

  lazy var temperatureLabel: UILabel = {
    let temperatureLabel = UILabel(frame: CGRect.zero)

    //    temperatureLabel.isHidden = true
    temperatureLabel.font = UIFont.systemFont(ofSize: 15)
    temperatureLabel.textColor = AppColor.TextColors.DarkGray
    temperatureLabel.text = "temperature".localized
    return temperatureLabel
  }()

  lazy var temperatureTextField: UITextField = {
    let temperatureTextField = UITextField(frame: CGRect.zero)

    //temperatureTextField.isHidden = true
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

    //temperatureUnit.isHidden = true
    temperatureUnit.font = UIFont.systemFont(ofSize: 15)
    temperatureUnit.textColor = AppColor.TextColors.DarkGray
    temperatureUnit.text = "°C"
    return temperatureUnit
  }()

  lazy var windSpeedLabel: UILabel = {
    let windSpeedLabel = UILabel(frame: CGRect.zero)

    //windSpeedLabel.isHidden = true
    windSpeedLabel.font = UIFont.systemFont(ofSize: 15)
    windSpeedLabel.textColor = AppColor.TextColors.DarkGray
    windSpeedLabel.text = "wind_speed".localized
    return windSpeedLabel
  }()

  lazy var windSpeedTextField: UITextField = {
    let windSpeedTextField = UITextField(frame: CGRect.zero)

    //windSpeedTextField.isHidden = true
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

    //windSpeedUnit.isHidden =  true
    windSpeedUnit.font = UIFont.systemFont(ofSize: 15)
    windSpeedUnit.textColor = AppColor.TextColors.DarkGray
    windSpeedUnit.text = "km/h"
    windSpeedUnit.translatesAutoresizingMaskIntoConstraints = false
    return windSpeedUnit
  }()

  lazy var cloudyButton: UIButton = {
    let cloudyButton = UIButton(frame: CGRect.zero)

    //windSpeedUnit.isHidden = true
    cloudyButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    cloudyButton.layer.borderColor = UIColor.lightGray.cgColor
    cloudyButton.layer.borderWidth = 1
    cloudyButton.layer.cornerRadius = 5
    cloudyButton.setImage(#imageLiteral(resourceName: "nuages"), for: .normal)
    cloudyButton.translatesAutoresizingMaskIntoConstraints = false
    return cloudyButton
  }()

  lazy var sunnyButton: UIButton = {
    let sunnyButton = UIButton(frame: CGRect.zero)

    //sunnyButton.isHidden = true
    sunnyButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    sunnyButton.layer.borderColor = UIColor.lightGray.cgColor
    sunnyButton.layer.borderWidth = 1
    sunnyButton.layer.cornerRadius = 5
    sunnyButton.setImage(#imageLiteral(resourceName: "soleil"), for: .normal)
    sunnyButton.translatesAutoresizingMaskIntoConstraints = false
    return sunnyButton
  }()

  lazy var cloudyPassageButton: UIButton = {
    let cloudyPassageButton = UIButton(frame: CGRect.zero)

    //cloudyPassageButton.isHidden = true
    cloudyPassageButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    cloudyPassageButton.layer.borderColor = UIColor.lightGray.cgColor
    cloudyPassageButton.layer.borderWidth = 1
    cloudyPassageButton.layer.cornerRadius = 5
    cloudyPassageButton.setImage(#imageLiteral(resourceName: "passages-nuageux"), for: .normal)
    cloudyPassageButton.translatesAutoresizingMaskIntoConstraints = false
    return cloudyPassageButton
  }()

  lazy var rainFallButton: UIButton = {
    let rainFallButton = UIButton(frame: CGRect.zero)

    //rainFallButton.isHidden = true
    rainFallButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    rainFallButton.layer.borderColor = UIColor.lightGray.cgColor
    rainFallButton.layer.borderWidth = 1
    rainFallButton.layer.cornerRadius = 5
    rainFallButton.setImage(#imageLiteral(resourceName: "averses"), for: .normal)
    rainFallButton.translatesAutoresizingMaskIntoConstraints = false
    return rainFallButton
  }()

  lazy var fogButton: UIButton = {
    let fogButton = UIButton(frame: CGRect.zero)

    //fogButton.isHidden = true
    fogButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    fogButton.layer.borderColor = UIColor.lightGray.cgColor
    fogButton.layer.borderWidth = 1
    fogButton.layer.cornerRadius = 5
    fogButton.setImage(#imageLiteral(resourceName: "brouillard"), for: .normal)
    fogButton.translatesAutoresizingMaskIntoConstraints = false
    return fogButton
  }()

  lazy var rainButton: UIButton = {
    let rainButton = UIButton(frame: CGRect.zero)

    //rainButton.isHidden = true
    rainButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    rainButton.layer.borderColor = UIColor.lightGray.cgColor
    rainButton.layer.borderWidth = 1
    rainButton.layer.cornerRadius = 5
    rainButton.setImage(#imageLiteral(resourceName: "pluie"), for: .normal)
    rainButton.translatesAutoresizingMaskIntoConstraints = false
    return rainButton
  }()

  lazy var snowButton: UIButton = {
    let snowButton = UIButton(frame: CGRect.zero)

    //snowButton.isHidden = true
    snowButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    snowButton.layer.borderColor = UIColor.lightGray.cgColor
    snowButton.layer.borderWidth = 1
    snowButton.layer.cornerRadius = 5
    snowButton.setImage(#imageLiteral(resourceName: "neige"), for: .normal)
    snowButton.translatesAutoresizingMaskIntoConstraints = false
    return snowButton
  }()

  lazy var stormButton: UIButton = {
    let stormButton = UIButton(frame: CGRect.zero)

    //stormButton.isHidden = true
    stormButton.backgroundColor = AppColor.ThemeColors.DarkWhite
    stormButton.layer.borderColor = UIColor.lightGray.cgColor
    stormButton.layer.borderWidth = 1
    stormButton.layer.cornerRadius = 5
    stormButton.setImage(#imageLiteral(resourceName: "orage"), for: .normal)
    stormButton.translatesAutoresizingMaskIntoConstraints = false
    return stormButton
  }()

  lazy var collapseButton: UIButton = {
    let collapseButton = UIButton(frame: CGRect.zero)

    //collapseButton.setImage(#imageLiteral(resourceName: "expand-collapse"), for: .normal)
    collapseButton.addTarget(self, action: #selector(expandOrCollapseView), for: .touchUpInside)
    collapseButton.translatesAutoresizingMaskIntoConstraints = false
    return collapseButton
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.backgroundColor = AppColor.ThemeColors.white
    self.addSubview(temperatureLabel)
    self.addSubview(temperatureTextField)
    self.addSubview(temperatureUnit)
    self.addSubview(windSpeedLabel)
    self.addSubview(windSpeedTextField)
    self.addSubview(windSpeedUnit)
    self.addSubview(cloudyButton)
    self.addSubview(sunnyButton)
    self.addSubview(cloudyPassageButton)
    self.addSubview(rainFallButton)
    self.addSubview(fogButton)
    self.addSubview(rainButton)
    self.addSubview(snowButton)
    self.addSubview(stormButton)
    self.addSubview(collapseButton)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      temperatureLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
      temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 70),

      temperatureTextField.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor, constant: 30),
      temperatureTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
      temperatureTextField.heightAnchor.constraint(equalToConstant: 20),
      temperatureTextField.widthAnchor.constraint(equalToConstant: 60),

      temperatureUnit.leftAnchor.constraint(equalTo: temperatureTextField.rightAnchor, constant: 5),
      temperatureUnit.topAnchor.constraint(equalTo: self.topAnchor, constant: 70),

      windSpeedLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
      windSpeedLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),

      windSpeedTextField.leftAnchor.constraint(equalTo: windSpeedLabel.rightAnchor, constant: 30),
      windSpeedTextField.topAnchor.constraint(equalTo: temperatureTextField.bottomAnchor, constant: 5),
      windSpeedTextField.heightAnchor.constraint(equalToConstant: 20),
      windSpeedTextField.widthAnchor.constraint(equalToConstant: 60),

      windSpeedUnit.leftAnchor.constraint(equalTo: windSpeedTextField.rightAnchor, constant: 5),
      windSpeedUnit.topAnchor.constraint(equalTo: temperatureUnit.bottomAnchor, constant: 20),

      cloudyButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
      cloudyButton.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor, constant: 20),
      cloudyButton.heightAnchor.constraint(equalToConstant: 70),
      cloudyButton.widthAnchor.constraint(equalToConstant: 70),

      sunnyButton.leftAnchor.constraint(equalTo: cloudyButton.rightAnchor, constant: 20),
      sunnyButton.topAnchor.constraint(equalTo: cloudyButton.topAnchor, constant: 0),
      sunnyButton.heightAnchor.constraint(equalToConstant: 70),
      sunnyButton.widthAnchor.constraint(equalToConstant: 70),

      cloudyPassageButton.leftAnchor.constraint(equalTo: sunnyButton.rightAnchor, constant: 20),
      cloudyPassageButton.topAnchor.constraint(equalTo: sunnyButton.topAnchor, constant: 0),
      cloudyPassageButton.heightAnchor.constraint(equalToConstant: 70),
      cloudyPassageButton.widthAnchor.constraint(equalToConstant: 70),

      rainFallButton.leftAnchor.constraint(equalTo: cloudyPassageButton.rightAnchor, constant: 20),
      rainFallButton.topAnchor.constraint(equalTo: cloudyPassageButton.topAnchor, constant: 0),
      rainFallButton.heightAnchor.constraint(equalToConstant: 70),
      rainFallButton.widthAnchor.constraint(equalToConstant: 70),

      fogButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
      fogButton.topAnchor.constraint(equalTo: cloudyButton.topAnchor, constant: 20),
      fogButton.heightAnchor.constraint(equalToConstant: 70),
      fogButton.widthAnchor.constraint(equalToConstant: 70),

      rainButton.leftAnchor.constraint(equalTo: fogButton.rightAnchor, constant: 20),
      rainButton.topAnchor.constraint(equalTo: fogButton.topAnchor, constant: 0),
      rainButton.heightAnchor.constraint(equalToConstant: 70),
      rainButton.widthAnchor.constraint(equalToConstant: 70),

      snowButton.leftAnchor.constraint(equalTo: rainButton.rightAnchor, constant: 20),
      snowButton.topAnchor.constraint(equalTo: rainButton.topAnchor, constant: 0),
      snowButton.heightAnchor.constraint(equalToConstant: 70),
      snowButton.widthAnchor.constraint(equalToConstant: 70),

      stormButton.leftAnchor.constraint(equalTo: snowButton.rightAnchor, constant: 20),
      stormButton.topAnchor.constraint(equalTo: snowButton.topAnchor, constant: 0),
      stormButton.heightAnchor.constraint(equalToConstant: 70),
      stormButton.widthAnchor.constraint(equalToConstant: 70),

      collapseButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
      collapseButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
      collapseButton.heightAnchor.constraint(equalToConstant: 20),
      collapseButton.widthAnchor.constraint(equalToConstant: 20)
      ]
    )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions
  
  @objc func expandOrCollapseView() {
    if addInterventionViewController?.weatherSectionHeightConstraint.constant == 70 {
      addInterventionViewController?.weatherSectionHeightConstraint.constant = 280
    } else {
      addInterventionViewController?.weatherSectionHeightConstraint.constant = 70
    }
  }
}
