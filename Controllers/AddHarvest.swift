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

  func defineUnit(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
    dimView.isHidden = false
    harvestUnitPickerView.isHidden = false
  }

  func defineStorage(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
    dimView.isHidden = false
    storagesPickerView.isHidden = false
  }

  func initHarvestView() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    if appDelegate.entityIsEmpty(entity: "Harvests") {
      createSampleStorage()
    }
    initializeHarvestTableView()
    initHarvestNaturePickerView()
    initHarvestUnitPickerView()
    initStoragesPickerView()
    harvestType.setTitle(harvestType.titleLabel?.text!.localized, for: .normal)
  }

  func initializeHarvestTableView() {
    harvestTableView.layer.borderWidth  = 0.5
    harvestTableView.layer.borderColor = UIColor.lightGray.cgColor
    harvestTableView.layer.cornerRadius = 4
    harvestTableView.dataSource = self
    harvestTableView.delegate = self
  }

  func initHarvestUnitPickerView () {
    let unit = ["QUINTAL", "TON", "KILOGRAM"]

    harvestUnitPickerView = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), unit, superview: view)
    harvestUnitPickerView.reference = self
    harvestUnitPickerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(harvestUnitPickerView)
  }

  func initHarvestNaturePickerView() {
    let unit = ["STRAW", "GRAIN", "SILAGE"]

    harvestNaturePickerView = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), unit, superview: view)
    harvestNaturePickerView.reference = self
    harvestNaturePickerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(harvestNaturePickerView)
  }

  func initStoragesPickerView() {
    let storages = fetchStoragesName()

    storagesPickerView = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), storages ?? ["---"], superview: view)
    storagesPickerView.reference = self
    storagesPickerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(storagesPickerView)
  }

  // MARK: - Actions

  func searchStorage(name: String) -> Storages? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    var storages: [Storages]
    let managedContext = appDelegate.persistentContainer.viewContext
    let storagesFetchRequest: NSFetchRequest<Storages> = Storages.fetchRequest()
    let predicate = NSPredicate(format: "name == %@", name)

    storagesFetchRequest.predicate = predicate

    do {
      storages = try managedContext.fetch(storagesFetchRequest)
      return storages.first
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  func fetchStoragesName() -> [String]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let storagesFetchRequest: NSFetchRequest<Storages> = Storages.fetchRequest()
    var storagesNames = [String]()

    do {
      let storages = try managedContext.fetch(storagesFetchRequest)

      for storage in storages {
        if storage.name != nil {
          storagesNames.append(storage.name!)
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return storagesNames
  }

  func createSampleStorage() {
    createStorage(name: "Silot 1", type: "silo")
    createStorage(name: "Bati 42", type: "building")
    createStorage(name: "bati simple", type: "building")
    createStorage(name: "bati silo", type: "silo")
  }

  func createHarvest() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvest = Harvests(context: managedContext)

    harvest.number = ""
    harvest.quantity = 0
    harvest.type = "STRAW"
    harvest.unit = "QUINTAL"
    harvests.append(harvest)
  }

  func createStorage(name: String, type: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let storage = Storages(context: managedContext)

    storage.name = name
    storage.type = type

    do {
      try managedContext.save()
      storages.append(storage)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  @IBAction func changeHarvestNature(_ sender: UIButton) {
    dimView.isHidden = false
    harvestNaturePickerView.isHidden = false
  }

  func removeHarvestCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(
      title: "",
      message: "delete_harvest_prompt".localized,
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
