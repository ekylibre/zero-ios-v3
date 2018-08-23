//
//  SelectedInputsTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import DropDown

class SelectedInputsTableViewCell: UITableViewCell, UITextFieldDelegate {
  let inputImage = UIImageView()
  let inputName = UILabel()
  let inputType = UILabel()
  let inputQuantity = UITextField()
  let quantity = UILabel()
  let quantityMeasureButton = UIButton()
  let removeCell = UIButton()
  let surfaceQuantity = UILabel()
  let warningImage = UIImageView()
  let warningLabel = UILabel()
  let quantityMeasureDropDown = DropDown()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    inputImage.translatesAutoresizingMaskIntoConstraints = false
    inputName.translatesAutoresizingMaskIntoConstraints = false
    inputType.translatesAutoresizingMaskIntoConstraints = false
    inputQuantity.translatesAutoresizingMaskIntoConstraints = false
    quantity.translatesAutoresizingMaskIntoConstraints = false
    quantityMeasureButton.translatesAutoresizingMaskIntoConstraints = false
    removeCell.translatesAutoresizingMaskIntoConstraints = false
    surfaceQuantity.translatesAutoresizingMaskIntoConstraints = false
    warningImage.translatesAutoresizingMaskIntoConstraints = false
    warningLabel.translatesAutoresizingMaskIntoConstraints = false

    inputName.font = UIFont.systemFont(ofSize: 14)
    inputType.font = UIFont.boldSystemFont(ofSize: 14)
    quantity.font = UIFont.systemFont(ofSize: 13)
    quantityMeasureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
    surfaceQuantity.font = UIFont.systemFont(ofSize: 13)
    warningLabel.font = UIFont.systemFont(ofSize: 13)

    quantity.textColor = AppColor.TextColors.DarkGray
    quantityMeasureButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    surfaceQuantity.textColor = AppColor.TextColors.DarkGray
    warningLabel.textColor = AppColor.TextColors.Red

    inputQuantity.backgroundColor = AppColor.CellColors.white
    inputQuantity.layer.borderColor = UIColor.lightGray.cgColor
    inputQuantity.layer.borderWidth = 1
    inputQuantity.layer.cornerRadius = 5

    quantityMeasureButton.backgroundColor = AppColor.CellColors.white
    quantityMeasureButton.layer.borderColor = UIColor.lightGray.cgColor
    quantityMeasureButton.layer.borderWidth = 1
    quantityMeasureButton.layer.cornerRadius = 5

    quantity.text = "Quantité"
    surfaceQuantity.text = "Soit 0,0 A"
    warningLabel.text = "dose invalide"

    warningImage.image = #imageLiteral(resourceName: "filled-circle")
    removeCell.setImage(#imageLiteral(resourceName: "delete"), for: .normal)

    warningLabel.isHidden = true
    warningImage.isHidden = true
    inputQuantity.delegate = self
    inputQuantity.keyboardType = .numberPad

    quantityMeasureButton.addTarget(self, action: #selector(self.showQuantityMeasure(sender:)), for: .touchUpInside)
    customizeDropDown(sender: self)

    contentView.addSubview(inputImage)
    contentView.addSubview(inputName)
    contentView.addSubview(inputType)
    contentView.addSubview(inputQuantity)
    contentView.addSubview(quantity)
    contentView.addSubview(quantityMeasureButton)
    contentView.addSubview(removeCell)
    contentView.addSubview(surfaceQuantity)
    contentView.addSubview(warningImage)
    contentView.addSubview(warningLabel)

    let viewsDict = [
      "inputImage": inputImage,
      "inputName": inputName,
      "inputType": inputType,
      "inputQuantity": inputQuantity,
      "quantity": quantity,
      "quantityMeasureButton": quantityMeasureButton,
      "removeCell": removeCell,
      "surfaceQuantity": surfaceQuantity,
      "warningImage": warningImage,
      "warningLabel": warningLabel
      ] as [String: Any]

    contentView.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-10-[inputImage(==30)]-[inputName]-[inputType]",
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
        withVisualFormat: "H:|-[quantity]-10-[inputQuantity(==100)][quantityMeasureButton(==60)]",
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
        withVisualFormat: "V:|-10-[inputType]-12.5-[quantityMeasureButton(==30)]",
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

  @objc func showQuantityMeasure(sender: UIButton) {
    quantityMeasureDropDown.show()
  }

  func customizeDropDown(sender: AnyObject) {
    let appearence = DropDown.appearance()

    appearence.cellHeight = 30
    appearence.backgroundColor = AppColor.CellColors.white
    appearence.selectionBackgroundColor = AppColor.CellColors.lightGray
    appearence.cornerRadius = 2
    appearence.shadowColor = UIColor(white: 0.6, alpha: 1)
    appearence.shadowOpacity = 1
    appearence.shadowRadius = 5
    appearence.animationduration = 0.25
    appearence.textColor = AppColor.TextColors.Black
    appearence.textFont = UIFont.boldSystemFont(ofSize: 12)
  }

  func setupSolideQuantityMeasureDropDown() {
    quantityMeasureDropDown.anchorView = quantityMeasureButton
    quantityMeasureDropDown.bottomOffset = CGPoint(x: 0, y: quantityMeasureButton.bounds.height)
    quantityMeasureDropDown.direction = .bottom
    quantityMeasureDropDown.dismissMode = .automatic
    quantityMeasureDropDown.dataSource = [
      "g",
      "g/ha",
      "g/m2",
      "kg",
      "kg/ha",
      "kg/m3",
      "q",
      "q/ha",
      "q/m2",
      "t",
      "t/ha",
      "t/m2"
    ]
    quantityMeasureDropDown.selectionAction = { [weak self] (index, item) in
      self?.quantityMeasureButton.setTitle(item, for: .normal)
    }
  }

  func setupLiquidQuantityMeasureDropDown() {
    quantityMeasureDropDown.anchorView = quantityMeasureButton
    quantityMeasureDropDown.bottomOffset = CGPoint(x: 0, y: quantityMeasureButton.bounds.height)
    quantityMeasureDropDown.direction = .bottom
    quantityMeasureDropDown.dismissMode = .automatic
    quantityMeasureDropDown.dataSource = [
      "l",
      "l/ha",
      "l/m2",
      "hl",
      "hl/ha",
      "hl/m2",
      "m3",
      "m3/ha",
      "m3/m2"
    ]
    quantityMeasureDropDown.selectionAction = { [weak self] (index, item) in
      self?.quantityMeasureButton.setTitle(item, for: .normal)
    }
  }

  func defineInputType(type: Int) {
    switch type {
    case 0:
      inputImage.image = #imageLiteral(resourceName: "seed")
      setupSolideQuantityMeasureDropDown()
    case 1:
      inputImage.image = #imageLiteral(resourceName: "phytosanitary")
      setupLiquidQuantityMeasureDropDown()
    case 2:
      inputImage.image = #imageLiteral(resourceName: "fertilizer")
      setupSolideQuantityMeasureDropDown()
    default:
      inputImage.image = #imageLiteral(resourceName: "seed")
      setupSolideQuantityMeasureDropDown()
    }
  }

  func reloadDropDown() {
    quantityMeasureDropDown.reloadAllComponents()
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let invalidCharacters = NSCharacterSet(charactersIn: "0123456789").inverted

    return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
