//
//  AddInterventionTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 31/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CropsTableViewCell: UITableViewCell {

  @IBOutlet weak var checkboxButton: UIButton!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var surfaceAreaLabel: UILabel!
  @IBOutlet weak var expandCollapseButton: UIButton!

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}

class InterventionToolsTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var typeImageView: UIImageView!
}
