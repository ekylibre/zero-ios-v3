//
//  EntityCell.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 17/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class EntityCell: UITableViewCell {
  @IBOutlet weak var lastName: UILabel!
  @IBOutlet weak var firstName: UILabel!
  @IBOutlet weak var logo: UIImageView!

  var isAvaible = true
}

protocol DoerCellDelegate: class {
  func removeDoerCell(_ indexPath: IndexPath)
  func updateDriverStatus(_ indexPath: IndexPath, driver: UISwitch)
}

class DoerCell: UITableViewCell {
  @IBOutlet weak var lastName: UILabel!
  @IBOutlet weak var firstName: UILabel!
  @IBOutlet weak var logo: UIImageView!
  @IBOutlet weak var driver: UISwitch!

  weak var cellDelegate: DoerCellDelegate?
  var indexPath: IndexPath!

  @IBAction func removeCellButton(_ sender: UIButton) {
    cellDelegate?.removeDoerCell(self.indexPath)
  }

  @IBAction func updateDriverStatus(_ sender: UISwitch) {
    cellDelegate?.updateDriverStatus(self.indexPath, driver: self.driver)
  }
}
