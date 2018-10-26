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

  lazy var heighConstraint: NSLayoutConstraint = {
    let heightConstraint = NSLayoutConstraint(
      item: self,
      attribute: .height,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 1,
      constant: 350)

    heightConstraint.isActive = true
    return heightConstraint
  }()

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
    nameTextField.borderStyle = .none
    nameTextField.layer.backgroundColor = UIColor.white.cgColor
    nameTextField.layer.masksToBounds = false
    nameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    nameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    nameTextField.layer.shadowOpacity = 1
    nameTextField.layer.shadowRadius = 0
    nameTextField.translatesAutoresizingMaskIntoConstraints = false
    return nameTextField
  }()

  lazy var errorLabel: UILabel = {
    let errorLabel = UILabel(frame: CGRect.zero)
    errorLabel.font = UIFont.systemFont(ofSize: 13)
    errorLabel.textColor = AppColor.TextColors.Red
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    return errorLabel
  }()

  lazy var numberTextField: UITextField = {
    let numberTextField = UITextField(frame: CGRect.zero)
    numberTextField.placeholder = "number".localized
    numberTextField.autocorrectionType = .no
    numberTextField.delegate = self
    numberTextField.borderStyle = .none
    numberTextField.layer.backgroundColor = UIColor.white.cgColor
    numberTextField.layer.masksToBounds = false
    numberTextField.layer.shadowColor = UIColor.darkGray.cgColor
    numberTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    numberTextField.layer.shadowOpacity = 1
    numberTextField.layer.shadowRadius = 0
    numberTextField.translatesAutoresizingMaskIntoConstraints = false
    return numberTextField
  }()

  lazy var firstEquipmentParameter: UITextField = {
    let firstEquipmentParameter = UITextField(frame: CGRect.zero)
    firstEquipmentParameter.isHidden = true
    firstEquipmentParameter.autocorrectionType = .no
    firstEquipmentParameter.delegate = self
    firstEquipmentParameter.borderStyle = .none
    firstEquipmentParameter.layer.backgroundColor = UIColor.white.cgColor
    firstEquipmentParameter.layer.masksToBounds = false
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
    secondEquipmentParameter.isHidden = true
    secondEquipmentParameter.autocorrectionType = .no
    secondEquipmentParameter.delegate = self
    secondEquipmentParameter.borderStyle = .none
    secondEquipmentParameter.layer.backgroundColor = UIColor.white.cgColor
    secondEquipmentParameter.layer.masksToBounds = false
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
    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    return cancelButton
  }()

  lazy var createButton: UIButton = {
    let createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("create".localized.uppercased(), for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    return createButton
  }()

  var firstEquipmentType: String

  // MARK: - Initialization

  init(firstType: String, frame: CGRect) {
    firstEquipmentType = firstType
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
    self.addSubview(titleLabel)
    self.addSubview(typeImageView)
    self.addSubview(typeLabel)
    self.addSubview(typeButton)
    self.addSubview(nameTextField)
    self.addSubview(errorLabel)
    self.addSubview(numberTextField)
    self.addSubview(firstEquipmentParameter)
    self.addSubview(firstParameterUnit)
    self.addSubview(secondEquipmentParameter)
    self.addSubview(secondParameterUnit)
    self.addSubview(cancelButton)
    self.addSubview(createButton)
    self.addConstraint(heighConstraint)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      typeImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
      typeImageView.heightAnchor.constraint(equalToConstant: 50),
      typeImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      typeImageView.widthAnchor.constraint(equalToConstant: 50),
      typeLabel.topAnchor.constraint(equalTo: typeImageView.bottomAnchor, constant: 10),
      typeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      typeButton.topAnchor.constraint(equalTo: typeLabel.bottomAnchor),
      typeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      typeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      nameTextField.topAnchor.constraint(equalTo: typeButton.bottomAnchor, constant: 35),
      nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
      errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      numberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 35),
      numberTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      numberTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      firstEquipmentParameter.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      firstEquipmentParameter.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      firstEquipmentParameter.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 35),
      firstParameterUnit.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      firstParameterUnit.topAnchor.constraint(equalTo: firstEquipmentParameter.bottomAnchor, constant: 10),
      secondEquipmentParameter.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      secondEquipmentParameter.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      secondEquipmentParameter.topAnchor.constraint(equalTo: firstParameterUnit.bottomAnchor, constant: 35),
      secondParameterUnit.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      secondParameterUnit.topAnchor.constraint(equalTo: secondEquipmentParameter.bottomAnchor, constant: 10),
      cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -15),
      createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      createButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Text field

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}
