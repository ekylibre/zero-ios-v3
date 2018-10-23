//
//  MaterialCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 26/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class MaterialCell: UITableViewCell {

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(nameLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
