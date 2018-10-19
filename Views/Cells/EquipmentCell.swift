//
//  EquipmentCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 31/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class EquipmentCell: UITableViewCell {

  // MARK: - Properties

  lazy var typeImageView: UIImageView = {
    let typeImageView = UIImageView(frame: CGRect.zero)
    typeImageView.tintColor = UIColor.darkGray
    typeImageView.backgroundColor = UIColor.lightGray
    typeImageView.translatesAutoresizingMaskIntoConstraints = false
    return typeImageView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var infosLabel: UILabel = {
    let infosLabel = UILabel(frame: CGRect.zero)
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
    contentView.addSubview(typeImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(infosLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      typeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      typeImageView.heightAnchor.constraint(equalToConstant: 35),
      typeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      typeImageView.widthAnchor.constraint(equalTo: typeImageView.heightAnchor),
      nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      nameLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      infosLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      infosLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      infosLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
