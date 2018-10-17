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

  lazy var inputLabel: UILabel = {
    let inputLabel = UILabel(frame: CGRect.zero)

    inputLabel.font = UIFont.boldSystemFont(ofSize: 14)
    inputLabel.translatesAutoresizingMaskIntoConstraints = false
    return inputLabel
  }()

  lazy var inputName: UILabel = {
    let inputName = UILabel(frame: CGRect.zero)

    inputName.font = UIFont.systemFont(ofSize: 14)
    inputName.translatesAutoresizingMaskIntoConstraints = false
    return inputName
  }()

  lazy var inputQuantity: UITextField = {
    let inputQuantity = UITextField(frame: CGRect.zero)

    inputQuantity.backgroundColor = AppColor.ThemeColors.White
    inputQuantity.layer.borderColor = UIColor.lightGray.cgColor
    inputQuantity.layer.borderWidth = 1
    inputQuantity.layer.cornerRadius = 5
    inputQuantity.delegate = self
    inputQuantity.text = ""
    inputQuantity.keyboardType = .decimalPad
    inputQuantity.textAlignment = .center
    inputQuantity.addTarget(self, action: #selector(saveQuantity), for: .editingChanged)
    inputQuantity.translatesAutoresizingMaskIntoConstraints = false
    return inputQuantity
  }()

  lazy var quantity: UILabel = {
    let quantity = UILabel(frame: CGRect.zero)

    quantity.text = "quantity".localized
    quantity.textColor = AppColor.TextColors.DarkGray
    quantity.font = UIFont.systemFont(ofSize: 15)
    quantity.translatesAutoresizingMaskIntoConstraints = false
    return quantity
  }()

  lazy var removeCell: UIButton = {
    let removeCell = UIButton(frame: CGRect.zero)
    let tintedImage = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
    removeCell.setImage(tintedImage, for: .normal)
    removeCell.tintColor = UIColor.red
    removeCell.addTarget(self, action: #selector(self.removeCell(sender:)), for: .touchUpInside)
    removeCell.translatesAutoresizingMaskIntoConstraints = false
    return removeCell
  }()

  lazy var surfaceQuantity: UILabel = {
    let surfaceQuantity = UILabel(frame: CGRect.zero)

    surfaceQuantity.isHidden = true
    surfaceQuantity.font = UIFont.systemFont(ofSize: 15)
    surfaceQuantity.textColor = AppColor.TextColors.DarkGray
    surfaceQuantity.text = "Soit 0,0"
    surfaceQuantity.translatesAutoresizingMaskIntoConstraints = false
    return surfaceQuantity
  }()

  lazy var unitMeasureButton: UIButton = {
    let unitMeasureButton = UIButton(frame: CGRect.zero)

    unitMeasureButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    unitMeasureButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    unitMeasureButton.backgroundColor = AppColor.ThemeColors.White
    unitMeasureButton.layer.borderColor = UIColor.lightGray.cgColor
    unitMeasureButton.layer.borderWidth = 1
    unitMeasureButton.layer.cornerRadius = 5
    unitMeasureButton.titleLabel?.textAlignment = .center
    unitMeasureButton.setTitle(nil, for: .normal)
    unitMeasureButton.addTarget(self, action: #selector(self.showUnitMeasure(sender:)), for: .touchUpInside)
    unitMeasureButton.translatesAutoresizingMaskIntoConstraints = false
    return unitMeasureButton
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
    warningLabel.text = "non_authorized_mix".localized
    warningLabel.translatesAutoresizingMaskIntoConstraints = false
    return warningLabel
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(inputImageView)
    contentView.addSubview(inputLabel)
    contentView.addSubview(inputName)
    contentView.addSubview(inputQuantity)
    contentView.addSubview(quantity)
    contentView.addSubview(removeCell)
    contentView.addSubview(surfaceQuantity)
    contentView.addSubview(unitMeasureButton)
    contentView.addSubview(warningImageView)
    contentView.addSubview(warningLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      inputImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
      inputImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      inputImageView.heightAnchor.constraint(equalToConstant: 30),
      inputImageView.widthAnchor.constraint(equalToConstant: 30),
      inputName.leftAnchor.constraint(equalTo: inputImageView.rightAnchor, constant: 10),
      inputLabel.leftAnchor.constraint(equalTo: inputName.rightAnchor, constant: 5),

      quantity.topAnchor.constraint(equalTo: inputName.bottomAnchor, constant: 20),
      quantity.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),

      removeCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      removeCell.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
      removeCell.heightAnchor.constraint(equalToConstant: 15),
      removeCell.widthAnchor.constraint(equalToConstant: 15),

      inputName.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      inputQuantity.topAnchor.constraint(equalTo: inputName.bottomAnchor, constant: 12.5),
      inputQuantity.leftAnchor.constraint(equalTo: quantity.rightAnchor, constant: 10),
      inputQuantity.heightAnchor.constraint(equalToConstant: 30),
      inputQuantity.widthAnchor.constraint(equalToConstant: 100),

      inputLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      unitMeasureButton.topAnchor.constraint(equalTo: inputQuantity.topAnchor, constant: 0),
      unitMeasureButton.leftAnchor.constraint(equalTo: inputQuantity.rightAnchor, constant: 0),
      unitMeasureButton.heightAnchor.constraint(equalToConstant: 30),
      unitMeasureButton.widthAnchor.constraint(equalToConstant: 60),

      warningImageView.heightAnchor.constraint(equalToConstant: 10),
      warningImageView.widthAnchor.constraint(equalToConstant: 10),
      warningImageView.leadingAnchor.constraint(equalTo: inputQuantity.leadingAnchor, constant: 0),
      warningLabel.leadingAnchor.constraint(equalTo: warningImageView.trailingAnchor, constant: 3),
      surfaceQuantity.leadingAnchor.constraint(equalTo: inputQuantity.leadingAnchor, constant: 0),
      ]
    )

    if warningImageView.isHidden {
      NSLayoutConstraint.activate([
        surfaceQuantity.topAnchor.constraint(equalTo: inputQuantity.bottomAnchor, constant: 1)
        ]
      )
    } else {
      NSLayoutConstraint.activate([
        warningImageView.topAnchor.constraint(equalTo: inputQuantity.bottomAnchor, constant: 5),
        warningLabel.topAnchor.constraint(equalTo: inputQuantity.bottomAnchor, constant: 2),
        surfaceQuantity.topAnchor.constraint(equalTo: warningImageView.bottomAnchor, constant: 1)
        ]
      )
    }
  }

  // MARK: - Actions

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let containsADot = textField.text?.contains(".")
    var invalidCharacters: CharacterSet!

    if containsADot! {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789").inverted
    } else {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789.").inverted
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
      addInterventionViewController?.liquidUnitPicker.isHidden = false
    } else {
      addInterventionViewController?.solidUnitPicker.isHidden = false
    }
    cellDelegate?.saveSelectedRow(indexPath)
  }

  @objc func removeCell(sender: UIButton) {
    cellDelegate?.removeInputCell(indexPath)
  }

  @objc func saveQuantity(_ sender: Any) {
    addInterventionViewController?.selectedInputs[indexPath.row].setValue(
      (inputQuantity.text! as NSString).doubleValue, forKey: "quantity")
    addInterventionViewController?.updateInputQuantity(indexPath: indexPath)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
