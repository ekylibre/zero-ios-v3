//
//  AddSelectedInputsToIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 23/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: SelectedInputsTableViewCellDelegate {
  func changeUnitMeasure(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
  }

  func removeInputsCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(title: "", message: "Êtes-vous sûr de vouloir supprimer l'intrant ?", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
      //self.selectedInputs.remove(at: indexPath.row)
      self.selectedInputsManagedObject.remove(at: indexPath.row)
      self.selectedInputsTableView.reloadData()

      if self.selectedInputsManagedObject.count > indexPath.row {
        let row = self.selectedInputsManagedObject[indexPath.row].value(forKey: "row") as! Int
        let indexTab = NSIndexPath(row: row, section: 0)
        let inputType = self.selectedInputsManagedObject[indexPath.row].value(forKey: "type") as! String
        switch inputType {
        case "Seed":
          let cell = self.specificInputsTableView.cellForRow(at: indexTab as IndexPath) as! SeedsTableViewCell

          cell.isAlreadySelected = false
          cell.backgroundColor = AppColor.CellColors.white
        case "Phyto":
          let cell = self.specificInputsTableView.cellForRow(at: indexTab as IndexPath) as! PhytosTableViewCell

          cell.isAlreadySelected = false
          cell.backgroundColor = AppColor.CellColors.white
        case "Fertilizer":
          let cell = self.specificInputsTableView.cellForRow(at: indexTab as IndexPath) as! FertilizersTableViewCell

          cell.isAlreadySelected = false
          cell.backgroundColor = AppColor.CellColors.white
        default:
          return
        }
      }
      //self.selectedInputsTableView.reloadData()
      if self.selectedInputsManagedObject.count == 0 && self.inputsSelectionView.frame.height != 70 {
        self.inputsHeightConstraint.constant = 70
        self.inputsCollapseButton.isHidden = true
      }
    }))
    self.present(alert, animated: true)
    changeInputsViewAndTableViewSize()
  }

  func changeInputsViewAndTableViewSize() {
    selectedInputsTableViewHeightConstraint.constant = selectedInputsTableView.contentSize.height
    inputsHeightConstraint.constant = selectedInputsTableViewHeightConstraint.constant + 100
  }

  func closeSelectInputsView() {
    dimView.isHidden = true
    inputsView.isHidden = true

    if selectedInputsManagedObject.count > 0 {
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
        self.view.layoutIfNeeded()
        self.inputsCollapseButton.isHidden = false
        self.selectedInputsTableView.isHidden = false
        self.changeInputsViewAndTableViewSize()
        self.inputsCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
      })
    }
    selectedInputsTableView.reloadData()
  }
  
  func showInputsNumber() {
    if selectedInputsManagedObject.count > 0 && inputsHeightConstraint.constant == 70 {
      addInputsButton.isHidden = true
      inputsNumber.text = (selectedInputsManagedObject.count == 1 ? "1 intrant" : "\(selectedInputsManagedObject.count) intrants")
      inputsNumber.isHidden = false
    } else {
      inputsNumber.isHidden = true
      addInputsButton.isHidden = false
    }
  }

  @IBAction func collapseInputsView(_ sender: Any) {
    if inputsHeightConstraint.constant != 70 {
      UIView.animate(withDuration: 0.5, animations: {
        self.selectedInputsTableView.isHidden = true
        self.inputsHeightConstraint.constant = 70
        self.inputsCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.view.layoutIfNeeded()
      })
    } else {
      UIView.animate(withDuration: 0.5, animations: {
        self.selectedInputsTableView.isHidden = false
        self.changeInputsViewAndTableViewSize()
        self.inputsCollapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
        self.view.layoutIfNeeded()
      })
    }
    showInputsNumber()
  }

  func storeSelectedInput(indexPath: IndexPath, inputType: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let inputsTable = NSEntityDescription.entity(forEntityName: "Inputs", in: managedContext)!
    let input = NSManagedObject(entity: inputsTable, insertInto: managedContext)
    var amm = ""
    var name = ""
    var specName = ""
    var time = ""

    switch inputType {
    case "Seed":
      let cell = specificInputsTableView.cellForRow(at: indexPath) as! SeedsTableViewCell

      name = cell.varietyLabel.text!
      specName = cell.specieLabel.text!
    case "Phyto":
      let cell = specificInputsTableView.cellForRow(at: indexPath) as! PhytosTableViewCell

      amm = cell.maaIDLabel.text!
      name = cell.nameLabel.text!
      specName = cell.firmNameLabel.text!
      time = cell.reentryLabel.text!
    case "Fertilizer":
      let cell = specificInputsTableView.cellForRow(at: indexPath) as! FertilizersTableViewCell

      name = cell.nameLabel.text!
      specName = cell.natureLabel.text!
    default:
      return
    }

    input.setValue(amm, forKey: "amm")
    input.setValue(indexPath.row, forKey: "row")
    input.setValue(name, forKey: "name")
    input.setValue(specName, forKey: "specName")
    input.setValue(time, forKey: "time")
    input.setValue(inputType, forKey: "type")
    selectedInputsManagedObject.append(input)
  }
}
