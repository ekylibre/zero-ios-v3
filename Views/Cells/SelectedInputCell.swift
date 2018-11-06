//
//  SelectedInputCell.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

protocol SelectedInputCellDelegate: class {
  func removeInputCell(_ indexPath: IndexPath)
  func saveSelectedRow(_ indexPath: IndexPath)
}

class SelectedInputCell: UITableViewCell, UITextFieldDelegate {

  // MARK: - Properties

  weak var cellDelegate: SelectedInputCellDelegate?
  var addInterventionViewController: AddInterventionViewController?
  var indexPath: IndexPath!
  var type = ""

  lazy var inputImageView: UIImageView = {
    let inputImageView = UIImageView(frame: CGRect.zero)
    inputImageView.translatesAutoresizingMaskIntoConstraints = false
    return inputImageView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.systemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var infoLabel: UILabel = {
    let infoLabel = UILabel(frame: CGRect.zero)
    infoLabel.font = UIFont.boldSystemFont(ofSize: 14)
    infoLabel.translatesAutoresizingMaskIntoConstraints = false
    return infoLabel
  }()

  lazy var deleteButton: UIButton = {
    let deleteButton = UIButton(frame: CGRect.zero)
    let tintedImage = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
    deleteButton.setImage(tintedImage, for: .normal)
    deleteButton.addTarget(self, action: #selector(self.removeCell(sender:)), for: .touchUpInside)
    deleteButton.tintColor = UIColor.red
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    return deleteButton
  }()

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
    quantityTextField.clipsToBounds = false
    quantityTextField.delegate = self
    quantityTextField.addTarget(self, action: #selector(saveQuantity), for: .editingChanged)
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
    unitButton.clipsToBounds = false
    unitButton.addTarget(self, action: #selector(self.showUnitMeasure(sender:)), for: .touchUpInside)
    unitButton.translatesAutoresizingMaskIntoConstraints = false
    return unitButton
  }()

  lazy var surfaceQuantity: UILabel = {
    let surfaceQuantity = UILabel(frame: CGRect.zero)

    surfaceQuantity.isHidden = true
    surfaceQuantity.font = UIFont.systemFont(ofSize: 15)
    surfaceQuantity.textColor = AppColor.TextColors.DarkGray
    surfaceQuantity.text = ""
    surfaceQuantity.translatesAutoresizingMaskIntoConstraints = false
    return surfaceQuantity
  }()

  lazy var warningImageView: UIImageView = {
    let warningImageView = UIImageView(frame: CGRect.zero)

    warningImageView.isHidden = true
    warningImageView.image = UIImage(named: "filled-circle")
    warningImageView.translatesAutoresizingMaskIntoConstraints = false
    return warningImageView
  }()

  lazy var warningLabel: UILabel = {
    let warningLabel = UILabel(frame: CGRect.zero)

    warningLabel.isHidden = true
    warningLabel.font = UIFont.systemFont(ofSize: 13)
    warningLabel.textColor = AppColor.TextColors.Red
    warningLabel.text = "unauthorized_mixing".localized
    warningLabel.translatesAutoresizingMaskIntoConstraints = false
    return warningLabel
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    self.backgroundColor = AppColor.CellColors.LightGray
    self.selectionStyle = .none
    contentView.addSubview(inputImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(infoLabel)
    contentView.addSubview(deleteButton)
    contentView.addSubview(quantityLabel)
    contentView.addSubview(quantityTextField)
    contentView.addSubview(unitButton)
    contentView.addSubview(warningImageView)
    contentView.addSubview(warningLabel)
    contentView.addSubview(surfaceQuantity)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      inputImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      inputImageView.heightAnchor.constraint(equalToConstant: 24),
      inputImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      inputImageView.widthAnchor.constraint(equalToConstant: 24),
      nameLabel.centerYAnchor.constraint(equalTo: inputImageView.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: inputImageView.trailingAnchor, constant: 10),
      infoLabel.centerYAnchor.constraint(equalTo: inputImageView.centerYAnchor),
      infoLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5),
      deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      deleteButton.heightAnchor.constraint(equalToConstant: 20),
      deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      deleteButton.widthAnchor.constraint(equalToConstant: 20),
      quantityLabel.topAnchor.constraint(equalTo: inputImageView.bottomAnchor, constant: 15),
      quantityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      quantityTextField.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      quantityTextField.heightAnchor.constraint(equalToConstant: 30),
      quantityTextField.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 15),
      quantityTextField.widthAnchor.constraint(equalToConstant: 70),
      unitButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      unitButton.heightAnchor.constraint(equalToConstant: 30),
      unitButton.leadingAnchor.constraint(equalTo: quantityTextField.trailingAnchor, constant: 10),
      unitButton.widthAnchor.constraint(equalToConstant: 70),

      warningImageView.heightAnchor.constraint(equalToConstant: 10),
      warningImageView.leadingAnchor.constraint(equalTo: quantityTextField.leadingAnchor),
      warningImageView.widthAnchor.constraint(equalToConstant: 10),
      warningLabel.leadingAnchor.constraint(equalTo: warningImageView.trailingAnchor, constant: 3),
      surfaceQuantity.leadingAnchor.constraint(equalTo: quantityTextField.leadingAnchor)
      ])

    if warningImageView.isHidden {
      NSLayoutConstraint.activate([
        surfaceQuantity.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 1)
        ]
      )
    } else {
      NSLayoutConstraint.activate([
        warningImageView.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 5),
        warningLabel.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 2),
        surfaceQuantity.topAnchor.constraint(equalTo: warningImageView.bottomAnchor, constant: 1)
        ]
      )
    }
  }

  // MARK: - Actions

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let containsADot = ((textField.text?.contains("."))! || (textField.text?.contains(","))!)
    var invalidCharacters: CharacterSet!

    if containsADot || textField.text?.count == 0 {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789").inverted
    } else {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789.,").inverted
    }
    return string.rangeOfCharacter(
      from: invalidCharacters,
      options: [],
      range: string.startIndex ..< string.endIndex
      ) == nil
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    saveQuantity(self)
    return false
  }

  @objc func showUnitMeasure(sender: UIButton) {
    addInterventionViewController?.dimView.isHidden = false
    if type == "Phyto" {
      addInterventionViewController?.volumeUnitPicker.isHidden = false
    } else {
      addInterventionViewController?.massUnitPicker.isHidden = false
    }
    cellDelegate?.saveSelectedRow(indexPath)
  }

  @objc func removeCell(sender: UIButton) {
    cellDelegate?.removeInputCell(indexPath)
  }

  @objc func saveQuantity(_ sender: Any) {
    addInterventionViewController?.selectedInputs[indexPath.row].setValue(
      (quantityTextField.text!).floatValue, forKey: "quantity")
    addInterventionViewController?.updateInputQuantity(indexPath: indexPath)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
