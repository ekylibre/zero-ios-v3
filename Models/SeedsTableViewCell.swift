//
//  SeedsTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 20/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SeedsTableViewCell: UITableViewCell {

  let varietyLabel = UILabel()
  let specieLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    varietyLabel.font = UIFont.boldSystemFont(ofSize: 14)
    varietyLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(varietyLabel)

    specieLabel.font = UIFont.systemFont(ofSize: 14)
    specieLabel.textColor = AppColor.TextColors.DarkGray
    specieLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(specieLabel)

    let viewsDict = [
      "variety" : varietyLabel,
      "specie" : specieLabel,
    ] as [String : Any]

    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[variety]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[specie]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[variety][specie]-10-|", options: [], metrics: nil, views: viewsDict))
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
