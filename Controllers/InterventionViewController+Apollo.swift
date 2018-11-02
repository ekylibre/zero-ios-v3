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
    let apollo = appDelegate.apollo!
    let query = FarmQuery(modifiedSince: defineLastSynchronisationDate())

    apollo.fetch(query: query) { result, error in
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
      newCrop.productionID = Int32(crop.productionNature.id)!
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
    local.productionID = Int32(updated.productionNature.id)!
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
    let crop = Crops(context: managedContext)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    crop.uuid = UUID(uuidString: new.uuid)
    crop.plotName = new.name
    crop.productionID = Int32(new.productionNature.id)!
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

  private func pushInput(unit: ArticleUnitEnum, name: String, type: ArticleTypeEnum) -> Int32{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let group = DispatchGroup()
    let mutation = PushArticleMutation(farmId: farmID, unit: unit, name: name, type: type)
    let _ = apollo.clearCache()

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

  func pushInputIfNoEkyID(input: NSManagedObject) -> Int32? {
    if (input.value(forKey: "ekyID") as! Int32) == 0 {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return nil
      }

      let managedContext = appDelegate.persistentContainer.viewContext

      do {
        var inputID: Int32 = 0
        switch input {
        case is Phytos:
          let phyto = input as! Phytos
          inputID = pushInput(unit: ArticleUnitEnum.liter, name: phyto.name!, type: ArticleTypeEnum.chemical)
        case is Fertilizers:
          let fertilizer = input as! Fertilizers
          inputID = pushInput(unit: ArticleUnitEnum.kilogram, name: fertilizer.name!, type: ArticleTypeEnum.fertilizer)
        default:
          return nil
        }

        input.setValue(inputID, forKey: "ekyID")
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    return input.value(forKey: "ekyID") as? Int32
  }

  private func pushSeed(unit: ArticleUnitEnum, variety: String, specie: String, type: ArticleTypeEnum) -> Int32{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let group = DispatchGroup()
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let _ = apollo.clearCache()
    let mutation = PushArticleMutation(farmId: farmID, unit: unit, name: variety, type: ArticleTypeEnum.seed,
                                       specie: SpecieEnum(rawValue: specie), variety: variety)

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

  func pushSeedIfNoEkyID(seed: Seeds) -> Int32? {
    if seed.ekyID == 0 {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return nil
      }

      let managedContext = appDelegate.persistentContainer.viewContext

      do {
        seed.ekyID = pushSeed(unit: ArticleUnitEnum.kilogram, variety: seed.variety!,
                              specie: seed.specie!, type: ArticleTypeEnum.seed);
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    return seed.ekyID
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
      seed.ekyID = 0
      seed.referenceID = Int32(article.id)!
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
      phyto.ekyID = 0
      phyto.referenceID = Int32(article.id)!
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
      fertilizer.ekyID = 0
      fertilizer.referenceID = Int32(article.id)!
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

  // MARK: - Update

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
    let equipment = Equipments(context: managedContext)
    let indicators = defineIndicators(fetchedEquipment.indicators)
    var type = fetchedEquipment.type?.rawValue

    type = type?.lowercased()
    equipment.farmID = farmID
    equipment.type = type?.localized
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

            if self.checkIfNewEntity(entityName: "Equipments", predicate: predicate) {
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
    let person = Persons(context: managedContext)

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

            if self.checkIfNewEntity(entityName: "Persons", predicate: predicate) {
              self.savePersons(fetchedPerson: person, farmID: farm.id)
            }
          }
        }
      }
    }
    completion(true)
  }

  // MARK: Storages

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
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else {
        let farm = (result?.data?.farms.first)!
        for storage in farm.storages {
          let predicate = NSPredicate(format: "storageID == %d", (storage.id as NSString).intValue)

          if self.checkIfNewEntity(entityName: "Storages", predicate: predicate) {
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

  private func returnEntityIfSame(entityName: String, predicate: NSPredicate) -> NSManagedObject? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

    entitiesFetchRequest.predicate = predicate
    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      if entities.count > 0 {
        return entities.first as? NSManagedObject
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
    let predicate = NSPredicate(format: "ekyID == %@", (fetchedEquipment.equipment?.id)!)
    let equipment = returnEntityIfSame(entityName: "Equipments", predicate: predicate)

    if equipment != nil {
      (equipment as! Equipments).addToInterventionEquipments(interventionEquipment)
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

  private func saveTargetToIntervention(fetchedTarget: InterventionQuery.Data.Farm.Intervention.Target, intervention: Interventions) -> Targets {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Targets()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let target = Targets(context: managedContext)
    let predicate = NSPredicate(format: "uuid == %@", fetchedTarget.crop.uuid)
    let crop = returnEntityIfSame(entityName: "Crops", predicate: predicate)

    if crop != nil {
      target.workAreaPercentage = Int16(fetchedTarget.workingPercentage)
      target.crops = crop as? Crops
      target.interventions = intervention
    }
    return target
  }

  // MARK: Doers

  private func saveInterventionPersonsToIntervention(fetchedOperator: InterventionQuery.Data.Farm.Intervention.Operator, intervention: Interventions) -> InterventionPersons {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return InterventionPersons()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionPersons = InterventionPersons(context: managedContext)
    let personID = fetchedOperator.person?.id
    let person: Persons?

    if personID != nil {
      let predicate = NSPredicate(format: "ekyID == %@", personID!)

      person = returnEntityIfSame(entityName: "Persons", predicate: predicate) as? Persons
      if person != nil {
        if fetchedOperator.role?.rawValue == "OPERATOR" {
          interventionPersons.isDriver = false
        } else {
          interventionPersons.isDriver = true
        }
        person?.addToInterventionPersons(interventionPersons)
        interventionPersons.interventions = intervention
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
    let storageID = fetchedLoad.storage?.id
    let storage: Storages?

    if storageID != nil {
      let predicate = NSPredicate(format: "storageID == %@", storageID!)
      storage = returnEntityIfSame(entityName: "Storages", predicate: predicate) as? Storages
      storage?.addToHarvests(harvest)
      harvest.storages = storage
    }
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

  private func saveInputsInIntervention(fetchedInput: InterventionQuery.Data.Farm.Intervention.Input, intervention: Interventions) -> Interventions {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return intervention
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let id = fetchedInput.article?.id
    let predicate: NSPredicate!

    predicate = (id == nil ? nil : NSPredicate(format: "ekyID == %@", id!))
    switch fetchedInput.article?.type.rawValue {
    case "SEED":
      let interventionSeed = InterventionSeeds(context: managedContext)
      let seed = returnEntityIfSame(entityName: "Seeds", predicate: predicate)

      interventionSeed.unit = fetchedInput.unit.rawValue
      interventionSeed.quantity = fetchedInput.quantity as NSNumber?
      interventionSeed.seeds = seed as? Seeds
      interventionSeed.interventions = intervention
      intervention.addToInterventionSeeds(interventionSeed)
    case "FERTILIZER":
      let interventionFertilizer = InterventionFertilizers(context: managedContext)
      let fertilizer = returnEntityIfSame(entityName: "Fertilizers", predicate: predicate)

      interventionFertilizer.unit = fetchedInput.unit.rawValue
      interventionFertilizer.quantity = fetchedInput.quantity as NSNumber?
      interventionFertilizer.fertilizers = fertilizer as? Fertilizers
      interventionFertilizer.interventions =  intervention
      intervention.addToInterventionFertilizers(interventionFertilizer)
    case "CHEMICAL":
      let interventionPhyto = InterventionPhytosanitaries(context: managedContext)
      let phyto = returnEntityIfSame(entityName: "Phytos", predicate: predicate)

      interventionPhyto.unit = fetchedInput.unit.rawValue
      interventionPhyto.quantity = fetchedInput.quantity as NSNumber?
      interventionPhyto.phytos = phyto as? Phytos
      interventionPhyto.interventions = intervention
      intervention.addToInterventionPhytosanitaries(interventionPhyto)
    case "MATERIAL":
      let interventionMaterial = InterventionMaterials(context: managedContext)
      let material = returnEntityIfSame(entityName: "Materials", predicate: predicate)

      interventionMaterial.unit = fetchedInput.unit.rawValue
      interventionMaterial.quantity = fetchedInput.quantity as NSNumber?
      interventionMaterial.materials = material as? Materials
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
    intervention.status = Int16((fetchedIntervention.validatedAt == nil ? InterventionState.Synced : InterventionState.Validated).rawValue)
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
    let interventionFetchRequest: NSFetchRequest<Interventions> = Interventions.fetchRequest()
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

  func loadIntervention(onCompleted: @escaping ((_ success: Bool) -> ())) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let group = DispatchGroup()

    group.enter()
    appDelegate.apollo?.fetch(query: InterventionQuery(modifiedSince: defineLastSynchronisationDate())) { (result, error) in
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

          if self.checkIfNewEntity(entityName: "Interventions", predicate: predicate) {
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

  func appendInputAttributes(id: String?, referenceID: String?, type: ArticleTypeEnum?, quantity: NSNumber, unit: String) -> InterventionInputAttributes {
    let article = InterventionArticleAttributes(
      id: id,
      referenceId: referenceID,
      type: type)
    let inputAttributes = InterventionInputAttributes(
      marketingAuthorizationNumber: nil,
      article: article,
      quantity: Double(truncating: quantity),
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

        if seed.seeds?.ekyID == 0 && seed.seeds?.referenceID != 0 {
          referenceId = (seed.seeds?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "SEED")
        } else if seed.seeds?.ekyID == 0 && seed.seeds?.referenceID == 0 {
          id = String(pushSeedIfNoEkyID(seed: seed.seeds!)!)
        } else {
          id = (seed.seeds?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: seed.quantity!, unit: seed.unit!))
      case is InterventionPhytosanitaries:
        let phyto = input as! InterventionPhytosanitaries
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if phyto.phytos?.ekyID == 0 && phyto.phytos?.referenceID != 0 {
          referenceId = (phyto.phytos?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "CHEMICAL")
        } else if phyto.phytos?.ekyID == 0 && phyto.phytos?.referenceID == 0 {
          id = String(pushInputIfNoEkyID(input: phyto.phytos!)!)
        } else {
          id = (phyto.phytos?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: phyto.quantity!, unit: phyto.unit!))
      case is InterventionFertilizers:
        let fertilizer = input as! InterventionFertilizers
        var id: String? = nil
        var referenceId: String? = nil
        var type: ArticleTypeEnum? = nil

        if fertilizer.fertilizers?.ekyID == 0 && fertilizer.fertilizers?.referenceID != 0 {
          referenceId = (fertilizer.fertilizers?.referenceID as NSNumber?)?.stringValue
          type = ArticleTypeEnum(rawValue: "FERTILIZER")
        } else if fertilizer.fertilizers?.ekyID == 0 && fertilizer.fertilizers?.referenceID == 0 {
          id = String(pushInputIfNoEkyID(input: fertilizer.fertilizers!)!)
        } else {
          id = (fertilizer.fertilizers?.ekyID as NSNumber?)?.stringValue
        }
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: fertilizer.quantity!, unit: fertilizer.unit!))
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
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type, quantity: material.quantity!, unit: material.unit!))
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

  private func pushEquipment(equipment: Equipments) -> Int32 {
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
      } else if let resultError = result?.data?.createEquipment?.errors {
        print("Error: \(resultError)")
      } else {
        if result?.data?.createEquipment?.equipment?.id != nil {
          id = Int32(result!.data!.createEquipment!.equipment!.id)!
        }
      }
      group.leave()
    })
    group.wait()
    return id
  }

  func pushEquipmentIfNoEkyId(equipment: Equipments) -> Int32? {
    if equipment.ekyID == 0 {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return nil
      }

      let managedContext = appDelegate.persistentContainer.viewContext

      do {
        equipment.ekyID = pushEquipment(equipment: equipment)
        try managedContext.save()
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    return equipment.ekyID
  }

  func defineEquipmentAttributesFrom(intervention: Interventions) -> [InterventionToolAttributes] {
    let equipments = intervention.interventionEquipments
    var equipmentsAttributes = [InterventionToolAttributes]()

    for equipment in equipments! {
      let equipmentID = pushEquipmentIfNoEkyId(equipment: (equipment as! InterventionEquipments).equipments!)
      let equipmentAttributes = InterventionToolAttributes(equipmentId: (equipmentID as NSNumber?)?.stringValue)

      equipmentsAttributes.append(equipmentAttributes)
    }
    return equipmentsAttributes
  }

  func defineOperatorAttributesFrom(intervention: Interventions) -> [InterventionOperatorAttributes] {
    let interventionPersons = intervention.interventionPersons
    var operatorsAttributes = [InterventionOperatorAttributes]()

    for interventionPerson in interventionPersons! {
      let personID = (interventionPerson as! InterventionPersons).persons?.ekyID
      let role = (interventionPerson as! InterventionPersons).isDriver
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
    weather.description = (intervention.weather?.weatherDescription).map { WeatherEnum(rawValue: $0) }
    return weather
  }

  func pushIntervention(intervention: Interventions) -> Int32 {
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
}
