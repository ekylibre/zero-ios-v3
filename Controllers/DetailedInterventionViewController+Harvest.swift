//
//  DetailedInterventionViewController+Harvest.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 12/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: HarvestCellDelegate {
  
  // MARK: - Initialization

  func initHarvestView() {
    let fetchedStorages = fetchStorages(predicate: nil)

    fetchedStorages != nil ? storages = fetchedStorages! : nil
    harvestSelectedType = "STRAW"
    harvestType.setTitle(harvestType.titleLabel?.text!.localized, for: .normal)
    harvestType.layer.borderColor = AppColor.CellColors.LightGray.cgColor
    harvestType.layer.borderWidth = 1
    harvestType.layer.cornerRadius = 5
    initializeHarvestTableView()
    initHarvestNaturePickerView()
    initHarvestUnitPickerView()
    initStoragesPickerView()
    setupStorageCreationView()
    initStoragesTypesPickerView()
  }

  func defineUnit(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
    dimView.isHidden = false
    harvestUnitPickerView.isHidden = false
  }

  func defineStorage(_ indexPath: IndexPath) {
    if storages.count > 0 {
      cellIndexPath = indexPath
      dimView.isHidden = false
      storagesPickerView.isHidden = false
    }
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

  func initStoragesTypesPickerView() {
    let types = ["BUILDING", "HEAP", "SILO"]

    storagesTypes = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), types, superview: view)
    storagesTypes.reference = self
    storagesTypes.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(storagesTypes)
  }

  func setupStorageCreationView() {
    storageCreationView = StorageCreationView(frame: CGRect.zero)
    storageCreationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(storageCreationView)

    NSLayoutConstraint.activate([
      storageCreationView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      storageCreationView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      storageCreationView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -30),
      storageCreationView.heightAnchor.constraint(equalToConstant: 300)
      ])
    storageCreationView.selectedType = "BUILDING"
    storageCreationView.createButton.addTarget(self, action: #selector(createNewStorage), for: .touchUpInside)
    storageCreationView.cancelButton.addTarget(self, action: #selector(cancelStorageCreation), for: .touchUpInside)
    storageCreationView.typeButton.addTarget(self, action: #selector(showStorageTypes), for: .touchUpInside)
  }


  // MARK: - Actions

  @IBAction func tapHarvestView() {
    let shouldExpand = (harvestViewHeightConstraint.constant == 70)
    let tableViewHeight = (harvests.count > 10) ? 10 * 150 : harvests.count * 150

    if harvests.count == 0 {
      return
    }

    updateHarvestCountLabel()
    harvestNature.isHidden = !shouldExpand
    harvestType.isHidden = !shouldExpand
    harvestTableView.isHidden = !shouldExpand
    harvestAddButton.isHidden = !shouldExpand
    harvestCountLabel.isHidden = shouldExpand
    harvestTableView.isHidden = !shouldExpand
    harvestExpandImageView.isHidden = (harvests.count == 0)
    harvestExpandImageView.transform = harvestExpandImageView.transform.rotated(by: CGFloat.pi)
    harvestViewHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 125) : 70
    harvestTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
  }

  private func updateHarvestCountLabel() {
    if harvests.count == 1 {
      harvestCountLabel.text = "load".localized
    } else if harvests.count > 1 {
      harvestCountLabel.text = String(format: "loads".localized, harvests.count)
    } else {
      harvestCountLabel.text = "none".localized
    }
  }

  private func checkStorageName() -> Bool {
    if storageCreationView.nameTextField.text!.isEmpty {
      storageCreationView.errorLabel.text = "storage_name_is_empty".localized
      storageCreationView.errorLabel.isHidden = false
      return false
    } else if storages.contains(where: { $0.name?.lowercased() == storageCreationView.nameTextField.text?.lowercased() }) {
      storageCreationView.errorLabel.text = "storage_name_not_available".localized
      storageCreationView.errorLabel.isHidden = false
      return false
    }
    return true
  }

  @objc func cancelStorageCreation(_ sender: Any) {
    storageCreationView.typeButton.setTitle(storageCreationView.returnTypesInSortedOrder()[0], for: .normal)
    storageCreationView.nameTextField.text = ""
    dimView.isHidden = true
    storageCreationView.isHidden = true
  }

  @objc func createNewStorage(_ sender: Any) {
    if !checkStorageName() {
      return
    }

    storageCreationView.nameTextField.resignFirstResponder()
    createStorage(name: storageCreationView.nameTextField.text!, type: storageCreationView.selectedType!)
    let storages = fetchStoragesName()

    storagesPickerView.values = (storages != nil ? storages! : ["---"])
    storagesPickerView.reloadComponent(0)
    cancelStorageCreation(self)
  }

  @objc func showStorageTypes(_ sender: Any) {
    storagesTypes.isHidden = false
  }

  func fetchStorages(predicate: NSPredicate?) -> [Storage]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let storagesFetchRequest: NSFetchRequest<Storage> = Storage.fetchRequest()

    storagesFetchRequest.predicate = predicate
    do {
      let storages = try managedContext.fetch(storagesFetchRequest)
      return storages
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
    let storagesFetchRequest: NSFetchRequest<Storage> = Storage.fetchRequest()
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

  func createHarvest() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvest = Harvest(context: managedContext)

    harvest.number = nil
    harvest.quantity = 0
    harvest.type = nil
    harvest.unit = "QUINTAL"
    harvests.append(harvest)
  }

  func createStorage(name: String, type: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let storage = Storage(context: managedContext)

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
        self.harvestExpandImageView.isHidden = true
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
    if harvests.count > 0 {
      let tableViewHeight = (harvests.count > 10) ? 10 * 150 : harvests.count * 150

      harvestNature.isHidden = false
      harvestType.isHidden = false
      harvestTableView.isHidden = false
      harvestAddButton.isHidden = false
      harvestCountLabel.isHidden = true
      harvestTableView.isHidden = false
      harvestExpandImageView.isHidden = false
      harvestViewHeightConstraint.constant = CGFloat(tableViewHeight + 125)
      harvestTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
      view.layoutIfNeeded()
    }
    harvestTableView.reloadData()
  }
}
