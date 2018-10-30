//
//  PersonCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 15/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

  // MARK: - Properties

  lazy var personImageView: UIImageView = {
    let typeImageView = UIImageView(frame: CGRect.zero)
    let tintedImage = UIImage(named: "person")?.withRenderingMode(.alwaysTemplate)
    typeImageView.image = tintedImage
    typeImageView.tintColor = UIColor.darkGray
    typeImageView.translatesAutoresizingMaskIntoConstraints = false
    return typeImageView
  }()

  lazy var firstNameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.systemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var lastNameLabel: UILabel = {
    let infosLabel = UILabel(frame: CGRect.zero)
    infosLabel.font = UIFont.boldSystemFont(ofSize: 14)
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
    contentView.addSubview(personImageView)
    contentView.addSubview(firstNameLabel)
    contentView.addSubview(lastNameLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      personImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      personImageView.heightAnchor.constraint(equalToConstant: 35),
      personImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      personImageView.widthAnchor.constraint(equalTo: personImageView.heightAnchor),
      firstNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      firstNameLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 15),
      firstNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      lastNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
      lastNameLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 15),
      lastNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
