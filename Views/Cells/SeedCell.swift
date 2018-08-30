//
//  SeedCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 20/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SeedCell: UITableViewCell {

  lazy var varietyLabel: UILabel = {
    let varietyLabel = UILabel(frame: CGRect.zero)
    varietyLabel.font = UIFont.boldSystemFont(ofSize: 14)
    varietyLabel.translatesAutoresizingMaskIntoConstraints = false
    return varietyLabel
  }()

  lazy var specieLabel: UILabel = {
    let specieLabel = UILabel(frame: CGRect.zero)
    specieLabel.font = UIFont.systemFont(ofSize: 14)
    specieLabel.textColor = AppColor.TextColors.DarkGray
    specieLabel.translatesAutoresizingMaskIntoConstraints = false
    return specieLabel
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(varietyLabel)
    contentView.addSubview(specieLabel)
    setupLayout()
  }

  private func setupLayout() {
    let viewsDict = [
      "variety" : varietyLabel,
      "specie" : specieLabel,
      ] as [String : Any]

    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[variety]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[specie]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[variety][specie]-10-|", options: [], metrics: nil, views: viewsDict))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
