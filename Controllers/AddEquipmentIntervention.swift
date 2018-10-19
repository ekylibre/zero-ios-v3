//
//  AddEquipmentIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: SelectedEquipmentCellDelegate {

  // MARK: - Initialization

  func loadEquipmentTypes() -> [String] {
    var equipmentType = [String]()

    if let asset = NSDataAsset(name: "equipment-types") {
      do {
        let jsonResult = try JSONSerialization.jsonObject(with: asset.data)
        let registeredEquipments = jsonResult as? [[String: Any]]

        for registeredEquipment in registeredEquipments! {
          let type = registeredEquipment["nature"] as! String
          equipmentType.append(type.uppercased())
        }
      } catch {
        print("Lexicon error")
      }
    } else {
      print("equipment-types.json not found")
    }
    return equipmentType.sorted()
  }

  func defineEquipmentTypes() -> [String] {
    var types = loadEquipmentTypes()

    types = types.sorted(by: {
      $0.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        <
      $1.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
    })
    return types
  }

  func defineEquipmentImage(type: String) -> UIImage? {
    let assetName = type.lowercased().replacingOccurrences(of: "_", with: "-")

    return UIImage(named: assetName)
  }

  // MARK: - Actions

  @IBAction func collapseEquipmentView(_ send: Any) {
    if equipmentHeightConstraint.constant != 70 {
      UIView.animate(withDuration: 0.5, animations: {
        self.selectedEquipmentsTableView.isHidden = true
        self.equipmentHeightConstraint.constant = 70
        self.collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.view.layoutIfNeeded()
      })
    } else {
      UIView.animate(withDuration: 0.5, animations: {
        self.selectedEquipmentsTableView.isHidden = false
        self.resizeViewAndTableView(
          viewHeightConstraint: self.equipmentHeightConstraint,
          tableViewHeightConstraint: self.equipmentTableViewHeightConstraint,
          tableView: self.selectedEquipmentsTableView)
        self.collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
        self.view.layoutIfNeeded()
      })
    }
    showEntitiesNumber(
      entities: selectedEquipments,
      constraint: equipmentHeightConstraint,
      numberLabel: equipmentNumberLabel,
      addEntityButton: addEquipmentButton)
  }


  @IBAction func openEquipmentsSelectionView(_ sender: Any) {
    dimView.isHidden = false
    selectEquipmentsView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
      self.view.layoutIfNeeded()
    })
  }

  @IBAction func closeEquipmentsSelectionView(_ sender: Any) {
    dimView.isHidden = true
    selectEquipmentsView.isHidden = true

    if selectedEquipments.count > 0 {
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
        self.collapseButton.isHidden = false
        self.selectedEquipmentsTableView.isHidden = false
        self.resizeViewAndTableView(
          viewHeightConstraint: self.equipmentHeightConstraint,
          tableViewHeightConstraint: self.equipmentTableViewHeightConstraint,
          tableView: self.selectedEquipmentsTableView)
        self.collapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
        self.view.layoutIfNeeded()
      })
    }
    searchedEquipments = equipments
    selectedEquipmentsTableView.reloadData()
  }

  @IBAction func openEquipmentsCreationView(_ sender: Any) {
    equipmentDarkLayer.isHidden = false
    createEquipmentsView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
      self.view.layoutIfNeeded()
    })
  }

  @IBAction func closeEquipmentsCreationView(_ sender: Any) {
    equipmentName.text = nil
    equipmentNumber.text = nil
    equipmentDarkLayer.isHidden = true
    createEquipmentsView.isHidden = true
    fetchEquipments()
    equipmentsTableView.reloadData()
  }

  func fetchEquipments() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsFetchRequest: NSFetchRequest<Equipments> = Equipments.fetchRequest()

    do {
      equipments = try managedContext.fetch(equipmentsFetchRequest)
      searchedEquipments = equipments
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  @IBAction func createNewEquipement(_ sender: Any) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipment = Equipments(context: managedContext)

    equipment.name = equipmentName.text
    equipment.number = equipmentNumber.text
    equipment.type = selectedEquipmentType

    do {
      let type = EquipmentTypeEnum(rawValue: "AIRPLANTER")!;              #warning("Wrong type passed")
      let ekyID = pushEquipment(type: type, name: equipmentName.text ?? "", number: equipmentNumber.text)
      equipment.setValue(ekyID, forKey: "ekyID")
      try managedContext.save()
      equipments.append(equipment)
      closeEquipmentsCreationView(self)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func pushEquipment(type: EquipmentTypeEnum, name: String, number: String?) -> Int32 {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let group = DispatchGroup()
    let mutation = PushEquipmentMutation(farmId: farmID, type: type, name: name, number: number)
    let _ = apollo.clearCache()

    group.enter()
    apollo.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print(error)
      } else if let resultError = result!.data!.createEquipment!.errors {
        print(resultError)
      } else {
        id = Int32(result!.data!.createEquipment!.equipment!.id)!
      }
      group.leave()
    })
    group.wait()
    return id
  }

  func removeEquipmentCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(
      title: "",
      message: "delete_equipment_prompt".localized,
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { (action: UIAlertAction!) in
      self.selectedEquipments.remove(at: indexPath.row)
      self.selectedEquipmentsTableView.reloadData()

      if self.selectedEquipments.count == 0 {
        self.selectedEquipmentsTableView.isHidden = true
        self.collapseButton.isHidden = true
        self.equipmentHeightConstraint.constant = 70
      } else {
        UIView.animate(withDuration: 0.5, animations: {
          self.resizeViewAndTableView(
            viewHeightConstraint: self.equipmentHeightConstraint,
            tableViewHeightConstraint: self.equipmentTableViewHeightConstraint,
            tableView: self.selectedEquipmentsTableView)
          self.view.layoutIfNeeded()
        })
      }
    }))
    self.present(alert, animated: true)
  }
}
