//
//  CropCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 30/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CropCell: UITableViewCell {

  // MARK:- Properties

  lazy var plotNameLabel: UILabel = {
    let plotNameLabel = UILabel(frame: CGRect.zero)
    plotNameLabel.font = UIFont.systemFont(ofSize: 14)
    plotNameLabel.translatesAutoresizingMaskIntoConstraints = false
    return plotNameLabel
  }()

  lazy var distanceLabel: UILabel = {
    let distanceLabel = UILabel(frame: CGRect.zero)
    distanceLabel.font = UIFont.systemFont(ofSize: 14)
    distanceLabel.textColor = AppColor.TextColors.Green
    distanceLabel.isHidden = true
    distanceLabel.translatesAutoresizingMaskIntoConstraints = false
    return distanceLabel
  }()

  lazy var surfaceAreaLabel: UILabel = {
    let surfaceAreaLabel = UILabel(frame: CGRect.zero)
    surfaceAreaLabel.font = UIFont.systemFont(ofSize: 14)
    surfaceAreaLabel.textColor = AppColor.TextColors.DarkGray
    surfaceAreaLabel.translatesAutoresizingMaskIntoConstraints = false
    return surfaceAreaLabel
  }()

  lazy var interventionImageView: UIImageView = {
    let interventionImageView = UIImageView(frame: CGRect.zero)
    interventionImageView.isHidden = true
    interventionImageView.translatesAutoresizingMaskIntoConstraints = false
    return interventionImageView
  }()

  var interventionImageViews = [UIImageView]()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(plotNameLabel)
    contentView.addSubview(distanceLabel)
    contentView.addSubview(surfaceAreaLabel)
    contentView.addSubview(interventionImageView)
    interventionImageViews.append(interventionImageView)
    setupLayout()
    setupImageViews()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      plotNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      plotNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      distanceLabel.centerYAnchor.constraint(equalTo: plotNameLabel.centerYAnchor),
      distanceLabel.trailingAnchor.constraint(equalTo: surfaceAreaLabel.leadingAnchor, constant: -15),
      surfaceAreaLabel.centerYAnchor.constraint(equalTo: plotNameLabel.centerYAnchor),
      surfaceAreaLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      plotNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: surfaceAreaLabel.leadingAnchor, constant: -15),
      interventionImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      interventionImageView.heightAnchor.constraint(equalToConstant: 20),
      interventionImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      interventionImageView.widthAnchor.constraint(equalToConstant: 20)
      ])
  }

  private func setupImageViews() {
    var count = 1
    let maxImageViews = (Int(UIScreen.main.bounds.width) - 15) / 25

    while (count != maxImageViews) {
      let imageView = UIImageView(frame: CGRect.zero)
      imageView.isHidden = true
      imageView.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(imageView)

      NSLayoutConstraint.activate([
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        imageView.heightAnchor.constraint(equalToConstant: 20),
        imageView.leadingAnchor.constraint(equalTo: interventionImageViews[count - 1].trailingAnchor, constant: 5),
        imageView.widthAnchor.constraint(equalToConstant: 20),
        ])

      interventionImageViews.append(imageView)
      count += 1
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
