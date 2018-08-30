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

  func changeEquipmentViewAndTableViewSize() {
    equipmentTableViewHeightConstraint.constant = selectedEquipmentsTableView.contentSize.height
    equipmentHeightConstraint.constant = equipmentTableViewHeightConstraint.constant + 100
  }

  func removeEquipmentCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(title: "", message: "Êtes-vous sûr de vouloir supprimer l'outil ?", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
      let row = self.selectedEquipments[indexPath.row].value(forKey: "row") as! Int
      let indexTab = NSIndexPath(row: row, section: 0)
      let cell = self.equipmentsTableView.cellForRow(at: indexTab as IndexPath) as! EquipmentCell

      cell.isAlreadySelected = false
      cell.backgroundColor = AppColor.CellColors.white

      self.selectedEquipments.remove(at: indexPath.row)

      if self.selectedEquipments.count == 0 {
        self.selectedEquipmentsTableView.isHidden = true
        self.equipmentHeightConstraint.constant = 70
        self.collapseButton.isHidden = true
      } else {
        self.changeEquipmentViewAndTableViewSize()
        self.showEquipmentsNumber()
      }
      self.selectedEquipmentsTableView.reloadData()
    }))
    self.present(alert, animated: true)
  }

  func defineEquipmentTypes() {
    equipmentTypes = [
      "Semoir monograines",
      "Presse enrubanneuse",
      "Castreuse",
      "Presse balle cubique",
      "Déchaumeur à disques",
      "Plateau",
      "Ensileuse",
      "Broyeur",
      "Herse",
      "Arracheuse",
      "Andaineur",
      "Butteuse",
      "Bineuse",
      "Désherbineuse",
      "Planteuse",
      "Tonne à lisier",
      "Faucheuse",
      "Faucheuse conditioneuse",
      "Charrue",
      "Moissonneuse-batteuse",
      "Rouleau",
      "Houe rotative",
      "Presse balle ronde",
      "Outil de préparation du lit de semences",
      "Décompacteur",
      "Semoir",
      "Pulvérisateur",
      "Épandeur à engrais",
      "Épandeur à fumier",
      "Sous soleuse",
      "Déchaumeur",
      "Faneuse",
      "Effaneuse",
      "Tracteur",
      "Remorque",
      "Écimeuse",
      "Vibroculteur",
      "Désherbeur",
      "Enrubanneuse"]
  }

  func showEquipmentsNumber() {
    if selectedEquipments.count > 0 && firstView.frame.height == 70 {
      addEquipmentButton.isHidden = true
      equipmentNumberLabel.isHidden = false
      equipmentNumberLabel.text = (selectedEquipments.count == 1 ? "1 outil" : "\(selectedEquipments.count) outils")
    } else {
      addEquipmentButton.isHidden = false
      equipmentNumberLabel.isHidden = true
    }
  }

  @IBAction func openSelectEquipmentsView(_ sender: Any) {
    dimView.isHidden = false
    selectEquipmentsView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  func closeSelectEquipmentsView() {
    dimView.isHidden = true
    selectEquipmentsView.isHidden = true

    if selectedEquipments.count > 0 {
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
        self.view.layoutIfNeeded()
        self.collapseButton.isHidden = false
        self.selectedEquipmentsTableView.isHidden = false
        self.changeEquipmentViewAndTableViewSize()
        self.collapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
      })
    }
    searchedEquipments = equipments
    selectedEquipmentsTableView.reloadData()
  }

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
        self.changeEquipmentViewAndTableViewSize()
        self.collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
        self.view.layoutIfNeeded()
      })
    }
    showEquipmentsNumber()
  }

  @IBAction func openCreateEquipmentsView(_ sender: Any) {
    equipmentDarkLayer.isHidden = false
    createEquipmentsView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchedEntities = searchText.isEmpty ? entities : entities.filter({(filterEntity: NSManagedObject) -> Bool in
      let entityName: String = filterEntity.value(forKey: "firstName") as! String
      return entityName.range(of: searchText) != nil
    })
    searchedEquipments = searchText.isEmpty ? equipments : equipments.filter({(filterEquipment: NSManagedObject) -> Bool in
      let equipmentName: String = filterEquipment.value(forKey: "name") as! String
      return equipmentName.range(of: searchText) != nil
    })
    entitiesTableView.reloadData()
    equipmentsTableView.reloadData()
  }

  func fetchEquipments() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Equipments")

    do {
      equipments = try managedContext.fetch(equipmentsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    searchedEquipments = equipments
    equipmentsTableView.reloadData()
  }

  @IBAction func closeEquipmentsCreationView(_ sender: Any) {
    equipmentName.text = nil
    equipmentNumber.text = nil
    equipmentDarkLayer.isHidden = true
    createEquipmentsView.isHidden = true
    fetchEquipments()
  }

  @IBAction func createNewEquipement(_ sender: Any) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsEntity = NSEntityDescription.entity(forEntityName: "Equipments", in: managedContext)!
    let equipment = NSManagedObject(entity: equipmentsEntity, insertInto: managedContext)

    equipment.setValue(equipmentName.text, forKeyPath: "name")
    equipment.setValue(equipmentNumber.text, forKeyPath: "number")
    equipment.setValue(selectedEquipmentType, forKeyPath: "type")
    equipment.setValue(UUID(), forKey: "uuid")
    equipment.setValue(0, forKey: "row")
    do {
      try managedContext.save()
      equipments.append(equipment)
      closeEquipmentsCreationView(self)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}

extension AddInterventionViewController{
  func defineEquipmentImage(equipmentName: String) -> Int {
    switch equipmentName {
    case "Semoir monograines":
      return 0
    case "Presse enrubanneuse":
      return 1
    case "Castreuse":
      return 2
    case "Presse balle cubique":
      return 3
    case "Déchaumeur à disques":
      return 4
    case "Plateau":
      return 5
    case "Ensileuse":
      return 6
    case "Broyeur":
      return 7
    case "Herse":
      return 8
    case "Arracheuse":
      return 9
    case "Andaineur":
      return 10
    case "Butteuse":
      return 11
    case "Bineuse":
      return 12
    case "Désherbineuse":
      return 13
    case "Planteuse":
      return 14
    case "Tonne à lisier":
      return 15
    case "Faucheuse":
      return 16
    case "Faucheuse conditioneuse":
      return 17
    case "Charrue":
      return 18
    case "Moissonneuse-batteuse":
      return 19
    case "Rouleau":
      return 20
    case "Houe rotative":
      return 21
    case "Presse balle ronde":
      return 22
    case "Outil de préparation du lit de semances":
      return 23
    case "Décompacteur":
      return 24
    case "Semoir":
      return 25
    case "Pulvérisateur":
      return 26
    case "Épandeur à engrais":
      return 27
    case "Épandeur à fumier":
      return 28
    case "Sous soleuse":
      return 29
    case "Déchaumeur":
      return 30
    case "Faneuse":
      return 31
    case "Effaneuse":
      return 32
    case "Tracteur":
      return 33
    case "Remorque":
      return 34
    case "Écimeuse":
      return 35
    case "Vibroculteur":
      return 36
    case "Désherbeur":
      return 37
    case "Enrubanneuse":
      return 38
    default:
      return 0
    }
  }
}
