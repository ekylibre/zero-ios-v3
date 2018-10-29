//
//  CropDetailedView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 29/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CropDetailedView: UIView {

  // MARK: - Properties

  lazy var headerView: UIView = {
    let headerView = UIView(frame: CGRect.zero)
    headerView.addSubview(nameLabel)
    headerView.addSubview(surfaceAreaLabel)
    headerView.addSubview(specieLabel)
    headerView.addSubview(dateLabel)
    headerView.addSubview(yieldLabel)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    return headerView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
    nameLabel.textColor = AppColor.TextColors.DarkGray
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var surfaceAreaLabel: UILabel = {
    let surfaceAreaLabel = UILabel(frame: CGRect.zero)
    surfaceAreaLabel.font = UIFont.systemFont(ofSize: 14)
    surfaceAreaLabel.textColor = AppColor.TextColors.DarkGray
    surfaceAreaLabel.translatesAutoresizingMaskIntoConstraints = false
    return surfaceAreaLabel
  }()

  lazy var specieLabel: UILabel = {
    let specieLabel = UILabel(frame: CGRect.zero)
    specieLabel.font = UIFont.systemFont(ofSize: 14)
    specieLabel.textColor = AppColor.TextColors.DarkGray
    specieLabel.translatesAutoresizingMaskIntoConstraints = false
    return specieLabel
  }()

  lazy var dateLabel: UILabel = {
    let dateLabel = UILabel(frame: CGRect.zero)
    dateLabel.font = UIFont.systemFont(ofSize: 14)
    dateLabel.textColor = AppColor.TextColors.DarkGray
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    return dateLabel
  }()

  lazy var yieldLabel: UILabel = {
    let yieldLabel = UILabel(frame: CGRect.zero)
    yieldLabel.font = UIFont.systemFont(ofSize: 14)
    yieldLabel.textColor = AppColor.TextColors.DarkGray
    yieldLabel.translatesAutoresizingMaskIntoConstraints = false
    return yieldLabel
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.isHidden = true
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.addSubview(headerView)
    self.addSubview(tableView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
      nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      surfaceAreaLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
      surfaceAreaLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
      specieLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
      specieLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      dateLabel.topAnchor.constraint(equalTo: specieLabel.bottomAnchor, constant: 10),
      dateLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      yieldLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
      yieldLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      headerView.topAnchor.constraint(equalTo: self.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 200),
      headerView.leftAnchor.constraint(equalTo: self.leftAnchor),
      headerView.rightAnchor.constraint(equalTo: self.rightAnchor),
      tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
