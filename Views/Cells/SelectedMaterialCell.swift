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

  lazy var materialImageView: UIImageView = {
    let materialImageView = UIImageView(frame: CGRect.zero)
    materialImageView.image = UIImage(named: "material")
    materialImageView.translatesAutoresizingMaskIntoConstraints = false
    return materialImageView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.lineBreakMode = .byTruncatingTail
    nameLabel.font = UIFont.systemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var removeButton: UIButton = {
    let removeButton = UIButton(frame: CGRect.zero)
    let tintedImage = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
    removeButton.setImage(tintedImage, for: .normal)
    removeButton.tintColor = AppColor.AppleColors.Red
    removeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    removeButton.translatesAutoresizingMaskIntoConstraints = false
    return removeButton
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

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    backgroundColor = AppColor.CellColors.LightGray
    selectionStyle = .none
    contentView.addSubview(materialImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(removeButton)
    contentView.addSubview(quantityLabel)
    contentView.addSubview(quantityTextField)
    contentView.addSubview(unitButton)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      materialImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      materialImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      materialImageView.widthAnchor.constraint(equalToConstant: 24),
      materialImageView.heightAnchor.constraint(equalToConstant: 24),
      nameLabel.leadingAnchor.constraint(equalTo: materialImageView.trailingAnchor, constant: 10),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: removeButton.leadingAnchor, constant: -10),
      nameLabel.centerYAnchor.constraint(equalTo: materialImageView.centerYAnchor),
      removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      removeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
      removeButton.widthAnchor.constraint(equalToConstant: 40),
      removeButton.heightAnchor.constraint(equalToConstant: 40),
      quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      quantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
      quantityTextField.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 15),
      quantityTextField.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      quantityTextField.widthAnchor.constraint(equalToConstant: 70),
      quantityTextField.heightAnchor.constraint(equalToConstant: 30),
      unitButton.leadingAnchor.constraint(equalTo: quantityTextField.trailingAnchor, constant: 10),
      unitButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
      unitButton.widthAnchor.constraint(equalToConstant: 70),
      unitButton.heightAnchor.constraint(equalToConstant: 30)
      ])
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

    let newText = oldText.replacingCharacters(in: r, with: string)
    var numberOfDecimalDigits = 0

    if newText.components(separatedBy: ".").count > 2 || newText.components(separatedBy: ",").count > 2 {
      return false
    } else if let dotIndex = (newText.contains(",") ? newText.index(of: ",") : newText.index(of: ".")) {
      numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
    }
    return numberOfDecimalDigits <= 2 && newText.count <= 16
  }
}
