//
//  LoadCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 17/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

protocol LoadCellDelegate: class {
  func removeLoadCell(_ indexPath: IndexPath)
}

class LoadCell: UITableViewCell, UITextFieldDelegate {

  // MARK: - Properties

  weak var cellDelegate: LoadCellDelegate?
  var addInterventionController: AddInterventionViewController?
  var indexPath: IndexPath!

  lazy var quantityLabel: UILabel = {
    let quantityLabel = UILabel(frame: CGRect.zero)
    quantityLabel.text = "quantity".localized
    quantityLabel.textColor = AppColor.TextColors.DarkGray
    quantityLabel.font = UIFont.systemFont(ofSize: 14)
    quantityLabel.translatesAutoresizingMaskIntoConstraints = false
    return quantityLabel
  }()

  lazy var quantityTextField: UITextField = {
    let quantityTextField = UITextField(frame: CGRect.zero)
    quantityTextField.placeholder = "0"
    quantityTextField.keyboardType = .decimalPad
    quantityTextField.textAlignment = .center
    quantityTextField.backgroundColor = AppColor.ThemeColors.White
    quantityTextField.layer.borderWidth = 0.5
    quantityTextField.layer.borderColor = UIColor.lightGray.cgColor
    quantityTextField.layer.cornerRadius = 5
    quantityTextField.delegate = self
    quantityTextField.translatesAutoresizingMaskIntoConstraints = false
    return quantityTextField
  }()

  lazy var unitButton: UIButton = {
    let unitButton = UIButton(frame: CGRect.zero)
    unitButton.setTitle("unit", for: .normal)
    unitButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    unitButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    unitButton.backgroundColor = AppColor.ThemeColors.White
    unitButton.layer.borderWidth = 0.5
    unitButton.layer.borderColor = UIColor.lightGray.cgColor
    unitButton.layer.cornerRadius = 5
    unitButton.translatesAutoresizingMaskIntoConstraints = false
    return unitButton
  }()

  lazy var deleteButton: UIButton = {
    let deleteButton = UIButton(frame: CGRect.zero)
    let tintedImage = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
    deleteButton.setImage(tintedImage, for: .normal)
    deleteButton.tintColor = AppColor.AppleColors.Red
    deleteButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    return deleteButton
  }()

  lazy var storageLabel: UILabel = {
    let storageLabel = UILabel(frame: CGRect.zero)
    storageLabel.text = "storage".localized
    storageLabel.textColor = AppColor.TextColors.DarkGray
    storageLabel.font = UIFont.systemFont(ofSize: 14)
    storageLabel.translatesAutoresizingMaskIntoConstraints = false
    return storageLabel
  }()

  lazy var storageButton: UIButton = {
    let storageButton = UIButton(frame: CGRect.zero)
    storageButton.setTitle("unit", for: .normal)
    storageButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    storageButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    storageButton.backgroundColor = AppColor.ThemeColors.White
    storageButton.layer.borderWidth = 0.5
    storageButton.layer.borderColor = UIColor.lightGray.cgColor
    storageButton.layer.cornerRadius = 5
    storageButton.translatesAutoresizingMaskIntoConstraints = false
    return storageButton
  }()

  lazy var createStorageButton: UIButton = {
    let createStorageButton = UIButton(frame: CGRect.zero)
    let tintedImage = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
    createStorageButton.setImage(tintedImage, for: .normal)
    createStorageButton.tintColor = AppColor.BarColors.Green
    createStorageButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    createStorageButton.translatesAutoresizingMaskIntoConstraints = false
    return createStorageButton
  }()

  lazy var numberLabel: UILabel = {
    let numberLabel = UILabel(frame: CGRect.zero)
    numberLabel.text = "number".localized
    numberLabel.textColor = AppColor.TextColors.DarkGray
    numberLabel.font = UIFont.systemFont(ofSize: 14)
    numberLabel.translatesAutoresizingMaskIntoConstraints = false
    return numberLabel
  }()

