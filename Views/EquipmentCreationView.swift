//
//  EquipmentCreationView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 11/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class EquipmentCreationView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "create_equipment_title".localized
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var typeImageView: UIImageView = {
    let imageName = firstEquipmentType.lowercased().replacingOccurrences(of: "_", with: "-")
    let typeImageView = UIImageView(image: UIImage(named: imageName))
    typeImageView.translatesAutoresizingMaskIntoConstraints = false
    return typeImageView
  }()

  lazy var typeLabel: UILabel = {
    let typeLabel = UILabel(frame: CGRect.zero)
    typeLabel.text = "chose_type".localized
    typeLabel.font = UIFont.systemFont(ofSize: 15)
    typeLabel.textColor = AppColor.TextColors.DarkGray
    typeLabel.translatesAutoresizingMaskIntoConstraints = false
    return typeLabel
  }()

  lazy var typeButton: UIButton = {
    let typeButton = UIButton(frame: CGRect.zero)
    typeButton.setTitle(firstEquipmentType.localized, for: .normal)
    typeButton.setTitleColor(UIColor.black, for: .normal)
    typeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    typeButton.contentHorizontalAlignment = .leading
    typeButton.titleEdgeInsets = UIEdgeInsets(top: 13, left: 8, bottom: 0, right: 0)
    typeButton.translatesAutoresizingMaskIntoConstraints = false
    return typeButton
  }()

  lazy var nameTextField: UITextField = {
    let nameTextField = UITextField(frame: CGRect.zero)
    nameTextField.placeholder = "name".localized
    nameTextField.autocorrectionType = .no
    nameTextField.delegate = self
    nameTextField.layer.backgroundColor = UIColor.white.cgColor
    nameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    nameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    nameTextField.layer.shadowOpacity = 1
    nameTextField.layer.shadowRadius = 0
    nameTextField.translatesAutoresizingMaskIntoConstraints = false
    return nameTextField
  }()

  lazy var nameErrorLabel: UILabel = {
    let nameErrorLabel = UILabel(frame: CGRect.zero)
    nameErrorLabel.font = UIFont.systemFont(ofSize: 13)
    nameErrorLabel.textColor = AppColor.AppleColors.Red
    nameErrorLabel.numberOfLines = 0
    nameErrorLabel.isHidden = true
    nameErrorLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameErrorLabel
  }()

  lazy var numberTextField: UITextField = {
    let numberTextField = UITextField(frame: CGRect.zero)
    numberTextField.placeholder = "number".localized
    numberTextField.autocorrectionType = .no
    numberTextField.delegate = self
    numberTextField.layer.backgroundColor = UIColor.white.cgColor
    numberTextField.layer.shadowColor = UIColor.darkGray.cgColor
    numberTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    numberTextField.layer.shadowOpacity = 1
    numberTextField.layer.shadowRadius = 0
    numberTextField.translatesAutoresizingMaskIntoConstraints = false
    return numberTextField
  }()

  lazy var numberErrorLabel: UILabel = {
    let numberErrorLabel = UILabel(frame: CGRect.zero)
    numberErrorLabel.text = "equipment_number_not_available".localized
    numberErrorLabel.font = UIFont.systemFont(ofSize: 13)
    numberErrorLabel.textColor = AppColor.AppleColors.Red
    numberErrorLabel.numberOfLines = 0
    numberErrorLabel.isHidden = true
    numberErrorLabel.translatesAutoresizingMaskIntoConstraints = false
    return numberErrorLabel
  }()

  lazy var firstEquipmentParameter: UITextField = {
    let firstEquipmentParameter = UITextField(frame: CGRect.zero)
    firstEquipmentParameter.keyboardType = .decimalPad
    firstEquipmentParameter.isHidden = true
    firstEquipmentParameter.autocorrectionType = .no
    firstEquipmentParameter.delegate = self
    firstEquipmentParameter.layer.backgroundColor = UIColor.white.cgColor
    firstEquipmentParameter.layer.shadowColor = UIColor.darkGray.cgColor
    firstEquipmentParameter.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    firstEquipmentParameter.layer.shadowOpacity = 1
    firstEquipmentParameter.layer.shadowRadius = 0
    firstEquipmentParameter.translatesAutoresizingMaskIntoConstraints = false
    return firstEquipmentParameter
  }()

  lazy var firstParameterUnit: UILabel = {
    let firstParameterUnit = UILabel(frame: CGRect.zero)
    firstParameterUnit.isHidden = true
    firstParameterUnit.font = UIFont.systemFont(ofSize: 12)
    firstParameterUnit.textColor = UIColor.lightGray
    firstParameterUnit.translatesAutoresizingMaskIntoConstraints = false
    return firstParameterUnit
  }()

  lazy var secondEquipmentParameter: UITextField = {
    let secondEquipmentParameter = UITextField(frame: CGRect.zero)
    secondEquipmentParameter.keyboardType = .decimalPad
    secondEquipmentParameter.isHidden = true
    secondEquipmentParameter.autocorrectionType = .no
    secondEquipmentParameter.delegate = self
    secondEquipmentParameter.layer.backgroundColor = UIColor.white.cgColor
    secondEquipmentParameter.layer.shadowColor = UIColor.darkGray.cgColor
    secondEquipmentParameter.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    secondEquipmentParameter.layer.shadowOpacity = 1
    secondEquipmentParameter.layer.shadowRadius = 0
    secondEquipmentParameter.translatesAutoresizingMaskIntoConstraints = false
    return secondEquipmentParameter
  }()

  lazy var secondParameterUnit: UILabel = {
    let secondParameterUnit = UILabel(frame: CGRect.zero)
    secondParameterUnit.isHidden = true
    secondParameterUnit.font = UIFont.systemFont(ofSize: 12)
    secondParameterUnit.textColor = UIColor.lightGray
    secondParameterUnit.translatesAutoresizingMaskIntoConstraints = false
    return secondParameterUnit
  }()

  lazy var cancelButton: UIButton = {
    let cancelButton = UIButton(frame: CGRect.zero)
    cancelButton.setTitle("cancel".localized.uppercased(), for: .normal)
    cancelButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    cancelButton.setTitleColor(AppColor.TextColors.LightGreen, for: .highlighted)
    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    return cancelButton
  }()

  lazy var createButton: UIButton = {
    let createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("create".localized.uppercased(), for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.setTitleColor(AppColor.TextColors.LightGreen, for: .highlighted)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    return createButton
  }()

  var firstEquipmentType: String
  lazy var heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil,
                                                 attribute: .notAnAttribute, multiplier: 1, constant: 350)

  // MARK: - Initialization

  init(firstType: String) {
    firstEquipmentType = firstType
    super.init(frame: CGRect.zero)
    setupView()
  }

  private func setupView() {
    backgroundColor = UIColor.white
    layer.cornerRadius = 5
    clipsToBounds = true
    isHidden = true
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(titleLabel)
    addSubview(typeImageView)
    addSubview(typeLabel)
    addSubview(typeButton)
    addSubview(nameTextField)
    addSubview(nameErrorLabel)
    addSubview(numberTextField)
    addSubview(numberErrorLabel)
    addSubview(firstEquipmentParameter)
    addSubview(firstParameterUnit)
    addSubview(secondEquipmentParameter)
    addSubview(secondParameterUnit)
    addSubview(cancelButton)
    addSubview(createButton)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      heightConstraint,
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      typeImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
      typeImageView.heightAnchor.constraint(equalToConstant: 50),
      typeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      typeImageView.widthAnchor.constraint(equalToConstant: 50),
      typeLabel.topAnchor.constraint(equalTo: typeImageView.bottomAnchor, constant: 10),
      typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      typeButton.topAnchor.constraint(equalTo: typeLabel.bottomAnchor),
      typeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      typeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      nameTextField.topAnchor.constraint(equalTo: typeButton.bottomAnchor, constant: 35),
      nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      nameErrorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
      nameErrorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      nameErrorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      numberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 35),
      numberTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      numberTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      numberErrorLabel.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 5),
      numberErrorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      numberErrorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      firstEquipmentParameter.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      firstEquipmentParameter.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      firstEquipmentParameter.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 35),
      firstParameterUnit.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      firstParameterUnit.topAnchor.constraint(equalTo: firstEquipmentParameter.bottomAnchor, constant: 10),
      secondEquipmentParameter.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      secondEquipmentParameter.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      secondEquipmentParameter.topAnchor.constraint(equalTo: firstEquipmentParameter.bottomAnchor, constant: 35),
      secondParameterUnit.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      secondParameterUnit.topAnchor.constraint(equalTo: secondEquipmentParameter.bottomAnchor, constant: 10),
      cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -15),
      createButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      createButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Text field

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    guard let oldText = textField.text, let r = Range(range, in: oldText) else {
      return true
    }

    if textField.keyboardType == .default {
      return oldText.replacingCharacters(in: r, with: string).count <= 500
    } else if textField.keyboardType == .numberPad {
      return oldText.replacingCharacters(in: r, with: string).count <= 16
    }

    let newText = oldText.replacingCharacters(in: r, with: string)
    var numberOfDecimalDigits = 0

    if newText.components(separatedBy: ".").count > 2 || newText.components(separatedBy: ",").count > 2 {
      return false
    } else if let dotIndex = (newText.contains(",") ? newText.index(of: ",") : newText.index(of: ".")) {
      numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
    }
    return numberOfDecimalDigits <= 2 && newText.count <= 16
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}
