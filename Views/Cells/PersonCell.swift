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
    let personImageView = UIImageView(frame: CGRect.zero)
    let tintedImage = UIImage(named: "person")?.withRenderingMode(.alwaysTemplate)
    personImageView.image = tintedImage
    personImageView.tintColor = UIColor.darkGray
    personImageView.translatesAutoresizingMaskIntoConstraints = false
    return personImageView
  }()

  lazy var firstNameLabel: UILabel = {
    let firstNameLabel = UILabel(frame: CGRect.zero)
    firstNameLabel.font = UIFont.systemFont(ofSize: 14)
    firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return firstNameLabel
  }()

  lazy var lastNameLabel: UILabel = {
    let lastNameLabel = UILabel(frame: CGRect.zero)
    lastNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    lastNameLabel.textColor = AppColor.TextColors.DarkGray
    lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return lastNameLabel
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
      personImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      personImageView.heightAnchor.constraint(equalToConstant: 35),
      personImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      personImageView.widthAnchor.constraint(equalTo: personImageView.heightAnchor),
      firstNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      firstNameLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 15),
      firstNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      lastNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
      lastNameLabel.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 15),
      lastNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
