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
    checkboxButton.setImage(#imageLiteral(resourceName: "check-box-blank"), for: .normal)
    checkboxButton.setImage(#imageLiteral(resourceName: "check-box"), for: .selected)
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
    expandCollapseImageView.image = #imageLiteral(resourceName: "expand-more")
    expandCollapseImageView.translatesAutoresizingMaskIntoConstraints = false
    return expandCollapseImageView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    self.clipsToBounds = true
    contentView.addSubview(checkboxButton)
    contentView.addSubview(nameLabel)
    contentView.addSubview(surfaceAreaLabel)
    contentView.addSubview(expandCollapseImageView)
    self.selectionStyle = .none
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      checkboxButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
      checkboxButton.heightAnchor.constraint(equalToConstant: 20),
      checkboxButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
      checkboxButton.widthAnchor.constraint(equalToConstant: 20),
      nameLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 15),
      surfaceAreaLabel.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
      surfaceAreaLabel.trailingAnchor.constraint(equalTo: expandCollapseImageView.leadingAnchor, constant: -25),
      expandCollapseImageView.centerYAnchor.constraint(equalTo: checkboxButton.centerYAnchor),
      expandCollapseImageView.heightAnchor.constraint(equalToConstant: 24),
      expandCollapseImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      expandCollapseImageView.widthAnchor.constraint(equalToConstant: 24)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
  }
}
