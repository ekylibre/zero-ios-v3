//
//  InterventionCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class InterventionCell: UITableViewCell {

  // MARK:- Properties

  lazy var typeImageView: UIImageView = {
    let typeImageView = UIImageView(frame: CGRect.zero)
    typeImageView.translatesAutoresizingMaskIntoConstraints = false
    return typeImageView
  }()

  lazy var typeLabel: UILabel = {
    let typeLabel = UILabel(frame: CGRect.zero)
    typeLabel.font = UIFont.boldSystemFont(ofSize: 14)
    typeLabel.textColor = AppColor.TextColors.Blue
    typeLabel.translatesAutoresizingMaskIntoConstraints = false
    return typeLabel
  }()

  lazy var stateImageView: UIImageView = {
    let stateImageView = UIImageView(frame: CGRect.zero)
    stateImageView.translatesAutoresizingMaskIntoConstraints = false
    return stateImageView
  }()

  lazy var dateLabel: UILabel = {
    let dateLabel = UILabel(frame: CGRect.zero)
    dateLabel.font = UIFont.systemFont(ofSize: 14)
    dateLabel.textColor = AppColor.TextColors.DarkGray
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    return dateLabel
  }()

  lazy var cropsLabel: UILabel = {
    let cropsLabel = UILabel(frame: CGRect.zero)
    cropsLabel.font = UIFont.systemFont(ofSize: 14)
    cropsLabel.textColor = AppColor.TextColors.DarkGray
    cropsLabel.translatesAutoresizingMaskIntoConstraints = false
    return cropsLabel
  }()

  lazy var notesLabel: UILabel = {
    let notesLabel = UILabel(frame: CGRect.zero)
    notesLabel.font = UIFont.systemFont(ofSize: 14)
    notesLabel.translatesAutoresizingMaskIntoConstraints = false
    return notesLabel
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(typeImageView)
    contentView.addSubview(typeLabel)
    contentView.addSubview(stateImageView)
    contentView.addSubview(dateLabel)
    contentView.addSubview(cropsLabel)
    contentView.addSubview(notesLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      typeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      typeImageView.heightAnchor.constraint(equalToConstant: 55),
      typeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      typeImageView.widthAnchor.constraint(equalToConstant: 55),
      typeLabel.topAnchor.constraint(equalTo: typeImageView.topAnchor),
      typeLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      stateImageView.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
      stateImageView.heightAnchor.constraint(equalToConstant: 20),
      stateImageView.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 10),
      stateImageView.widthAnchor.constraint(equalToConstant: 20),
      dateLabel.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
      dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      cropsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      cropsLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      notesLabel.bottomAnchor.constraint(equalTo: typeImageView.bottomAnchor),
      notesLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
