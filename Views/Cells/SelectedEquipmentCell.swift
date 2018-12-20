//
//  SelectedEquipmentCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 11/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SelectedEquipmentCell: UITableViewCell {

  // MARK: - Properties

  lazy var typeImageView: UIImageView = {
    let typeImageView = UIImageView(frame: CGRect.zero)
    typeImageView.tintColor = UIColor.darkGray
    typeImageView.translatesAutoresizingMaskIntoConstraints = false
    return typeImageView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.lineBreakMode = .byTruncatingTail
    nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
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

  lazy var infosLabel: UILabel = {
    let infosLabel = UILabel(frame: CGRect.zero)
    infosLabel.lineBreakMode = .byTruncatingTail
    infosLabel.font = UIFont.systemFont(ofSize: 14)
    infosLabel.textColor = AppColor.TextColors.DarkGray
    infosLabel.translatesAutoresizingMaskIntoConstraints = false
    return infosLabel
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    backgroundColor = AppColor.CellColors.LightGray
    selectionStyle = .none
    contentView.addSubview(typeImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(removeButton)
    contentView.addSubview(infosLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      typeImageView.widthAnchor.constraint(equalToConstant: 35),
      typeImageView.heightAnchor.constraint(equalToConstant: 35),
      nameLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 10),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: removeButton.leadingAnchor, constant: -10),
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      removeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
      removeButton.widthAnchor.constraint(equalToConstant: 40),
      removeButton.heightAnchor.constraint(equalToConstant: 40),
      infosLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 10),
      infosLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      infosLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
