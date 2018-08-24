//
//  PhytosTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class PhytosTableViewCell: UITableViewCell {

  let nameLabel = UILabel()
  let firmNameLabel = UILabel()
  let maaLabel = UILabel()
  let maaIDLabel = UILabel()
  let reentryLabel = UILabel()
  let inFieldReentryDelayLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(nameLabel)

    firmNameLabel.font = UIFont.systemFont(ofSize: 14)
    firmNameLabel.textColor = AppColor.TextColors.Green
    firmNameLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(firmNameLabel)

    maaLabel.text = "N° AMM"
    maaLabel.font = UIFont.italicSystemFont(ofSize: 14)
    maaLabel.textColor = AppColor.TextColors.DarkGray
    maaLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(maaLabel)

    maaIDLabel.font = UIFont.systemFont(ofSize: 14)
    maaIDLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(maaIDLabel)

    reentryLabel.text = "Délai de réentrée"
    reentryLabel.font = UIFont.italicSystemFont(ofSize: 14)
    reentryLabel.textColor = AppColor.TextColors.DarkGray
    reentryLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(reentryLabel)

    inFieldReentryDelayLabel.font = UIFont.systemFont(ofSize: 14)
    inFieldReentryDelayLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(inFieldReentryDelayLabel)

    let viewsDict = [
      "name" : nameLabel,
      "firmName" : firmNameLabel,
      "maa" : maaLabel,
      "maaID" : maaIDLabel,
      "reentry" : reentryLabel,
      "inFieldReentryDelay" : inFieldReentryDelayLabel,
      ] as [String : Any]

    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[name]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[firmName]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[maa]-[maaID]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[reentry]-[inFieldReentryDelay]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[name][firmName]-[maa][reentry]-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[firmName]-[maaID][inFieldReentryDelay]", options: [], metrics: nil, views: viewsDict))
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
