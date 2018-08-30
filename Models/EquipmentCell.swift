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

protocol SelectedEquipmentCellDelegate: class {
  func removeEquipmentCell(_ indexPath: IndexPath)
}

class SelectedEquipmentCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var typeImageView: UIImageView!
  @IBOutlet weak var deleteButton: UIButton!

  weak var cellDelegate: SelectedEquipmentCellDelegate?
  var indexPath: IndexPath!

  @IBAction func buttonPressed(_ sender: UIButton) {
    cellDelegate?.removeEquipmentCell(self.indexPath)
  }
}

class EquipmentTypesCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
}
