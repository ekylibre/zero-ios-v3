//
//  AddHarvest.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 12/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: HarvestCellDelegate {

  // MARK: - Initialization

  func defineIndexPath(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
    dimView.isHidden = false
    harvestUnitPickerView.isHidden = false
  }

  func initHarvestView() {
    initializeHarvestTableView()
    initHarvestNaturePickerView()
    initHarvestUnitPickerView()
  }

  func initializeHarvestTableView() {
    harvestTableView.layer.borderWidth  = 0.5
    harvestTableView.layer.borderColor = UIColor.lightGray.cgColor
    harvestTableView.layer.cornerRadius = 4
    harvestTableView.dataSource = self
    harvestTableView.delegate = self
    harvestTableView.bounces = false
  }

  func initHarvestUnitPickerView () {
    let unit = ["q", "t", "kg"]

    harvestUnitPickerView = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), unit, superview: view)
    harvestUnitPickerView.reference = self
    harvestUnitPickerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(harvestUnitPickerView)
  }

  func initHarvestNaturePickerView() {
    let unit = ["straw".localized, "seed".localized, "silaging".localized]

    harvestNaturePickerView = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), unit, superview: view)
    harvestNaturePickerView.reference = self
    harvestNaturePickerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(harvestNaturePickerView)
  }

  // MARK: - Actions

  func createHarvest() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvestsEntity = NSEntityDescription.entity(forEntityName: "Harvests", in: managedContext)!
    let harvest = NSManagedObject(entity: harvestsEntity, insertInto: managedContext)

    harvest.setValue("", forKey: "number")
    harvest.setValue(0, forKey: "quantity")
    harvest.setValue("straw", forKey: "type")
    harvest.setValue("q", forKey: "unit")
    harvests.append(harvest)
  }

  @IBAction func changeHarvestNature(_ sender: UIButton) {
    dimView.isHidden = false
    harvestNaturePickerView.isHidden = false
  }

  func removeHarvestCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(
      title: "",
      message: String(format: "are_you_sure_you_want_to_delete".localized, "shipment".localized),
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "no".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { (action: UIAlertAction!) in
      self.harvests.remove(at: indexPath.row)
      self.harvestTableView.reloadData()
      if self.harvests.count == 0 {
        self.harvestTableView.isHidden = true
        self.harvestType.isHidden = true
        self.harvestNature.isHidden = true
        self.harvestViewHeightConstraint.constant = 70
      } else if self.harvests.count < 4 {
        UIView.animate(withDuration: 0.5, animations: {
          self.harvestTableViewHeightConstraint.constant = self.harvestTableView.contentSize.height
          self.harvestViewHeightConstraint.constant = self.harvestTableViewHeightConstraint.constant + 125
          self.view.layoutIfNeeded()
        })
      }
    }))
    present(alert, animated: true)
  }

  @IBAction func addHarvest(_ sender: UIButton) {
    createHarvest()
    harvestNature.isHidden = false
    harvestType.isHidden = false
    harvestTableView.isHidden = false
    harvestTableView.reloadData()
    if harvests.count < 4 {
      harvestTableViewHeightConstraint.constant = harvestTableView.contentSize.height
      harvestViewHeightConstraint.constant = harvestTableViewHeightConstraint.constant + 125
    }
  }
}
