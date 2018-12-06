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
    firstNameTextField.layer.backgroundColor = UIColor.white.cgColor
    firstNameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    firstNameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    firstNameTextField.layer.shadowOpacity = 1
    firstNameTextField.layer.shadowRadius = 0
    firstNameTextField.delegate = self
    firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
    return firstNameTextField
  }()

  lazy var firstNameErrorLabel: UILabel = {
    let firstNameErrorLabel = UILabel(frame: CGRect.zero)
    firstNameErrorLabel.text = "person_first_name_is_empty".localized
    firstNameErrorLabel.font = UIFont.systemFont(ofSize: 13)
    firstNameErrorLabel.textColor = AppColor.AppleColors.Red
    firstNameErrorLabel.isHidden = true
    firstNameErrorLabel.translatesAutoresizingMaskIntoConstraints = false
    return firstNameErrorLabel
  }()

  lazy var lastNameTextField: UITextField = {
    let lastNameTextField = UITextField(frame: CGRect.zero)
    lastNameTextField.placeholder = "last_name".localized
    lastNameTextField.autocorrectionType = .no
    lastNameTextField.layer.backgroundColor = UIColor.white.cgColor
    lastNameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    lastNameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    lastNameTextField.layer.shadowOpacity = 1
    lastNameTextField.layer.shadowRadius = 0
    lastNameTextField.delegate = self
    lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
    return lastNameTextField
  }()

  lazy var lastNameErrorLabel: UILabel = {
    let lastNameErrorLabel = UILabel(frame: CGRect.zero)
    lastNameErrorLabel.text = "person_last_name_is_empty".localized
    lastNameErrorLabel.font = UIFont.systemFont(ofSize: 13)
    lastNameErrorLabel.textColor = AppColor.AppleColors.Red
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
    backgroundColor = UIColor.white
    layer.cornerRadius = 5
    clipsToBounds = true
    isHidden = true
    addSubview(titleLabel)
    addSubview(firstNameTextField)
    addSubview(firstNameErrorLabel)
    addSubview(lastNameTextField)
    addSubview(lastNameErrorLabel)
    addSubview(cancelButton)
    addSubview(createButton)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      firstNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
      firstNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      firstNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      firstNameErrorLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 5),
      firstNameErrorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      firstNameErrorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 35),
      lastNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      lastNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      lastNameErrorLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 5),
      lastNameErrorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      lastNameErrorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
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

    return oldText.replacingCharacters(in: r, with: string).count <= 500
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == firstNameTextField {
      lastNameTextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return false
  }
}
