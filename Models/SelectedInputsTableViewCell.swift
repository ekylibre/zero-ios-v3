//
//  SelectedInputsTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 22/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SelectedInputsTableViewCell: UITableViewCell, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  let inputImage = UIImageView()
  let inputName = UILabel()
  let inputType = UILabel()
  let inputQuantity = UITextField()
  let quantity = UILabel()
  let quantityMeasure = UIView()
  //let quantityMeasure = MeasureTableView(frame: CGRect(x: 0, y: 0, width: 60, height: 25))
  let removeCell = UIButton()
  let surfaceQuantity = UILabel()
  let warningImage = UIImageView()
  let warningLabel = UILabel()
  let measureType = [["g", "g/ha", "g/m2", "kg", "kg/ha", "kg/m3", "q", "q/ha", "q/m2", "t", "t/ha", "t/m2"], ["l", "l/ha", "l/m2", "hl", "hl/ha", "hl/m2", "m3", "m3/ha", "m3/m2"]]
  var measureTableView: UITableView!

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

    inputName.font = UIFont.systemFont(ofSize: 14)
    inputType.font = UIFont.boldSystemFont(ofSize: 14)
    quantity.font = UIFont.systemFont(ofSize: 13)
    surfaceQuantity.font = UIFont.systemFont(ofSize: 13)
    warningLabel.font = UIFont.systemFont(ofSize: 13)
    quantity.textColor = AppColor.TextColors.DarkGray
    inputQuantity.backgroundColor = AppColor.CellColors.white
    inputQuantity.layer.borderColor = UIColor.lightGray.cgColor
    inputQuantity.layer.borderWidth = 1
    inputQuantity.layer.cornerRadius = 5
    quantityMeasure.backgroundColor = AppColor.CellColors.white
    quantityMeasure.layer.borderColor = UIColor.lightGray.cgColor
    quantityMeasure.layer.borderWidth = 1
    quantityMeasure.layer.cornerRadius = 5
    surfaceQuantity.textColor = AppColor.TextColors.DarkGray
    warningLabel.textColor = AppColor.TextColors.Red
    warningLabel.text = "dose invalide"
    quantity.text = "Quantité"
    surfaceQuantity.text = "Soit 0,0 A"
    warningImage.image = #imageLiteral(resourceName: "filled-circle")
    inputImage.image = #imageLiteral(resourceName: "seed")
    removeCell.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
    warningLabel.isHidden = true
    warningImage.isHidden = true
    inputQuantity.delegate = self
    inputQuantity.keyboardType = .numberPad

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

    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[inputImage(==30)]-[inputName]-[inputType]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[removeCell(==15)]-10-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[quantity]-10-[inputQuantity(==100)][quantityMeasure(==60)]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[inputImage(==30)]-10-[quantity]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[inputName]-15-[inputQuantity(==25)]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[inputType]-15-[quantityMeasure(==25)]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[removeCell(==15)]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[warningImage(==10)]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[warningImage(==10)]", options: [], metrics: nil, views: viewsDict))
    NSLayoutConstraint(item: surfaceQuantity, attribute: .leading, relatedBy: .equal, toItem: inputQuantity, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: warningImage, attribute: .leading, relatedBy: .equal, toItem: inputQuantity, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: warningLabel, attribute: .leading, relatedBy: .equal, toItem: warningImage, attribute: .trailing, multiplier: 1, constant: 3).isActive = true
    if warningImage.isHidden {
      NSLayoutConstraint(item: surfaceQuantity, attribute: .top, relatedBy: .equal, toItem: inputQuantity , attribute: .bottom, multiplier: 1, constant: 1).isActive = true
    } else {
      NSLayoutConstraint(item: warningImage, attribute: .top, relatedBy: .equal, toItem: inputQuantity, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
      NSLayoutConstraint(item: warningLabel, attribute: .top, relatedBy: .equal, toItem: inputQuantity, attribute: .bottom, multiplier: 1, constant: 2).isActive = true
      NSLayoutConstraint(item: surfaceQuantity, attribute: .top, relatedBy: .equal, toItem: warningImage, attribute: .bottom, multiplier: 1, constant: 1).isActive = true
    }
    let measureTypeSelection = MeasureTableView(frame: quantityMeasure.frame)

    quantityMeasure.addSubview(measureTypeSelection)
    measureTableView = measureTypeSelection.subviews.last as! UITableView
    measureTableView.register(MeasureTableViewCell.self, forCellReuseIdentifier: "MeasureTableViewCell")
    measureTableView.delegate = self
    measureTableView.dataSource = self
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return measureType[1].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = measureTableView.dequeueReusableCell(withIdentifier: "MeasureTableViewCell", for: indexPath) as! MeasureTableViewCell

    cell.measureType.text = measureType[indexPath.row][1]
    return cell
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let invalidCharacters = NSCharacterSet(charactersIn: "0123456789").inverted
    return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class MeasureTableView: UIView {
  var tableView: UITableView!

  override init(frame: CGRect) {
    super.init(frame: frame)

    tableView = UITableView(frame: CGRect.zero)
    tableView.separatorInset = UIEdgeInsets.zero
    let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale)
    let line = UIView(frame: frame)

    line.backgroundColor = tableView.separatorColor
    tableView.tableHeaderView = line
    tableView.tableFooterView = UIView()
    tableView.backgroundColor = AppColor.CellColors.white
    tableView.layer.shadowColor = UIColor.black.cgColor
    tableView.layer.shadowOffset = .zero
    tableView.layer.shadowOpacity = 10
    tableView.layer.shadowRadius = 5
    tableView.layer.cornerRadius = 5
    tableView.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(tableView)
    let viewDict = ["tableView": tableView] as [String: Any]

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: viewDict))
  }

  @objc func reloadTable() {
    tableView.reloadData()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class MeasureTableViewCell: UITableViewCell {
  let measureType = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    measureType.translatesAutoresizingMaskIntoConstraints = false
    measureType.font = UIFont.boldSystemFont(ofSize: 14)
    contentView.addSubview(measureType)

    let viewDict = ["measureType": measureType] as [String: Any]

    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(<=1)-[measureType]", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(<=1)-[measureType]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewDict))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
