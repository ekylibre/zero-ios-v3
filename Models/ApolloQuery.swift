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
    let farm = Farms(context: managedContext)

    farm.farmID = id
    farm.name = name

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
    let equipmentsFetchRequest: NSFetchRequest<Equipments> = Equipments.fetchRequest()

    do {
      let equipments = try managedContext.fetch(equipmentsFetchRequest)

      for equipment in equipments {
        if equipmentID == equipment.equipmentIDEky {
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
    let equipment = Equipments(context: managedContext)
    var type = fetchedEquipment.type?.rawValue

    type = type?.lowercased()
    equipment.farmID = farmID
    equipment.type = type?.localized
    equipment.name = fetchedEquipment.name
    equipment.number = fetchedEquipment.number
    equipment.equipmentIDEky = (fetchedEquipment.id as NSString).intValue
    equipment.row = 0

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
    let entitiesFetchRequest: NSFetchRequest<Entities> = Entities.fetchRequest()

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        if personID == entity.personIDEky {
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
    let person = Entities(context: managedContext)

    person.farmID = farmID
    person.firstName = fetchedPerson.firstName
    person.lastName = fetchedPerson.lastName
    person.personIDEky = (fetchedPerson.id as NSString).intValue
    person.isDriver = false
    person.row = 0

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
    let weather = Weather(context: managedContext)

    weather.weatherDescription = fetchedIntervention.weather?.description?.rawValue.lowercased().localized
    weather.windSpeed = fetchedIntervention.weather?.windSpeed as NSNumber?
    weather.temperature = fetchedIntervention.weather?.temperature as NSNumber?
    weather.interventionID = (fetchedIntervention.id as NSString).intValue as NSNumber?
    weather.interventions = intervention as? Interventions

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return weather
  }

  /*func returnPersonIfSame(personID: Int32) -> NSManagedObject? {
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

   func saveDoersInIntervention(fetchedOperator: InterventionQuery.Data.Farm.Intervention.Operator, intervention: NSManagedObject) -> NSManagedObject {
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

   func saveEquipmentInInterventionEquipments(fetchedEquipment: InterventionQuery.Data.Farm.Intervention.Tool.Equipment, interventionEquipments: NSManagedObject) -> NSManagedObject {
   let managedContext = appDelegate.persistentContainer.viewContext
   let equipmentsEntity = NSEntityDescription.entity(forEntityName: "Equipments", in: managedContext)!
   let equipment = NSManagedObject(entity: equipmentsEntity, insertInto: managedContext)

   equipment.setValue(fetchedEquipment.id, forKey: "equipmentID")
   equipment.setValue(interventionEquipments, forKey: "interventionEquipments")
   return equipment
   }

   func saveInterventionEquipmentsInIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention, intervention: NSManagedObject) -> NSManagedObject {
   let managedContext = appDelegate.persistentContainer.viewContext
   let equipmentsEntity = NSEntityDescription.entity(forEntityName: "InterventionEquipments", in: managedContext)!
   let equipment = NSManagedObject(entity: equipmentsEntity, insertInto: managedContext)
   var equipments = [NSManagedObject]()

   equipment.setValue(intervention, forKey: "interventions")
   for fetchedTool in fetchedIntervention.tools! {
   equipments.append(saveEquipmentInInterventionEquipments(fetchedEquipment: fetchedTool.equipment!, interventionEquipments: equipment))
   }
   //equipment.setValue(equipments, forKey: "equipments")
   return equipment
   }*/

  func saveWorkingDays(fetchedDay: InterventionQuery.Data.Farm.Intervention.WorkingDay) -> WorkingPeriods {
    let managedContext = appDelegate.persistentContainer.viewContext
    let workingPeriod = WorkingPeriods(context: managedContext)
    let dateFormatter = DateFormatter()

    dateFormatter.locale = Locale(identifier: "fr_FR")
    dateFormatter.dateFormat = "yyyy-mm-dd"
    workingPeriod.executionDate = dateFormatter.date(from: fetchedDay.executionDate!)
    workingPeriod.hourDuration = Float(fetchedDay.hourDuration!)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return workingPeriod
  }

  func returnEquipmentIfSame(equipmentID: Int32?) -> Equipments? {
    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsFetchRequest: NSFetchRequest<Equipments> = Equipments.fetchRequest()

    do {
      let equipments = try managedContext.fetch(equipmentsFetchRequest)

      for equipment in equipments {
        if equipmentID == equipment.equipmentIDEky {
          return equipment
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  func saveEquipmentsToIntervention(fetchedEquipment: InterventionQuery.Data.Farm.Intervention.Tool, intervention: Interventions) -> InterventionEquipments {
    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionEquipment = InterventionEquipments(context: managedContext)
    let equipment = returnEquipmentIfSame(equipmentID: (fetchedEquipment.equipment?.id as NSString?)?.intValue)

    if equipment != nil {
      equipment?.addToInterventionEquipments(interventionEquipment)
      interventionEquipment.interventions = intervention
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return interventionEquipment
  }

  func returnPersonIfSame(personID: Int32?) -> Entities? {
    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest: NSFetchRequest<Entities> = Entities.fetchRequest()

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        if personID == entity.personIDEky {
          return entity
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  func saveDoersToIntervention(fetchedOperator: InterventionQuery.Data.Farm.Intervention.Operator, intervention: Interventions) -> Doers {
    let managedContext = appDelegate.persistentContainer.viewContext
    let doers = Doers(context: managedContext)
    let doer = returnPersonIfSame(personID: (fetchedOperator.person?.id as NSString?)?.intValue)

    if doer != nil {
      if fetchedOperator.role?.rawValue == "OPERATOR" {
        doers.isDriver = false
      } else {
        doers.isDriver = true
      }
      doer?.addToDoers(doers)
      doers.interventions = intervention
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return doers
  }

  func saveIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention, farmID: String) {
    let managedContext = appDelegate.persistentContainer.viewContext
    let intervention = Interventions(context: managedContext)

    intervention.farmID = farmID
    intervention.interventionIDEky = (fetchedIntervention.id as NSString).intValue
    intervention.type = fetchedIntervention.type.rawValue.lowercased().localized
    intervention.infos = fetchedIntervention.description
    intervention.waterUnit = fetchedIntervention.waterUnit?.rawValue.lowercased().localized
    intervention.weather = saveWeatherInIntervention(fetchedIntervention: fetchedIntervention, intervention: intervention) as? Weather
    for workingDay in fetchedIntervention.workingDays {
      intervention.addToWorkingPeriods(saveWorkingDays(fetchedDay: workingDay))
    }
    for fetchedEquipment in fetchedIntervention.tools! {
      intervention.addToInterventionEquipments(saveEquipmentsToIntervention(fetchedEquipment: fetchedEquipment, intervention: intervention))
    }
    for fetchedOperator in fetchedIntervention.operators! {
      intervention.addToDoers(saveDoersToIntervention(fetchedOperator: fetchedOperator, intervention: intervention))
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func checkIfNewIntervention(interventionID: Int32) -> Bool {
    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsFetchRequest: NSFetchRequest<Interventions> = Interventions.fetchRequest()

    do {
      let interventions = try managedContext.fetch(interventionsFetchRequest)

      for intervention in interventions {
        if interventionID == intervention.interventionIDEky {
          return false
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return true
  }

  func loadIntervention() {
    appDelegate.apollo?.fetch(query: InterventionQuery()) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve interventions"); return }

      for farm in farms {
        for intervention in farm.interventions! {
          if self.checkIfNewIntervention(interventionID: (intervention.id as NSString).intValue) {
            self.saveIntervention(fetchedIntervention: intervention, farmID: farm.id)
          }
        }
      }
    }
  }
}
