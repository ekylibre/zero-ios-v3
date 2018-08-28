//
//  SelectedInputsTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

protocol SelectedInputsTableViewCellDelegate: class {
  func removeInputsCell(_ indexPath: IndexPath)
  func changeUnitMeasure(_ indexPath: IndexPath)
}

class SelectedInputsTableViewCell: UITableViewCell, UITextFieldDelegate {
  weak var cellDelegate: SelectedInputsTableViewCellDelegate?
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

    let viewsDict = [
      "inputImage": inputImage,
      "inputName": inputName,
      "inputSpec": inputSpec,
      "inputQuantity": inputQuantity,
      "quantity": quantity,
      "removeCell": removeCell,
      "surfaceQuantity": surfaceQuantity,
      "unitMeasureButton": unitMeasureButton,
      "warningImage": warningImage,
      "warningLabel": warningLabel
      ] as [String: Any]

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-10-[inputImage(==30)]-[inputName]-[inputSpec]",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:[removeCell(==15)]-10-|",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-[quantity]-10-[inputQuantity(==100)][unitMeasureButton(==60)]",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-5-[inputImage(==30)]-10-[quantity]",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-10-[inputName]-12.5-[inputQuantity(==30)]",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-10-[inputSpec]-12.5-[unitMeasureButton(==30)]",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|-10-[removeCell(==15)]",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:[warningImage(==10)]",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:[warningImage(==10)]",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    NSLayoutConstraint(
      item: surfaceQuantity,
      attribute: .leading,
      relatedBy: .equal,
      toItem: inputQuantity,
      attribute: .leading,
      multiplier: 1,
      constant: 0
      ).isActive = true

    NSLayoutConstraint(
      item: warningImage,
      attribute: .leading,
      relatedBy: .equal,
      toItem: inputQuantity,
      attribute: .leading,
      multiplier: 1,
      constant: 0
      ).isActive = true

    NSLayoutConstraint(
      item: warningLabel,
      attribute: .leading,
      relatedBy: .equal,
      toItem: warningImage,
      attribute: .trailing,
      multiplier: 1,
      constant: 3
      ).isActive = true

    if warningImage.isHidden {
      NSLayoutConstraint(
        item: surfaceQuantity,
        attribute: .top,
        relatedBy: .equal,
        toItem: inputQuantity,
        attribute: .bottom,
        multiplier: 1,
        constant: 1
        ).isActive = true
    } else {
      NSLayoutConstraint(
        item: warningImage,
        attribute: .top,
        relatedBy: .equal,
        toItem: inputQuantity,
        attribute: .bottom,
        multiplier: 1,
        constant: 5
        ).isActive = true

      NSLayoutConstraint(
        item: warningLabel,
        attribute: .top,
        relatedBy: .equal,
        toItem: inputQuantity,
        attribute: .bottom,
        multiplier: 1,
        constant: 2
        ).isActive = true

      NSLayoutConstraint(
        item: surfaceQuantity,
        attribute: .top,
        relatedBy: .equal,
        toItem: warningImage,
        attribute: .bottom,
        multiplier: 1,
        constant: 1
        ).isActive = true
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let invalidCharacters = NSCharacterSet(charactersIn: "0123456789.").inverted

    return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
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
    cellDelegate?.removeInputsCell(indexPath)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
