//
//  EquipmentCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 31/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class EquipmentCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var typeImageView: UIImageView!

  var isAlreadySelected = false
}

protocol SelectedToolsTableViewCellDelegate: class {
  func removeToolsCell(_ indexPath: IndexPath)
}

class SelectedToolsTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var typeImageView: UIImageView!
  @IBOutlet weak var deleteButton: UIButton!

  weak var cellDelegate: SelectedToolsTableViewCellDelegate?
  var indexPath: IndexPath!

  @IBAction func buttonPressed(_ sender: UIButton) {
    cellDelegate?.removeToolsCell(self.indexPath)
  }
}

class EquipmentTypesCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
}
