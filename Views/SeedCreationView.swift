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

  // MARK: - Initialization

  init(firstSpecie: String, frame: CGRect) {
    self.firstSpecie = firstSpecie
    self.rawSpecie = firstSpecie
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
    self.addSubview(titleLabel)
    self.addSubview(specieLabel)
    self.addSubview(specieButton)
    self.addSubview(varietyTextField)
    self.addSubview(errorLabel)
    self.addSubview(cancelButton)
    self.addSubview(createButton)
    setupLayout()
    setupActions()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      specieLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
      specieLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      specieButton.topAnchor.constraint(equalTo: specieLabel.bottomAnchor),
      specieButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      specieButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 60),
      varietyTextField.topAnchor.constraint(equalTo: specieButton.bottomAnchor, constant: 50),
      varietyTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      varietyTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      errorLabel.topAnchor.constraint(equalTo: varietyTextField.bottomAnchor, constant: 5),
      errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -15),
      createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      createButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
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
