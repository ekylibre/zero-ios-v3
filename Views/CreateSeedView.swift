//
//  CreateSeedView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CreateSeedView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Création d'une semence"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var specieLabel: UILabel = {
    let specieLabel = UILabel(frame: CGRect.zero)
    specieLabel.text = "Espèce"
    specieLabel.font = UIFont.systemFont(ofSize: 15)
    specieLabel.textColor = AppColor.TextColors.DarkGray
    specieLabel.translatesAutoresizingMaskIntoConstraints = false
    return specieLabel
  }()

  lazy var specieButton: UIButton = {
    let specieButton = UIButton(frame: CGRect.zero)
    specieButton.setTitle("Abricotier", for: .normal)
    specieButton.setTitleColor(UIColor.black, for: .normal)
    specieButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    specieButton.contentHorizontalAlignment = .leading
    specieButton.titleEdgeInsets = UIEdgeInsetsMake(13, 8, 0, 0)
    specieButton.translatesAutoresizingMaskIntoConstraints = false
    return specieButton
  }()

  lazy var varietyTextField: UITextField = {
    let varietyTextField = UITextField(frame: CGRect.zero)
    varietyTextField.placeholder = "Variété"
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

  lazy var cancelButton: UIButton = {
    let cancelButton = UIButton(frame: CGRect.zero)
    cancelButton.setTitle("ANNULER", for: .normal)
    cancelButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    return cancelButton
  }()

  lazy var createButton: UIButton = {
    let createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("CRÉER", for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
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
    self.addSubview(specieLabel)
    self.addSubview(specieButton)
    self.addSubview(varietyTextField)
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
      cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -15),
      createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      createButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15)
      ])
  }

  private func setupActions() {
    cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    createButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
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

  @objc func closeView(sender: UIButton) {
    varietyTextField.resignFirstResponder()
    if sender == cancelButton {
      specieButton.setTitle("Abricotier", for: .normal)
      varietyTextField.text = ""
    }
    self.isHidden = true
  }
}
