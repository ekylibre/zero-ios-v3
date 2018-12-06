//
//  FertilizerCreationView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class FertilizerCreationView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "create_ferti_title".localized
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
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

  lazy var natureLabel: UILabel = {
    let natureLabel = UILabel(frame: CGRect.zero)
    natureLabel.text = "nature".localized
    natureLabel.font = UIFont.systemFont(ofSize: 14)
    natureLabel.textColor = AppColor.TextColors.DarkGray
    natureLabel.translatesAutoresizingMaskIntoConstraints = false
    return natureLabel
  }()

  lazy var natureButton: UIButton = {
    let natureButton = UIButton(frame: CGRect.zero)
    natureButton.setTitle("organic".localized, for: .normal)
    natureButton.setTitleColor(UIColor.black, for: .normal)
    natureButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    natureButton.contentHorizontalAlignment = .leading
    natureButton.titleEdgeInsets = UIEdgeInsets(top: 13, left: 8, bottom: 0, right: 0)
    natureButton.translatesAutoresizingMaskIntoConstraints = false
    return natureButton
  }()

  lazy var natureAlertController: UIAlertController = {
    let natureAlertController = UIAlertController(title: "chose_nature".localized,
                                                  message: nil,
                                                  preferredStyle: .actionSheet)
    return natureAlertController
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
    addSubview(natureLabel)
    addSubview(natureButton)
    addSubview(cancelButton)
    addSubview(createButton)
    setupLayout()
    setupActions()
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
      natureLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 25),
      natureLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      natureButton.topAnchor.constraint(equalTo: natureLabel.bottomAnchor),
      natureButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      natureButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
      cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -15),
      createButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      createButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
      ])
  }

  private func setupActions() {
    natureAlertController.addAction(UIAlertAction(title: "organic".localized, style: .default, handler: { action in
      self.natureButton.setTitle("organic".localized, for: .normal)
    }))
    natureAlertController.addAction(UIAlertAction(title: "mineral".localized, style: .default, handler: { action in
      self.natureButton.setTitle("mineral".localized, for: .normal)
    }))
    natureAlertController.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
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

    return oldText.replacingCharacters(in: r, with: string).count <= 500
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  // MARK: - Actions

  @objc private func nameDidChange(_ textField: UITextField) {
    if !errorLabel.isHidden {
      errorLabel.isHidden = true
    }
  }

  @objc private func closeView(sender: UIButton) {
    nameTextField.resignFirstResponder()
    nameTextField.text = ""
    natureButton.setTitle("organic".localized, for: .normal)
    self.isHidden = true
  }
}
