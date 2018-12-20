//
//  SelectedPersonCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 15/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SelectedPersonCell: UITableViewCell {

  // MARK: - Properties

  lazy var personImageView: UIImageView = {
    let personImageView = UIImageView(frame: CGRect.zero)
    let tintedImage = UIImage(named: "person")?.withRenderingMode(.alwaysTemplate)
    personImageView.image = tintedImage
    personImageView.tintColor = UIColor.darkGray
    personImageView.translatesAutoresizingMaskIntoConstraints = false
    return personImageView
  }()

  lazy var firstNameLabel: UILabel = {
    let firstNameLabel = UILabel(frame: CGRect.zero)
    firstNameLabel.lineBreakMode = .byTruncatingTail
    firstNameLabel.font = UIFont.systemFont(ofSize: 14)
    firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return firstNameLabel
  }()

  lazy var lastNameLabel: UILabel = {
    let lastNameLabel = UILabel(frame: CGRect.zero)
    lastNameLabel.lineBreakMode = .byTruncatingTail
    lastNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return lastNameLabel
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

  lazy var driverSwitch: UISwitch = {
    let driverSwitch = UISwitch(frame: CGRect.zero)
    driverSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    driverSwitch.onTintColor = AppColor.BarColors.Green
    driverSwitch.tintColor = UIColor.lightGray
    driverSwitch.layer.cornerRadius = 16
    driverSwitch.backgroundColor = UIColor.lightGray
    driverSwitch.translatesAutoresizingMaskIntoConstraints = false
    return driverSwitch
  }()

  lazy var driverLabel: UILabel = {
    let driverLabel = UILabel(frame: CGRect.zero)
    driverLabel.text = "driver".localized
    driverLabel.font = UIFont.systemFont(ofSize: 14)
    driverLabel.textColor = AppColor.TextColors.DarkGray
    driverLabel.translatesAutoresizingMaskIntoConstraints = false
    return driverLabel
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    backgroundColor = AppColor.CellColors.LightGray
    selectionStyle = .none
    contentView.addSubview(personImageView)
    contentView.addSubview(firstNameLabel)
    contentView.addSubview(lastNameLabel)
    contentView.addSubview(removeButton)
    contentView.addSubview(driverSwitch)
    contentView.addSubview(driverLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      personImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      personImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      personImageView.widthAnchor.constraint(equalToConstant: 45),
      personImageView.heightAnchor.constraint(equalToConstant: 45),
      firstNameLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 10),
      firstNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      lastNameLabel.leadingAnchor.constraint(equalTo: firstNameLabel.trailingAnchor, constant: 5),
      lastNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: removeButton.leadingAnchor, constant: -10),
      lastNameLabel.centerYAnchor.constraint(equalTo: firstNameLabel.centerYAnchor),
      removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      removeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
      removeButton.widthAnchor.constraint(equalToConstant: 40),
      removeButton.heightAnchor.constraint(equalToConstant: 40),
      driverSwitch.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 7.5),
      driverSwitch.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7.5),
      driverLabel.leadingAnchor.constraint(equalTo: driverSwitch.trailingAnchor, constant: 5),
      driverLabel.centerYAnchor.constraint(equalTo: driverSwitch.centerYAnchor)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
