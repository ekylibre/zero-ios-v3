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
    checkboxButton.setImage(#imageLiteral(resourceName: "uncheckedCheckbox"), for: .normal)
    checkboxButton.setImage(#imageLiteral(resourceName: "checkedCheckbox"), for: .selected)
    checkboxButton.translatesAutoresizingMaskIntoConstraints = false
    return checkboxButton
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.systemFont(ofSize: 13)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var surfaceAreaLabel: UILabel = {
    let surfaceAreaLabel = UILabel(frame: CGRect.zero)
    surfaceAreaLabel.font = UIFont.systemFont(ofSize: 13)
    surfaceAreaLabel.translatesAutoresizingMaskIntoConstraints = false
    return surfaceAreaLabel
  }()

  lazy var expandCollapseImageView: UIImageView = {
    let expandCollapseImageView = UIImageView(frame: CGRect.zero)
    expandCollapseImageView.image = #imageLiteral(resourceName: "expandCollapse")
    expandCollapseImageView.translatesAutoresizingMaskIntoConstraints = false
    return expandCollapseImageView
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(checkboxButton)
    contentView.addSubview(nameLabel)
    contentView.addSubview(surfaceAreaLabel)
    contentView.addSubview(expandCollapseImageView)
    setupLayout()
  }

  private func setupLayout() {
    let viewsDict = [
      "checkbox" : checkboxButton,
      "name" : nameLabel,
      "surface" : surfaceAreaLabel,
      "expand" : expandCollapseImageView,
      ] as [String : Any]

    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[checkbox(16)]-15-[name]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[surface]-30-[expand(16)]-15-|", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[checkbox(16)]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[name]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[surface]", options: [], metrics: nil, views: viewsDict))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[expand(16)]", options: [], metrics: nil, views: viewsDict))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
  }
}
