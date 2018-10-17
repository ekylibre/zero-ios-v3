//
//  SelectedMaterialCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 08/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SelectedMaterialCell: UITableViewCell, UITextFieldDelegate {

  // MARK: - Properties

  var indexPath: IndexPath!

  lazy var materialImageView: UIImageView = {
    let materialImageView = UIImageView(frame: CGRect.zero)
    materialImageView.image = UIImage(named: "material")
    materialImageView.translatesAutoresizingMaskIntoConstraints = false
    return materialImageView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.systemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var deleteButton: UIButton = {
    let deleteButton = UIButton(frame: CGRect.zero)
    let tintedImage = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
    deleteButton.setImage(tintedImage, for: .normal)
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
    unitButton.translatesAutoresizingMaskIntoConstraints = false
    return unitButton
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    self.backgroundColor = AppColor.CellColors.LightGray
    self.selectionStyle = .none
    contentView.addSubview(materialImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(deleteButton)
    contentView.addSubview(quantityLabel)
    contentView.addSubview(quantityTextField)
    contentView.addSubview(unitButton)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      materialImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      materialImageView.heightAnchor.constraint(equalToConstant: 24),
      materialImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      materialImageView.widthAnchor.constraint(equalToConstant: 24),
      nameLabel.centerYAnchor.constraint(equalTo: materialImageView.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: materialImageView.trailingAnchor, constant: 10),
      deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      deleteButton.heightAnchor.constraint(equalToConstant: 20),
      deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      deleteButton.widthAnchor.constraint(equalToConstant: 20),
      quantityLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      quantityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      quantityTextField.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      quantityTextField.heightAnchor.constraint(equalToConstant: 30),
      quantityTextField.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 15),
      quantityTextField.widthAnchor.constraint(equalToConstant: 70),
      unitButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      unitButton.heightAnchor.constraint(equalToConstant: 30),
      unitButton.leadingAnchor.constraint(equalTo: quantityTextField.trailingAnchor, constant: 10),
      unitButton.widthAnchor.constraint(equalToConstant: 70)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}
