//
//  PlotCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 31/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class PlotCell: UITableViewCell {

  lazy var checkboxButton: UIButton = {
    let checkboxButton = UIButton(frame: CGRect.zero)
    checkboxButton.setImage(UIImage(named: "unchecked-checkbox"), for: .normal)
    checkboxButton.setImage(UIImage(named: "checked-checkbox"), for: .selected)
    checkboxButton.translatesAutoresizingMaskIntoConstraints = false
    return checkboxButton
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.systemFont(ofSize: 15)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var surfaceAreaLabel: UILabel = {
    let surfaceAreaLabel = UILabel(frame: CGRect.zero)
    surfaceAreaLabel.font = UIFont.systemFont(ofSize: 15)
    surfaceAreaLabel.translatesAutoresizingMaskIntoConstraints = false
    return surfaceAreaLabel
  }()

  lazy var expandCollapseImageView: UIImageView = {
    let expandCollapseImageView = UIImageView(frame: CGRect.zero)
    expandCollapseImageView.image = UIImage(named: "expand-more")
    expandCollapseImageView.translatesAutoresizingMaskIntoConstraints = false
    return expandCollapseImageView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    clipsToBounds = true
    selectionStyle = .none
    contentView.addSubview(checkboxButton)
    contentView.addSubview(nameLabel)
    contentView.addSubview(surfaceAreaLabel)
    contentView.addSubview(expandCollapseImageView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      checkboxButton.topAnchor.constraint(equalTo: topAnchor, constant: 17.5),
      checkboxButton.heightAnchor.constraint(equalToConstant: 25),
      checkboxButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.5),
      checkboxButton.widthAnchor.constraint(equalToConstant: 25),
      nameLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 15),
      surfaceAreaLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
      surfaceAreaLabel.trailingAnchor.constraint(equalTo: expandCollapseImageView.leadingAnchor, constant: -25),
      expandCollapseImageView.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
      expandCollapseImageView.heightAnchor.constraint(equalToConstant: 16),
      expandCollapseImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      expandCollapseImageView.widthAnchor.constraint(equalToConstant: 16)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
  }
}
