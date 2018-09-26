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

  func createSelectedInput(input: NSManagedObject, entityName: String, relationShip: String) -> NSManagedObject? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let selectedInputs = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
    let selectedInput = NSManagedObject(entity: selectedInputs, insertInto: managedContext)
    let unit = input.value(forKey: "unit")

    selectedInput.setValue(unit, forKey: "unit")
    selectedInput.setValue(input, forKey: relationShip)
    return selectedInput
  }

  func resetInputsUsedAttribute(index: Int) {
    switch selectedInputs[index] {
    case is InterventionSeeds:
      (selectedInputs[index] as! InterventionSeeds).seeds?.used = false
    case is InterventionPhytosanitaries:
      (selectedInputs[index] as! InterventionPhytosanitaries).phytos?.used = false
    case is InterventionFertilizers:
      (selectedInputs[index] as! InterventionFertilizers).fertilizers?.used = false
    default:
      return
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
      self.resetInputsUsedAttribute(index: indexPath.row)
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
