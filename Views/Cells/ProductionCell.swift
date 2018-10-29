//
//  ProductionCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 29/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class ProductionCell: UITableViewCell {

  lazy var headerSeparatorView: UIView = {
    let headerSeparatorView = UIView(frame: CGRect.zero)
    headerSeparatorView.backgroundColor = UITableView().separatorColor
    headerSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    return headerSeparatorView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
    nameLabel.textColor = AppColor.TextColors.Green
    nameLabel.textAlignment = .center
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var footerSeparatorView: UIView = {
    let footerSeparatorView = UIView(frame: CGRect.zero)
    footerSeparatorView.backgroundColor = UITableView().separatorColor
    footerSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    return footerSeparatorView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.backgroundColor = AppColor.CellColors.LightGray
    contentView.addSubview(headerSeparatorView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(footerSeparatorView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      headerSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
      headerSeparatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
      headerSeparatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      headerSeparatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      footerSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      footerSeparatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
      footerSeparatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      footerSeparatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
