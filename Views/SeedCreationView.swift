//
//  SeedCreationView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SeedCreationView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  var rawSpecie: String!

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "create_seed_title".localized
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var specieLabel: UILabel = {
    let specieLabel = UILabel(frame: CGRect.zero)
    specieLabel.text = "chose_specie".localized
    specieLabel.font = UIFont.systemFont(ofSize: 15)
    specieLabel.textColor = AppColor.TextColors.DarkGray
    specieLabel.translatesAutoresizingMaskIntoConstraints = false
    return specieLabel
  }()

  lazy var specieButton: UIButton = {
    let specieButton = UIButton(frame: CGRect.zero)
    specieButton.setTitle(firstSpecie.localized, for: .normal)
    specieButton.setTitleColor(UIColor.black, for: .normal)
    specieButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    specieButton.contentHorizontalAlignment = .leading
    specieButton.titleEdgeInsets = UIEdgeInsets(top: 13, left: 8, bottom: 0, right: 0)
    specieButton.translatesAutoresizingMaskIntoConstraints = false
    return specieButton
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
    unitButton.setTitle("KILOGRAM_PER_HECTARE".localized, for: .normal)
    unitButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    unitButton.setTitleColor(UIColor.black, for: .normal)
    unitButton.contentHorizontalAlignment = .leading
    unitButton.titleEdgeInsets = UIEdgeInsets(top: 13, left: 8, bottom: 0, right: 0)
    unitButton.translatesAutoresizingMaskIntoConstraints = false
    return unitButton
  }()

  lazy var varietyTextField: UITextField = {
    let varietyTextField = UITextField(frame: CGRect.zero)
    varietyTextField.placeholder = "variety".localized
    varietyTextField.autocorrectionType = .no
    varietyTextField.delegate = self
    varietyTextField.borderStyle = .none
    varietyTextField.layer.backgroundColor = UIColor.white.cgColor
    varietyTextField.layer.masksToBounds = false
    varietyTextField.layer.shadowColor = UIColor.darkGray.cgColor
    varietyTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    varietyTextField.layer.shadowOpacity = 1
    varietyTextField.layer.shadowRadius = 0
    varietyTextField.translatesAutoresizingMaskIntoConstraints = false
    return varietyTextField
  }()

  lazy var errorLabel: UILabel = {
    let errorLabel = UILabel(frame: CGRect.zero)
    errorLabel.font = UIFont.systemFont(ofSize: 13)
    errorLabel.textColor = AppColor.TextColors.Red
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    return errorLabel
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

  var firstSpecie: String
  var rawUnit = "KILOGRAM_PER_HECTARE"

  // MARK: - Initialization

  init(firstSpecie: String, frame: CGRect) {
    self.firstSpecie = firstSpecie
    rawSpecie = firstSpecie
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    backgroundColor = UIColor.white
    layer.cornerRadius = 5
    clipsToBounds = true
    isHidden = true
    addSubview(titleLabel)
    addSubview(specieLabel)
    addSubview(specieButton)
    addSubview(unitLabel)
    addSubview(unitButton)
    addSubview(varietyTextField)
    addSubview(errorLabel)
    addSubview(cancelButton)
    addSubview(createButton)
    setupLayout()
    setupActions()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      specieLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
      specieLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      specieButton.topAnchor.constraint(equalTo: specieLabel.bottomAnchor),
      specieButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      specieButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 60),
      unitLabel.topAnchor.constraint(equalTo: specieButton.bottomAnchor, constant: 15),
      unitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      unitButton.topAnchor.constraint(equalTo: unitLabel.bottomAnchor),
      unitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      unitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 60),
      varietyTextField.topAnchor.constraint(equalTo: unitButton.bottomAnchor, constant: 30),
      varietyTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      varietyTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      errorLabel.topAnchor.constraint(equalTo: varietyTextField.bottomAnchor, constant: 5),
      errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -15),
      createButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      createButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
      ])
  }

  private func setupActions() {
    varietyTextField.addTarget(self, action: #selector(varietyDidChange), for: .editingChanged)
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

    return oldText.replacingCharacters(in: r, with: string).count <= 500
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  // MARK: - Actions

  @objc private func varietyDidChange(_ textField: UITextField) {
    if !errorLabel.isHidden {
      errorLabel.isHidden = true
    }
  }

  @objc private func closeView(sender: UIButton) {
    varietyTextField.resignFirstResponder()
    specieButton.setTitle(firstSpecie.localized, for: .normal)
    varietyTextField.text = ""
    self.isHidden = true
  }
}
