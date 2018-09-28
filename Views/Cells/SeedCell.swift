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

  lazy var starImageView: UIImageView = {
    let starImageView = UIImageView(frame: CGRect.zero)
    let starImage = #imageLiteral(resourceName: "star")
    let tintedImage = starImage.withRenderingMode(.alwaysTemplate)
    starImageView.image = tintedImage
    starImageView.tintColor = AppColor.BarColors.Green
    starImageView.translatesAutoresizingMaskIntoConstraints = false
    starImageView.isHidden = true
    return starImageView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    let selectedColor = UIView()

    selectedColor.backgroundColor = AppColor.CellColors.LightGray
    self.selectedBackgroundView = selectedColor
    contentView.addSubview(varietyLabel)
    contentView.addSubview(specieLabel)
    contentView.addSubview(starImageView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      varietyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      varietyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      specieLabel.topAnchor.constraint(equalTo: varietyLabel.bottomAnchor),
      specieLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      specieLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      starImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      starImageView.heightAnchor.constraint(equalToConstant: 20),
      starImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      starImageView.widthAnchor.constraint(equalToConstant: 20)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
