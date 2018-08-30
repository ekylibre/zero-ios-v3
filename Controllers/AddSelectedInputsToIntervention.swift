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
  func changeUnitMeasure(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
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
      if self.selectedInputs.count == 0 && self.inputsSelectionView.frame.height != 70 {
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

    if selectedInputs.count > 0 {
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
    if selectedInputs.count > 0 && inputsHeightConstraint.constant == 70 {
      addInputsButton.isHidden = true
      inputsNumber.text = (selectedInputs.count == 1 ? "1 intrant" : "\(selectedInputs.count) intrants")
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
}
