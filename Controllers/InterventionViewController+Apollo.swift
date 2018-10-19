//
//  InterventionViewController+Apollo.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 19/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import Apollo
import CoreData
/*
extension InterventionViewController {

  func checkLocalData() {
    initializeApolloClient()

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBefore") {
      loadRegisteredInputs()
    }
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

  func initializeApolloClient() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let url = URL(string: "https://api.ekylibre-test.com/v1/graphql")!
    let configuation = URLSessionConfiguration.default
    let authService = AuthentificationService(username: "", password: "")
    let token = authService.oauth2.accessToken!

    configuation.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    appDelegate.apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuation))
  }

  func queryFarms(endResult: @escaping (_ success: Bool) -> ()) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let apollo = appDelegate.apollo!
    let query = FarmQuery(modifiedSince: defineLastSynchronisationDate())

    apollo.fetch(query: query) { result, error in
      if let error = error {
        print("Error: \(error)")
        endResult(false)
        return
      } else if let error = result?.errors {
        print("Error: \(error)")
      }

      guard let farms = result?.data?.farms else { print("Could not retrieve farms"); return }
      if UserDefaults.isFirstLaunch() {
        self.saveFarms(farms)
        self.saveCrops(crops: farms.first!.crops)
        self.loadEquipments()
        self.loadStorage()
        self.loadPeople { (success) -> Void in
          if success {
            self.loadIntervention(onCompleted: { (success) -> Void in
              endResult(success)
            })
          } else {
            endResult(false)
          }
        }
      } else {
        self.registerFarmID()
        self.checkCropsData(crops: farms.first!.crops)
        self.loadEquipments()
        self.loadStorage()
        self.loadPeople { (success) -> Void in
          if success {
            self.loadIntervention(onCompleted: { (success) -> Void in
              endResult(success)
            })
          } else {
            endResult(false)
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

  // MARK: - Farms

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

  // MARK: - Crops

  private func saveCrops(crops: [FarmQuery.Data.Farm.Crop]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    for crop in crops {
      let newCrop = Crops(context: managedContext)

      newCrop.uuid = UUID(uuidString: crop.uuid)
      newCrop.plotName = crop.name
      newCrop.productionMode = crop.productionMode
      newCrop.provisionalYield = crop.provisionalYield
      newCrop.species = crop.species.rawValue
      newCrop.startDate = dateFormatter.date(from: crop.startDate!)
      newCrop.startDate = dateFormatter.date(from: crop.stopDate!)
      let splitString = crop.surfaceArea.split(separator: " ", maxSplits: 1)
      let surfaceArea = Float(splitString.first!)!
      newCrop.surfaceArea = surfaceArea
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func checkCropsData(crops : [FarmQuery.Data.Farm.Crop]) {
    for crop in crops {
      let localCrop = fetchCrop(uuid: crop.uuid)

      if let localCrop = localCrop {
        updateCrop(local: localCrop, updated: crop)
      } else {
        insertCrop(crop)
      }
    }
  }

  private func fetchCrop(uuid: String) -> Crops? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    var crops = [Crops]()
    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crops> = Crops.fetchRequest()
    let predicate = NSPredicate(format: "uuid == %@", uuid)
    cropsFetchRequest.predicate = predicate

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return crops.first
  }

  private func updateCrop(local: Crops, updated: FarmQuery.Data.Farm.Crop) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    local.plotName = updated.name
    local.productionMode = updated.productionMode
    local.provisionalYield = updated.provisionalYield
    local.species = updated.species.rawValue
    local.startDate = dateFormatter.date(from: updated.startDate!)
    local.startDate = dateFormatter.date(from: updated.stopDate!)
    let splitString = updated.surfaceArea.split(separator: " ", maxSplits: 1)
    let surfaceArea = Float(splitString.first!)!
    local.surfaceArea = surfaceArea

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func insertCrop(_ new: FarmQuery.Data.Farm.Crop) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let crop = Crops(context: managedContext)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    crop.uuid = UUID(uuidString: new.uuid)
    crop.plotName = new.name
    crop.productionMode = new.productionMode
    crop.provisionalYield = new.provisionalYield
    crop.species = new.species.rawValue
    crop.startDate = dateFormatter.date(from: new.startDate!)
    crop.startDate = dateFormatter.date(from: new.stopDate!)
    let splitString = new.surfaceArea.split(separator: " ", maxSplits: 1)
    let surfaceArea = Float(splitString.first!)!
    crop.surfaceArea = surfaceArea

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Articles

  private func saveArticles(articles: [FarmQuery.Data.Farm.Article]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for article in articles {
      switch article.type.rawValue {
      case "SEED":
        saveSeed(managedContext, article)
      case "CHEMICAL":
        savePhyto(managedContext, article)
      case "FERTILIZER":
        saveFertilizer(managedContext, article)
      case "MATERIAL":
        saveMaterial(managedContext, article)
      default:
        fatalError(article.type.rawValue + ": Unknown value of TypeEnum")
      }
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func saveSeed(_ managedContext: NSManagedObjectContext, _ article: FarmQuery.Data.Farm.Article) {
    if article.referenceId != nil {
      var seeds: [Seeds]
      let seedsFetchRequest: NSFetchRequest<Seeds> = Seeds.fetchRequest()
      let predicate = NSPredicate(format: "referenceID == %d", article.referenceId!)
      seedsFetchRequest.predicate = predicate

      do {
        seeds = try managedContext.fetch(seedsFetchRequest)
        seeds.first?.ekyID = Int32(article.id)!
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    } else {
      let seed = Seeds(context: managedContext)

      seed.registered = false
      seed.ekyID = Int32(article.id)!
      seed.variety = (article.variety == nil) ? article.name : article.variety
      seed.specie = article.species?.rawValue
      seed.unit = article.unit.rawValue
      seed.used = false
    }
  }

  private func savePhyto(_ managedContext: NSManagedObjectContext, _ article: FarmQuery.Data.Farm.Article) {
    if article.referenceId != nil {
      var phytos: [Phytos]
      let phytosFetchRequest: NSFetchRequest<Phytos> = Phytos.fetchRequest()
      let predicate = NSPredicate(format: "referenceID == %d", article.referenceId!)
      phytosFetchRequest.predicate = predicate

      do {
        phytos = try managedContext.fetch(phytosFetchRequest)
        phytos.first?.ekyID = Int32(article.id)!
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    } else {
      let phyto = Phytos(context: managedContext)

      phyto.registered = false
      phyto.ekyID = Int32(article.id)!
      phyto.name = article.name
      phyto.unit = article.unit.rawValue
      phyto.used = false
    }
  }

  private func saveFertilizer(_ managedContext: NSManagedObjectContext, _ article: FarmQuery.Data.Farm.Article) {
    if article.referenceId != nil {
      var fertilizers: [Fertilizers]
      let fertilizersFetchRequest: NSFetchRequest<Fertilizers> = Fertilizers.fetchRequest()
      let predicate = NSPredicate(format: "referenceID == %d", article.referenceId!)
      fertilizersFetchRequest.predicate = predicate

      do {
        fertilizers = try managedContext.fetch(fertilizersFetchRequest)
        fertilizers.first?.ekyID = Int32(article.id)!
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    } else {
      let fertilizer = Fertilizers(context: managedContext)

      fertilizer.registered = false
      fertilizer.ekyID = Int32(article.id)!
      fertilizer.name = article.name
      fertilizer.unit = article.unit.rawValue
      fertilizer.used = false
    }
  }

  private func saveMaterial(_ managedContext: NSManagedObjectContext, _ article: FarmQuery.Data.Farm.Article) {
    let material = Materials(context: managedContext)

    material.name = article.name
    material.ekyID = Int32(article.id)!
    material.unit = article.unit.rawValue
  }

  private func checkArticlesData(articles : [FarmQuery.Data.Farm.Article]) {
    let types = ["SEED": "Seeds", "CHEMICAL": "Phytos", "FERTILIZER": "Fertilizers", "MATERIAL": "Materials"]

    for article in articles {
      let type = types[article.type.rawValue]!
      let localArticle = fetchArticle(type: type, ekyID: article.id)

      if let localArticle = localArticle {
        updateArticle(local: localArticle, updated: article)
      } else {
        insertArticle(type, article)
      }
    }
  }

  private func fetchArticle(type: String, ekyID: String) -> NSManagedObject? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    var articles = [NSManagedObject]()
    let managedContext = appDelegate.persistentContainer.viewContext
    let articlesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: type)
    let predicate = NSPredicate(format: "ekyID == %@", ekyID)
    articlesFetchRequest.predicate = predicate

    do {
      articles = try managedContext.fetch(articlesFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return articles.first
  }

  private func updateArticle(local: NSManagedObject, updated: FarmQuery.Data.Farm.Article) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    if local is Seeds {
      return
    } else {
      local.setValue(updated.name, forKey: "name")
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func insertArticle(_ type: String, _ new: FarmQuery.Data.Farm.Article) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let articleEntity = NSEntityDescription.entity(forEntityName: type, in: managedContext)!
    let article = NSManagedObject(entity: articleEntity, insertInto: managedContext)
    let variety = (new.variety == nil) ? new.name : new.variety

    if new.type.rawValue != "MATERIAL" {
      article.setValue((new.referenceId != nil), forKey: "registered")
    }

    article.setValue(Int(new.id), forKey: "ekyID")
    article.setValue(new.unit.rawValue, forKey: "unit")
    article.setValue(false, forKey: "used")

    if new.referenceId != nil {
      article.setValue(Int(new.referenceId!), forKey: "referenceID")
    }

    if new.type.rawValue == "SEED" {
      article.setValue(new.species?.rawValue, forKey: "specie")
      article.setValue(variety, forKey: "variety")
    } else if new.type.rawValue == "CHEMICAL"{
      article.setValue(new.name, forKey: "name")
      article.setValue(new.marketingAuthorizationNumber, forKey: "maaID")
    } else {
      article.setValue(new.name, forKey: "name")
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - (Temporary)

  func updateInterventionStatus(fetchedIntervention: InterventionQuery.Data.Farm.Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionFetchRequest: NSFetchRequest<Interventions> = Interventions.fetchRequest()
    let predicate = NSPredicate(format: "ekyID == %@", fetchedIntervention.id)

    interventionFetchRequest.predicate = predicate

    do {
      let intervention = try managedContext.fetch(interventionFetchRequest)

      if intervention.count > 0 {
        intervention.first?.status = (fetchedIntervention.validatedAt == nil ? Intervention.Status.Synchronised : Intervention.Status.Validated).rawValue
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Could not fetch or save. \(error), \(error.userInfo)")
    }
  }

  func loadIntervention(onCompleted: @escaping ((_ success: Bool) -> ())) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let group = DispatchGroup()

    group.enter()
    appDelegate.apollo?.fetch(query: InterventionQuery(modifiedSince: defineLastSynchronisationDate())) { (result, error) in
      guard let farms = result?.data?.farms else {
        print("Could not retrieve interventions")
        group.leave()
        onCompleted(false)
        return
      }

      for farm in farms {
        for intervention in farm.interventions {
          if self.checkIfNewIntervention(interventionID: (intervention.id as NSString).intValue) {
            self.saveIntervention(fetchedIntervention: intervention, farmID: farm.id)
          }
          self.updateInterventionStatus(fetchedIntervention: intervention)
        }
      }
      group.leave()
    }

    group.notify(queue: DispatchQueue.main) {
      let _ = appDelegate.apollo?.clearCache()
      onCompleted(true)
    }
  }

  func defineLastSynchronisationDate() -> String? {
    let dateFormatter = DateFormatter()

    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    let date = UserDefaults.standard.value(forKey: "lastSyncDate") as? Date
    var lastSyncDate: String?

    if date != nil {
      lastSyncDate = dateFormatter.string(from: date!)
    }
    return lastSyncDate
  }

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

    appDelegate.apollo?.fetch(query: FarmQuery(modifiedSince: defineLastSynchronisationDate())) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve farms."); return }

      for farm in farms {
        for equipment in farm.equipments {
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

    appDelegate.apollo?.fetch(query: FarmQuery(modifiedSince: defineLastSynchronisationDate())) { (result, error) in
      guard let farms = result?.data?.farms else {
        print("Could not retrieve farms.")
        completion(false)
        return
      }

      for farm in farms {
        for person in farm.people {
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

    appDelegate.apollo?.fetch(query: FarmQuery(modifiedSince: defineLastSynchronisationDate())) { (result, error) in
      guard let farms = result?.data?.farms else { print("Could not retrieve farms."); return }

      for farm in farms {
        for storage in farm.storages {
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
      print("Unknown value of TypeEnum")
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
      intervention.workingPeriods = saveWorkingDays(fetchedDay: workingDay)
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
    intervention.type = fetchedIntervention.type.rawValue
    intervention.infos = fetchedIntervention.description
    intervention.waterUnit = fetchedIntervention.waterUnit?.rawValue.lowercased().localized
    intervention.weather = saveWeatherInIntervention(fetchedIntervention: fetchedIntervention, intervention: intervention) as? Weather
    intervention = saveEntitiesIntoIntervention(intervention: intervention, fetchedIntervention: fetchedIntervention)
    intervention.status = (fetchedIntervention.validatedAt == nil ? Intervention.Status.Synchronised : Intervention.Status.Validated).rawValue
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


  // MARK: - Update interventions

  func defineWorkingDayAttributesFrom(intervention: Interventions) -> [InterventionWorkingDayAttributes] {
    let workingDays = intervention.workingPeriods
    let formatter = DateFormatter()

    formatter.dateFormat = "yyyy-MM-dd"
    let workingDayAttributes = InterventionWorkingDayAttributes(executionDate: formatter.string(from: (workingDays?.executionDate)!), hourDuration: Double((workingDays?.hourDuration)!))
    return [workingDayAttributes]
  }

  func defineTargetAttributesFrom(intervention: Interventions) -> [InterventionTargetAttributes] {
    let targets = intervention.targets
    var targetsAttributes = [InterventionTargetAttributes]()

    for target in targets! {
      let target = target as! Targets
      let targetAttributes = InterventionTargetAttributes(
        cropId: (target.crops?.uuid)?.uuidString,
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

  func appendInputAttributes(id: String?, referenceID: String?, type: ArticleTypeEnum?, quantity: Double, unit: String, maa: String?) -> InterventionInputAttributes {
    let article = InterventionArticleAttributes(
      id: id,
      referenceId: referenceID,
      type: type)
    let inputAttributes = InterventionInputAttributes(
      marketingAuthorizationNumber: nil,
      article: article,
      quantity: quantity,
      unit: ArticleAllUnitEnum(rawValue: unit)!,
      unitPrice: nil)
    return inputAttributes
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
      switch input {
      case is InterventionSeeds:
        let seed = input as! InterventionSeeds
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if seed.seeds?.ekyID == 0 {
          referenceId = (seed.seeds?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "SEED")
        } else {
          id = (seed.seeds?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: seed.quantity as! Double, unit: seed.unit!.uppercased(), maa: nil))
      case is InterventionPhytosanitaries:
        let phyto = input as! InterventionPhytosanitaries
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if phyto.phytos?.ekyID == 0 {
          referenceId = (phyto.phytos?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "CHEMICAL")
        } else {
          id = (phyto.phytos?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: phyto.quantity as! Double, unit: phyto.unit!.uppercased(), maa: phyto.phytos?.maaID))
      case is InterventionFertilizers:
        let fertilizer = input as! InterventionFertilizers
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if fertilizer.fertilizers?.ekyID == 0 {
          referenceId = (fertilizer.fertilizers?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "FERTILIZER")
        } else {
          id = (fertilizer.fertilizers?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: fertilizer.quantity as! Double, unit: fertilizer.unit!.uppercased(), maa: "0"))
      case is InterventionMaterials:
        let material = input as! InterventionMaterials
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if material.materials?.ekyID == 0 {
          referenceId = (material.materials?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "MATERIAL")
        } else {
          id = (material.materials?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: material.quantity as! Double, unit: material.unit!.uppercased(), maa: nil))
      default:
        print("No type")
      }
    }
    return inputsAttributes
  }

  func defineHarvestAttribuesFrom(intervention: Interventions) -> [InterventionOutputAttributes] {
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
        nature: InterventionOutputTypeEnum(rawValue: harvest.type!),
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
      let equipmentAttributes = InterventionToolAttributes(equipmentId: (equipmentID as NSNumber?)?.stringValue)

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
        personId: (personID as NSNumber?)?.stringValue,
        role: (role ? OperatorRoleEnum(rawValue: "DRIVER") : OperatorRoleEnum(rawValue: "OPERATOR")))

      operatorsAttributes.append(operatorAttributes)
    }
    return operatorsAttributes
  }

  func defineWeatherAttributesFrom(intervention: Interventions) -> WeatherAttributes {
    var weather = WeatherAttributes()

    weather.temperature = intervention.weather?.temperature as? Double
    weather.windSpeed = intervention.weather?.windSpeed as? Double
    weather.description = (intervention.weather?.weatherDescription?.uppercased()).map { WeatherEnum(rawValue: $0) }
    return weather
  }

  func pushUpdatedIntervention(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let group = DispatchGroup()
    let apollo = appDelegate.apollo
    let _ = apollo?.clearCache()
    let updateMutation = UpdateInterMutation(
      interventionId: String(intervention.ekyID),
      farmId: intervention.farmID!,
      procedure: InterventionTypeEnum(rawValue: intervention.type!)!,
      cropList: defineTargetAttributesFrom(intervention: intervention),
      workingDays: defineWorkingDayAttributesFrom(intervention: intervention),
      waterQuantity: intervention.type == "IRRIGATION" ? Int(intervention.waterQuantity) : nil,
      waterUnit: intervention.type == "IRRIGATION" ? ArticleVolumeUnitEnum(rawValue: intervention.waterUnit!) : nil,
      inputs: defineInputsAttributesFrom(intervention: intervention),
      outputs: defineHarvestAttribuesFrom(intervention: intervention),
      tools: defineEquipmentAttributesFrom(intervention: intervention),
      operators: defineOperatorAttributesFrom(intervention: intervention),
      weather: defineWeatherAttributesFrom(intervention: intervention),
      description: intervention.infos)


    group.enter()
    apollo?.perform(mutation: updateMutation, queue: DispatchQueue.global(), resultHandler: { (error, result) in
      if let error = error?.errors {
        print("Error: \(String(describing: error))")
      }
      group.leave()
    })
    group.wait()
  }
}
*/
