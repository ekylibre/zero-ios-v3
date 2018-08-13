//
//  AddInterventionTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 31/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class InterventionToolsTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var typeImageView: UIImageView!
}

protocol SelectedToolsTableViewCellDelegate: class {
  func removeCellButton(_ indexPath: Int)
}

class SelectedToolsTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var typeLabel: UILabel!
  @IBOutlet weak var typeImageView: UIImageView!
  @IBOutlet weak var deleteButton: UIButton!

  weak var cellDelegate: SelectedToolsTableViewCellDelegate?
  var indexPath: Int!

  @IBAction func buttonPressed(_ sender: UIButton) {
    cellDelegate?.removeCellButton(self.indexPath)
  }
}
