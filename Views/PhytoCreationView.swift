//
//  PhytoCreationView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class PhytoCreationView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "create_phyto_title".localized
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var nameTextField: UITextField = {
    let nameTextField = UITextField(frame: CGRect.zero)
    nameTextField.placeholder = "name".localized
    nameTextField.autocorrectionType = .no
    nameTextField.delegate = self
    nameTextField.tag = 10
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

  lazy var firmNameTextField: UITextField = {
    let firmNameTextField = UITextField(frame: CGRect.zero)
    firmNameTextField.placeholder = "brand".localized
    firmNameTextField.autocorrectionType = .no
    firmNameTextField.delegate = self
    firmNameTextField.tag = 11
    firmNameTextField.borderStyle = .none
    firmNameTextField.layer.backgroundColor = UIColor.white.cgColor
    firmNameTextField.layer.masksToBounds = false
    firmNameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    firmNameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    firmNameTextField.layer.shadowOpacity = 1
    firmNameTextField.layer.shadowRadius = 0
    firmNameTextField.translatesAutoresizingMaskIntoConstraints = false
    return firmNameTextField
  }()

  lazy var maaTextField: UITextField = {
    let maaTextField = UITextField(frame: CGRect.zero)
    maaTextField.keyboardType = .numberPad
    maaTextField.placeholder = "mmaid_number".localized
    maaTextField.autocorrectionType = .no
    maaTextField.delegate = self
    maaTextField.tag = 12
    maaTextField.borderStyle = .none
    maaTextField.layer.backgroundColor = UIColor.white.cgColor
    maaTextField.layer.masksToBounds = false
    maaTextField.layer.shadowColor = UIColor.darkGray.cgColor
    maaTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    maaTextField.layer.shadowOpacity = 1
    maaTextField.layer.shadowRadius = 0
    maaTextField.translatesAutoresizingMaskIntoConstraints = false
    return maaTextField
  }()

  lazy var reentryDelayTextField: UITextField = {
    let reentryDelayTextField = UITextField(frame: CGRect.zero)
    reentryDelayTextField.keyboardType = .numberPad
    reentryDelayTextField.placeholder = "reentry_delay".localized
    reentryDelayTextField.autocorrectionType = .no
    reentryDelayTextField.delegate = self
    reentryDelayTextField.tag = 13
    reentryDelayTextField.borderStyle = .none
    reentryDelayTextField.layer.backgroundColor = UIColor.white.cgColor
    reentryDelayTextField.layer.masksToBounds = false
    reentryDelayTextField.layer.shadowColor = UIColor.darkGray.cgColor
    reentryDelayTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    reentryDelayTextField.layer.shadowOpacity = 1
    reentryDelayTextField.layer.shadowRadius = 0
    reentryDelayTextField.translatesAutoresizingMaskIntoConstraints = false
    return reentryDelayTextField
  }()

  lazy var reentryUnitLabel: UILabel = {
    let unitLabel = UILabel(frame: CGRect.zero)
    unitLabel.text = "in_hours".localized.lowercased()
    unitLabel.font = UIFont.systemFont(ofSize: 14)
    unitLabel.textColor = UIColor.lightGray
    unitLabel.translatesAutoresizingMaskIntoConstraints = false
    return unitLabel
  }()

  lazy var unitLabel: UILabel = {
    let unitLabel = UILabel(frame: CGRect.zero)
    unitLabel.text = "unit".localized
    unitLabel.font = UIFont.systemFont(ofSize: 15)
    unitLabel.textColor = AppColor.TextColors.DarkGray
    unitLabel.translatesAutoresizingMaskIntoConstraints = false
    return unitLabel
  }()

  lazy var unitButton: UIButton = {
    let unitButton = UIButton(frame: CGRect.zero)
    unitButton.setTitle("LITER_PER_HECTARE".localized, for: .normal)
    unitButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    unitButton.setTitleColor(UIColor.black, for: .normal)
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

  var rawUnit = "LITER_PER_HECTARE"

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
    addSubview(firmNameTextField)
    addSubview(maaTextField)
    addSubview(reentryDelayTextField)
    addSubview(reentryUnitLabel)
    addSubview(unitLabel)
    addSubview(unitButton)
    addSubview(cancelButton)
    addSubview(createButton)
    setupLayout()
    setupActions()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
      nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
      errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      firmNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 35),
      firmNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      firmNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      maaTextField.topAnchor.constraint(equalTo: firmNameTextField.bottomAnchor, constant: 35),
      maaTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      maaTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      reentryDelayTextField.topAnchor.constraint(equalTo: maaTextField.bottomAnchor, constant: 35),
      reentryDelayTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      reentryDelayTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      reentryUnitLabel.topAnchor.constraint(equalTo: reentryDelayTextField.bottomAnchor, constant: 5),
      reentryUnitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      unitLabel.topAnchor.constraint(equalTo: reentryUnitLabel.bottomAnchor, constant: 30),
      unitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      unitButton.topAnchor.constraint(equalTo: unitLabel.bottomAnchor),
      unitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      unitButton.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: 60),
      cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -15),
      createButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      createButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
      ])
  }

  private func setupActions() {
    nameTextField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
    cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
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

    if textField.keyboardType == .numberPad {
      return oldText.replacingCharacters(in: r, with: string).count <= 16
    }
    return oldText.replacingCharacters(in: r, with: string).count <= 500
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextTag = textField.tag + 1

    if let nextResponder = textField.superview?.viewWithTag(nextTag) as? UITextField {
      nextResponder.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }

    return false
  }

  // MARK: - Actions

  @objc private func nameDidChange(_ textField: UITextField) {
    if !errorLabel.isHidden {
      errorLabel.isHidden = true
    }
  }

  @objc private func closeView(sender: UIButton) {
    for subview in self.subviews {
      let textField = subview as? UITextField
      textField?.resignFirstResponder()
      textField?.text = ""
    }
    errorLabel.isHidden = true
    self.isHidden = true
  }
}
