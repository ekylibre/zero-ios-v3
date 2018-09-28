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

  func checkLocalData() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    queryFarms()
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

  // MARK: - Queries: Farms

  private func queryFarms() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let apollo = appDelegate.apollo!
    let query = FarmQuery()

    apollo.fetch(query: query) { result, error in
      if let error = error { print("Error: \(error)"); return }

      guard let farms = result?.data?.farms else { print("Could not retrieve farms"); return }
      if UserDefaults.isFirstLaunch() {
        self.saveFarms(farms)
        self.loadEquipments()
        self.loadStorage()
        self.loadPeople { (success) -> Void in
          if success {
            self.loadIntervention()
          }
        }
      } else {
        self.registerFarmID()
        self.loadEquipments()
        self.loadStorage()
        self.loadPeople { (success) -> Void in
          if success {
            self.loadIntervention()
          }
        }
      }
    }
  }

  private func registerFarmID() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let farmsFetchRequest: NSFetchRequest<Farms> = Farms.fetchRequest()

    do {
      let farms = try managedContext.fetch(farmsFetchRequest)
      appDelegate.farmID = farms.first!.id!
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func saveFarms(_ farms: [FarmQuery.Data.Farm]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for farm in farms {
      let newFarm = Farms(context: managedContext)

      newFarm.id = farm.id
      newFarm.name = farm.label
    }

    do {
      try managedContext.save()
      appDelegate.farmID = farms.first?.id
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  /*func saveFarmNameAndID(name: String?, id: String?) {
   let managedContext = appDelegate.persistentContainer.viewContext
   let farm = Farms(context: managedContext)

   farm.id = id
   farm.name = name
   print("\nFarm: \(farm)")

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
   }*/

  // MARK: Equipments

  private func checkIfNewEquipment(equipmentID: Int32) -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return true
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsFetchRequest: NSFetchRequest<Equipments> = Equipments.fetchRequest()

    do {
      let equipments = try managedContext.fetch(equipmentsFetchRequest)

      for equipment in equipments {
        if equipmentID == equipment.ekyID {
          return false
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return true
  }

  private func saveEquipments(fetchedEquipment: FarmQuery.Data.Farm.Equipment, farmID: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipment = Equipments(context: managedContext)
    var type = fetchedEquipment.type?.rawValue

    type = type?.lowercased()
    equipment.farmID = farmID
    equipment.type = type?.localized
    equipment.name = fetchedEquipment.name
    equipment.number = fetchedEquipment.number
    equipment.ekyID = (fetchedEquipment.id as NSString).intValue
    equipment.row = 0

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func loadEquipments() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    appDelegate.apollo?.fetch(query: FarmQuery()) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve farms."); return }

      for farm in farms {
        for equipment in farm.equipments! {
          if self.checkIfNewEquipment(equipmentID: (equipment.id as NSString).intValue) {
            self.saveEquipments(fetchedEquipment: equipment, farmID: farm.id)
          }
        }
      }
    }
  }

  // MARK: People

  private func checkIfNewPerson(personID: Int32) -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return true
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest: NSFetchRequest<Entities> = Entities.fetchRequest()

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        if personID == entity.ekyID {
          return false
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return true
  }

  private func savePeople(fetchedPerson: FarmQuery.Data.Farm.Person, farmID: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let person = Entities(context: managedContext)

    person.farmID = farmID
    person.firstName = fetchedPerson.firstName
    person.lastName = fetchedPerson.lastName
    person.ekyID = (fetchedPerson.id as NSString).intValue
    person.isDriver = false
    person.row = 0

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func loadPeople(completion: @escaping (_ success: Bool) -> Void) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

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

  // MARK: Storages

  private func checkifNewStorage(storageID: Int32) -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return true
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let storagesFetchRequest: NSFetchRequest<Storages> = Storages.fetchRequest()

    do {
      let storages = try managedContext.fetch(storagesFetchRequest)

      for storage in storages {
        if storageID == storage.storageID {
          return false
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return true
  }

  private func saveStorage(fetchedStorage: FarmQuery.Data.Farm.Storage, farmID: String){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let manaedContext = appDelegate.persistentContainer.viewContext
    let storage = Storages(context: manaedContext)

    storage.storageID = (fetchedStorage.id as NSString).intValue
    storage.name = fetchedStorage.name
    storage.type = fetchedStorage.type.rawValue.lowercased().localized

    do {
      try manaedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func loadStorage() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    appDelegate.apollo?.fetch(query: FarmQuery()) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve farms."); return }

      for farm in farms {
        for storage in farm.storages! {
          if self.checkifNewStorage(storageID: (storage.id as NSString).intValue) {
            self.saveStorage(fetchedStorage: storage, farmID: farm.id)
          }
        }
      }
    }
  }

  // MARK: Weather

  private func saveWeatherInIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention, intervention: NSManagedObject) -> NSManagedObject {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return NSManagedObject()
    }

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

  // MARK: Working Periods

  private func saveWorkingDays(fetchedDay: InterventionQuery.Data.Farm.Intervention.WorkingDay) -> WorkingPeriods {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return WorkingPeriods()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let workingPeriod = WorkingPeriods(context: managedContext)
    let dateFormatter = DateFormatter()

    dateFormatter.locale = Locale(identifier: "fr_FR")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    workingPeriod.executionDate = dateFormatter.date(from: fetchedDay.executionDate!)
    workingPeriod.hourDuration = Float(fetchedDay.hourDuration!)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return workingPeriod
  }

  // MARK: Intervention Equipments

  private func returnEquipmentIfSame(equipmentID: Int32?) -> Equipments? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsFetchRequest: NSFetchRequest<Equipments> = Equipments.fetchRequest()

    do {
      let equipments = try managedContext.fetch(equipmentsFetchRequest)

      for equipment in equipments {
        if equipmentID == equipment.ekyID {
          return equipment
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func saveEquipmentsToIntervention(fetchedEquipment: InterventionQuery.Data.Farm.Intervention.Tool, intervention: Interventions) -> InterventionEquipments {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return InterventionEquipments()
    }

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

  // MARK: Targets

  private func returnCropIfSame(cropUUID: UUID?) -> Crops? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crops> = Crops.fetchRequest()

    do {
      let crops = try managedContext.fetch(cropsFetchRequest)

      for crop in crops {
        if cropUUID == crop.uuid && crop.uuid != nil {
          return crop
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func saveTargetToIntervention(fetchedTarget: InterventionQuery.Data.Farm.Intervention.Target, intervention: Interventions) -> Targets {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Targets()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let target = Targets(context: managedContext)
    let crop = returnCropIfSame(cropUUID: UUID(uuidString: fetchedTarget.crop.uuid))

    if crop != nil {
      target.workAreaPercentage = Int16(fetchedTarget.workingPercentage)
      target.crops = crop
      target.interventions = intervention
    }
    return target
  }

  // MARK: Doers

  private func returnPersonIfSame(personID: Int32?) -> Entities? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest: NSFetchRequest<Entities> = Entities.fetchRequest()

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        if personID == entity.ekyID {
          return entity
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func saveDoersToIntervention(fetchedOperator: InterventionQuery.Data.Farm.Intervention.Operator, intervention: Interventions) -> Doers {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Doers()
    }

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

  // MARK: Harvests

  private func createLoadIfGlobalOutput(fetchedOutput: InterventionQuery.Data.Farm.Intervention.Output, intervention: Interventions) -> Harvests {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Harvests()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvest = Harvests(context: managedContext)

    harvest.quantity = fetchedOutput.quantity ?? 0
    harvest.type = fetchedOutput.nature.rawValue.lowercased().localized
    harvest.unit = fetchedOutput.unit?.rawValue.lowercased().localized
    harvest.number = fetchedOutput.id
    harvest.interventions = intervention

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return harvest
  }

  private func returnStorageIfSame(storageID: Int32?) -> Storages? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let storagesFetchRequest: NSFetchRequest<Storages> = Storages.fetchRequest()

    do {
      let storages = try managedContext.fetch(storagesFetchRequest)

      for storage in storages {
        if storageID == storage.storageID {
          return storage
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func saveLoadToIntervention(fetchedLoad: InterventionQuery.Data.Farm.Intervention.Output.Load, intervention: Interventions, nature: String) -> Harvests {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Harvests()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvest = Harvests(context: managedContext)
    let storage = returnStorageIfSame(storageID: (fetchedLoad.storage?.id as NSString?)?.intValue)

    storage?.addToHarvests(harvest)
    harvest.storages = storage
    harvest.interventions = intervention
    harvest.type = nature
    harvest.number = fetchedLoad.number
    harvest.quantity = fetchedLoad.quantity
    harvest.unit = fetchedLoad.unit?.rawValue.lowercased().localized

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return harvest
  }

  // MARK: Inputs

  private func returnSeedIfSame(seedID: Int32?) -> Seeds? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let seedsFetchRequest: NSFetchRequest<Seeds> = Seeds.fetchRequest()

    do {
      let seeds = try managedContext.fetch(seedsFetchRequest)

      for seed in seeds {
        if seedID == seed.ekyID {
          return seed
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func returnFertilizerIfSame(fertilizerID: Int32?) -> Fertilizers? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let fertilizersFetchRequest: NSFetchRequest<Fertilizers> = Fertilizers.fetchRequest()

    do {
      let fertilizers = try managedContext.fetch(fertilizersFetchRequest)

      for fertilizer in fertilizers {
        if fertilizerID == fertilizer.ekyID {
          return fertilizer
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func returnPhytoIfSame(phytoID: Int32?) -> Phytos? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let phytosFetchRequest: NSFetchRequest<Phytos> = Phytos.fetchRequest()

    do {
      let phytos = try managedContext.fetch(phytosFetchRequest)

      for phyto in phytos {
        if phytoID == phyto.ekyID {
          return phyto
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func returnMaterialIfSame(materialID: Int32?) -> Materials? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let materialsFetchRequest: NSFetchRequest<Materials> = Materials.fetchRequest()

    do {
      let materials = try managedContext.fetch(materialsFetchRequest)

      for material in materials {
        if materialID == material.ekyID {
          return material
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func saveInputsInIntervention(fetchedInput: InterventionQuery.Data.Farm.Intervention.Input, intervention: Interventions) -> Interventions {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return intervention
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    switch fetchedInput.article?.type.rawValue {
    case "SEED":
      let interventionSeed = InterventionSeeds(context: managedContext)
      let seed = returnSeedIfSame(seedID: (fetchedInput.article?.id as NSString?)?.intValue)

      interventionSeed.unit = fetchedInput.unit.rawValue
      interventionSeed.quantity = fetchedInput.quantity as NSNumber?
      interventionSeed.seeds = seed
      interventionSeed.interventions = intervention
      intervention.addToInterventionSeeds(interventionSeed)
    case "FERTILIZER":
      let interventionFertilizer = InterventionFertilizers(context: managedContext)
      let fertilizer = returnFertilizerIfSame(fertilizerID: (fetchedInput.article?.id as NSString?)?.intValue)

      interventionFertilizer.unit = fetchedInput.unit.rawValue
      interventionFertilizer.quantity = fetchedInput.quantity as NSNumber?
      interventionFertilizer.fertilizers = fertilizer
      interventionFertilizer.interventions =  intervention
      intervention.addToInterventionFertilizers(interventionFertilizer)
    case "CHEMICAL":
      let interventionPhyto = InterventionPhytosanitaries(context: managedContext)
      let phyto = returnPhytoIfSame(phytoID: (fetchedInput.article?.id as NSString?)?.intValue)

      interventionPhyto.unit = fetchedInput.unit.rawValue
      interventionPhyto.quantity = fetchedInput.quantity as NSNumber?
      interventionPhyto.phytos = phyto
      interventionPhyto.interventions = intervention
      intervention.addToInterventionPhytosanitaries(interventionPhyto)
    case "MATERIAL":
      let interventionMaterial = InterventionMaterials(context: managedContext)
      let material = returnMaterialIfSame(materialID: (fetchedInput.article?.id as NSString?)?.intValue)

      interventionMaterial.unit = fetchedInput.unit.rawValue
      interventionMaterial.quantity = fetchedInput.quantity as NSNumber?
      interventionMaterial.materials = material
      interventionMaterial.interventions = intervention
      intervention.addToInterventionMaterials(interventionMaterial)
    default:
      fatalError((fetchedInput.article?.type.rawValue)! + ": Unknown value of TypeEnum")
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return intervention
  }

  // MARK: Intervention

  private func saveEntitiesIntoIntervention(intervention: Interventions, fetchedIntervention: InterventionQuery.Data.Farm.Intervention) -> Interventions {
    for workingDay in fetchedIntervention.workingDays {
      intervention.addToWorkingPeriods(saveWorkingDays(fetchedDay: workingDay))
    }
    for fetchedEquipment in fetchedIntervention.tools! {
      intervention.addToInterventionEquipments(saveEquipmentsToIntervention(fetchedEquipment: fetchedEquipment, intervention: intervention))
    }
    for fetchedOperator in fetchedIntervention.operators! {
      intervention.addToDoers(saveDoersToIntervention(fetchedOperator: fetchedOperator, intervention: intervention))
    }
    for fetchedTarget in fetchedIntervention.targets {
      intervention.addToTargets(saveTargetToIntervention(fetchedTarget: fetchedTarget, intervention: intervention))
    }
    for fetchedOutput in fetchedIntervention.outputs! {
      if fetchedIntervention.globalOutputs! {
        intervention.addToHarvests(createLoadIfGlobalOutput(fetchedOutput: fetchedOutput, intervention: intervention))
      } else {
        for load in fetchedOutput.loads! {
          intervention.addToHarvests(saveLoadToIntervention(fetchedLoad: load, intervention: intervention, nature: fetchedOutput.nature.rawValue.lowercased().localized))
        }
      }
    }
    return intervention
  }

  private func saveIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention, farmID: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    var intervention = Interventions(context: managedContext)

    intervention.farmID = farmID
    intervention.ekyID = (fetchedIntervention.id as NSString).intValue
    intervention.type = fetchedIntervention.type.rawValue.lowercased()
    intervention.infos = fetchedIntervention.description
    intervention.waterUnit = fetchedIntervention.waterUnit?.rawValue.lowercased().localized
    intervention.weather = saveWeatherInIntervention(fetchedIntervention: fetchedIntervention, intervention: intervention) as? Weather
    intervention = saveEntitiesIntoIntervention(intervention: intervention, fetchedIntervention: fetchedIntervention)
    for fetchedInput in fetchedIntervention.inputs! {
      intervention = saveInputsInIntervention(fetchedInput: fetchedInput, intervention: intervention)
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func checkIfNewIntervention(interventionID: Int32) -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return true
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsFetchRequest: NSFetchRequest<Interventions> = Interventions.fetchRequest()

    do {
      let interventions = try managedContext.fetch(interventionsFetchRequest)

      for intervention in interventions {
        if interventionID == intervention.ekyID {
          return false
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return true
  }

  func loadIntervention() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

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

  // MARK: - Mutations: Interventions

  func defineWorkingDayAttributesFrom(intervention: Interventions) -> [InterventionWorkingDayAttributes] {
    let workingDays = intervention.workingPeriods
    var workingDaysAttributes = [InterventionWorkingDayAttributes]()

    for workingDay in workingDays! {
      let executionDate = (workingDay as AnyObject).value(forKey: "executionDate")
      let formatter = DateFormatter()

      formatter.dateFormat = "yyyy-MM-dd"
      let workingDayAttributes = InterventionWorkingDayAttributes(
        executionDate: formatter.string(from: executionDate as! Date),
        hourDuration: (workingDay as AnyObject).value(forKey: "hourDuration") as? Double)

      workingDaysAttributes.append(workingDayAttributes)
    }
    return workingDaysAttributes
  }

  func defineTargetAttributesFrom(intervention: Interventions) -> [InterventionTargetAttributes] {
    let targets = intervention.targets
    var targetsAttributes = [InterventionTargetAttributes]()

    for target in targets! {
      let target = target as! Targets
      let targetAttributes = InterventionTargetAttributes(
        cropId: "\(String(describing: target.crops))",
        workZone: nil,
        workAreaPercentage: Int(target.workAreaPercentage))

      targetsAttributes.append(targetAttributes)
    }
    return targetsAttributes
  }

  func initializeInputsArray(inputs: inout [NSManagedObject], entities: [Any]?) {
    if entities != nil {
      for entity in entities! {
        inputs.append(entity as! NSManagedObject)
      }
    }
  }

  func defineInputsAttributesFrom(intervention: Interventions) -> [InterventionInputAttributes] {
    let seeds = intervention.interventionSeeds?.allObjects
    let phytos = intervention.interventionPhytosanitaries?.allObjects
    let fertilizers = intervention.interventionFertilizers?.allObjects
    let materials = intervention.interventionMaterials?.allObjects
    var inputs = [NSManagedObject]()
    var inputsAttributes = [InterventionInputAttributes]()

    initializeInputsArray(inputs: &inputs, entities: seeds)
    initializeInputsArray(inputs: &inputs, entities: phytos)
    initializeInputsArray(inputs: &inputs, entities: fertilizers)
    initializeInputsArray(inputs: &inputs, entities: materials)
    for input in inputs {
      var inputAttributes: InterventionInputAttributes
      switch input {
      case is InterventionSeeds:
        let seed = input as! InterventionSeeds
        let article = InterventionArticleAttributes(
          id: "\(String(describing: seed.seeds?.ekyID))",
          referenceId: "\(String(describing: seed.seeds?.referenceID))",
          type: ArticleTypeEnum(rawValue: "SEED"))
        inputAttributes = InterventionInputAttributes(
          marketingAuthorizationNumber: nil,
          article: article,
          quantity: seed.quantity as! Double,
          unit: ArticleAllUnitEnum(rawValue: seed.unit!)!,
          unitPrice: nil)
        inputsAttributes.append(inputAttributes)
      case is InterventionPhytosanitaries:
        let phyto = input as! InterventionPhytosanitaries
        let article = InterventionArticleAttributes(
          id: "\(String(describing: phyto.phytos?.ekyID))",
          referenceId: "\(String(describing: phyto.phytos?.referenceID))",
          type: ArticleTypeEnum(rawValue: "CHEMICAL"))
        inputAttributes = InterventionInputAttributes(
          marketingAuthorizationNumber: phyto.phytos?.maaID,
          article: article,
          quantity: phyto.quantity as! Double,
          unit: ArticleAllUnitEnum(rawValue: phyto.unit!)!,
          unitPrice: nil)
        inputsAttributes.append(inputAttributes)
      case is InterventionFertilizers:
        let fertilizer = input as! InterventionFertilizers
        let article = InterventionArticleAttributes(
          id: "\(String(describing: fertilizer.fertilizers?.ekyID))",
          referenceId: "\(String(describing: fertilizer.fertilizers?.referenceID))",
          type: ArticleTypeEnum(rawValue: "FERTILIZER"))
        inputAttributes = InterventionInputAttributes(
          marketingAuthorizationNumber: nil,
          article: article,
          quantity: fertilizer.quantity as! Double,
          unit: ArticleAllUnitEnum(rawValue: fertilizer.unit!)!,
          unitPrice: nil)
        inputsAttributes.append(inputAttributes)
      case is InterventionMaterials:
        let material = input as! InterventionMaterials
        let article = InterventionArticleAttributes(
          id: "\(String(describing: material.materials?.ekyID))",
          referenceId: "\(String(describing: material.materials?.materialID))",
          type: ArticleTypeEnum(rawValue: "MATERIAL"))
        inputAttributes = InterventionInputAttributes(
          marketingAuthorizationNumber: nil,
          article: article,
          quantity: material.quantity as! Double,
          unit: ArticleAllUnitEnum(rawValue: material.unit!)!,
          unitPrice: nil)
        inputsAttributes.append(inputAttributes)
      default:
        print("No type")
      }
    }
    return inputsAttributes
  }

  func defineHarvestAttributesFrom(intervention: Interventions) -> [InterventionOutputAttributes] {
    let harvests = intervention.harvests
    var harvestsAttributes = [InterventionOutputAttributes]()
    for harvest in harvests! {
      let harvest = harvest as! Harvests
      let loads = HarvestLoadAttributes(
        quantity: harvest.quantity,
        netQuantity: nil,
        unit: HarvestLoadUnitEnum(rawValue: harvest.unit!),
        number: harvest.number,
        storageId: "\(String(describing: harvest.storages))")
      let harvestAttributes = InterventionOutputAttributes(
        quantity: nil,
        nature: InterventionOutputTypeEnum(rawValue: harvest.type!.uppercased()),
        unit: nil,
        approximative: nil,
        loads: [loads])

      harvestsAttributes.append(harvestAttributes)
    }
    return harvestsAttributes
  }

  func defineEquipmentAttributesFrom(intervention: Interventions) -> [InterventionToolAttributes] {
    let equipments = intervention.interventionEquipments
    var equipmentsAttributes = [InterventionToolAttributes]()

    for equipment in equipments! {
      let equipmentID = (equipment as! InterventionEquipments).equipments?.ekyID
      let equipmentAttributes = InterventionToolAttributes(equipmentId: "\(String(describing: equipmentID))")

      equipmentsAttributes.append(equipmentAttributes)
    }
    return equipmentsAttributes
  }

  func defineOperatorAttributesFrom(intervention: Interventions) -> [InterventionOperatorAttributes] {
    let doers = intervention.doers
    var operatorsAttributes = [InterventionOperatorAttributes]()

    for doer in doers! {
      let personID = (doer as! Doers).entities?.ekyID
      let role = (doer as! Doers).isDriver
      let operatorAttributes = InterventionOperatorAttributes(
        personId: "\(String(describing: personID))",
        role: (role ? OperatorRoleEnum(rawValue: "DRIVER") : OperatorRoleEnum(rawValue: "OPERATOR")))

      operatorsAttributes.append(operatorAttributes)
    }
    return operatorsAttributes
  }

  func defineWeatherAttributesFrom(intervention: Interventions) -> WeatherAttributes {
    var weather = WeatherAttributes()

    weather.temperature = intervention.weather?.temperature as? Double
    weather.windSpeed = intervention.weather?.windSpeed as? Double
    weather.description = (intervention.weather?.weatherDescription).map { WeatherEnum(rawValue: $0) }
    return weather
  }

  func pushIntervention(intervention: Interventions) {
    let mutation = PushInterMutation(
      farmId: intervention.farmID!,
      procedure: InterventionTypeEnum(rawValue: intervention.type!.uppercased())!,
      cropList: defineTargetAttributesFrom(intervention: intervention),
      workingDays: defineWorkingDayAttributesFrom(intervention: intervention),
      waterQuantity: Int(intervention.waterQuantity),
      waterUnit: InterventionWaterVolumeUnitEnum(rawValue: intervention.waterUnit ?? "LITER"),
      inputs: defineInputsAttributesFrom(intervention: intervention),
      outputs: defineHarvestAttributesFrom(intervention: intervention),
      globalOutputs: false,
      tools: defineEquipmentAttributesFrom(intervention: intervention),
      operators: defineOperatorAttributesFrom(intervention: intervention),
      weather: defineWeatherAttributesFrom(intervention: intervention),
      description: intervention.infos)
  }
}