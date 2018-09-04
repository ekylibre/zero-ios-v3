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

  // MARK: - Action

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
    })
  }

  func closeEquipmentsSelectionView() {
    dimView.isHidden = true
    selectEquipmentsView.isHidden = true

    if selectedEquipments.count > 0 {
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
        self.view.layoutIfNeeded()
        self.collapseButton.isHidden = false
        self.selectedEquipmentsTableView.isHidden = false
        self.resizeViewAndTableView(
          viewHeightConstraint: self.equipmentHeightConstraint,
          tableViewHeightConstraint: self.equipmentTableViewHeightConstraint,
          tableView: self.selectedEquipmentsTableView)
        self.collapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
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
    })
  }

  @IBAction func closeEquipmentsCreationView(_ sender: Any) {
    equipmentName.text = nil
    equipmentNumber.text = nil
    equipmentDarkLayer.isHidden = true
    createEquipmentsView.isHidden = true
    fetchEntity(entityName: "Equipments", searchedEntity: &searchedEquipments, entity: &equipments)
    equipmentsTableView.reloadData()
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

  func removeEquipmentCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(
      title: "",
      message: "Êtes-vous sûr de vouloir supprimer l'outil ?",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
      let row = self.selectedEquipments[indexPath.row].value(forKey: "row") as! Int
      let indexTab = NSIndexPath(row: row, section: 0)
      let cell = self.equipmentsTableView.cellForRow(at: indexTab as IndexPath) as! EquipmentCell

      cell.isAvaible = true
      cell.backgroundColor = AppColor.CellColors.white

      self.selectedEquipments.remove(at: indexPath.row)

      if self.selectedEquipments.count == 0 {
        self.selectedEquipmentsTableView.isHidden = true
        self.equipmentHeightConstraint.constant = 70
        self.collapseButton.isHidden = true
      } else {
        self.resizeViewAndTableView(
          viewHeightConstraint: self.equipmentHeightConstraint,
          tableViewHeightConstraint: self.equipmentTableViewHeightConstraint,
          tableView: self.selectedEquipmentsTableView)
        self.showEntitiesNumber(
          entities: self.selectedEquipments,
          constraint: self.equipmentHeightConstraint,
          numberLabel: self.equipmentNumberLabel,
          addEntityButton: self.addEquipmentButton)
      }
      self.selectedEquipmentsTableView.reloadData()
    }))
    self.present(alert, animated: true)
  }
}

extension AddInterventionViewController {

  // MARK: - Initialization

  func defineEquipmentImage(equipmentName: String) -> UIImage? {
    switch equipmentName {
    case "Semoir monograines":
      return #imageLiteral(resourceName: "airplanter")
    case "Presse enrubanneuse":
      return #imageLiteral(resourceName: "baler-wrapper")
    case "Castreuse":
      return #imageLiteral(resourceName: "corn-topper")
    case "Presse balle cubique":
      return #imageLiteral(resourceName: "cubic-baler")
    case "Déchaumeur à disques":
      return #imageLiteral(resourceName: "disc-harrow")
    case "Plateau":
      return #imageLiteral(resourceName: "forage-platform")
    case "Ensileuse":
      return #imageLiteral(resourceName: "forager")
    case "Broyeur":
      return #imageLiteral(resourceName: "grinder")
    case "Herse":
      return #imageLiteral(resourceName: "harrow")
    case "Arracheuse":
      return #imageLiteral(resourceName: "harvester")
    case "Andaineur":
      return #imageLiteral(resourceName: "hay-rake")
    case "Butteuse":
      return #imageLiteral(resourceName: "hiller")
    case "Bineuse":
      return #imageLiteral(resourceName: "hoe")
    case "Désherbineuse":
      return #imageLiteral(resourceName: "hoe_weeder")
    case "Planteuse":
      return #imageLiteral(resourceName: "implanter")
    case "Tonne à lisier":
      return #imageLiteral(resourceName: "irrigation-pivot")
    case "Faucheuse":
      return #imageLiteral(resourceName: "mower")
    case "Faucheuse conditioneuse":
      return #imageLiteral(resourceName: "mower-conditioner")
    case "Charrue":
      return #imageLiteral(resourceName: "plow")
    case "Moissonneuse-batteuse":
      return #imageLiteral(resourceName: "reaper")
    case "Rouleau":
      return #imageLiteral(resourceName: "roll")
    case "Houe rotative":
      return #imageLiteral(resourceName: "rotary-hoe")
    case "Presse balle ronde":
      return #imageLiteral(resourceName: "round-baler")
    case "Outil de préparation du lit de semences":
      return #imageLiteral(resourceName: "seedbed-preparator")
    case "Décompacteur":
      return #imageLiteral(resourceName: "soil-loosener")
    case "Semoir":
      return #imageLiteral(resourceName: "sower")
    case "Pulvérisateur":
      return #imageLiteral(resourceName: "sprayer")
    case "Épandeur à engrais":
      return #imageLiteral(resourceName: "spreader")
    case "Épandeur à fumier":
      return #imageLiteral(resourceName: "liquid-manure-spreader")
    case "Sous soleuse":
      return #imageLiteral(resourceName: "subsoil-plow")
    case "Déchaumeur":
      return #imageLiteral(resourceName: "superficial-plow")
    case "Faneuse":
      return #imageLiteral(resourceName: "tedder")
    case "Effaneuse":
      return #imageLiteral(resourceName: "topper")
    case "Tracteur":
      return #imageLiteral(resourceName: "tractor")
    case "Remorque":
      return #imageLiteral(resourceName: "trailer")
    case "Écimeuse":
      return #imageLiteral(resourceName: "trimmer")
    case "Vibroculteur":
      return #imageLiteral(resourceName: "vibrocultivator")
    case "Désherbeur":
      return #imageLiteral(resourceName: "weeder")
    case "Enrubanneuse":
      return #imageLiteral(resourceName: "wrapper")
    default:
      return nil
    }
  }
}
