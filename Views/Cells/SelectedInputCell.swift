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
  func changeUnitMeasure(_ indexPath: IndexPath)
}

class SelectedInputCell: UITableViewCell, UITextFieldDelegate {
  weak var cellDelegate: SelectedInputCellDelegate?
  var indexPath: IndexPath!
  var type = ""

  var addInterventionViewController: AddInterventionViewController?
  let inputImage = UIImageView()
  let inputName = UILabel()
  let inputSpec = UILabel()
  let inputQuantity = UITextField()
  let quantity = UILabel()
  let removeCell = UIButton()
  let surfaceQuantity = UILabel()
  let unitMeasureButton = UIButton()
  let warningImage = UIImageView()
  let warningLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    inputImage.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(inputImage)

    inputName.font = UIFont.systemFont(ofSize: 14)
    inputName.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(inputName)

    inputSpec.font = UIFont.boldSystemFont(ofSize: 14)
    inputSpec.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(inputSpec)

    inputQuantity.backgroundColor = AppColor.CellColors.white
    inputQuantity.layer.borderColor = UIColor.lightGray.cgColor
    inputQuantity.layer.borderWidth = 1
    inputQuantity.layer.cornerRadius = 5
    inputQuantity.delegate = self
    inputQuantity.text = ""
    inputQuantity.keyboardType = .decimalPad
    inputQuantity.textAlignment = .center
    inputQuantity.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(inputQuantity)

    quantity.text = "Quantité"
    quantity.textColor = AppColor.TextColors.DarkGray
    quantity.font = UIFont.systemFont(ofSize: 13)
    quantity.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(quantity)

    removeCell.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
    removeCell.addTarget(self, action: #selector(self.removeCell(sender:)), for: .touchUpInside)
    removeCell.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(removeCell)

    surfaceQuantity.font = UIFont.systemFont(ofSize: 13)
    surfaceQuantity.textColor = AppColor.TextColors.DarkGray
    surfaceQuantity.text = "Soit 0,0 A"
    surfaceQuantity.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(surfaceQuantity)

    unitMeasureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
    unitMeasureButton.backgroundColor = AppColor.CellColors.white
    unitMeasureButton.layer.borderColor = UIColor.lightGray.cgColor
    unitMeasureButton.layer.borderWidth = 1
    unitMeasureButton.layer.cornerRadius = 5
    unitMeasureButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    unitMeasureButton.titleLabel?.textAlignment = .center
    unitMeasureButton.setTitle(nil, for: .normal)
    unitMeasureButton.addTarget(self, action: #selector(self.showUnitMeasure(sender:)), for: .touchUpInside)
    unitMeasureButton.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(unitMeasureButton)

    warningImage.isHidden = true
    warningImage.image = #imageLiteral(resourceName: "filled-circle")
    warningImage.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(warningImage)

    warningLabel.isHidden = true
    warningLabel.font = UIFont.systemFont(ofSize: 13)
    warningLabel.textColor = AppColor.TextColors.Red
    warningLabel.text = "dose invalide"
    warningLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(warningLabel)

    NSLayoutConstraint.activate([
      inputImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
      inputImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      inputImage.heightAnchor.constraint(equalToConstant: 30),
      inputImage.widthAnchor.constraint(equalToConstant: 30),
      inputName.leftAnchor.constraint(equalTo: inputImage.rightAnchor, constant: 10),
      inputSpec.leftAnchor.constraint(equalTo: inputName.rightAnchor, constant: 5),
      quantity.topAnchor.constraint(equalTo: inputName.bottomAnchor, constant: 20),
      quantity.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
      ]
    )

    NSLayoutConstraint.activate([
      removeCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      removeCell.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
      removeCell.heightAnchor.constraint(equalToConstant: 15),
      removeCell.widthAnchor.constraint(equalToConstant: 15)
      ]
    )

    NSLayoutConstraint.activate([
      inputName.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      inputQuantity.topAnchor.constraint(equalTo: inputName.bottomAnchor, constant: 12.5),
      inputQuantity.leftAnchor.constraint(equalTo: quantity.rightAnchor, constant: 10),
      inputQuantity.heightAnchor.constraint(equalToConstant: 30),
      inputQuantity.widthAnchor.constraint(equalToConstant: 100)
      ]
    )

    NSLayoutConstraint.activate([
      inputSpec.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      unitMeasureButton.topAnchor.constraint(equalTo: inputSpec.bottomAnchor, constant: 12.5),
      unitMeasureButton.leftAnchor.constraint(equalTo: inputQuantity.rightAnchor, constant: 0),
      unitMeasureButton.heightAnchor.constraint(equalToConstant: 30),
      unitMeasureButton.widthAnchor.constraint(equalToConstant: 60)
      ]
    )

    NSLayoutConstraint.activate([
      warningImage.heightAnchor.constraint(equalToConstant: 10),
      warningImage.widthAnchor.constraint(equalToConstant: 10)
      ]
    )

    NSLayoutConstraint.activate([
      surfaceQuantity.leadingAnchor.constraint(equalTo: inputQuantity.leadingAnchor, constant: 0),
      warningImage.leadingAnchor.constraint(equalTo: inputQuantity.leadingAnchor, constant: 0),
      warningLabel.leadingAnchor.constraint(equalTo: warningImage.trailingAnchor, constant: 3)
      ]
    )

    if warningImage.isHidden {

      NSLayoutConstraint.activate([
        surfaceQuantity.topAnchor.constraint(equalTo: inputQuantity.bottomAnchor, constant: 1)
        ]
      )
    } else {
      NSLayoutConstraint.activate([
        warningImage.topAnchor.constraint(equalTo: inputQuantity.bottomAnchor, constant: 5),
        warningLabel.topAnchor.constraint(equalTo: inputQuantity.bottomAnchor, constant: 2),
        surfaceQuantity.topAnchor.constraint(equalTo: warningImage.bottomAnchor, constant: 1)
        ]
      )
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let invalidCharacters = NSCharacterSet(charactersIn: "0123456789.").inverted

    return string.rangeOfCharacter(
      from: invalidCharacters,
      options: [],
      range: string.startIndex ..< string.endIndex
      ) == nil
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if textField == inputQuantity {
      addInterventionViewController?.selectedInputs[indexPath.row].setValue(
        (inputQuantity.text! as NSString).doubleValue, forKey: "quantity")
    }
    return false
  }

  @objc func showUnitMeasure(sender: UIButton) {
    addInterventionViewController?.dimView.isHidden = false
    if type == "Phyto" {
      addInterventionViewController?.liquidUnitPicker.isHidden = false
    } else {
      addInterventionViewController?.solidUnitPicker.isHidden = false
    }
    cellDelegate?.changeUnitMeasure(indexPath)
  }

  @objc func removeCell(sender: UIButton) {
    cellDelegate?.removeInputCell(indexPath)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
