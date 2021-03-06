//
//  MaterialCreationView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 28/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class MaterialCreationView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "create_material_title".localized
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
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

  lazy var errorLabel: UILabel = {
    let errorLabel = UILabel(frame: CGRect.zero)
    errorLabel.font = UIFont.systemFont(ofSize: 13)
    errorLabel.textColor = AppColor.AppleColors.Red
    errorLabel.numberOfLines = 0
    errorLabel.isHidden = true
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    return errorLabel
  }()

  lazy var unitLabel: UILabel = {
    let unitLabel = UILabel(frame: CGRect.zero)
    unitLabel.text = "chose_unit".localized
    unitLabel.font = UIFont.systemFont(ofSize: 15)
    unitLabel.textColor = AppColor.TextColors.DarkGray
    unitLabel.translatesAutoresizingMaskIntoConstraints = false
    return unitLabel
  }()

  lazy var unitButton: UIButton = {
    let unitButton = UIButton(frame: CGRect.zero)
    unitButton.setTitle("METER".localized.lowercased(), for: .normal)
    unitButton.setTitleColor(UIColor.black, for: .normal)
    unitButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    unitButton.contentHorizontalAlignment = .leading
    unitButton.titleEdgeInsets = UIEdgeInsets(top: 13, left: 8, bottom: 0, right: 0)
    unitButton.translatesAutoresizingMaskIntoConstraints = false
    return unitButton
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
    addSubview(nameTextField)
    addSubview(errorLabel)
    addSubview(unitLabel)
    addSubview(unitButton)
    addSubview(cancelButton)
    addSubview(createButton)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
      nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
      errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      unitLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
      unitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      unitButton.topAnchor.constraint(equalTo: unitLabel.bottomAnchor),
      unitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      unitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
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

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}
