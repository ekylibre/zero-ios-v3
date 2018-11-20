//
//  PersonCreationView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 15/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class PersonCreationView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "create_person_title".localized
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var firstNameTextField: UITextField = {
    let firstNameTextField = UITextField(frame: CGRect.zero)
    firstNameTextField.placeholder = "first_name".localized
    firstNameTextField.autocorrectionType = .no
    firstNameTextField.delegate = self
    firstNameTextField.borderStyle = .none
    firstNameTextField.layer.backgroundColor = UIColor.white.cgColor
    firstNameTextField.layer.masksToBounds = false
    firstNameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    firstNameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    firstNameTextField.layer.shadowOpacity = 1
    firstNameTextField.layer.shadowRadius = 0
    firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
    return firstNameTextField
  }()

  lazy var firstNameErrorLabel: UILabel = {
    let firstNameErrorLabel = UILabel(frame: CGRect.zero)
    firstNameErrorLabel.text = "person_first_name_is_empty".localized
    firstNameErrorLabel.font = UIFont.systemFont(ofSize: 13)
    firstNameErrorLabel.textColor = AppColor.TextColors.Red
    firstNameErrorLabel.isHidden = true
    firstNameErrorLabel.translatesAutoresizingMaskIntoConstraints = false
    return firstNameErrorLabel
  }()

  lazy var lastNameTextField: UITextField = {
    let lastNameTextField = UITextField(frame: CGRect.zero)
    lastNameTextField.placeholder = "last_name".localized
    lastNameTextField.autocorrectionType = .no
    lastNameTextField.delegate = self
    lastNameTextField.borderStyle = .none
    lastNameTextField.layer.backgroundColor = UIColor.white.cgColor
    lastNameTextField.layer.masksToBounds = false
    lastNameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    lastNameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    lastNameTextField.layer.shadowOpacity = 1
    lastNameTextField.layer.shadowRadius = 0
    lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
    return lastNameTextField
  }()

  lazy var lastNameErrorLabel: UILabel = {
    let lastNameErrorLabel = UILabel(frame: CGRect.zero)
    lastNameErrorLabel.text = "person_last_name_is_empty".localized
    lastNameErrorLabel.font = UIFont.systemFont(ofSize: 13)
    lastNameErrorLabel.textColor = AppColor.TextColors.Red
    lastNameErrorLabel.isHidden = true
    lastNameErrorLabel.translatesAutoresizingMaskIntoConstraints = false
    return lastNameErrorLabel
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

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
    self.addSubview(titleLabel)
    self.addSubview(firstNameTextField)
    self.addSubview(firstNameErrorLabel)
    self.addSubview(lastNameTextField)
    self.addSubview(lastNameErrorLabel)
    self.addSubview(cancelButton)
    self.addSubview(createButton)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      firstNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
      firstNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      firstNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      firstNameErrorLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 5),
      firstNameErrorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      firstNameErrorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 35),
      lastNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      lastNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      lastNameErrorLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 5),
      lastNameErrorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      lastNameErrorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
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
