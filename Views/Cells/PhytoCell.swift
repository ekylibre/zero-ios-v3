//
//  PhytoCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class PhytoCell: UITableViewCell {

  var isAvaible = true

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var firmNameLabel: UILabel = {
    let firmNameLabel = UILabel(frame: CGRect.zero)
    firmNameLabel.font = UIFont.systemFont(ofSize: 14)
    firmNameLabel.textColor = AppColor.TextColors.Green
    firmNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return firmNameLabel
  }()

  lazy var maaLabel: UILabel = {
    let maaLabel = UILabel(frame: CGRect.zero)
    maaLabel.text = "N° AMM"
    maaLabel.font = UIFont.italicSystemFont(ofSize: 14)
    maaLabel.textColor = AppColor.TextColors.DarkGray
    maaLabel.translatesAutoresizingMaskIntoConstraints = false
    return maaLabel
  }()

  lazy var maaIDLabel: UILabel = {
    let maaIDLabel = UILabel(frame: CGRect.zero)
    maaIDLabel.font = UIFont.systemFont(ofSize: 14)
    maaIDLabel.translatesAutoresizingMaskIntoConstraints = false
    return maaIDLabel
  }()

  lazy var reentryLabel: UILabel = {
    let reentryLabel = UILabel(frame: CGRect.zero)
    reentryLabel.text = "Délai de réentrée"
    reentryLabel.font = UIFont.italicSystemFont(ofSize: 14)
    reentryLabel.textColor = AppColor.TextColors.DarkGray
    reentryLabel.translatesAutoresizingMaskIntoConstraints = false
    return reentryLabel
  }()

  lazy var inFieldReentryDelayLabel: UILabel = {
    let inFieldReentryDelayLabel = UILabel(frame: CGRect.zero)
    inFieldReentryDelayLabel.font = UIFont.systemFont(ofSize: 14)
    inFieldReentryDelayLabel.translatesAutoresizingMaskIntoConstraints = false
    return inFieldReentryDelayLabel
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(nameLabel)
    contentView.addSubview(firmNameLabel)
    contentView.addSubview(maaLabel)
    contentView.addSubview(maaIDLabel)
    contentView.addSubview(reentryLabel)
    contentView.addSubview(inFieldReentryDelayLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      firmNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
      firmNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      maaLabel.topAnchor.constraint(equalTo: firmNameLabel.bottomAnchor, constant: 15),
      maaLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      maaIDLabel.topAnchor.constraint(equalTo: firmNameLabel.bottomAnchor, constant: 15),
      maaIDLabel.leadingAnchor.constraint(equalTo: maaLabel.trailingAnchor, constant: 15),
      reentryLabel.topAnchor.constraint(equalTo: maaLabel.bottomAnchor),
      reentryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      inFieldReentryDelayLabel.topAnchor.constraint(equalTo: maaIDLabel.bottomAnchor),
      inFieldReentryDelayLabel.leadingAnchor.constraint(equalTo: reentryLabel.trailingAnchor, constant: 15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
