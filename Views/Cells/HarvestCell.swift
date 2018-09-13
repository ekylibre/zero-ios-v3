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
  func defineIndexPath(_ indexPath: IndexPath)
}

class HarvestCell: UITableViewCell, UITextFieldDelegate {
  @IBOutlet weak var number: UITextField!
  @IBOutlet weak var quantity: UITextField!
  @IBOutlet weak var delete: UIButton!
  @IBOutlet weak var storage: UIButton!
  @IBOutlet weak var unit: UIButton!

  weak var cellDelegate: HarvestCellDelegate?
  var addInterventionController: AddInterventionViewController?
  var indexPath: IndexPath!

  @IBAction func removeCell(_ sender: UIButton) {
    cellDelegate?.removeHarvestCell(indexPath)
  }

  @IBAction func defineSelectedCell(_ sender: Any) {
    cellDelegate?.defineIndexPath(indexPath)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    switch textField {
    case quantity:
      addInterventionController?.harvests[indexPath.row].setValue((quantity.text! as NSString).doubleValue, forKey: "quantity")
      return false
    case number:
      addInterventionController?.harvests[indexPath.row].setValue(number.text!, forKey: "number")
      return false
    default:
      return false
    }
  }
}
