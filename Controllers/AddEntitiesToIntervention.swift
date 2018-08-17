//
//  AddEntitiesToIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 17/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController {
  @IBAction func openSelectEntitiesView(_ sender: Any) {
    dimView.isHidden = false
    selectEntitiesView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  /*func closeSelectEntitiesView() {
    dimView.isHidden = true
    selectEntitiesView.isHidden = true
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
    if selectedTools.count > 0 && firstView.frame.height == 50 {
      collapseExpand(self)
    }
    entitiesTableView.reloadData()
  }*/

  @IBAction func openCreateEntitiesView(_ sender: Any) {
    darkLayerView.isHidden = false
    createEntitiesView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @IBAction func closeEntitiesCreationView(_ sender: Any) {
    entityFirstName.text = nil
    entityLastName.text = nil
    entityTitle.text = nil
    darkLayerView.isHidden = true
    createEntitiesView.isHidden = true
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
    fetchTools()
  }

  @IBAction func createNewEntity(_ sender: Any) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsEntity = NSEntityDescription.entity(forEntityName: "Entities", in: managedContext)!
    let equipment = NSManagedObject(entity: equipmentsEntity, insertInto: managedContext)

    equipment.setValue(toolName.text, forKeyPath: "firstName")
    equipment.setValue(toolNumber.text, forKeyPath: "lastName")
    equipment.setValue(selectedToolType, forKeyPath: "role")
    do {
      try managedContext.save()
      equipments.append(equipment)
      closeToolsCreationView(self)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}
