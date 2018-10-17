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

  func saveSelectedRow(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
  }

  @IBAction func collapseInputsView(_ sender: Any) {
    let shouldExpand = (inputsHeightConstraint.constant == 70)

    selectedInputsTableView.isHidden = !shouldExpand
    inputsCollapseButton.imageView!.transform = inputsCollapseButton.imageView!.transform.rotated(by: CGFloat.pi)
    view.layoutIfNeeded()

    if shouldExpand {
      resizeViewAndTableView(viewHeightConstraint: self.inputsHeightConstraint,
        tableViewHeightConstraint: self.selectedInputsTableViewHeightConstraint,
        tableView: self.selectedInputsTableView)
    } else {
      inputsHeightConstraint.constant = 70
    }
    showEntitiesNumber(entities: selectedInputs, constraint: inputsHeightConstraint,
      numberLabel: inputsNumber, addEntityButton: addInputsButton)
  }

  func closeInputsSelectionView() {
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })

    inputsView.isHidden = true
    dimView.isHidden = true

    if selectedInputs.count > 0 {
      inputsCollapseButton.isHidden = false
      selectedInputsTableView.isHidden = false
      resizeViewAndTableView(
        viewHeightConstraint: self.inputsHeightConstraint,
        tableViewHeightConstraint: self.selectedInputsTableViewHeightConstraint,
        tableView: self.selectedInputsTableView)
      inputsCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      view.layoutIfNeeded()
    }
    selectedInputsTableView.reloadData()
  }

  func selectInput(_ input: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    switch input {
    case let seed as Seeds:
      let selectedSeed = InterventionSeeds(context: managedContext)
      selectedSeed.unit = seed.unit
      selectedSeed.seeds = seed
      selectedInputs.append(selectedSeed)
    case let phyto as Phytos:
      let selectedPhyto = InterventionPhytosanitaries(context: managedContext)
      selectedPhyto.unit = phyto.unit
      selectedPhyto.phytos = phyto
      selectedInputs.append(selectedPhyto)
    case let fertilizer as Fertilizers:
      let selectedFertilizer = InterventionFertilizers(context: managedContext)
      selectedFertilizer.unit = fertilizer.unit
      selectedFertilizer.fertilizers = fertilizer
      selectedInputs.append(selectedFertilizer)
    default:
      fatalError("Input type not found")
    }

    selectedInputsTableView.reloadData()
    closeInputsSelectionView()
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
      message: "delete_input_prompt".localized,
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { (action: UIAlertAction!) in
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
    present(alert, animated: true)
  }

  func defineQuantityInFunctionOfSurface(unit: String, quantity: Float, indexPath: IndexPath) {
    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let surfaceArea = cropsView.selectedSurfaceArea
    var efficiency: Float = 0

    if (unit.contains("/")) {
      let surfaceUnit = unit.components(separatedBy: "/")[1]
      switch surfaceUnit {
      case "ha":
        efficiency = quantity * surfaceArea
      case "m²":
        efficiency = quantity * (surfaceArea * 10000)
      default:
        return
      }
      cell.surfaceQuantity.text = String(format: "input_quantity".localized, efficiency, (unit.components(separatedBy: "/")[0]))
    } else {
      efficiency = quantity / surfaceArea
      cell.surfaceQuantity.text = String(format: "input_quantity_per_surface".localized, efficiency, unit)
    }
    cell.surfaceQuantity.textColor = AppColor.TextColors.DarkGray
  }

  func updateInputQuantity(indexPath: IndexPath) {
    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let quantity = Float(cell.inputQuantity.text!)
    let unit = cell.unitMeasureButton.titleLabel?.text

    cell.surfaceQuantity.isHidden = false
    if quantity == 0 || quantity == nil {
      let error = (cell.type == "Phyto") ? "volume_cannot_be_null".localized : "quantity_cannot_be_null".localized
      cell.surfaceQuantity.text = error
      cell.surfaceQuantity.textColor = AppColor.TextColors.Red
    } else if totalLabel.text == "select_crops".localized.uppercased() {
      cell.surfaceQuantity.text = "no_crop_selected".localized
      cell.surfaceQuantity.textColor = AppColor.TextColors.Red
    } else {
      defineQuantityInFunctionOfSurface(unit: unit!.localized, quantity: quantity ?? 0, indexPath: indexPath)
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
