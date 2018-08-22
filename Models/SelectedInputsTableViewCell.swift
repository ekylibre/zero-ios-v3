//
//  SelectedInputsTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SelectedInputsTableViewCell: UITableViewCell {
  let inputImage = UIImageView()
  let inputName = UILabel()
  let inputType = UILabel()
  let inputQuantity = UITextField()
  let quantity = UILabel()
  let quantityMeasure = UIView()
  let removeCell = UIButton()
  let surfaceQuantity = UILabel()
  let warningImage = UIImageView()
  let warningLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    inputImage.translatesAutoresizingMaskIntoConstraints = false
    inputName.translatesAutoresizingMaskIntoConstraints = false
    inputType.translatesAutoresizingMaskIntoConstraints = false
    inputQuantity.translatesAutoresizingMaskIntoConstraints = false
    quantity.translatesAutoresizingMaskIntoConstraints = false
    quantityMeasure.translatesAutoresizingMaskIntoConstraints = false
    removeCell.translatesAutoresizingMaskIntoConstraints = false
    surfaceQuantity.translatesAutoresizingMaskIntoConstraints = false
    warningImage.translatesAutoresizingMaskIntoConstraints = false
    warningLabel.translatesAutoresizingMaskIntoConstraints = false

    inputName.font = UIFont.systemFont(ofSize: 15)
    inputType.font = UIFont.boldSystemFont(ofSize: 15)
    quantity.font = UIFont.systemFont(ofSize: 14)
    surfaceQuantity.font = UIFont.systemFont(ofSize: 14)
    warningLabel.font = UIFont.systemFont(ofSize: 14)
    quantity.textColor = AppColor.TextColors.DarkGray
    removeCell.imageView?.image = #imageLiteral(resourceName: "delete")
    surfaceQuantity.textColor = AppColor.TextColors.DarkGray
    warningLabel.textColor = AppColor.TextColors.Red
    warningLabel.isHidden = true
    warningImage.isHidden = true
    contentView.addSubview(inputImage)
    contentView.addSubview(inputName)
    contentView.addSubview(inputType)
    contentView.addSubview(inputQuantity)
    contentView.addSubview(quantity)
    contentView.addSubview(quantityMeasure)
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
      "quantityMeasure": quantityMeasure,
      "removeCell": removeCell,
      "surfaceQuantity": surfaceQuantity,
      "warningImage": warningImage,
      "warningLabel": warningLabel
    ] as [String: Any]

    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[inputImage]-[inputName]-[inputType]-[removeCell]-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[quantity]-[inputQuantity]-[quantityMeasure]-|", options: [], metrics: nil, views: viewsDict))
    NSLayoutConstraint(item: surfaceQuantity, attribute: .leading, relatedBy: .equal, toItem: inputQuantity, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: warningImage, attribute: .leading, relatedBy: .equal, toItem: inputQuantity, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: warningLabel, attribute: .leading, relatedBy: .equal, toItem: warningImage, attribute: .trailing, multiplier: 1, constant: 1).isActive = true
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[inputImage]-10-[quantity]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[inputName]-5-[inputQuantity]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[inputType]-5-[quantityMeasure]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[removeCell]", options: [], metrics: nil, views: viewsDict))
    if warningImage.isHidden {
      NSLayoutConstraint(item: surfaceQuantity, attribute: .top, relatedBy: .equal, toItem: inputQuantity , attribute: .bottom, multiplier: 1, constant: 1).isActive = true
    } else {
      NSLayoutConstraint(item: warningImage, attribute: .top, relatedBy: .equal, toItem: inputQuantity, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
      NSLayoutConstraint(item: surfaceQuantity, attribute: .top, relatedBy: .equal, toItem: warningImage, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
