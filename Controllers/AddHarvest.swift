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
    setupHarvestPickerViewLayout()
    setupHarvestPickerViewActions()
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

    harvestUnitPickerView = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), unit)
    harvestUnitPickerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(harvestUnitPickerView)
  }

  func initHarvestNaturePickerView() {
    let unit = ["straw".localized, "seed".localized, "silaging".localized]

    harvestNaturePickerView = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), unit)
    harvestNaturePickerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(harvestNaturePickerView)
  }

  func setupHarvestPickerViewLayout() {
    NSLayoutConstraint.activate([
      harvestNaturePickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      harvestNaturePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      harvestNaturePickerView.widthAnchor.constraint(equalTo: view.widthAnchor),
      harvestNaturePickerView.heightAnchor.constraint(equalToConstant: 266),
      harvestUnitPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      harvestUnitPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      harvestUnitPickerView.widthAnchor.constraint(equalTo: view.widthAnchor),
      harvestUnitPickerView.heightAnchor.constraint(equalToConstant: 266)
      ])
  }

  func setupHarvestPickerViewActions() {
    harvestNaturePickerView.cancelButton.addTarget(self, action: #selector(cancelHarvestNaturePicking), for: .touchUpInside)
    harvestNaturePickerView.validateButton.addTarget(self, action: #selector(validateHarvestNaturePicking), for: .touchUpInside)
    harvestUnitPickerView.cancelButton.addTarget(self, action: #selector(cancelHarvestUnitPicking), for: .touchUpInside)
    harvestUnitPickerView.validateButton.addTarget(self, action: #selector(validateHarvestUnitPicking), for: .touchUpInside)
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
    do {
      try managedContext.save()
      harvests.append(harvest)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  @IBAction func changeHarvestNature(_ sender: UIButton) {
    dimView.isHidden = false
    harvestNaturePickerView.isHidden = false
  }

  @objc func cancelHarvestNaturePicking() {
    let selectedRow = harvestNaturePickerView.selectedRow

    harvestNaturePickerView.pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
    harvestNaturePickerView.isHidden = true
    dimView.isHidden = true
  }

  @objc func cancelHarvestUnitPicking() {
    let selectedRow = harvestNaturePickerView.selectedRow

    harvestUnitPickerView.pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
    harvestUnitPickerView.isHidden = true
    dimView.isHidden = true
  }

  @objc func validateHarvestNaturePicking() {
    let selectedRow = harvestNaturePickerView.pickerView.selectedRow(inComponent: 0)
    let unit = harvestNaturePickerView.values[selectedRow]

    for harvest in harvests {
      harvest.setValue(unit, forKey: "type")
    }
    harvestType.setTitle(unit, for: .normal)
    harvestNaturePickerView.selectedRow = selectedRow
    harvestNaturePickerView.isHidden = true
    dimView.isHidden = true
  }

  @objc func validateHarvestUnitPicking() {
    let selectedRow = harvestUnitPickerView.pickerView.selectedRow(inComponent: 0)
    let unit = harvestUnitPickerView.values[selectedRow]

    harvests[cellIndexPath.row].setValue(unit, forKey: "unit")
    harvestUnitPickerView.selectedRow = selectedRow
    harvestUnitPickerView.isHidden = true
    dimView.isHidden = true
    harvestTableView.reloadData()
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
