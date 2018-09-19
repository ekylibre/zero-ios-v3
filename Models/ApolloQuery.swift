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

  // MARK: - Properties

  let appDelegate = UIApplication.shared.delegate as! AppDelegate

  // MARK: - Actions

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
      guard let farms = result?.data?.farms else { print("Could not retrieve profile"); return }

      for farm in farms {
        self.saveFarmNameAndID(name: farm.label, id: farm.id)
      }
      completion(true)
    }
  }

  func checkIfNewEquipment(equipmentID: Int32) -> Bool {
    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Equipments")

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        if equipmentID == entity.value(forKey: "equipmentIDEky") as? Int32 {
          return false
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return true
  }

  func saveEquipments(fetchedEquipment: FarmQuery.Data.Farm.Equipment, farmID: String) {
    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsEntity = NSEntityDescription.entity(forEntityName: "Equipments", in: managedContext)!
    let equipment = NSManagedObject(entity: equipmentsEntity, insertInto: managedContext)
    var type = fetchedEquipment.type?.rawValue

    type = type?.lowercased()
    equipment.setValue(farmID, forKey: "farmID")
    equipment.setValue(type?.localized, forKey: "type")
    equipment.setValue(fetchedEquipment.name, forKey: "name")
    equipment.setValue(fetchedEquipment.number, forKey: "number")
    equipment.setValue((fetchedEquipment.id as NSString).intValue, forKey: "equipmentIDEky")
    equipment.setValue(0, forKey: "row")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func loadEquipments() {
    appDelegate.apollo?.fetch(query: FarmQuery()) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve farms. \(error!)"); return }

      for farm in farms {
        for equipment in farm.equipments! {
          if self.checkIfNewEquipment(equipmentID: (equipment.id as NSString).intValue) {
            self.saveEquipments(fetchedEquipment: equipment, farmID: farm.id)
          }
        }
      }
    }
  }

  func checkIfNewPerson(personID: Int32) -> Bool {
    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entities")

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        if personID == entity.value(forKey: "personIDEky") as? Int32 {
          return false
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return true
  }

  func savePeople(fetchedPerson: FarmQuery.Data.Farm.Person, farmID: String) {
    let managedContext = appDelegate.persistentContainer.viewContext
    let peopleEntity = NSEntityDescription.entity(forEntityName: "Entities", in: managedContext)!
    let person = NSManagedObject(entity: peopleEntity, insertInto: managedContext)

    person.setValue(farmID, forKey: "farmID")
    person.setValue(fetchedPerson.firstName, forKey: "firstName")
    person.setValue(fetchedPerson.lastName, forKey: "lastName")
    person.setValue((fetchedPerson.id as NSString).intValue, forKey: "personIDEky")
    person.setValue(false, forKey: "isDriver")
    person.setValue(0, forKey: "row")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func loadPeople(completion: @escaping (_ success: Bool) -> Void) {
    appDelegate.apollo?.fetch(query: FarmQuery()) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve farms."); return }

      for farm in farms {
        for person in farm.people! {
          if self.checkIfNewPerson(personID: (person.id as NSString).intValue) {
            self.savePeople(fetchedPerson: person, farmID: farm.id)
          }
        }
      }
    }
    completion(true)
  }

  func saveWeatherInIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention, intervention: NSManagedObject) -> NSManagedObject {
    let managedContext = appDelegate.persistentContainer.viewContext
    let weatherEntity = NSEntityDescription.entity(forEntityName: "Weather", in: managedContext)!
    let weather = NSManagedObject(entity: weatherEntity, insertInto: managedContext)

    weather.setValue(fetchedIntervention.weather?.temperature, forKey: "temperature")
    weather.setValue(fetchedIntervention.weather?.description?.rawValue, forKey: "weatherDescription")
    weather.setValue(fetchedIntervention.weather?.windSpeed, forKey: "windSpeed")
    weather.setValue((fetchedIntervention.id as NSString).intValue, forKey: "interventionID")
    weather.setValue(intervention, forKey: "interventions")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return weather
  }

  func returnPersonIfSame(personID: Int32) -> NSManagedObject? {
    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entities")

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        if personID == entity.value(forKey: "personIDEky") as? Int32 {
          return entity
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  func saveEntities(fetchedPerson: InterventionQuery.Data.Farm.Intervention.Operator.Person) -> NSManagedObject {
    let returnPerson = returnPersonIfSame(personID: (fetchedPerson.id as NSString).intValue)

    if returnPerson == nil {
      let managedContext = appDelegate.persistentContainer.viewContext
      let entitiesEntity = NSEntityDescription.entity(forEntityName: "Entities", in: managedContext)!
      let entity = NSManagedObject(entity: entitiesEntity, insertInto: managedContext)

      entity.setValue((fetchedPerson.id as NSString).intValue, forKey: "personID")

      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
      return entity
    }
    return returnPerson!
  }

  func saveDoers(fetchedOperator: InterventionQuery.Data.Farm.Intervention.Operator, intervention: NSManagedObject) -> NSManagedObject {
    let managedContext = appDelegate.persistentContainer.viewContext
    let doersEntity = NSEntityDescription.entity(forEntityName: "Doers", in: managedContext)!
    let doer = NSManagedObject(entity: doersEntity, insertInto: managedContext)

    if fetchedOperator.role?.rawValue == "OPERATOR" {
      doer.setValue(false, forKey: "isDriver")
    } else {
      doer.setValue(true, forKey: "isDriver")
    }
    doer.setValue(saveEntities(fetchedPerson: fetchedOperator.person!), forKey: "entities")
    doer.setValue(intervention, forKey: "interventions")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return doer
  }

  func saveIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention, farmID: String) {
    let managedContext = appDelegate.persistentContainer.viewContext
    let farmsEntity = NSEntityDescription.entity(forEntityName: "Interventions", in: managedContext)!
    let intervention = NSManagedObject(entity: farmsEntity, insertInto: managedContext)

    intervention.setValue(farmID, forKey: "farmID")
    intervention.setValue((fetchedIntervention.id as NSString).intValue, forKey: "interventionIDEky")
    intervention.setValue(fetchedIntervention.type.rawValue, forKey: "type")
    intervention.setValue(fetchedIntervention.description, forKey: "infos")
    intervention.setValue(fetchedIntervention.waterQuantity, forKey: "waterQuantity")
    intervention.setValue(fetchedIntervention.waterUnit?.rawValue, forKey: "waterUnit")
    intervention.setValue(fetchedIntervention.globalOutputs, forKey: "output")
    intervention.setValue(saveWeatherInIntervention(fetchedIntervention: fetchedIntervention, intervention: intervention), forKey: "weather")
    let doers = NSSet()
    for fetchedOperator in fetchedIntervention.operators! {
      doers.adding(saveDoers(fetchedOperator: fetchedOperator, intervention: intervention))
    }
    intervention.setValue(doers, forKey: "doers")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func loadIntervention() {
    appDelegate.apollo?.fetch(query: InterventionQuery()) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve interventions"); return }

      for farm in farms {
        for intervention in farm.interventions! {
          self.saveIntervention(fetchedIntervention: intervention, farmID: farm.id)
        }
      }
    }
  }
}
