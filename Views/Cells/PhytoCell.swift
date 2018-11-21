//
//  PhytoCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class PhytoCell: UITableViewCell {

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var firmNameLabel: UILabel = {
    let firmNameLabel = UILabel(frame: CGRect.zero)
    firmNameLabel.font = UIFont.systemFont(ofSize: 14)
    firmNameLabel.textColor = AppColor.TextColors.Green
    firmNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return firmNameLabel
  }()

  lazy var unauthorizedMixingImage: UIImageView = {
    let unauthorizedMixingImage = UIImageView(frame: CGRect.zero)
    let warningImage = UIImage(named: "warning")?.withRenderingMode(.alwaysTemplate)
    unauthorizedMixingImage.image = warningImage
    unauthorizedMixingImage.tintColor = .red
    unauthorizedMixingImage.isHidden = true
    unauthorizedMixingImage.translatesAutoresizingMaskIntoConstraints = false
    return unauthorizedMixingImage
  }()

  lazy var unauthorizedMixingLabel: UILabel = {
    let unauthorizedMixingLabel = UILabel(frame: CGRect.zero)
    unauthorizedMixingLabel.font = UIFont.systemFont(ofSize: 14)
    unauthorizedMixingLabel.textColor = .red
    unauthorizedMixingLabel.text = "unauthorized_mixing".localized
    unauthorizedMixingLabel.isHidden = true
    unauthorizedMixingLabel.translatesAutoresizingMaskIntoConstraints = false
    return unauthorizedMixingLabel
  }()

  lazy var maaLabel: UILabel = {
    let maaLabel = UILabel(frame: CGRect.zero)
    maaLabel.text = "mmaid_number".localized
    maaLabel.font = UIFont.italicSystemFont(ofSize: 14)
    maaLabel.textColor = AppColor.TextColors.DarkGray
    maaLabel.translatesAutoresizingMaskIntoConstraints = false
    return maaLabel
  }()

  lazy var maaIDLabel: UILabel = {
    let maaIDLabel = UILabel(frame: CGRect.zero)
    maaIDLabel.font = UIFont.systemFont(ofSize: 14)
    maaIDLabel.translatesAutoresizingMaskIntoConstraints = false
    return maaIDLabel
  }()

  lazy var reentryLabel: UILabel = {
    let reentryLabel = UILabel(frame: CGRect.zero)
    reentryLabel.text = "reentry_delay".localized
    reentryLabel.font = UIFont.italicSystemFont(ofSize: 14)
    reentryLabel.textColor = AppColor.TextColors.DarkGray
    reentryLabel.translatesAutoresizingMaskIntoConstraints = false
    return reentryLabel
  }()

  lazy var inFieldReentryDelayLabel: UILabel = {
    let inFieldReentryDelayLabel = UILabel(frame: CGRect.zero)
    inFieldReentryDelayLabel.font = UIFont.systemFont(ofSize: 14)
    inFieldReentryDelayLabel.translatesAutoresizingMaskIntoConstraints = false
    return inFieldReentryDelayLabel
  }()

  lazy var starImageView: UIImageView = {
    let starImageView = UIImageView(frame: CGRect.zero)
    let starImage = UIImage(named: "star")!
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
    contentView.addSubview(firmNameLabel)
    contentView.addSubview(unauthorizedMixingImage)
    contentView.addSubview(unauthorizedMixingLabel)
    contentView.addSubview(maaLabel)
    contentView.addSubview(maaIDLabel)
    contentView.addSubview(reentryLabel)
    contentView.addSubview(inFieldReentryDelayLabel)
    contentView.addSubview(starImageView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      firmNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
      firmNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      unauthorizedMixingImage.heightAnchor.constraint(equalToConstant: 15),
      unauthorizedMixingImage.widthAnchor.constraint(equalToConstant: 15),
      unauthorizedMixingImage.leadingAnchor.constraint(equalTo: firmNameLabel.leadingAnchor),
      unauthorizedMixingImage.topAnchor.constraint(equalTo: firmNameLabel.bottomAnchor),
      unauthorizedMixingLabel.centerYAnchor.constraint(equalTo: unauthorizedMixingImage.centerYAnchor),
      unauthorizedMixingLabel.leadingAnchor.constraint(equalTo: unauthorizedMixingImage.trailingAnchor, constant: 3),
      maaLabel.topAnchor.constraint(equalTo: unauthorizedMixingImage.bottomAnchor, constant: 5),
      maaLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      maaIDLabel.centerYAnchor.constraint(equalTo: maaLabel.centerYAnchor),
      maaIDLabel.leadingAnchor.constraint(equalTo: maaLabel.trailingAnchor, constant: 15),
      reentryLabel.topAnchor.constraint(equalTo: maaLabel.bottomAnchor),
      reentryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      inFieldReentryDelayLabel.topAnchor.constraint(equalTo: maaIDLabel.bottomAnchor),
      inFieldReentryDelayLabel.leadingAnchor.constraint(equalTo: reentryLabel.trailingAnchor, constant: 15),
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
