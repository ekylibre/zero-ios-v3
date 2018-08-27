//
//  FertilizersTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class FertilizersTableViewCell: UITableViewCell {
  
  let nameLabel = UILabel()
  let natureLabel = UILabel()
  var isAlreadySelected = false

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(nameLabel)

    natureLabel.font = UIFont.systemFont(ofSize: 14)
    natureLabel.textColor = AppColor.TextColors.DarkGray
    natureLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(natureLabel)

    let viewsDict = [
      "name": nameLabel,
      "nature": natureLabel,
      ] as [String: Any]

    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[nature]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[name][nature]-10-|", options: [], metrics: nil, views: viewsDict))
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
