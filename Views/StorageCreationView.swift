//
//  StorageCreationView.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 02/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class StorageCreationView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "create_storage_title".localized
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var nameTextField: UITextField = {
    let nameTextField = UITextField(frame: CGRect.zero)
    nameTextField.placeholder = "name".localized
    nameTextField.delegate = self
    nameTextField.layer.backgroundColor = UIColor.white.cgColor
    nameTextField.layer.shadowColor = UIColor.darkGray.cgColor
    nameTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    nameTextField.layer.shadowOpacity = 1
    nameTextField.layer.shadowRadius = 0
    nameTextField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
    nameTextField.translatesAutoresizingMaskIntoConstraints = false
    return nameTextField
  }()

  lazy var errorLabel: UILabel = {
    let errorLabel = UILabel(frame: CGRect.zero)
    errorLabel.isHidden = true
    errorLabel.font = UIFont.systemFont(ofSize: 13)
    errorLabel.textColor = AppColor.AppleColors.Red
    errorLabel.numberOfLines = 0
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    return errorLabel
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
    typeButton.setTitle(returnTypesInSortedOrder()[0], for: .normal)
    typeButton.setTitleColor(.black, for: .normal)
    typeButton.contentHorizontalAlignment = .leading
    typeButton.titleEdgeInsets = UIEdgeInsets(top: 13, left: 8, bottom: 0, right: 0)
    typeButton.translatesAutoresizingMaskIntoConstraints = false
    return typeButton
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

  var selectedType: String?

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  func setupView() {
    backgroundColor = .white
    layer.cornerRadius = 5
    clipsToBounds = true
    isHidden = true
    addSubview(titleLabel)
    addSubview(nameTextField)
    addSubview(errorLabel)
    addSubview(typeLabel)
    addSubview(typeButton)
    addSubview(cancelButton)
    addSubview(createButton)
    setupLayout()
  }

  func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
      nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
      errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      typeLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
      typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      typeButton.topAnchor.constraint(equalTo: typeLabel.bottomAnchor),
      typeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      typeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      createButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      createButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
      cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -15)
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

  // MARK: - Actions

  func returnTypesInSortedOrder() -> [String] {
    var types = ["BUILDING", "HEAP", "SILO"]

    for index in 0..<types.count {
      types[index] = types[index].localized
    }
    types = types.sorted(by: {
      $0 < $1
    })
    return types
  }

  @objc private func nameDidChange() {
    if !errorLabel.isHidden {
      errorLabel.isHidden = true
    }
  }
}
