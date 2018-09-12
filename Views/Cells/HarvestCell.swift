//
//  HarvestCell.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 12/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

protocol HarvestCellDelegate: class {
  func removeHarvestCell(_ indexPath: IndexPath)
}

class HarvestCell: UITableViewCell {
  @IBOutlet weak var number: UITextField!
  @IBOutlet weak var quantity: UITextField!
  @IBOutlet weak var delete: UIButton!
  @IBOutlet weak var storage: UIButton!
  @IBOutlet weak var unit: UIButton!

  weak var cellDelegate: HarvestCellDelegate?
  var indexPath: IndexPath!

  @IBAction func removeCell(_ sender: UIButton) {
    cellDelegate?.removeHarvestCell(indexPath)
  }
}