  lazy var numberTextField: UITextField = {
    let numberTextField = UITextField(frame: CGRect.zero)
    numberTextField.keyboardType = .decimalPad
    numberTextField.textAlignment = .center
    numberTextField.placeholder = "provided_by_collector".localized
    numberTextField.backgroundColor = AppColor.ThemeColors.White
    numberTextField.layer.borderWidth = 0.5
    numberTextField.layer.borderColor = UIColor.lightGray.cgColor
    numberTextField.layer.cornerRadius = 5
    numberTextField.delegate = self
    numberTextField.translatesAutoresizingMaskIntoConstraints = false
    return numberTextField
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    backgroundColor = AppColor.CellColors.LightGray
    selectionStyle = .none
    contentView.addSubview(quantityLabel)
    contentView.addSubview(quantityTextField)
    contentView.addSubview(unitButton)
    contentView.addSubview(deleteButton)
    contentView.addSubview(storageLabel)
    contentView.addSubview(storageButton)
    contentView.addSubview(createStorageButton)
    contentView.addSubview(numberLabel)
    contentView.addSubview(numberTextField)
    setupLayout()
    setupActions()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      quantityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      quantityTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
      quantityTextField.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      quantityTextField.widthAnchor.constraint(equalToConstant: 70),
      quantityTextField.heightAnchor.constraint(equalToConstant: 30),
      unitButton.leadingAnchor.constraint(equalTo: quantityTextField.trailingAnchor, constant: 10),
      unitButton.trailingAnchor.constraint(lessThanOrEqualTo: deleteButton.leadingAnchor),
      unitButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      unitButton.widthAnchor.constraint(equalToConstant: 70),
      unitButton.heightAnchor.constraint(equalToConstant: 30),
      deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
      deleteButton.widthAnchor.constraint(equalToConstant: 40),
      deleteButton.heightAnchor.constraint(equalToConstant: 40),
      storageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      storageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      storageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
      storageButton.trailingAnchor.constraint(equalTo: createStorageButton.leadingAnchor),
      storageButton.centerYAnchor.constraint(equalTo: storageLabel.centerYAnchor),
      storageButton.heightAnchor.constraint(equalToConstant: 30),
      createStorageButton.centerXAnchor.constraint(equalTo: deleteButton.centerXAnchor),
      createStorageButton.centerYAnchor.constraint(equalTo: storageLabel.centerYAnchor),
      createStorageButton.widthAnchor.constraint(equalToConstant: 40),
      createStorageButton.heightAnchor.constraint(equalToConstant: 40),
      numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
      numberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
      numberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      numberTextField.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
      numberTextField.heightAnchor.constraint(equalToConstant: 30)
      ])
  }

  private func setupActions() {
    quantityTextField.addTarget(self, action: #selector(defineQuantity), for: .editingChanged)
    unitButton.addTarget(self, action: #selector(defineUnit), for: .touchUpInside)
    deleteButton.addTarget(self, action: #selector(removeCell), for: .touchUpInside)
    storageButton.addTarget(self, action: #selector(defineStorage), for: .touchUpInside)
    createStorageButton.addTarget(self, action: #selector(createStorage), for: .touchUpInside)
    numberTextField.addTarget(self, action: #selector(defineNumber), for: .editingChanged)
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
    if textField == quantityTextField {
      defineQuantity()
    } else if textField == numberTextField {
      defineNumber()
    }

    textField.resignFirstResponder()
    return false
  }

  // MARK: - Actions

  @objc private func defineQuantity() {
    addInterventionController?.selectedHarvests[indexPath.row].quantity = (quantityTextField.text! as NSString).doubleValue
  }

  @objc private func defineUnit(_ sender: UIButton) {
    guard let selectedUnit = sender.titleLabel?.text else { return }

    addInterventionController?.customPickerView.values = ["KILOGRAM", "QUINTAL", "TON"]
    addInterventionController?.customPickerView.pickerView.reloadComponent(0)
    addInterventionController?.customPickerView.selectLastValue(selectedUnit)
    addInterventionController?.customPickerView.closure = { (value) in
      self.addInterventionController?.selectedHarvests[self.indexPath.row].unit = value
      self.addInterventionController?.loadsTableView.reloadData()
    }
    addInterventionController?.customPickerView.isHidden = false
  }

  @objc private func removeCell() {
    cellDelegate?.removeLoadCell(indexPath)
  }

  @objc private func defineStorage(_ sender: UIButton) {
    guard let selectedUnit = sender.titleLabel?.text else { return }

    if let storagesNumber = addInterventionController?.storages.count {
      if storagesNumber > 0 {
        addInterventionController?.customPickerView.values = addInterventionController?.fetchStoragesName()
        addInterventionController?.customPickerView.pickerView.reloadComponent(0)
        addInterventionController?.customPickerView.selectLastValue(selectedUnit)
        addInterventionController?.customPickerView.closure = { (value) in
          let predicate = NSPredicate(format: "name == %@", value)
          let searchedStorage = self.addInterventionController?.fetchStorages(predicate: predicate)

          self.addInterventionController?.selectedHarvests[self.indexPath.row].storage = searchedStorage?.first
          self.addInterventionController?.loadsTableView.reloadData()
        }
        addInterventionController?.customPickerView.isHidden = false
      }
    }
  }

  @objc private func createStorage() {
    addInterventionController?.dimView.isHidden = false
    addInterventionController?.storageCreationView.isHidden = false
  }

  @objc private func defineNumber() {
    addInterventionController?.selectedHarvests[indexPath.row].number = numberTextField.text!
  }
}
