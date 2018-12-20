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

  lazy var editButton: UIButton = {
    let editButton = UIButton(frame: CGRect.zero)
    let image = UIImage(named: "edit")?.withRenderingMode(.alwaysTemplate)
    editButton.setImage(image, for: .normal)
    editButton.tintColor = UIColor.darkGray
    editButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    editButton.addTarget(self, action: #selector(openEditionView), for: .touchUpInside)
    editButton.translatesAutoresizingMaskIntoConstraints = false
    return editButton
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
    contentView.addSubview(typeImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(editButton)
    contentView.addSubview(infosLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      typeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      typeImageView.widthAnchor.constraint(equalToConstant: 35),
      typeImageView.heightAnchor.constraint(equalToConstant: 35),
      nameLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      nameLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -5),
      nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      editButton.widthAnchor.constraint(equalToConstant: 44),
      editButton.heightAnchor.constraint(equalToConstant: 44),
      infosLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      infosLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -5),
      infosLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc private func openEditionView(_ sender: UIButton) {
    guard let cell = sender.superview?.superview as? UITableViewCell else { return }
    guard let equipmentsView = cell.superview?.superview as? EquipmentsView else { return }

    equipmentsView.editionView.updateView(cell: cell)
    equipmentsView.dimView.isHidden = false
    equipmentsView.editionView.isHidden = false
  }
}
