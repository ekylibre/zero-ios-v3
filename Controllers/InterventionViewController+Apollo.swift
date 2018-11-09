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

extension InterventionViewController {

  // MARK: - Initialization

  func checkLocalData() {
    initializeApolloClient()

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBefore") {
      loadRegisteredInputs()
    }
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

  private func initializeApolloClient() {
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

    apollo.fetch(query: FarmQuery(modifiedSince: defineLastSynchronisationDate())) { result, error in
      if let error = error {
        print("Error: \(error)")
        endResult(false)
        return
      } else if let resultError = result?.errors {
        print("Result Error: \(resultError)")
        endResult(false)
        return
      }

      guard let farms = result?.data?.farms else { print("Could not retrieve farms"); return }
      if UserDefaults.isFirstLaunch() {
        self.saveFarms(farms)
        self.saveCrops(crops: farms.first!.crops)
        self.saveArticles(articles: farms.first!.articles)
        self.loadEquipments()
        self.loadStorage()
        self.loadPersons { (success) -> Void in
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
        self.checkArticlesData(articles: farms.first!.articles)
        self.loadEquipments()
        self.loadStorage()
        self.loadPersons { (success) -> Void in
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
    let farmsFetchRequest: NSFetchRequest<Farm> = Farm.fetchRequest()

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
      let newFarm = Farm(context: managedContext)

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
      let newCrop = Crop(context: managedContext)

      newCrop.uuid = UUID(uuidString: crop.uuid)
      newCrop.plotName = crop.name
      newCrop.productionMode = crop.productionMode
      newCrop.provisionalYield = crop.provisionalYield
      newCrop.species = crop.species.rawValue
      newCrop.startDate = dateFormatter.date(from: crop.startDate!)
      newCrop.stopDate = dateFormatter.date(from: crop.stopDate!)
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

  private func fetchCrop(uuid: String) -> Crop? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    var crops = [Crop]()
    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crop> = Crop.fetchRequest()
    let predicate = NSPredicate(format: "uuid == %@", uuid)
    cropsFetchRequest.predicate = predicate

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return crops.first
  }

  private func updateCrop(local: Crop, updated: FarmQuery.Data.Farm.Crop) {
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
    local.stopDate = dateFormatter.date(from: updated.stopDate!)
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
    let crop = Crop(context: managedContext)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    crop.uuid = UUID(uuidString: new.uuid)
    crop.plotName = new.name
    crop.productionMode = new.productionMode
    crop.provisionalYield = new.provisionalYield
    crop.species = new.species.rawValue
    crop.startDate = dateFormatter.date(from: new.startDate!)
    crop.stopDate = dateFormatter.date(from: new.stopDate!)
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

  private func pushInput(input: NSManagedObject, type: ArticleTypeEnum, unit: ArticleUnitEnum) -> Int32 {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let group = DispatchGroup()
    let mutation = PushArticleMutation(farmId: farmID, unit: unit, name: input.value(forKey: "name") as! String, type: type)
    let _ = apollo.clearCache()

    print("\nInput: \(input)")
    print("\nType: \(type)")
    print("\nUnit: \(unit)")
    group.enter()
    apollo.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else {
        if let dataError = result?.data?.createArticle?.errors {
          print("Data error: \(dataError)")
        } else {
          id = Int32(result!.data!.createArticle!.article!.id)!
        }
      }
      group.leave()
    })
    group.wait()
    return id
  }

  private func pushSeed(seed: Seed) -> Int32{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let group = DispatchGroup()
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let _ = apollo.clearCache()
    let mutation = PushArticleMutation(
      farmId: farmID,
      unit: ArticleUnitEnum.kilogram,
      name: seed.variety!,
      type: ArticleTypeEnum.seed,
      specie: SpecieEnum(rawValue: seed.specie!),
      variety: seed.variety)

    group.enter()
    apollo.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else {
        if let dataError = result?.data?.createArticle?.errors {
          print("Data error: \(dataError)")
        } else {
          id = Int32(result!.data!.createArticle!.article!.id)!
        }
      }
      group.leave()
    })
    group.wait()
    return id
  }

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
      var seeds: [Seed]
      let seedsFetchRequest: NSFetchRequest<Seed> = Seed.fetchRequest()
      let predicate = NSPredicate(format: "referenceID == %d", Int32(article.referenceId!)!)
      seedsFetchRequest.predicate = predicate

      do {
        seeds = try managedContext.fetch(seedsFetchRequest)
        seeds.first?.ekyID = Int32(article.id)!
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    } else {
      let seed = Seed(context: managedContext)

      seed.registered = false
      seed.referenceID =  0
      seed.ekyID = Int32(article.id)!
      seed.variety = (article.variety == nil) ? article.name : article.variety
      seed.specie = article.species?.rawValue
      seed.unit = article.unit.rawValue
      seed.used = false
    }
  }

