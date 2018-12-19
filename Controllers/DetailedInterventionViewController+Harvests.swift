//
//  DetailedInterventionViewController+Harvests.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 12/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: LoadCellDelegate {

  // MARK: - Initialization

  func setupHarvestView() {
    let fetchedStorages = fetchStorages(predicate: nil)

    fetchedStorages != nil ? storages = fetchedStorages! : nil
    harvestSelectedType = "GRAIN"
    harvestNatureButton.setTitle(harvestNatureButton.titleLabel?.text!.localized, for: .normal)
    harvestNatureButton.layer.borderWidth = 0.5
    harvestNatureButton.layer.borderColor = UIColor.lightGray.cgColor
    harvestNatureButton.layer.cornerRadius = 5
    harvestTapGesture.delegate = self
    initializeHarvestTableView()
    setupStorageCreationView()
  }

  private func initializeHarvestTableView() {
    loadsTableView.layer.borderWidth  = 0.5
    loadsTableView.layer.borderColor = UIColor.lightGray.cgColor
    loadsTableView.layer.cornerRadius = 5
    loadsTableView.register(LoadCell.self, forCellReuseIdentifier: "LoadCell")
    loadsTableView.bounces = false
    loadsTableView.dataSource = self
    loadsTableView.delegate = self
  }

  private func setupStorageCreationView() {
    storageCreationView = StorageCreationView(frame: CGRect.zero)
    storageCreationView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(storageCreationView)

    NSLayoutConstraint.activate([
      storageCreationView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      storageCreationView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      storageCreationView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -30),
      storageCreationView.heightAnchor.constraint(equalToConstant: 250)
      ])
    storageCreationView.selectedType = "BUILDING"
    storageCreationView.createButton.addTarget(self, action: #selector(createNewStorage), for: .touchUpInside)
    storageCreationView.cancelButton.addTarget(self, action: #selector(cancelStorageCreation), for: .touchUpInside)
    storageCreationView.typeButton.addTarget(self, action: #selector(showStorageTypes), for: .touchUpInside)
  }

  // MARK: - Actions

  @IBAction func tapHarvestView() {
    let shouldExpand = (harvestViewHeightConstraint.constant == 70)
    let tableViewHeight = (selectedHarvests.count > 10) ? 10 * 125 : selectedHarvests.count * 125

    if selectedHarvests.count == 0 {
      return
    }

    if interventionState != InterventionState.Validated.rawValue {
      loadsAddButton.isHidden = !shouldExpand
    }
    view.endEditing(true)
    updateHarvestCountLabel()
    harvestNatureButton.isHidden = !shouldExpand
    loadsTableView.isHidden = !shouldExpand
    loadsCountLabel.isHidden = shouldExpand
    harvestExpandImageView.isHidden = (selectedHarvests.count == 0)
    harvestExpandImageView.transform = harvestExpandImageView.transform.rotated(by: CGFloat.pi)
    harvestViewHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 130) : 70
    loadsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
  }

  private func updateHarvestCountLabel() {
    if selectedHarvests.count == 1 {
      loadsCountLabel.text = "load".localized
    } else if selectedHarvests.count > 1 {
      loadsCountLabel.text = String(format: "loads".localized, selectedHarvests.count)
    } else {
      loadsCountLabel.text = "none".localized
    }
  }

  private func checkStorageName() -> Bool {
    if storageCreationView.nameTextField.text!.isEmpty {
      storageCreationView.errorLabel.text = "storage_name_is_empty".localized
      storageCreationView.errorLabel.isHidden = false
      return false
    } else if storages.contains(where:
      { $0.name?.lowercased() == storageCreationView.nameTextField.text?.lowercased() }) {
      storageCreationView.errorLabel.text = "storage_name_not_available".localized
      storageCreationView.errorLabel.isHidden = false
      return false
    }
    return true
  }

  @objc private func cancelStorageCreation() {
    storageCreationView.typeButton.setTitle(storageCreationView.returnTypesInSortedOrder()[0], for: .normal)
    storageCreationView.nameTextField.text = nil
    dimView.isHidden = true
    storageCreationView.isHidden = true
    storageCreationView.errorLabel.isHidden = true
  }

  @objc private func createNewStorage() {
    if !checkStorageName() {
      return
    }

    storageCreationView.nameTextField.resignFirstResponder()
    createStorage(name: storageCreationView.nameTextField.text!, type: storageCreationView.selectedType!)
    cancelStorageCreation()
  }

  @objc private func showStorageTypes() {
    guard let selectedType = storageCreationView.typeButton.title(for: .normal) else { return }

    customPickerView.values = ["BUILDING", "HEAP", "SILO"]
    customPickerView.pickerView.reloadComponent(0)
    customPickerView.selectLastValue(selectedType)
    customPickerView.closure = { (_ value: String) in
      self.storageCreationView.typeButton.setTitle(value.localized, for: .normal)
      self.storageCreationView.selectedType = value
    }
    customPickerView.isHidden = false
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
      storagesNames.append("---")
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return storagesNames.sorted()
  }

  func createHarvest(_ storage: Storage?, _ type: String?, _ number: String?, _ unit: String?, _ quantity: Double?) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvest = Harvest(context: managedContext)

    harvest.storage = storage
    harvest.type = type
    harvest.number = number
    harvest.unit = (unit != nil ? unit : "QUINTAL")
    harvest.quantity = (quantity != nil ? quantity! : 0)
    selectedHarvests.append(harvest)
  }

  private func createStorage(name: String, type: String) {
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

  @IBAction private func changeHarvestNature(_ sender: UIButton) {
    guard let selectedNature = harvestNatureButton.title(for: .normal) else { return }

    customPickerView.values = ["GRAIN", "SILAGE", "STRAW"]
    customPickerView.pickerView.reloadComponent(0)
    customPickerView.selectLastValue(selectedNature)
    customPickerView.closure = { (_ value: String) in
      self.harvestNatureButton.setTitle(value.localized, for: .normal)
      self.harvestSelectedType = value
    }
    customPickerView.isHidden = false
  }

  func removeLoadCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(title: "delete_load_prompt".localized, message: nil, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { (action: UIAlertAction!) in
      self.selectedHarvests.remove(at: indexPath.row)
      self.loadsTableView.reloadData()
      if self.selectedHarvests.count == 0 {
        self.harvestExpandImageView.isHidden = true
        self.loadsTableView.isHidden = true
        self.harvestNatureButton.isHidden = true
        self.harvestViewHeightConstraint.constant = 70
      } else if self.selectedHarvests.count < 10 {
        self.loadsTableViewHeightConstraint.constant = self.loadsTableView.contentSize.height
        self.harvestViewHeightConstraint.constant = self.loadsTableViewHeightConstraint.constant + 130
        self.view.layoutIfNeeded()
      }
    }))
    present(alert, animated: true)
  }

  @IBAction private func addHarvest(_ sender: UIButton) {
    let isCollapsed = harvestViewHeightConstraint.constant == 70
    createHarvest(nil, nil, nil, nil, nil)
    if selectedHarvests.count > 0 {
      let tableViewHeight = (selectedHarvests.count > 10) ? 10 * 125 : selectedHarvests.count * 125

      isCollapsed ? harvestExpandImageView.transform = harvestExpandImageView.transform.rotated(by: CGFloat.pi) : nil
      harvestNatureButton.isHidden = false
      loadsTableView.isHidden = false
      loadsAddButton.isHidden = false
      loadsCountLabel.isHidden = true
      harvestExpandImageView.isHidden = false
      harvestViewHeightConstraint.constant = CGFloat(tableViewHeight + 130)
      loadsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
      view.layoutIfNeeded()
    }
    loadsTableView.reloadData()
  }

  func loadTableViewCellForRowAt(_ tableView: UITableView, _ indexPath: IndexPath) -> LoadCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LoadCell", for: indexPath) as! LoadCell
    let harvest = selectedHarvests[indexPath.row]
    let unit = harvest.unit

    if interventionState == InterventionState.Validated.rawValue {
      cell.quantityTextField.placeholder = String(format: "%g", harvest.quantity)
      cell.numberTextField.placeholder = harvest.number
    } else {
      cell.quantityTextField.text = harvest.quantity != 0 ? String(format: "%g", harvest.quantity) : nil
      cell.numberTextField.text = harvest.number
    }
    cell.addInterventionController = self
    cell.cellDelegate = self
    cell.indexPath = indexPath
    cell.unitButton.setTitle(unit?.localized, for: .normal)
    cell.storageButton.setTitle(harvest.storage?.name ?? "---", for: .normal)
    return cell
  }
}
