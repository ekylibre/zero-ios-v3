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

  func storeSampleSeed(indexPath: IndexPath) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let seeds = NSEntityDescription.entity(forEntityName: "Seeds", in: managedContext)!
    let seed = NSManagedObject(entity: seeds, insertInto: managedContext)

    seed.setValue("Aubergine", forKey: "specie")
    seed.setValue("Marfa", forKey: "variety")
    seed.setValue("kg/ha", forKey: "unit")
    seed.setValue(false, forKey: "used")
    seed.setValue(false, forKey: "registered")

    do {
      try managedContext.save()
      createdSeed.append(seed)
    } catch {
      print("Unable to save managed context object.")
    }
  }

  func saveSelectedSeed(indexPath: IndexPath, seed: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let selectedSeeds = NSEntityDescription.entity(forEntityName: "InterventionSeeds", in: managedContext)!
    let selectedSeed = NSManagedObject(entity: selectedSeeds, insertInto: managedContext)

    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let quantity = (cell.inputQuantity.text! as NSString).doubleValue
    let unit = cell.unitMeasureButton.titleLabel?.text

    selectedSeed.setValue(quantity, forKey: "quantity")
    selectedSeed.setValue(unit, forKey: "unit")

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
    let selectedPhytos = NSEntityDescription.entity(forEntityName: "InterventionPhytosanitary", in: managedContext)!
    let selectedPhyto = NSManagedObject(entity: selectedPhytos, insertInto: managedContext)

    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let quantity = (cell.inputQuantity.text! as NSString).doubleValue
    let unit = cell.unitMeasureButton.titleLabel?.text

    selectedPhyto.setValue(quantity, forKey: "quantity")
    selectedPhyto.setValue(unit, forKey: "unit")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func removeInputCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(
      title: "",
      message: String(format: "are_you_sure_you_want_to_delete".localized, "input".localized),
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "no".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { (action: UIAlertAction!) in
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

  func forTrailingZero(temp: Double) -> String {
    let withoutTrailing = String(format: "%g", temp)

    return withoutTrailing
  }

  func defineQuantityInFunctionOfSurface(unit: String, quantity: Double, indexPath: IndexPath) {
    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let surfaceArea = cropsView.totalSurfaceArea
    var efficiency: Double = 0

    if (unit.contains("/")) {
      let surfaceUnit = unit.components(separatedBy: "/")[1]
      switch surfaceUnit {
      case "ha":
        efficiency = Double(quantity) * surfaceArea
      case "m2":
        efficiency = Double(quantity) * (surfaceArea * 10000)
      default:
        return
      }
      let efficiencyWithoutTrailing = forTrailingZero(temp: efficiency)
      cell.surfaceQuantity.text = String(format: "or".localized, efficiencyWithoutTrailing, (unit.components(separatedBy: "/")[0]))
    } else {
      efficiency = Double(quantity) / surfaceArea
      let efficiencyWithoutTrailing = forTrailingZero(temp: efficiency)
      cell.surfaceQuantity.text = String(format: "or_per_hectare".localized, efficiencyWithoutTrailing, unit)
    }
    cell.surfaceQuantity.textColor = AppColor.TextColors.DarkGray
  }

  func updateInputQuantity(indexPath: IndexPath) {
    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let quantity = (cell.inputQuantity.text! as NSString).doubleValue
    let unit = cell.unitMeasureButton.titleLabel?.text

    cell.surfaceQuantity.isHidden = false
    if quantity == 0.0 {
      cell.surfaceQuantity.text = String(format: "quantity_cant_be_nul".localized, (cell.type == "Phyto" ? "volume".localized : "mass".localized))
      cell.surfaceQuantity.textColor = AppColor.TextColors.Red
    } else if totalLabel.text == "select".localized {
      cell.surfaceQuantity.text = "no_crop_selected".localized
      cell.surfaceQuantity.textColor = AppColor.TextColors.Red
    } else {
      defineQuantityInFunctionOfSurface(unit: unit!, quantity: quantity, indexPath: indexPath)
    }
  }

  func updateAllInputQuantity() {
    let totalCellNumber = selectedInputs.count
    var indexPath: IndexPath!

    if totalCellNumber > 0 {
      for currentCell in 0..<(totalCellNumber) {
        indexPath = NSIndexPath(row: currentCell, section: 0) as IndexPath?
        updateInputQuantity(indexPath: indexPath)
      }
    }
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