  private func savePhyto(_ managedContext: NSManagedObjectContext, _ article: FarmQuery.Data.Farm.Article) {
    if article.referenceId != nil {
      var phytos: [Phyto]
      let phytosFetchRequest: NSFetchRequest<Phyto> = Phyto.fetchRequest()
      let predicate = NSPredicate(format: "referenceID == %d", Int32(article.referenceId!)!)
      phytosFetchRequest.predicate = predicate

      do {
        phytos = try managedContext.fetch(phytosFetchRequest)
        phytos.first?.ekyID = Int32(article.id)!
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    } else {
      let phyto = Phyto(context: managedContext)

      phyto.registered = false
      phyto.referenceID = 0
      phyto.ekyID = Int32(article.id)!
      phyto.name = article.name
      phyto.unit = article.unit.rawValue
      phyto.used = false
    }
  }

  private func saveFertilizer(_ managedContext: NSManagedObjectContext, _ article: FarmQuery.Data.Farm.Article) {
    if article.referenceId != nil {
      var fertilizers: [Fertilizer]
      let fertilizersFetchRequest: NSFetchRequest<Fertilizer> = Fertilizer.fetchRequest()
      let predicate = NSPredicate(format: "referenceID == %d", Int32(article.referenceId!)!)
      fertilizersFetchRequest.predicate = predicate

      do {
        fertilizers = try managedContext.fetch(fertilizersFetchRequest)
        fertilizers.first?.ekyID = Int32(article.id)!
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    } else {
      let fertilizer = Fertilizer(context: managedContext)

      fertilizer.registered = false
      fertilizer.referenceID = 0
      fertilizer.ekyID = Int32(article.id)!
      fertilizer.name = article.name
      fertilizer.unit = article.unit.rawValue
      fertilizer.used = false
    }
  }

  private func saveMaterial(_ managedContext: NSManagedObjectContext, _ article: FarmQuery.Data.Farm.Article) {
    let material = Material(context: managedContext)

    material.name = article.name
    material.ekyID = Int32(article.id)!
    material.unit = article.unit.rawValue
    material.referenceID = 0
  }

  private func checkArticlesData(articles : [FarmQuery.Data.Farm.Article]) {
    let types = ["SEED": "Seed", "CHEMICAL": "Phyto", "FERTILIZER": "Fertilizer", "MATERIAL": "Material"]

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

    if local is Seed {
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


  // MARK: - Update

  func defineLastSynchronisationDate() -> String? {
    let dateFormatter = DateFormatter()
    let timezone = TimeZone.current.abbreviation()

    dateFormatter.timeZone = TimeZone(abbreviation: timezone!)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = UserDefaults.standard.value(forKey: "lastSyncDate") as? Date
    var lastSyncDate: String?

    if date != nil {
      lastSyncDate = dateFormatter.string(from: date!)
    }
    return lastSyncDate
  }

  // MARK: - Queries: Equipments

  private func checkIfNewEntity(entityName: String, predicate: NSPredicate) -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return true
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entityFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

    entityFetchRequest.predicate = predicate

    do {
      let entities = try managedContext.fetch(entityFetchRequest)
      if entities.count > 0 {
        return false
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return true
  }

  func defineIndicatorIfOnlyOne(_ indicator: String?) -> [String] {
    let indicatorOne = indicator?.components(separatedBy: ":")

    if indicatorOne!.count > 1 {
      return [indicatorOne![1]]
    }
    return [String]()
  }

  func defineIndicators(_ indicator: String?) -> [String] {
    if indicator == nil {
      return [String]()
    } else if (indicator?.contains("|"))! {
      let indicators = indicator?.split(separator: "|")
      let indicatorOne = indicators?[0].components(separatedBy: ":")[1]
      let indicatorTwo = indicators?[1].components(separatedBy: ":")[1]
      var returnIndicator = [String]()

      returnIndicator.append(indicatorOne!)
      returnIndicator.append(indicatorTwo!)
      return (returnIndicator)
    }
    return defineIndicatorIfOnlyOne(indicator)
  }

  private func saveEquipments(fetchedEquipment: FarmQuery.Data.Farm.Equipment, farmID: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipment = Equipment(context: managedContext)
    let indicators = defineIndicators(fetchedEquipment.indicators)

    equipment.farmID = farmID
    equipment.type = fetchedEquipment.type?.rawValue
    equipment.name = fetchedEquipment.name
    equipment.number = fetchedEquipment.number
    equipment.ekyID = (fetchedEquipment.id as NSString).intValue
    equipment.indicatorOne = (indicators.count > 0 ? indicators[0] : nil)
    equipment.indicatorTwo = (indicators.count > 1 ? indicators[1] : nil)

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
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else {
        for farm in (result?.data?.farms)! {
          for equipment in farm.equipments {

            let predicate = NSPredicate(format: "ekyID == %d", (equipment.id as NSString).intValue)

            if self.checkIfNewEntity(entityName: "Equipment", predicate: predicate) {
              self.saveEquipments(fetchedEquipment: equipment, farmID: farm.id)
            }
          }
        }
      }
    }
  }

  // MARK: Persons

  private func savePersons(fetchedPerson: FarmQuery.Data.Farm.Person, farmID: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let person = Person(context: managedContext)

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

  func loadPersons(completion: @escaping (_ success: Bool) -> Void) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    appDelegate.apollo?.fetch(query: FarmQuery(modifiedSince: defineLastSynchronisationDate())) { (result, error) in
      if let error = error {
        print("Error: \(error)")
        completion(false)
        return
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
        completion(false)
        return
      } else {
        for farm in (result?.data?.farms)! {
          for person in farm.people {
            let predicate = NSPredicate(format: "ekyID == %d", (person.id as NSString).intValue)

            if self.checkIfNewEntity(entityName: "Person", predicate: predicate) {
              self.savePersons(fetchedPerson: person, farmID: farm.id)
            }
          }
        }
      }
    }
    completion(true)
  }

  // MARK: Storages

  private func pushStorages(storage: Storage) -> Int32 {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let group = DispatchGroup()
    let _ = apollo.clearCache()
    let mutation = PushStorageMutation(
      farmId: farmID,
      type: storage.type.map { StorageTypeEnum(rawValue: $0) }!,
      name: storage.name!)

    group.enter()
    apollo.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("ResultError: \(resultError)")
      } else  {
        if let dataError = result?.data?.createStorage?.errors {
          print("DataError: \(dataError)")
        } else {
          id = Int32(result!.data!.createStorage!.storage!.id)!
        }
      }
      group.leave()
    })
    group.wait()
    return id
  }

  private func saveStorage(fetchedStorage: FarmQuery.Data.Farm.Storage, farmID: String){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let manaedContext = appDelegate.persistentContainer.viewContext
    let storage = Storage(context: manaedContext)

    storage.storageID = (fetchedStorage.id as NSString).intValue
    storage.name = fetchedStorage.name
    storage.type = fetchedStorage.type.rawValue.lowercased()

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
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else {
        let farm = (result?.data?.farms.first)!
        for storage in farm.storages {
          let predicate = NSPredicate(format: "storageID == %d", (storage.id as NSString).intValue)

          if self.checkIfNewEntity(entityName: "Storage", predicate: predicate) {
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

    weather.weatherDescription = fetchedIntervention.weather?.description?.rawValue.lowercased()
    weather.windSpeed = fetchedIntervention.weather?.windSpeed as NSNumber?
    weather.temperature = fetchedIntervention.weather?.temperature as NSNumber?
    weather.interventionID = (fetchedIntervention.id as NSString).intValue as NSNumber?
    weather.intervention = intervention as? Intervention

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return weather
  }

  // MARK: Working Periods

  private func saveWorkingDays(fetchedDay: InterventionQuery.Data.Farm.Intervention.WorkingDay) -> WorkingPeriod {
    let managedContext = appDelegate.persistentContainer.viewContext
    let workingPeriod = WorkingPeriod(context: managedContext)
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

  private func returnEntityIfSame(entityName: String, predicate: NSPredicate) -> NSManagedObject? {
    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

    entitiesFetchRequest.predicate = predicate
    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      if entities.count > 0 {
        return (entities.first as! NSManagedObject)
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func saveEquipmentsToIntervention(fetchedEquipment: InterventionQuery.Data.Farm.Intervention.Tool, intervention: Intervention) -> InterventionEquipment {
    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionEquipment = InterventionEquipment(context: managedContext)
    let predicate = NSPredicate(format: "ekyID == %d", (Int32(fetchedEquipment.equipment!.id)!)) // Warning("Check predicate")
    let equipment = returnEntityIfSame(entityName: "Equipment", predicate: predicate)

    if equipment != nil {
      (equipment as! Equipment).addToInterventionEquipments(interventionEquipment)
      interventionEquipment.intervention = intervention
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return interventionEquipment
  }

  // MARK: Targets

  private func saveTargetToIntervention(fetchedTarget: InterventionQuery.Data.Farm.Intervention.Target, intervention: Intervention) -> Target {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Target()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let target = Target(context: managedContext)
    let predicate = NSPredicate(format: "uuid == %@", fetchedTarget.crop.uuid)
    let crop = returnEntityIfSame(entityName: "Crop", predicate: predicate)

    if crop != nil {
      target.workAreaPercentage = Int16(fetchedTarget.workingPercentage)
      target.crop = crop as? Crop
      target.intervention = intervention
    }
    return target
  }

  // MARK: Persons

  private func saveInterventionPersonsToIntervention(fetchedOperator: InterventionQuery.Data.Farm.Intervention.Operator, intervention: Intervention) -> InterventionPerson {
    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionPersons = InterventionPerson(context: managedContext)
    let personID = fetchedOperator.person?.id
    let person: Person?

    if personID != nil {
      let predicate = NSPredicate(format: "ekyID == %d", Int32(personID!)!)

      person = returnEntityIfSame(entityName: "Person", predicate: predicate) as? Person
      if person != nil {
        if fetchedOperator.role?.rawValue == "OPERATOR" {
          interventionPersons.isDriver = false
        } else {
          interventionPersons.isDriver = true
        }
        person?.addToInterventionPersons(interventionPersons)
        interventionPersons.intervention = intervention
      }
    }
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return interventionPersons
  }

  // MARK: Harvests

  private func createLoadIfGlobalOutput(fetchedOutput: InterventionQuery.Data.Farm.Intervention.Output, intervention: Intervention) -> Harvest {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Harvest()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvest = Harvest(context: managedContext)

    harvest.quantity = fetchedOutput.quantity ?? 0
    harvest.type = fetchedOutput.nature.rawValue.lowercased()
    harvest.unit = fetchedOutput.unit?.rawValue.lowercased()
    harvest.number = fetchedOutput.id
    harvest.intervention = intervention

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return harvest
  }

  private func returnStorageIfSame(storageID: Int32?) -> Storage? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let storagesFetchRequest: NSFetchRequest<Storage> = Storage.fetchRequest()

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

  private func saveLoadToIntervention(fetchedLoad: InterventionQuery.Data.Farm.Intervention.Output.Load, intervention: Intervention, nature: String) -> Harvest {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Harvest()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvest = Harvest(context: managedContext)
    let storageID = fetchedLoad.storage?.id
    let storage: Storage?

    if storageID != nil {
      let predicate = NSPredicate(format: "storageID == %d", Int32(storageID!)!)
      storage = returnEntityIfSame(entityName: "Storage", predicate: predicate) as? Storage
      storage?.addToHarvests(harvest)
      harvest.storage = storage
    }
    harvest.intervention = intervention
    harvest.type = nature
    harvest.number = fetchedLoad.number
    harvest.quantity = fetchedLoad.quantity
    harvest.unit = fetchedLoad.unit?.rawValue.lowercased()

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return harvest
  }

  // MARK: Inputs

  private func saveInputsInIntervention(fetchedInput: InterventionQuery.Data.Farm.Intervention.Input, intervention: Intervention) -> Intervention {
    let managedContext = appDelegate.persistentContainer.viewContext
    let id = fetchedInput.article?.id
    let predicate: NSPredicate!

    predicate = (id == nil ? nil : NSPredicate(format: "ekyID == %d", Int32(id!)!))
    switch fetchedInput.article?.type.rawValue {
    case "SEED":
      let interventionSeed = InterventionSeed(context: managedContext)
      let seed = returnEntityIfSame(entityName: "Seed", predicate: predicate)

      interventionSeed.unit = fetchedInput.unit.rawValue
      fetchedInput.quantity != nil ? interventionSeed.quantity = Float(fetchedInput.quantity!) : nil
      interventionSeed.seed = (seed as? Seed)
      interventionSeed.intervention = intervention
      intervention.addToInterventionSeeds(interventionSeed)
    case "FERTILIZER":
      let interventionFertilizer = InterventionFertilizer(context: managedContext)
      let fertilizer = returnEntityIfSame(entityName: "Fertilizer", predicate: predicate)

      interventionFertilizer.unit = fetchedInput.unit.rawValue
      fetchedInput.quantity != nil ? interventionFertilizer.quantity = Float(fetchedInput.quantity!) : nil
      interventionFertilizer.fertilizer = (fertilizer as? Fertilizer)
      interventionFertilizer.intervention =  intervention
      intervention.addToInterventionFertilizers(interventionFertilizer)
    case "CHEMICAL":
      let interventionPhyto = InterventionPhytosanitary(context: managedContext)
      let phyto = returnEntityIfSame(entityName: "Phyto", predicate: predicate)

      interventionPhyto.unit = fetchedInput.unit.rawValue
      fetchedInput.quantity != nil ? interventionPhyto.quantity = Float(fetchedInput.quantity!) : nil
      interventionPhyto.phyto = (phyto as? Phyto)
      interventionPhyto.intervention = intervention
      intervention.addToInterventionPhytosanitaries(interventionPhyto)
    case "MATERIAL":
      let interventionMaterial = InterventionMaterial(context: managedContext)
      let material = returnEntityIfSame(entityName: "Material", predicate: predicate)

      interventionMaterial.unit = fetchedInput.unit.rawValue
      fetchedInput.quantity != nil ? interventionMaterial.quantity = Float(fetchedInput.quantity!) : nil
      interventionMaterial.material = (material as? Material)
      interventionMaterial.intervention = intervention
      intervention.addToInterventionMaterials(interventionMaterial)
    default:
      print("\(String(describing: fetchedInput.article?.type.rawValue)) : Unknown value of TypeEnum")
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return intervention
  }

  // MARK: Intervention

  private func saveEntitiesIntoIntervention(intervention: Intervention, fetchedIntervention: InterventionQuery.Data.Farm.Intervention) -> Intervention {
    for workingDay in fetchedIntervention.workingDays {
      intervention.addToWorkingPeriods(saveWorkingDays(fetchedDay: workingDay))
    }
    for fetchedEquipment in fetchedIntervention.tools! {
      intervention.addToInterventionEquipments(saveEquipmentsToIntervention(fetchedEquipment: fetchedEquipment, intervention: intervention))
    }
    for fetchedOperator in fetchedIntervention.operators! {
      intervention.addToInterventionPersons(saveInterventionPersonsToIntervention(fetchedOperator: fetchedOperator, intervention: intervention))
    }
    for fetchedTarget in fetchedIntervention.targets {
      intervention.addToTargets(saveTargetToIntervention(fetchedTarget: fetchedTarget, intervention: intervention))
    }
    for fetchedOutput in fetchedIntervention.outputs! {
      if fetchedIntervention.globalOutputs! {
        intervention.addToHarvests(createLoadIfGlobalOutput(fetchedOutput: fetchedOutput, intervention: intervention))
      } else {
        for load in fetchedOutput.loads! {
          intervention.addToHarvests(saveLoadToIntervention(fetchedLoad: load, intervention: intervention, nature: fetchedOutput.nature.rawValue.lowercased()))
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
    var intervention = Intervention(context: managedContext)

    intervention.farmID = farmID
    intervention.ekyID = (fetchedIntervention.id as NSString).intValue
    intervention.type = fetchedIntervention.type.rawValue
    intervention.infos = fetchedIntervention.description
    (fetchedIntervention.workingDays.first != nil) ? intervention.addToWorkingPeriods(saveWorkingDays(fetchedDay: fetchedIntervention.workingDays.first!)) : nil
    intervention.waterUnit = fetchedIntervention.waterUnit?.rawValue
    (intervention.type == InterventionType.Irrigation.rawValue) ? intervention.waterQuantity = Float(fetchedIntervention.waterQuantity!) : nil
    intervention.weather = saveWeatherInIntervention(fetchedIntervention: fetchedIntervention, intervention: intervention) as? Weather
    intervention = saveEntitiesIntoIntervention(intervention: intervention, fetchedIntervention: fetchedIntervention)
    intervention.status = (fetchedIntervention.validatedAt == nil ? InterventionState.Synced : InterventionState.Validated).rawValue
    for fetchedInput in fetchedIntervention.inputs! {
      intervention = saveInputsInIntervention(fetchedInput: fetchedInput, intervention: intervention)
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func updateInterventionStatus(fetchedIntervention: InterventionQuery.Data.Farm.Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionFetchRequest: NSFetchRequest<Intervention> = Intervention.fetchRequest()
    let predicate = NSPredicate(format: "ekyID == %@", fetchedIntervention.id)

    interventionFetchRequest.predicate = predicate

    do {
      let intervention = try managedContext.fetch(interventionFetchRequest)

      if intervention.count > 0 {
        intervention.first?.status = Int16((fetchedIntervention.validatedAt == nil ? InterventionState.Synced : InterventionState.Validated).rawValue)
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Could not fetch or save. \(error), \(error.userInfo)")
    }
  }

  func updateEquipments(fetchedIntervention: InterventionQuery.Data.Farm.Intervention, intervention: Intervention) {
    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsFetchRequest: NSFetchRequest<InterventionEquipment> = InterventionEquipment.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", intervention)

    equipmentsFetchRequest.predicate = predicate
    do {
      let equipments = try managedContext.fetch(equipmentsFetchRequest)

      for equipment in equipments {
        managedContext.delete(equipment)
      }
      for fetchedEquipment in fetchedIntervention.tools! {
        intervention.addToInterventionEquipments(saveEquipmentsToIntervention(fetchedEquipment: fetchedEquipment, intervention: intervention))
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  func updatePersons(fetchedIntervention: InterventionQuery.Data.Farm.Intervention, intervention: Intervention) {
    let managedContext = appDelegate.persistentContainer.viewContext
    let personsFetchRequest: NSFetchRequest<InterventionPerson> = InterventionPerson.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", intervention)

    personsFetchRequest.predicate = predicate
    do {
      let persons = try managedContext.fetch(personsFetchRequest)

      for person in persons {
        managedContext.delete(person)
      }
      for fetchedPerson in fetchedIntervention.operators! {
        intervention.addToInterventionPersons(saveInterventionPersonsToIntervention(fetchedOperator: fetchedPerson, intervention: intervention))
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  func deleteInterventionInputs(_ entityName: String, intervention: Intervention) {
    let managedContext = appDelegate.persistentContainer.viewContext
    let inputsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let predicate = NSPredicate(format: "intervention == %@", intervention)

    inputsFetchRequest.predicate = predicate

    do {
      let inputs = try managedContext.fetch(inputsFetchRequest)

      for input in inputs {
        managedContext.delete(input as! NSManagedObject)
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  func updateInputs(fetchedIntervention: InterventionQuery.Data.Farm.Intervention, intervention: inout Intervention) {
    deleteInterventionInputs("InterventionSeed", intervention: intervention)
    deleteInterventionInputs("InterventionPhytosanitary", intervention: intervention)
    deleteInterventionInputs("InterventionFertilizer", intervention: intervention)
    deleteInterventionInputs("InterventionMaterial", intervention: intervention)
    for fetchedInput in fetchedIntervention.inputs! {
      intervention = saveInputsInIntervention(fetchedInput: fetchedInput, intervention: intervention)
    }
  }

  func updateIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention) {
    let predicate = NSPredicate(format: "ekyID == %d", Int32(fetchedIntervention.id)!)
    var intervention = returnEntityIfSame(entityName: "Intervention", predicate: predicate) as? Intervention

    if intervention != nil {
      (fetchedIntervention.workingDays.first != nil) ? intervention?.addToWorkingPeriods(saveWorkingDays(fetchedDay: fetchedIntervention.workingDays.first!)) : nil
      intervention?.weather?.temperature = fetchedIntervention.weather?.temperature as NSNumber?
      intervention?.weather?.windSpeed = fetchedIntervention.weather?.windSpeed as NSNumber?
      intervention?.weather?.weatherDescription = (fetchedIntervention.weather?.description).map { $0.rawValue }
      intervention?.infos = fetchedIntervention.description
      intervention?.type = fetchedIntervention.type.rawValue
      intervention?.status = Int16((fetchedIntervention.validatedAt == nil ? InterventionState.Synced : InterventionState.Validated).rawValue)
      updateEquipments(fetchedIntervention: fetchedIntervention, intervention: intervention!)
      updatePersons(fetchedIntervention: fetchedIntervention, intervention: intervention!)
      updateInputs(fetchedIntervention: fetchedIntervention, intervention: &intervention!)
    }
  }

  func loadIntervention(onCompleted: @escaping ((_ success: Bool) -> ())) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let group = DispatchGroup()

    group.enter()
    let date = defineLastSynchronisationDate()
    let query = InterventionQuery(modifiedSince: date)
    let _ = appDelegate.apollo?.clearCache()

    appDelegate.apollo?.fetch(query: query, resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
        onCompleted(false)
        return
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
        onCompleted(false)
        return
      } else {
        let farm = (result?.data?.farms.first)!
        for intervention in farm.interventions {
          let predicate = NSPredicate(format: "ekyID == %d", (intervention.id as NSString).intValue)

          if self.checkIfNewEntity(entityName: "Intervention", predicate: predicate) {
            self.saveIntervention(fetchedIntervention: intervention, farmID: farm.id)
            self.updateInterventionStatus(fetchedIntervention: intervention)
          }
        }
      }
      group.leave()
    })

    group.notify(queue: DispatchQueue.main) {
      let _ = appDelegate.apollo?.clearCache()
      onCompleted(true)
    }
  }

  func updateInterventionIfChangedOnApi() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let group = DispatchGroup()

    group.enter()
    let date = defineLastSynchronisationDate()
    let query = InterventionQuery(modifiedSince: date)
    let _ = appDelegate.apollo?.clearCache()

    appDelegate.apollo?.fetch(query: query, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else {
        let farm = (result?.data?.farms.first)!
        for intervention in farm.interventions {
          self.updateIntervention(fetchedIntervention: intervention)
        }
      }
      group.leave()
    })
    group.wait()
  }

  // MARK: - Mutations: Interventions

  func defineWorkingDayAttributesFrom(intervention: Intervention) -> [InterventionWorkingDayAttributes] {
    let workingPeriod = (intervention.workingPeriods?.allObjects.first as! WorkingPeriod)
    var workingDaysAttributes = [InterventionWorkingDayAttributes]()
    let executionDate = workingPeriod.executionDate
    let formatter = DateFormatter()

    formatter.dateFormat = "yyyy-MM-dd"
    if executionDate != nil {
      let workingDayAttributes = InterventionWorkingDayAttributes(
        executionDate: formatter.string(from: executionDate!),
        hourDuration: Double(workingPeriod.hourDuration))

      workingDaysAttributes.append(workingDayAttributes)
    }
    return workingDaysAttributes
  }

  func defineTargetAttributesFrom(intervention: Intervention) -> [InterventionTargetAttributes] {
    let targets = intervention.targets
    var targetsAttributes = [InterventionTargetAttributes]()

    for target in targets! {
      let target = target as! Target
      let targetAttributes = InterventionTargetAttributes(
        cropId: (target.crop?.uuid)?.uuidString,
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

  func appendInputAttributes(id: String?, referenceID: String?, type: ArticleTypeEnum?, quantity: Float, unit: String) -> InterventionInputAttributes {
    let article = InterventionArticleAttributes(
      id: id,
      referenceId: referenceID,
      type: type)
    let inputAttributes = InterventionInputAttributes(
      marketingAuthorizationNumber: nil,
      article: article,
      quantity: Double(quantity),
      unit: ArticleAllUnitEnum(rawValue: unit)!,
      unitPrice: nil)

    return inputAttributes
  }

  func defineInputsAttributesFrom(intervention: Intervention) -> [InterventionInputAttributes] {
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
      case is InterventionSeed:
        let seed = input as! InterventionSeed
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if seed.seed?.ekyID == 0 && seed.seed?.referenceID != 0 {
          referenceId = (seed.seed?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "SEED")
        } else if seed.seed?.ekyID == 0 && seed.seed?.referenceID == 0 {
          id = String(seed.seed!.ekyID)
        } else {
          id = (seed.seed?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: seed.quantity, unit: seed.unit!))
      case is InterventionPhytosanitary:
        let phyto = input as! InterventionPhytosanitary
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if phyto.phyto?.ekyID == 0 && phyto.phyto?.referenceID != 0 {
          referenceId = (phyto.phyto?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "CHEMICAL")
        } else if phyto.phyto?.ekyID == 0 && phyto.phyto?.referenceID == 0 {
          id = String(phyto.phyto!.ekyID)
        } else {
          id = (phyto.phyto?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: phyto.quantity, unit: phyto.unit!))
      case is InterventionFertilizer:
        let fertilizer = input as! InterventionFertilizer
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if fertilizer.fertilizer?.ekyID == 0 && fertilizer.fertilizer?.referenceID != 0 {
          referenceId = (fertilizer.fertilizer?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "FERTILIZER")
        } else if fertilizer.fertilizer?.ekyID == 0 && fertilizer.fertilizer?.referenceID == 0 {
          id = String(fertilizer.fertilizer!.ekyID)
        } else {
          id = (fertilizer.fertilizer?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: fertilizer.quantity, unit: fertilizer.unit!))
      case is InterventionMaterial:
        let material = input as! InterventionMaterial
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if material.material?.ekyID == 0 {
          referenceId = (material.material?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "MATERIAL")
        } else {
          id = String(material.material!.ekyID)
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: material.quantity, unit: material.unit!))
      default:
        print("No type")
      }
    }
    return inputsAttributes
  }

  func defineHarvestAttributesFrom(intervention: Intervention) -> [InterventionOutputAttributes] {
    let harvests = intervention.harvests
    var harvestsAttributes = [InterventionOutputAttributes]()
    for harvest in harvests! {
      let harvest = harvest as! Harvest
      let loads = HarvestLoadAttributes(
        quantity: harvest.quantity,
        netQuantity: nil,
        unit: HarvestLoadUnitEnum(rawValue: harvest.unit!),
        number: harvest.number,
        storageId: (harvest.storage?.storageID as NSNumber?)?.stringValue)
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

  private func pushEquipment(equipment: Equipment) -> Int32 {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let group = DispatchGroup()
    let _ = apollo.clearCache()
    let mutation = PushEquipmentMutation(
      farmId: farmID,
      type: EquipmentTypeEnum(rawValue: equipment.type!)!,
      name: equipment.name!,
      number: equipment.number,
      indicator1: equipment.indicatorOne,
      indicator2: equipment.indicatorTwo)

    group.enter()
    apollo.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("ResultError: \(resultError)")
      } else  {
        if let dataError = result?.data?.createEquipment?.errors {
          print("DataError: \(dataError)")
        } else {
          id = Int32(result!.data!.createEquipment!.equipment!.id)!
        }
      }
      group.leave()
    })
    group.wait()
    return id
  }

  func pushEntitiesIfNeeded(_ entityName: String, _ predicate: NSPredicate) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let group = DispatchGroup()

    entitiesFetchRequest.predicate = predicate
    group.enter()
    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        switch entity {
        case is Equipment:
          (entity as! Equipment).ekyID = pushEquipment(equipment: entity as! Equipment)
        case is Person:
          (entity as! Person).ekyID = pushPerson(person: entity as! Person)
        case is Seed:
          (entity as! Seed).ekyID = pushSeed(seed: entity as! Seed)
        case is Phyto:
          let phyto = (entity as! Phyto)
          phyto.ekyID = pushInput(input: entity as! NSManagedObject, type: .chemical, unit: ArticleUnitEnum(rawValue: phyto.unit!)!)
        case is Fertilizer:
          let fertilizer = (entity as! Fertilizer)
          fertilizer.ekyID = pushInput(input: entity as! NSManagedObject, type: .fertilizer, unit: ArticleUnitEnum(rawValue: fertilizer.unit!)!)
        case is Material:
          let material = (entity as! Material)
          material.ekyID = pushInput(input: entity as! NSManagedObject, type: .material, unit: ArticleUnitEnum(rawValue: material.unit!)!)
        case is Storage:
          (entity as! Storage).storageID = pushStorages(storage: entity as! Storage)
        default:
          return
        }
      }
      try managedContext.save()
      group.leave()
    } catch let error as NSError {
      print("Could not fetch or save. \(error), \(error.userInfo)")
      group.leave()
    }
    group.wait()
  }

  func pushEntities() {
    let ekyPredicate = NSPredicate(format: "ekyID == %d", 0)
    let referencePredicate = NSPredicate(format: "referenceID == %d", 0)
    let storagePredicate = NSPredicate(format: "storageID == %d", 0)
    let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [ekyPredicate, referencePredicate])

    pushEntitiesIfNeeded("Equipment", ekyPredicate)
    pushEntitiesIfNeeded("Person", ekyPredicate)
    pushEntitiesIfNeeded("Seed", predicates)
    pushEntitiesIfNeeded("Phyto", predicates)
    pushEntitiesIfNeeded("Fertilizer", predicates)
    pushEntitiesIfNeeded("Material", predicates)
    pushEntitiesIfNeeded("Storage", storagePredicate)
  }

  func defineEquipmentAttributesFrom(intervention: Intervention) -> [InterventionToolAttributes] {
    let equipments = intervention.interventionEquipments
    var equipmentsAttributes = [InterventionToolAttributes]()

    for equipment in equipments! {
      let equipmentID = (equipment as! InterventionEquipment).equipment!.ekyID
      let equipmentAttributes = InterventionToolAttributes(equipmentId: (equipmentID as NSNumber?)?.stringValue)

      equipmentsAttributes.append(equipmentAttributes)
    }
    return equipmentsAttributes
  }

  private func pushPerson(person: Person) -> Int32 {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let group = DispatchGroup()
    let mutation = PushPersonMutation(farmId: farmID, firstName: person.firstName, lastName: person.lastName!)
    let _ = apollo.clearCache()

    group.enter()
    apollo.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.data?.createPerson?.errors {
        print("Error: \(resultError)")
      } else {
        if result?.data?.createPerson?.person?.id != nil {
          id = Int32(result!.data!.createPerson!.person!.id)!
        }
      }
      group.leave()
    })
    group.wait()
    return id
  }

  func defineOperatorAttributesFrom(intervention: Intervention) -> [InterventionOperatorAttributes] {
    let interventionPersons = intervention.interventionPersons
    var operatorsAttributes = [InterventionOperatorAttributes]()

    for interventionPerson in interventionPersons! {
      let personID = (interventionPerson as! InterventionPerson).person?.ekyID
      let role = (interventionPerson as! InterventionPerson).isDriver
      let operatorAttributes = InterventionOperatorAttributes(
        personId: (personID as NSNumber?)?.stringValue,
        role: (role ? OperatorRoleEnum(rawValue: "DRIVER") : OperatorRoleEnum(rawValue: "OPERATOR")))

      operatorsAttributes.append(operatorAttributes)
    }
    return operatorsAttributes
  }

  func defineWeatherAttributesFrom(intervention: Intervention) -> WeatherAttributes {
    var weather = WeatherAttributes()

    weather.temperature = intervention.weather?.temperature as? Double
    weather.windSpeed = intervention.weather?.windSpeed as? Double
    weather.description = (intervention.weather?.weatherDescription).map { WeatherEnum(rawValue: $0) }
    return weather
  }

  func pushIntervention(intervention: Intervention) -> Int32 {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let group = DispatchGroup()
    let apollo = appDelegate.apollo
    let _ = apollo?.clearCache()
    let mutation = PushInterMutation(
      farmId: intervention.farmID!,
      procedure: InterventionTypeEnum(rawValue: intervention.type!)!,
      cropList: defineTargetAttributesFrom(intervention: intervention),
      workingDays: defineWorkingDayAttributesFrom(intervention: intervention),
      waterQuantity: intervention.type == "IRRIGATION" ? Int(intervention.waterQuantity) : nil,
      waterUnit: intervention.type == "IRRIGATION" ? InterventionWaterVolumeUnitEnum(rawValue: intervention.waterUnit!) : nil,
      inputs: defineInputsAttributesFrom(intervention: intervention),
      outputs: defineHarvestAttributesFrom(intervention: intervention),
      globalOutputs: false,
      tools: defineEquipmentAttributesFrom(intervention: intervention),
      operators: defineOperatorAttributesFrom(intervention: intervention),
      weather: defineWeatherAttributesFrom(intervention: intervention),
      description: intervention.infos)

    group.enter()
    apollo?.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else {
        if let dataError = result?.data?.createIntervention?.errors {
          print("Data error: \(dataError)")
        } else {
          if result?.data?.createIntervention?.intervention?.id != nil {
            id = Int32((result?.data?.createIntervention?.intervention?.id)!)!
          }
        }
      }
      group.leave()
    })
    group.wait()
    return id
  }

  func pushUpdatedIntervention(intervention: Intervention) {
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
      outputs: defineHarvestAttributesFrom(intervention: intervention),
      tools: defineEquipmentAttributesFrom(intervention: intervention),
      operators: defineOperatorAttributesFrom(intervention: intervention),
      weather: defineWeatherAttributesFrom(intervention: intervention),
      description: intervention.infos)

    group.enter()
    apollo?.perform(mutation: updateMutation, queue: DispatchQueue.global(), resultHandler: { (error, result) in
      if let error = error?.errors {
        print("Error: \(String(describing: error))")
      } else {
        intervention.status = InterventionState.Synced.rawValue
      }
      group.leave()
    })
    group.wait()
  }
}
