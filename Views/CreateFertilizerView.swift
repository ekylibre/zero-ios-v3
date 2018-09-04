//
//  CreateFertilizerView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CreateFertilizerView: UIView, UITextFieldDelegate {

  //MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Création d'un fertilisant"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var nameTextField: UITextField = {
    let nameTextField = UITextField(frame: CGRect.zero)
    nameTextField.placeholder = "Nom"
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

  lazy var natureLabel: UILabel = {
    let natureLabel = UILabel(frame: CGRect.zero)
    natureLabel.text = "Nature"
    natureLabel.font = UIFont.systemFont(ofSize: 14)
    natureLabel.textColor = AppColor.TextColors.DarkGray
    natureLabel.translatesAutoresizingMaskIntoConstraints = false
    return natureLabel
  }()

  lazy var natureButton: UIButton = {
    let natureButton = UIButton(frame: CGRect.zero)
    natureButton.setTitle("Organique", for: .normal)
    natureButton.setTitleColor(UIColor.black, for: .normal)
    natureButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    natureButton.contentHorizontalAlignment = .leading
    natureButton.titleEdgeInsets = UIEdgeInsetsMake(13, 8, 0, 0)
    natureButton.translatesAutoresizingMaskIntoConstraints = false
    return natureButton
  }()

  lazy var natureAlertController: UIAlertController = {
    let natureAlertController = UIAlertController(title: "Choisissez une nature", message: nil, preferredStyle: .actionSheet)
    return natureAlertController
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

  //MARK: - Initialization

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
    self.addSubview(nameTextField)
    self.addSubview(natureLabel)
    self.addSubview(natureButton)
    self.addSubview(cancelButton)
    self.addSubview(createButton)
    setupLayout()
    setupActions()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
      nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      natureLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
      natureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      natureButton.topAnchor.constraint(equalTo: natureLabel.bottomAnchor),
      natureButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      natureButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
      cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -15),
      createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      createButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
      ])
  }

  private func setupActions() {
    natureAlertController.addAction(UIAlertAction(title: "Organique", style: .default, handler: { action in
      self.natureButton.setTitle("Organique", for: .normal)
    }))
    natureAlertController.addAction(UIAlertAction(title: "Minéral", style: .default, handler: { action in
      self.natureButton.setTitle("Minéral", for: .normal)
    }))
    natureAlertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
    cancelButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    createButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Text field

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  //MARK: - Actions

  @objc func closeView(sender: UIButton) {
    nameTextField.resignFirstResponder()
    if sender == cancelButton {
      nameTextField.text = ""
      natureButton.setTitle("Organique", for: .normal)
    }
    self.isHidden = true
  }
}
