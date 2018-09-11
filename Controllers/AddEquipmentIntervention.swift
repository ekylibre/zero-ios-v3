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

  private func loadEquipmentTypes() -> [String] {
    var equipmentType = [String]()

    if let asset = NSDataAsset(name: "equipment-types") {
      do {
        let jsonResult = try JSONSerialization.jsonObject(with: asset.data)
        let registeredEquipments = jsonResult as? [[String: Any]]

        for registeredEquipment in registeredEquipments! {
          equipmentType.append(registeredEquipment["nature"] as! String)
        }
      } catch {
        print("Lexicon error")
      }
    } else {
      print("equipment_types.json not found")
    }
    return equipmentType
  }

  func defineEquipmentTypes() -> [String] {
    var types = loadEquipmentTypes()
    var translatedTypes = [String]()

    types = types.sorted()
    for type in types {
       translatedTypes.append(type.localized)
    }
    return translatedTypes
  }

  func defineEquipmentImage(equipmentName: String) -> UIImage? {
    switch equipmentName {
    case equipmentTypes[0]:
      return #imageLiteral(resourceName: "airplanter")
    case equipmentTypes[1]:
      return #imageLiteral(resourceName: "baler-wrapper")
    case equipmentTypes[2]:
      return #imageLiteral(resourceName: "corn-topper")
    case equipmentTypes[3]:
      return #imageLiteral(resourceName: "cubic-baler")
    case equipmentTypes[4]:
      return #imageLiteral(resourceName: "disc-harrow")
    case equipmentTypes[5]:
      return #imageLiteral(resourceName: "forage-platform")
    case equipmentTypes[6]:
      return #imageLiteral(resourceName: "forager")
    case equipmentTypes[7]:
      return #imageLiteral(resourceName: "grinder")
    case equipmentTypes[8]:
      return #imageLiteral(resourceName: "harrow")
    case equipmentTypes[9]:
      return #imageLiteral(resourceName: "harvester")
    case equipmentTypes[10]:
      return #imageLiteral(resourceName: "hay-rake")
    case equipmentTypes[11]:
      return #imageLiteral(resourceName: "hiller")
    case equipmentTypes[12]:
      return #imageLiteral(resourceName: "hoe")
    case equipmentTypes[13]:
      return #imageLiteral(resourceName: "hoe_weeder")
    case equipmentTypes[14]:
      return #imageLiteral(resourceName: "implanter")
    case equipmentTypes[15]:
      return #imageLiteral(resourceName: "irrigation-pivot")
    case equipmentTypes[16]:
      return #imageLiteral(resourceName: "liquid-manure-spreader")
    case equipmentTypes[17]:
      return #imageLiteral(resourceName: "mower")
    case equipmentTypes[18]:
      return #imageLiteral(resourceName: "mower-conditioner")
    case equipmentTypes[19]:
      return #imageLiteral(resourceName: "plow")
    case equipmentTypes[20]:
      return #imageLiteral(resourceName: "reaper")
    case equipmentTypes[21]:
      return #imageLiteral(resourceName: "roll")
    case equipmentTypes[22]:
      return #imageLiteral(resourceName: "rotary-hoe")
    case equipmentTypes[23]:
      return #imageLiteral(resourceName: "round-baler")
    case equipmentTypes[24]:
      return #imageLiteral(resourceName: "seedbed-preparator")
    case equipmentTypes[25]:
      return #imageLiteral(resourceName: "soil-loosener")
    case equipmentTypes[26]:
      return #imageLiteral(resourceName: "sower")
    case equipmentTypes[27]:
      return #imageLiteral(resourceName: "sprayer")
    case equipmentTypes[28]:
      return #imageLiteral(resourceName: "spreader")
    case equipmentTypes[29]:
      return #imageLiteral(resourceName: "spreader-trailer")
    case equipmentTypes[30]:
      return #imageLiteral(resourceName: "subsoil-plow")
    case equipmentTypes[31]:
      return #imageLiteral(resourceName: "superficial-plow")
    case equipmentTypes[32]:
      return #imageLiteral(resourceName: "tedder")
    case equipmentTypes[33]:
      return #imageLiteral(resourceName: "topper")
    case equipmentTypes[34]:
      return #imageLiteral(resourceName: "tractor")
    case equipmentTypes[35]:
      return #imageLiteral(resourceName: "trailer")
    case equipmentTypes[36]:
      return #imageLiteral(resourceName: "trimmer")
    case equipmentTypes[37]:
      return #imageLiteral(resourceName: "vibrocultivator")
    case equipmentTypes[38]:
      return #imageLiteral(resourceName: "water-spreader")
    case equipmentTypes[39]:
      return #imageLiteral(resourceName: "weeder")
    case equipmentTypes[40]:
      return #imageLiteral(resourceName: "wrapper")
    default:
      return nil
    }
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

  func closeEquipmentsSelectionView() {
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
