//
//  EquipmentEditionView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 10/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class EquipmentEditionView: UIView, UITextFieldDelegate {

  // MARK: - Properties

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "edit_equipment_title".localized
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var typeImageView: UIImageView = {
    let imageName = firstEquipmentType.lowercased().replacingOccurrences(of: "_", with: "-")
    let typeImageView = UIImageView(image: UIImage(named: imageName))
    typeImageView.translatesAutoresizingMaskIntoConstraints = false
    return typeImageView
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
    typeButton.setTitle(firstEquipmentType.localized, for: .normal)
    typeButton.setTitleColor(UIColor.black, for: .normal)
    typeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    typeButton.contentHorizontalAlignment = .leading
    typeButton.titleEdgeInsets = UIEdgeInsets(top: 13, left: 8, bottom: 0, right: 0)
    typeButton.translatesAutoresizingMaskIntoConstraints = false
    return typeButton
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
    errorLabel.isHidden = true
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    return errorLabel
  }()

  lazy var numberTextField: UITextField = {
    let numberTextField = UITextField(frame: CGRect.zero)
    numberTextField.placeholder = "number".localized
    numberTextField.autocorrectionType = .no
    numberTextField.delegate = self
    numberTextField.layer.backgroundColor = UIColor.white.cgColor
    numberTextField.layer.shadowColor = UIColor.darkGray.cgColor
    numberTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    numberTextField.layer.shadowOpacity = 1
    numberTextField.layer.shadowRadius = 0
    numberTextField.translatesAutoresizingMaskIntoConstraints = false
    return numberTextField
  }()

  lazy var firstIndicatorTextField: UITextField = {
    let firstIndicatorTextField = UITextField(frame: CGRect.zero)
    firstIndicatorTextField.keyboardType = .decimalPad
    firstIndicatorTextField.isHidden = true
    firstIndicatorTextField.autocorrectionType = .no
    firstIndicatorTextField.delegate = self
    firstIndicatorTextField.layer.backgroundColor = UIColor.white.cgColor
    firstIndicatorTextField.layer.shadowColor = UIColor.darkGray.cgColor
    firstIndicatorTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    firstIndicatorTextField.layer.shadowOpacity = 1
    firstIndicatorTextField.layer.shadowRadius = 0
    firstIndicatorTextField.translatesAutoresizingMaskIntoConstraints = false
    return firstIndicatorTextField
  }()

  lazy var firstIndicatorLabel: UILabel = {
    let firstIndicatorLabel = UILabel(frame: CGRect.zero)
    firstIndicatorLabel.isHidden = true
    firstIndicatorLabel.font = UIFont.systemFont(ofSize: 12)
    firstIndicatorLabel.textColor = UIColor.lightGray
    firstIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
    return firstIndicatorLabel
  }()

  lazy var secondIndicatorTextField: UITextField = {
    let secondIndicatorTextField = UITextField(frame: CGRect.zero)
    secondIndicatorTextField.keyboardType = .decimalPad
    secondIndicatorTextField.isHidden = true
    secondIndicatorTextField.autocorrectionType = .no
    secondIndicatorTextField.delegate = self
    secondIndicatorTextField.layer.backgroundColor = UIColor.white.cgColor
    secondIndicatorTextField.layer.shadowColor = UIColor.darkGray.cgColor
    secondIndicatorTextField.layer.shadowOffset = CGSize(width: 0, height: 0.5)
    secondIndicatorTextField.layer.shadowOpacity = 1
    secondIndicatorTextField.layer.shadowRadius = 0
    secondIndicatorTextField.translatesAutoresizingMaskIntoConstraints = false
    return secondIndicatorTextField
  }()

  lazy var secondIndicatorLabel: UILabel = {
    let secondIndicatorLabel = UILabel(frame: CGRect.zero)
    secondIndicatorLabel.isHidden = true
    secondIndicatorLabel.font = UIFont.systemFont(ofSize: 12)
    secondIndicatorLabel.textColor = UIColor.lightGray
    secondIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
    return secondIndicatorLabel
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

  lazy var saveButton: UIButton = {
    let saveButton = UIButton(frame: CGRect.zero)
    saveButton.setTitle("save".localized.uppercased(), for: .normal)
    saveButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    saveButton.setTitleColor(AppColor.TextColors.LightGreen, for: .highlighted)
    saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    saveButton.translatesAutoresizingMaskIntoConstraints = false
    return saveButton
  }()

  var firstEquipmentType: String
  lazy var heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil,
                                                 attribute: .notAnAttribute, multiplier: 1, constant: 350)

  // MARK: - Initialization

  init(firstType: String) {
    firstEquipmentType = firstType
    super.init(frame: CGRect.zero)
    setupView()
  }

  private func setupView() {
    backgroundColor = UIColor.white
    layer.cornerRadius = 5
    clipsToBounds = true
    isHidden = true
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(titleLabel)
    addSubview(typeImageView)
    addSubview(typeLabel)
    addSubview(typeButton)
    addSubview(nameTextField)
    addSubview(errorLabel)
    addSubview(numberTextField)
    addSubview(firstIndicatorTextField)
    addSubview(firstIndicatorLabel)
    addSubview(secondIndicatorTextField)
    addSubview(secondIndicatorLabel)
    addSubview(cancelButton)
    addSubview(saveButton)
    setupLayout()
    setupActions()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      heightConstraint,
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      typeImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
      typeImageView.heightAnchor.constraint(equalToConstant: 50),
      typeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      typeImageView.widthAnchor.constraint(equalToConstant: 50),
      typeLabel.topAnchor.constraint(equalTo: typeImageView.bottomAnchor, constant: 10),
      typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      typeButton.topAnchor.constraint(equalTo: typeLabel.bottomAnchor),
      typeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      typeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      nameTextField.topAnchor.constraint(equalTo: typeButton.bottomAnchor, constant: 35),
      nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
      errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      numberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 35),
      numberTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      numberTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      firstIndicatorTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      firstIndicatorTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      firstIndicatorTextField.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 35),
      firstIndicatorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      firstIndicatorLabel.topAnchor.constraint(equalTo: firstIndicatorTextField.bottomAnchor, constant: 10),
      secondIndicatorTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      secondIndicatorTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      secondIndicatorTextField.topAnchor.constraint(equalTo: firstIndicatorTextField.bottomAnchor, constant: 35),
      secondIndicatorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      secondIndicatorLabel.topAnchor.constraint(equalTo: secondIndicatorTextField.bottomAnchor, constant: 10),
      cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      cancelButton.rightAnchor.constraint(equalTo: saveButton.leftAnchor, constant: -15),
      saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      saveButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15)
      ])
  }

  private func setupActions() {
    cancelButton.addTarget(self, action: #selector(cancelEdition), for: .touchUpInside)
    saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
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

    if textField.keyboardType == .default {
      return oldText.replacingCharacters(in: r, with: string).count <= 500
    } else if textField.keyboardType == .numberPad {
      return oldText.replacingCharacters(in: r, with: string).count <= 16
    }

    let newText = oldText.replacingCharacters(in: r, with: string)
    var numberOfDecimalDigits = 0

    if newText.components(separatedBy: ".").count > 2 || newText.components(separatedBy: ",").count > 2 {
      return false
    } else if let dotIndex = (newText.contains(",") ? newText.index(of: ",") : newText.index(of: ".")) {
      numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
    }
    return numberOfDecimalDigits <= 2 && newText.count <= 16
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  // MARK: - Actions

  @objc private func cancelEdition() {
    guard let equipmentsView = superview as? EquipmentsView else { return }

    isHidden = true
    equipmentsView.dimView.isHidden = true
  }

  @objc private func saveChanges() {
    guard let equipmentsView = superview as? EquipmentsView else { return }

    isHidden = true
    equipmentsView.dimView.isHidden = true
  }
}
