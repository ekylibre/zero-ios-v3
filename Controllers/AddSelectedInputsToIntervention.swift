//
//  AddSelectedInputsToIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 23/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: SelectedInputCellDelegate {

  // MARK: - Actions

  func changeUnitMeasure(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
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
        self.resizeViewAndTableView(
          viewHeightConstraint: self.inputsHeightConstraint,
          tableViewHeightConstraint: self.selectedInputsTableViewHeightConstraint,
          tableView: self.selectedInputsTableView)
        self.inputsCollapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
        self.view.layoutIfNeeded()
      })
    }
    showEntitiesNumber(
      entities: selectedInputs,
      constraint: inputsHeightConstraint,
      numberLabel: inputsNumber,
      addEntityButton: addInputsButton)
  }

  func closeInputsSelectionView() {
    dimView.isHidden = true
    inputsView.isHidden = true

    if selectedInputs.count > 0 {
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
        self.inputsCollapseButton.isHidden = false
        self.selectedInputsTableView.isHidden = false
        self.resizeViewAndTableView(
          viewHeightConstraint: self.inputsHeightConstraint,
          tableViewHeightConstraint: self.selectedInputsTableViewHeightConstraint,
          tableView: self.selectedInputsTableView)
        self.inputsCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
        self.view.layoutIfNeeded()
      })
    }
    selectedInputsTableView.reloadData()
  }

  func saveSelectedSeed(indexPath: IndexPath, seed: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let selectedSeed = InterventionSeeds(context: managedContext)
    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let quantity = (cell.inputQuantity.text! as NSString).doubleValue
    let unit = cell.unitMeasureButton.titleLabel?.text

    selectedSeed.quantity = quantity
    selectedSeed.unit = unit

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func saveSelectedPhyto(indexPath: IndexPath, phyto: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let selectedPhyto = InterventionPhytosanitary(context: managedContext)
    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let quantity = (cell.inputQuantity.text! as NSString).doubleValue
    let unit = cell.unitMeasureButton.titleLabel?.text

    selectedPhyto.quantity = quantity
    selectedPhyto.unit = unit

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func removeInputCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(
      title: "",
      message: "Êtes-vous sûr de vouloir supprimer l'intrant ?",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
      self.selectedInputs.remove(at: indexPath.row)
      self.selectedInputsTableView.reloadData()
      if self.selectedInputs.count == 0 {
        self.selectedInputsTableView.isHidden = true
        self.inputsCollapseButton.isHidden = true
        self.inputsHeightConstraint.constant = 70
      } else {
        UIView.animate(withDuration: 0.5, animations: {
          self.resizeViewAndTableView(
            viewHeightConstraint: self.inputsHeightConstraint,
            tableViewHeightConstraint: self.selectedInputsTableViewHeightConstraint,
            tableView: self.selectedInputsTableView
          )
          self.view.layoutIfNeeded()
        })
      }
    }))
    self.present(alert, animated: true)
  }
}

// Begin unselection of cells in inputs table view (not working for now)

/*let type = self.selectedInputs[indexPath.row].value(forKey: "type") as! String
 let row = self.selectedInputs[indexPath.row].value(forKey: "row") as! Int
 let cellIndexPath = NSIndexPath(row: row, section: 0)

 switch type {
 case "Seed":
 let cell = self.inputsView.tableView.cellForRow(at: cellIndexPath as IndexPath) as! SeedCell

 cell.isAvaible = true
 cell.backgroundColor = AppColor.CellColors.white
 case "Phyto":
 let cell = self.inputsView.tableView.cellForRow(at: cellIndexPath as IndexPath) as! PhytoCell

 cell.isAvaible = true
 cell.backgroundColor = AppColor.CellColors.white
 case "Fertilizer":
 let cell = self.inputsView.tableView.cellForRow(at: cellIndexPath as IndexPath) as! FertilizerCell

 cell.isAvaible = true
 cell.backgroundColor = AppColor.CellColors.white
 default:
 print("No type")
 }*/
