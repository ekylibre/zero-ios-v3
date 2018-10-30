//
//  CropCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 30/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CropCell: UITableViewCell {

  lazy var plotNameLabel: UILabel = {
    let plotNameLabel = UILabel(frame: CGRect.zero)
    plotNameLabel.font = UIFont.systemFont(ofSize: 14)
    plotNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return plotNameLabel
  }()

  lazy var surfaceAreaLabel: UILabel = {
    let surfaceAreaLabel = UILabel(frame: CGRect.zero)
    surfaceAreaLabel.font = UIFont.systemFont(ofSize: 14)
    surfaceAreaLabel.textColor = AppColor.TextColors.DarkGray
    surfaceAreaLabel.translatesAutoresizingMaskIntoConstraints = false
    return surfaceAreaLabel
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(plotNameLabel)
    contentView.addSubview(surfaceAreaLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      plotNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      plotNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      surfaceAreaLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      surfaceAreaLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      plotNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: surfaceAreaLabel.leadingAnchor, constant: -15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
