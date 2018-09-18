//
//  ApolloQuery.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 17/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import Apollo
import CoreData

class ApolloQuery {

  let appDelegate = UIApplication.shared.delegate as! AppDelegate

  func saveFarmNameAndID(name: String?, id: String?) {
    let managedContext = appDelegate.persistentContainer.viewContext
    let farmsEntity = NSEntityDescription.entity(forEntityName: "Farms", in: managedContext)!
    let farm = NSManagedObject(entity: farmsEntity, insertInto: managedContext)

    farm.setValue(name, forKey: "name")
    farm.setValue(id, forKey: "farmID")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func defineFarmNameAndID(completion: @escaping (_ success: Bool) -> Void) {
    appDelegate.apollo?.fetch(query: ProfileQuery()) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve farms"); return }

      for farm in farms {
        self.saveFarmNameAndID(name: farm.label, id: farm.id)
      }
      completion(true)
    }
  }

  func checkIfNewEquipment(equipmentID: Double) -> Bool {
    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Equipments")

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        if equipmentID == entity.value(forKey: "equipmentIDEky") as? Double {
          return false
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return true
  }

  func saveEquipments(fetchedEquipment: FarmQuery.Data.Farm.Equipment) {
    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsEntity = NSEntityDescription.entity(forEntityName: "Equipments", in: managedContext)!
    let equipment = NSManagedObject(entity: equipmentsEntity, insertInto: managedContext)
    var type = fetchedEquipment.type?.rawValue

    type = type?.lowercased()
    equipment.setValue(fetchedEquipment.name, forKey: "name")
    equipment.setValue(fetchedEquipment.number, forKey: "number")
    equipment.setValue(type?.localized, forKey: "type")
    equipment.setValue((fetchedEquipment.id as NSString).intValue, forKey: "equipmentIDEky")
    equipment.setValue(0, forKey: "row")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func defineEquipments() {
    appDelegate.apollo?.fetch(query: FarmQuery()) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve farms. \(error!)"); return }

      for farm in farms {
        let equipments = farm.equipments!
        for equipment in equipments {
          if self.checkIfNewEquipment(equipmentID: (equipment.id as NSString).doubleValue) {
            self.saveEquipments(fetchedEquipment: equipment)
          }
        }
      }
    }
  }
}
