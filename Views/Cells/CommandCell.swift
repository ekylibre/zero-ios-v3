//
//  CommandCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 03/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CommandCell: UITableViewCell {

  lazy var commandImageView: UIImageView = {
    let commandImageView = UIImageView(frame: CGRect.zero)
    commandImageView.tintColor = UIColor.darkGray
    commandImageView.translatesAutoresizingMaskIntoConstraints = false
    return commandImageView
  }()

  lazy var commandLabel: UILabel = {
    let commandLabel = UILabel(frame: CGRect.zero)
    commandLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    commandLabel.translatesAutoresizingMaskIntoConstraints = false
    return commandLabel
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(commandImageView)
    contentView.addSubview(commandLabel)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      commandImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      commandImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      commandImageView.widthAnchor.constraint(equalToConstant: 32),
      commandImageView.heightAnchor.constraint(equalToConstant: 32),
      commandLabel.leadingAnchor.constraint(equalTo: commandImageView.trailingAnchor, constant: 10),
      commandLabel.centerYAnchor.constraint(equalTo: commandImageView.centerYAnchor)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
