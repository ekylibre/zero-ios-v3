//
//  EquipmentCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 31/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class EquipmentCell: UITableViewCell {

  // MARK: - Properties

  lazy var typeImageView: UIImageView = {
    let typeImageView = UIImageView(frame: CGRect.zero)
    typeImageView.tintColor = UIColor.darkGray
    typeImageView.translatesAutoresizingMaskIntoConstraints = false
    return typeImageView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var infosLabel: UILabel = {
    let infosLabel = UILabel(frame: CGRect.zero)
    infosLabel.font = UIFont.systemFont(ofSize: 14)
    infosLabel.textColor = AppColor.TextColors.DarkGray
    infosLabel.translatesAutoresizingMaskIntoConstraints = false
    return infosLabel
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(openEditionView))

    contentView.addSubview(typeImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(infosLabel)
    contentView.addGestureRecognizer(gesture)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      typeImageView.heightAnchor.constraint(equalToConstant: 35),
      typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      typeImageView.widthAnchor.constraint(equalTo: typeImageView.heightAnchor),
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      nameLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      infosLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
      infosLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      infosLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc private func openEditionView(_ sender: UILongPressGestureRecognizer) {
    guard let cell = sender.view?.superview else { return }
    guard let equipmentsView = cell.superview?.superview as? EquipmentsView else { return }

    equipmentsView.dimView.isHidden = false
    equipmentsView.editionView.isHidden = false
  }
}
