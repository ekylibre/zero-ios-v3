//
//  EntitiesTableViewCell.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 17/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class EntitiesTableViewCell: UITableViewCell {
  @IBOutlet weak var lastName: UILabel!
  @IBOutlet weak var firstName: UILabel!
  @IBOutlet weak var logo: UIImageView!

  var isAlreadySelected = false
}

protocol DoersTableViewCellDelegate: class {
  func removeDoersCell(_ indexPath: IndexPath)
  func updateDriverCell(_ indexPath: IndexPath, driver: UISwitch)
}

class DoersTableViewCell: UITableViewCell {
  @IBOutlet weak var lastName: UILabel!
  @IBOutlet weak var firstName: UILabel!
  @IBOutlet weak var logo: UIImageView!
  @IBOutlet weak var driver: UISwitch!

  weak var cellDelegate: DoersTableViewCellDelegate?
  var indexPath: IndexPath!

  @IBAction func removeCellButton(_ sender: UIButton) {
    cellDelegate?.removeDoersCell(self.indexPath)
  }

  @IBAction func updateDriverStatus(_ sender: UISwitch) {
    cellDelegate?.updateDriverCell(self.indexPath, driver: self.driver)
  }
}
