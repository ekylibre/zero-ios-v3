//
//  UseToolsInIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: SelectedToolsTableViewCellDelegate {

  func changeEquipmentViewAndTableViewSize() {
    equipmentTableViewHeightConstraint.constant = selectedToolsTableView.contentSize.height
    equipmentHeightConstraint.constant = equipmentTableViewHeightConstraint.constant + 100
  }

  func removeToolsCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(title: "", message: "Êtes-vous sûr de vouloir supprimer l'outil ?", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
      let row = self.selectedTools[indexPath.row].value(forKey: "row") as! Int
      let indexTab = NSIndexPath(row: row, section: 0)
      let cell = self.equipmentsTableView.cellForRow(at: indexTab as IndexPath) as! EquipmentCell

      cell.isAlreadySelected = false
      cell.backgroundColor = AppColor.CellColors.white

      self.selectedTools.remove(at: indexPath.row)

      if self.selectedTools.count == 0 {
        self.selectedToolsTableView.isHidden = true
        self.equipmentHeightConstraint.constant = 70
        self.collapseButton.isHidden = true
      } else {
        self.changeEquipmentViewAndTableViewSize()
        self.showEquipmentsNumber()
      }
      self.selectedToolsTableView.reloadData()
    }))
    self.present(alert, animated: true)
  }

  func defineToolTypes() {
    toolTypes = ["Semoir monograines", "Presse enrubanneuse", "Castreuse", "Presse balle cubique",
                 "Déchaumeur à disques", "Plateau", "Ensileuse", "Broyeur", "Herse", "Arracheuse",
                 "Andaineur", "Butteuse", "Bineuse", "Désherbineuse", "Planteuse", "Tonne à lisier",
                 "Faucheuse", "Faucheuse conditioneuse", "Charrue", "Moissonneuse-batteuse", "Rouleau",
                 "Houe rotative", "Presse balle ronde", "Outil de préparation du lit de semences",
                 "Décompacteur", "Semoir", "Pulvérisateur", "Épandeur à engrais", "Épandeur à fumier",
                 "Sous soleuse", "Déchaumeur", "Faneuse", "Effaneuse", "Tracteur", "Remorque", "Écimeuse",
                 "Vibroculteur", "Désherbeur", "Enrubanneuse"]
  }

  func showEquipmentsNumber() {
    if selectedTools.count > 0 && firstView.frame.height == 70 {
      addToolButton.isHidden = true
      toolNumberLabel.isHidden = false
      toolNumberLabel.text = (selectedTools.count == 1 ? "1 outil" : "\(selectedTools.count) outils")
    } else {
      addToolButton.isHidden = false
      toolNumberLabel.isHidden = true
    }
  }

  @IBAction func openSelectToolsView(_ sender: Any) {
    dimView.isHidden = false
    selectToolsView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  func closeSelectToolsView() {
    dimView.isHidden = true
    selectToolsView.isHidden = true

    if selectedTools.count > 0 {
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
        self.view.layoutIfNeeded()
        self.collapseButton.isHidden = false
        self.selectedToolsTableView.isHidden = false
        self.changeEquipmentViewAndTableViewSize()
        self.collapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
      })
    }
    searchedTools = equipments
    selectedToolsTableView.reloadData()
  }

  @IBAction func collapseEquipmentView(_ send: Any) {
    if equipmentHeightConstraint.constant != 70 {
      UIView.animate(withDuration: 0.5, animations: {
        self.selectedToolsTableView.isHidden = true
        self.equipmentHeightConstraint.constant = 70
        self.collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.view.layoutIfNeeded()
      })
    } else {
      UIView.animate(withDuration: 0.5, animations: {
        self.selectedToolsTableView.isHidden = false
        self.changeEquipmentViewAndTableViewSize()
        self.collapseButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
        self.view.layoutIfNeeded()
      })
    }
    showEquipmentsNumber()
  }

  @IBAction func openCreateToolsView(_ sender: Any) {
    toolsDarkLayer.isHidden = false
    createToolsView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchedEntities = searchText.isEmpty ? entities : entities.filter({(filterEntity: NSManagedObject) -> Bool in
      let entityName: String = filterEntity.value(forKey: "firstName") as! String
      return entityName.range(of: searchText) != nil
    })
    searchedTools = searchText.isEmpty ? equipments : equipments.filter({(filterTool: NSManagedObject) -> Bool in
      let toolName: String = filterTool.value(forKey: "name") as! String
      return toolName.range(of: searchText) != nil
    })
    entitiesTableView.reloadData()
    equipmentsTableView.reloadData()
  }

  func fetchTools() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let toolsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Equipments")

    do {
      equipments = try managedContext.fetch(toolsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    searchedTools = equipments
    equipmentsTableView.reloadData()
  }

  @IBAction func closeToolsCreationView(_ sender: Any) {
    toolName.text = nil
    toolNumber.text = nil
    toolsDarkLayer.isHidden = true
    createToolsView.isHidden = true
    fetchTools()
  }

  @IBAction func createNewEquipement(_ sender: Any) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsEntity = NSEntityDescription.entity(forEntityName: "Equipments", in: managedContext)!
    let equipment = NSManagedObject(entity: equipmentsEntity, insertInto: managedContext)

    equipment.setValue(toolName.text, forKeyPath: "name")
    equipment.setValue(toolNumber.text, forKeyPath: "number")
    equipment.setValue(selectedToolType, forKeyPath: "type")
    equipment.setValue(UUID(), forKey: "uuid")
    equipment.setValue(0, forKey: "row")
    do {
      try managedContext.save()
      equipments.append(equipment)
      closeToolsCreationView(self)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}

extension AddInterventionViewController{
  func defineToolImage(toolName: String) -> Int {
    switch toolName {
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
