//
//  FertilizerCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class FertilizerCell: UITableViewCell {

  var isAlreadySelected = false

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var natureLabel: UILabel = {
    let natureLabel = UILabel(frame: CGRect.zero)
    natureLabel.font = UIFont.systemFont(ofSize: 14)
    natureLabel.textColor = AppColor.TextColors.DarkGray
    natureLabel.translatesAutoresizingMaskIntoConstraints = false
    return natureLabel
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(nameLabel)
    contentView.addSubview(natureLabel)
    setupLayout()
  }

  private func setupLayout() {
    let viewsDict = [
      "name": nameLabel,
      "nature": natureLabel,
      ] as [String: Any]

    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[nature]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[name][nature]-10-|", options: [], metrics: nil, views: viewsDict))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
