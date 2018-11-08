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
  func defineUnit(_ indexPath: IndexPath)
  func defineStorage(_ indexPath: IndexPath)
}

class HarvestCell: UITableViewCell, UITextFieldDelegate {
  @IBOutlet weak var number: UITextField!
  @IBOutlet weak var quantity: UITextField!
  @IBOutlet weak var delete: UIButton!
  @IBOutlet weak var storage: UIButton!
  @IBOutlet weak var unit: UIButton!
  @IBOutlet weak var createStorage: UIButton!

  weak var cellDelegate: HarvestCellDelegate?
  var addInterventionController: AddInterventionViewController?
  var indexPath: IndexPath!

  @IBAction func removeCell(_ sender: UIButton) {
    cellDelegate?.removeHarvestCell(indexPath)
  }

  @IBAction func defineUnit(_ sender: Any) {
    cellDelegate?.defineUnit(indexPath)
  }

  @IBAction func defineStorage(_ sender: Any) {
    cellDelegate?.defineStorage(indexPath)
  }

  @IBAction func defineQuantity(_ sender: Any) {
    addInterventionController?.harvests[indexPath.row].quantity = (quantity.text! as NSString).doubleValue
  }

  @IBAction func defineNumber(_ sender: Any) {
    addInterventionController?.harvests[indexPath.row].number = number.text!
  }

  @IBAction func createStorage(_ sender: Any) {
    addInterventionController?.dimView.isHidden = false
    addInterventionController?.storageCreationView.isHidden = false
  }


  // MARK: - Text field

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    guard let oldText = textField.text, let r = Range(range, in: oldText) else {
      return true
    }

    if textField.keyboardType == .decimalPad {
      let newText = oldText.replacingCharacters(in: r, with: string)
      let isNumeric = newText.isEmpty || !newText.contains("0123456789.,")
      let numberOfDots = (newText.contains(",") ? newText.components(separatedBy: ",").count - 1 : newText.components(separatedBy: ".").count - 1)
      let numberOfDecimalDigits: Int

      if let dotIndex = (newText.contains(",") ? newText.index(of: ",") : newText.index(of: ".")) {
        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
      } else {
        numberOfDecimalDigits = 0
      }
      return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && newText.count <= 16
    }
    return oldText.replacingCharacters(in: r, with: string).count <= 500
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    switch textField {
    case quantity:
      defineQuantity(self)
      return false
    case number:
      defineNumber(self)
      return false
    default:
      return false
    }
  }
}
