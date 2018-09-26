//
//  FertilizerCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class FertilizerCell: UITableViewCell {

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
    contentView.addSubview(nameLabel)
    contentView.addSubview(natureLabel)
    contentView.addSubview(starImageView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      natureLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
      natureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      natureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
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
