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
    #if DEBUG
    let url = URL(string: "https://api.ekylibre-test.com/v1/graphql")!
    #else
    let url = URL(string: "https://api.ekylibre.com/v1/graphql")!
    #endif
    let configuation = URLSessionConfiguration.default
    let authService = AuthenticationService()

    authService.setupOauthPasswordGrant(username: nil, password: nil)
    if let token = authService.oauth2?.accessToken {
      configuation.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
      apolloClient = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuation))
    }
  }

  func queryFarms(endResult: @escaping (_ success: Bool) -> ()) {
    let query = FarmQuery(modifiedSince: getLastSyncDate())

    apolloClient.fetch(query: query) { result, error in
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
        self.saveFarmID()
        self.checkCropsData(crops: farms.first!.crops)
        self.checkArticlesData(articles: farms.first!.articles)
        self.updateEditedEquipments()
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

  private func saveFarmID() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let farmsFetchRequest: NSFetchRequest<Farm> = Farm.fetchRequest()

    do {
      let farms = try managedContext.fetch(farmsFetchRequest)
      farmID = farms.first!.id!
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
      farmID = farms.first?.id
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
      let splitString = crop.surfaceArea.split(separator: " ", maxSplits: 1)
      let surfaceArea = Float(splitString.first!)!

      newCrop.uuid = UUID(uuidString: crop.uuid)
      newCrop.plotName = crop.name
      newCrop.productionID = Int32(crop.productionNature.id)!
      newCrop.productionMode = crop.productionMode
      newCrop.provisionalYield = crop.provisionalYield
      newCrop.species = crop.species.rawValue
      newCrop.startDate = crop.startDate!
      newCrop.stopDate = crop.stopDate!
      newCrop.surfaceArea = surfaceArea
      newCrop.centroid = crop.centroid.jsonValue as? String
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
    local.productionID = Int32(updated.productionNature.id)!
    local.productionMode = updated.productionMode
    local.provisionalYield = updated.provisionalYield
    local.species = updated.species.rawValue
    local.startDate = updated.startDate!
    local.stopDate = updated.stopDate!
    let splitString = updated.surfaceArea.split(separator: " ", maxSplits: 1)
    let surfaceArea = Float(splitString.first!)!
    local.surfaceArea = surfaceArea
    local.centroid = updated.centroid.jsonValue as? String

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
    let splitString = new.surfaceArea.split(separator: " ", maxSplits: 1)
    let surfaceArea = Float(splitString.first!)!
    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = "yyyy-MM-dd"
    crop.uuid = UUID(uuidString: new.uuid)
    crop.plotName = new.name
    crop.productionID = Int32(new.productionNature.id)!
    crop.productionMode = new.productionMode
    crop.provisionalYield = new.provisionalYield
    crop.species = new.species.rawValue
    crop.startDate = new.startDate!
    crop.stopDate = new.stopDate!
    crop.surfaceArea = surfaceArea

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Articles

  private func pushInput(input: NSManagedObject, type: ArticleTypeEnum, unit: ArticleUnitEnum) {
    let mutation = PushArticleMutation(
      farmID: farmID, unit: unit, name: input.value(forKey: "name") as! String, type: type)

    _ = apolloClient.clearCache()
    apolloClient.perform(mutation: mutation, resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else if let dataError = result?.data?.createArticle?.errors {
        print("Data error: \(dataError)")
      }

      guard let graphqlID = result?.data?.createArticle?.article?.id, let id = Int32(graphqlID) else {
        print("Could not unwrap article id")
        return
      }

      input.setValue(id, forKey: "ekyID")
    })
  }

  private func pushSeed(seed: Seed) {
    let mutation = PushArticleMutation(farmID: farmID, unit: ArticleUnitEnum.kilogram, name: seed.variety!,
                                       type: .seed, specie: SpecieEnum(rawValue: seed.specie!), variety: seed.variety)

    _ = apolloClient.clearCache()
    apolloClient.perform(mutation: mutation, resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else if let dataError = result?.data?.createArticle?.errors {
        print("Data error: \(dataError)")
      }

      guard let graphqlID = result?.data?.createArticle?.article?.id, let id = Int32(graphqlID) else {
        print("Could not unwrap seed id")
        return
      }

      seed.ekyID = id
    })
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
      phyto.maaID = article.marketingAuthorizationNumber
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
      let localArticle = fetchArticle(type: type, predicate: NSPredicate(format: "ekyID == %@", article.id))

      if let localArticle = localArticle {
        updateArticle(local: localArticle, updated: article)
      } else if article.referenceId == nil {
        insertArticle(type, article)
      }
    }
  }

  private func fetchArticle(type: String, predicate: NSPredicate) -> NSManagedObject? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    var articles = [NSManagedObject]()
    let managedContext = appDelegate.persistentContainer.viewContext
    let articlesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: type)
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

  private func getLastSyncDate() -> Date? {
    return UserDefaults.standard.value(forKey: "lastSyncDate") as? Date
  }

  private func updateEditedEquipments() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let request: NSFetchRequest<Equipment> = Equipment.fetchRequest()
    let predicate = NSPredicate(format: "edited == %@", NSNumber(value: true))

    request.predicate = predicate

    do {
      let equipments = try context.fetch(request)

      for equipment in equipments {
        updateEquipment(equipment)
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func updateEquipment(_ equipment: Equipment) {
    guard let type = EquipmentTypeEnum(rawValue: equipment.type!) else { return }
    let mutation = UpdateEquipmentMutation(id: String(equipment.ekyID), farmID: farmID, type: type,
                                           name: equipment.name!, number: equipment.number,
                                           indicator1: equipment.indicatorOne, indicator2: equipment.indicatorTwo)

    _ = apolloClient.clearCache()
    apolloClient.perform(mutation: mutation, resultHandler: { (error, result) in
      if let error = error?.errors {
        print("Error: \(String(describing: error))")
      } else {
        equipment.edited = false
      }
    })
  }

  // MARK: - Delete

  func deleteEquipment(_ equipment: Equipment, viewController: UIViewController) {
    guard let addInterventionVC = viewController as? AddInterventionViewController else { fatalError() }
    let mutation: DeleteEquipmentMutation

    saveFarmID()
    initializeApolloClient()
    mutation = DeleteEquipmentMutation(id: String(equipment.ekyID), farmID: farmID)

    _ = apolloClient.clearCache()
    apolloClient.perform(mutation: mutation, resultHandler: { (error, message) in
      if let error = error?.errors {
        print("Error: \(String(describing: error))")
        self.presentErrorAlert(message: "equipment_cannot_be_deleted".localized, viewController: viewController)
      } else {
        addInterventionVC.equipmentsSelectionView.editionView.deleteEquipmentLocally()
      }
    })
  }

  private func presentErrorAlert(message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: "an_error_occured".localized, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "ok".localized.uppercased(), style: .cancel, handler: nil)

    alert.addAction(cancelAction)
    viewController.present(alert, animated: true)
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

  private func defineIndicatorIfOnlyOne(_ indicator: String?) -> [String] {
    let indicatorOne = indicator?.components(separatedBy: ":")

    if indicatorOne!.count > 1 {
      return [indicatorOne![1]]
    }
    return [String]()
  }

  private func defineIndicators(_ indicator: String?) -> [String] {
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

  private func saveEquipments(fetchedEquipment: FarmQuery.Data.Farm.Equipment) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipment = Equipment(context: managedContext)
    let indicators = defineIndicators(fetchedEquipment.indicators)

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

  private func loadEquipments() {
    let query = FarmQuery(modifiedSince: getLastSyncDate())

    apolloClient.fetch(query: query) { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else {
        guard let farms = result?.data?.farms else {
          print("Could not unwrap farms")
          return
        }

        for farm in farms {
          for equipment in farm.equipments {

            let predicate = NSPredicate(format: "ekyID == %d", (equipment.id as NSString).intValue)

            if self.checkIfNewEntity(entityName: "Equipment", predicate: predicate) {
              self.saveEquipments(fetchedEquipment: equipment)
            }
          }
        }
      }
    }
  }

  // MARK: Persons

  private func savePersons(fetchedPerson: FarmQuery.Data.Farm.Person) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let person = Person(context: managedContext)

    person.firstName = fetchedPerson.firstName
    person.lastName = fetchedPerson.lastName
    person.ekyID = (fetchedPerson.id as NSString).intValue

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func loadPersons(completion: @escaping (_ success: Bool) -> Void) {
    let query = FarmQuery(modifiedSince: getLastSyncDate())

    apolloClient.fetch(query: query) { (result, error) in
      if let error = error {
        print("Error: \(error)")
        completion(false)
        return
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
        completion(false)
        return
      } else {
        guard let farms = result?.data?.farms else {
          print("Could not unwrap farms")
          return
        }

        for farm in farms {
          for person in farm.people {
            let predicate = NSPredicate(format: "ekyID == %d", (person.id as NSString).intValue)

            if self.checkIfNewEntity(entityName: "Person", predicate: predicate) {
              self.savePersons(fetchedPerson: person)
            }
          }
        }
      }
    }
    completion(true)
  }

  // MARK: Storages

  private func pushStorage(storage: Storage) {
    let mutation = PushStorageMutation(farmID: farmID, type: StorageTypeEnum(rawValue: storage.type!),
                                       name: storage.name!)

    _ = apolloClient.clearCache()
    apolloClient.perform(mutation: mutation, resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("ResultError: \(resultError)")
      } else if let dataError = result?.data?.createStorage?.errors {
        print("DataError: \(dataError)")
      }

      guard let graphqlID = result?.data?.createStorage?.storage?.id, let id = Int32(graphqlID) else {
        print("Could not unwrap storage id")
        return
      }

      storage.storageID = id
    })
  }

  private func saveStorage(fetchedStorage: FarmQuery.Data.Farm.Storage) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let storage = Storage(context: managedContext)

    storage.storageID = (fetchedStorage.id as NSString).intValue
    storage.name = fetchedStorage.name
    storage.type = fetchedStorage.type.rawValue

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func loadStorage() {
    let query = FarmQuery(modifiedSince: getLastSyncDate())

    apolloClient.fetch(query: query) { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else {
        guard let farm = result?.data?.farms.first else {
          print("Could not unwrap farms")
          return
        }

        for storage in farm.storages {
          let predicate = NSPredicate(format: "storageID == %d", (storage.id as NSString).intValue)

          if self.checkIfNewEntity(entityName: "Storage", predicate: predicate) {
            self.saveStorage(fetchedStorage: storage)
          }
        }
      }
    }
  }

  // MARK: Weather

  private func saveWeatherInIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention,
                                         intervention: NSManagedObject) -> NSManagedObject {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return NSManagedObject()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let weather = Weather(context: managedContext)

    weather.weatherDescription = fetchedIntervention.weather?.description?.rawValue.lowercased()
    weather.windSpeed = fetchedIntervention.weather?.windSpeed as NSNumber?
    weather.temperature = fetchedIntervention.weather?.temperature as NSNumber?
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
    workingPeriod.executionDate = fetchedDay.executionDate!
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

  private func saveEquipmentsToIntervention(fetchedEquipment: InterventionQuery.Data.Farm.Intervention.Tool,
                                            intervention: Intervention) -> InterventionEquipment {
    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionEquipment = InterventionEquipment(context: managedContext)
    let predicate = NSPredicate(format: "ekyID == %d", (Int32(fetchedEquipment.equipment!.id)!))
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

  private func saveTargetToIntervention(fetchedTarget: InterventionQuery.Data.Farm.Intervention.Target,
                                        intervention: Intervention) -> Target {
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

  private func saveInterventionPersonsToIntervention(fetchedOperator: InterventionQuery.Data.Farm.Intervention.Operator,
                                                     intervention: Intervention) -> InterventionPerson {
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

  private func createLoadIfGlobalOutput(fetchedOutput: InterventionQuery.Data.Farm.Intervention.Output,
                                        intervention: Intervention) -> Harvest {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Harvest()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvest = Harvest(context: managedContext)

    harvest.quantity = fetchedOutput.quantity ?? 0
    harvest.type = fetchedOutput.nature.rawValue
    harvest.unit = fetchedOutput.unit?.rawValue
    harvest.number = fetchedOutput.id
    harvest.intervention = intervention

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return harvest
  }

  private func saveLoadToIntervention(fetchedLoad: InterventionQuery.Data.Farm.Intervention.Output.Load,
                                      intervention: Intervention, nature: String) -> Harvest {
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
    harvest.unit = fetchedLoad.unit?.rawValue

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    return harvest
  }

  // MARK: Inputs

  private func ifEntityIsEmptySearchWithReferenceID(
    entity: NSManagedObject?, referenceID: String?, entityName: String) -> NSManagedObject? {
    if entity == nil {
      let predicate: NSPredicate!

      predicate = (referenceID == nil ? nil : NSPredicate(format: "referenceID == %d", Int32(referenceID!)!))
      return returnEntityIfSame(entityName: entityName, predicate: predicate)
    }
    return entity
  }

  private func saveInputsInIntervention(fetchedInput: InterventionQuery.Data.Farm.Intervention.Input,
                                        intervention: Intervention) -> Intervention {
    let managedContext = appDelegate.persistentContainer.viewContext
    let ekyID = fetchedInput.article?.id
    let referenceID = fetchedInput.article?.referenceId
    let predicate: NSPredicate!

    predicate = (ekyID == nil ? nil : NSPredicate(format: "ekyID == %d", Int32(ekyID!)!))
    switch fetchedInput.article?.type.rawValue {
    case "SEED":
      let interventionSeed = InterventionSeed(context: managedContext)
      var seed = returnEntityIfSame(entityName: "Seed", predicate: predicate)

      seed = ifEntityIsEmptySearchWithReferenceID(entity: seed, referenceID: referenceID, entityName: "Seed")
      interventionSeed.unit = fetchedInput.unit.rawValue
      fetchedInput.quantity != nil ? interventionSeed.quantity = Float(fetchedInput.quantity!) : nil
      interventionSeed.seed = (seed as? Seed)
      interventionSeed.intervention = intervention
      intervention.addToInterventionSeeds(interventionSeed)
    case "FERTILIZER":
      let interventionFertilizer = InterventionFertilizer(context: managedContext)
      var fertilizer = returnEntityIfSame(entityName: "Fertilizer", predicate: predicate)

      fertilizer = ifEntityIsEmptySearchWithReferenceID(
        entity: fertilizer, referenceID: referenceID, entityName: "Fertilizer")
      interventionFertilizer.unit = fetchedInput.unit.rawValue
      fetchedInput.quantity != nil ? interventionFertilizer.quantity = Float(fetchedInput.quantity!) : nil
      interventionFertilizer.fertilizer = (fertilizer as? Fertilizer)
      interventionFertilizer.intervention =  intervention
      intervention.addToInterventionFertilizers(interventionFertilizer)
    case "CHEMICAL":
      let interventionPhyto = InterventionPhytosanitary(context: managedContext)
      var phyto = returnEntityIfSame(entityName: "Phyto", predicate: predicate)

      phyto = ifEntityIsEmptySearchWithReferenceID(entity: phyto, referenceID: referenceID, entityName: "Phyto")
      interventionPhyto.unit = fetchedInput.unit.rawValue
      fetchedInput.quantity != nil ? interventionPhyto.quantity = Float(fetchedInput.quantity!) : nil
      interventionPhyto.phyto = (phyto as? Phyto)
      interventionPhyto.intervention = intervention
      intervention.addToInterventionPhytosanitaries(interventionPhyto)
    case "MATERIAL":
      let interventionMaterial = InterventionMaterial(context: managedContext)
      var material = returnEntityIfSame(entityName: "Material", predicate: predicate)

      material = ifEntityIsEmptySearchWithReferenceID(
        entity: material, referenceID: referenceID, entityName: "Material")
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

  private func saveEntitiesIntoIntervention(
    intervention: Intervention, fetchedIntervention: InterventionQuery.Data.Farm.Intervention) -> Intervention {
    for workingDay in fetchedIntervention.workingDays {
      intervention.addToWorkingPeriods(saveWorkingDays(fetchedDay: workingDay))
    }
    for fetchedEquipment in fetchedIntervention.tools! {
      intervention.addToInterventionEquipments(saveEquipmentsToIntervention(
        fetchedEquipment: fetchedEquipment, intervention: intervention))
    }
    for fetchedOperator in fetchedIntervention.operators! {
      intervention.addToInterventionPersons(saveInterventionPersonsToIntervention(
        fetchedOperator: fetchedOperator, intervention: intervention))
    }
    for fetchedTarget in fetchedIntervention.targets {
      intervention.addToTargets(saveTargetToIntervention(fetchedTarget: fetchedTarget, intervention: intervention))
    }
    for fetchedOutput in fetchedIntervention.outputs! {
      if fetchedIntervention.globalOutputs! {
        intervention.addToHarvests(createLoadIfGlobalOutput(fetchedOutput: fetchedOutput, intervention: intervention))
      } else {
        for load in fetchedOutput.loads! {
          intervention.addToHarvests(saveLoadToIntervention(
            fetchedLoad: load, intervention: intervention, nature: fetchedOutput.nature.rawValue))
        }
      }
    }
    return intervention
  }

  private func saveIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    var intervention = Intervention(context: managedContext)
    let weather = saveWeatherInIntervention(fetchedIntervention: fetchedIntervention, intervention: intervention)
    let status = Int16((fetchedIntervention.validatedAt == nil ? InterventionState.Synced :
      InterventionState.Validated).rawValue)

    intervention.ekyID = (fetchedIntervention.id as NSString).intValue
    intervention.type = fetchedIntervention.type.rawValue
    intervention.infos = fetchedIntervention.description
    intervention.waterUnit = fetchedIntervention.waterUnit?.rawValue
    (intervention.type == InterventionType.Irrigation.rawValue) ?
      intervention.waterQuantity = Float(fetchedIntervention.waterQuantity!) : nil
    intervention = saveEntitiesIntoIntervention(intervention: intervention, fetchedIntervention: fetchedIntervention)
    intervention.weather = weather as? Weather
    intervention.status = status
    for fetchedInput in fetchedIntervention.inputs! {
      intervention = saveInputsInIntervention(fetchedInput: fetchedInput, intervention: intervention)
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func updateInterventionStatus(fetchedIntervention: InterventionQuery.Data.Farm.Intervention) {
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
        let status = Int16((fetchedIntervention.validatedAt == nil ? InterventionState.Synced :
          InterventionState.Validated).rawValue)

        intervention.first?.status = status
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Could not fetch or save. \(error), \(error.userInfo)")
    }
  }

  private func updateEquipments(
    fetchedIntervention: InterventionQuery.Data.Farm.Intervention, intervention: Intervention) {
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
        intervention.addToInterventionEquipments(
          saveEquipmentsToIntervention(fetchedEquipment: fetchedEquipment, intervention: intervention))
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func updatePersons(
    fetchedIntervention: InterventionQuery.Data.Farm.Intervention, intervention: Intervention) {
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
        intervention.addToInterventionPersons(
          saveInterventionPersonsToIntervention(fetchedOperator: fetchedPerson, intervention: intervention))
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func deleteInterventionInputs(_ entityName: String, intervention: Intervention) {
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

  private func updateInputs(
    fetchedIntervention: InterventionQuery.Data.Farm.Intervention, intervention: inout Intervention) {
    deleteInterventionInputs("InterventionSeed", intervention: intervention)
    deleteInterventionInputs("InterventionPhytosanitary", intervention: intervention)
    deleteInterventionInputs("InterventionFertilizer", intervention: intervention)
    deleteInterventionInputs("InterventionMaterial", intervention: intervention)
    for fetchedInput in fetchedIntervention.inputs! {
      intervention = saveInputsInIntervention(fetchedInput: fetchedInput, intervention: intervention)
    }
  }

  private func updateIntervention(fetchedIntervention: InterventionQuery.Data.Farm.Intervention) {
    let predicate = NSPredicate(format: "ekyID == %d", Int32(fetchedIntervention.id)!)
    var intervention = returnEntityIfSame(entityName: "Intervention", predicate: predicate) as? Intervention

    if intervention != nil {
      let date = fetchedIntervention.workingDays.first!.executionDate!
      let status = (fetchedIntervention.validatedAt == nil ?
        InterventionState.Synced : InterventionState.Validated).rawValue

      intervention?.workingPeriods?.setValue(date, forKey: "executionDate")
      intervention?.workingPeriods?.setValue(
        fetchedIntervention.workingDays.first?.hourDuration, forKey: "hourDuration")
      intervention?.weather?.temperature = fetchedIntervention.weather?.temperature as NSNumber?
      intervention?.weather?.windSpeed = fetchedIntervention.weather?.windSpeed as NSNumber?
      intervention?.weather?.weatherDescription = (fetchedIntervention.weather?.description).map { $0.rawValue }
      intervention?.infos = fetchedIntervention.description
      intervention?.type = fetchedIntervention.type.rawValue
      intervention?.status = Int16(status)
      updateEquipments(fetchedIntervention: fetchedIntervention, intervention: intervention!)
      updatePersons(fetchedIntervention: fetchedIntervention, intervention: intervention!)
      updateInputs(fetchedIntervention: fetchedIntervention, intervention: &intervention!)
    }
  }

  private func loadIntervention(onCompleted: @escaping ((_ success: Bool) -> ())) {
    let query = InterventionQuery(modifiedSince: getLastSyncDate())
    let group = DispatchGroup()

    group.enter()
    apolloClient.fetch(query: query) { (result, error) in
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
            self.saveIntervention(fetchedIntervention: intervention)
            self.updateInterventionStatus(fetchedIntervention: intervention)
          }
        }
      }
      group.leave()
    }

    group.notify(queue: DispatchQueue.main) {
      _ = self.apolloClient.clearCache()
      onCompleted(true)
    }
  }

  func updateInterventionIfChangedOnApi() {
    let query = InterventionQuery(modifiedSince: getLastSyncDate())


    _ = apolloClient.clearCache()
    apolloClient.fetch(query: query, resultHandler: { (result, error) in
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
    })
  }

  // MARK: - Mutations: Interventions

  private func defineWorkingDayAttributesFrom(intervention: Intervention) -> [InterventionWorkingDayAttributes] {
    guard let workingDays = intervention.workingPeriods else {
      fatalError("Could not unwrap NSSet (workingPeriods")
    }
    var workingDaysAttributes = [InterventionWorkingDayAttributes]()

    for case let workingDay as WorkingPeriod in workingDays {
      let workingDayAttributes = InterventionWorkingDayAttributes(
        executionDate: workingDay.executionDate!,
        hourDuration: Double(workingDay.hourDuration))

      workingDaysAttributes.append(workingDayAttributes)
    }
    return workingDaysAttributes
  }

  private func defineTargetAttributesFrom(intervention: Intervention) -> [InterventionTargetAttributes] {
    let targets = intervention.targets
    var targetsAttributes = [InterventionTargetAttributes]()

    for target in targets! {
      let target = target as! Target
      let targetAttributes = InterventionTargetAttributes(
        cropId: (target.crop?.uuid)?.uuidString,
        workAreaPercentage: Int(target.workAreaPercentage))

      targetsAttributes.append(targetAttributes)
    }
    return targetsAttributes
  }

  private func initializeInputsArray(inputs: inout [NSManagedObject], entities: [Any]?) {
    if entities != nil {
      for entity in entities! {
        inputs.append(entity as! NSManagedObject)
      }
    }
  }

  private func appendInputAttributes(id: String?, referenceID: String?, type: ArticleTypeEnum?, quantity: Float,
                                     unit: String) -> InterventionInputAttributes {
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

  private func defineInputsAttributesFrom(intervention: Intervention) -> [InterventionInputAttributes] {
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
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type,
                                                      quantity: seed.quantity, unit: seed.unit!))
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
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type,
                                                      quantity: phyto.quantity, unit: phyto.unit!))
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
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type,
                                                      quantity: fertilizer.quantity, unit: fertilizer.unit!))
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
        inputsAttributes.append(appendInputAttributes(id: id, referenceID: referenceId, type: type,
                                                      quantity: material.quantity, unit: material.unit!))
      default:
        print("No type")
      }
    }
    return inputsAttributes
  }

  private func defineHarvestAttributesFrom(intervention: Intervention) -> [InterventionOutputAttributes] {
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

  private func pushEquipment(equipment: Equipment) {
    let mutation = PushEquipmentMutation(farmID: farmID, type: EquipmentTypeEnum(rawValue: equipment.type!)!,
                                         name: equipment.name!, number: equipment.number,
                                         indicator1: equipment.indicatorOne, indicator2: equipment.indicatorTwo)

    _ = apolloClient.clearCache()
    apolloClient.perform(mutation: mutation, resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("ResultError: \(resultError)")
      } else if let dataError = result?.data?.createEquipment?.errors {
        print("DataError: \(dataError)")
      }

      guard let graphqlID = result?.data?.createEquipment?.equipment?.id, let id = Int32(graphqlID) else {
        print("Could not unwrap equipment id")
        return
      }

      equipment.ekyID = id
    })
  }

  private func pushEntitiesIfNeeded(_ entityName: String, _ predicate: NSPredicate) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

    entitiesFetchRequest.predicate = predicate
    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        switch entity {
        case is Equipment:
          pushEquipment(equipment: entity as! Equipment)
        case is Person:
          pushPerson(person: entity as! Person)
        case is Seed:
          pushSeed(seed: entity as! Seed)
        case is Phyto:
          let phyto = (entity as! Phyto)
          pushInput(
            input: entity as! NSManagedObject, type: .chemical, unit: ArticleUnitEnum(rawValue: phyto.unit!)!)
        case is Fertilizer:
          let fertilizer = (entity as! Fertilizer)
          pushInput(
            input: entity as! NSManagedObject, type: .fertilizer, unit: ArticleUnitEnum(rawValue: fertilizer.unit!)!)
        case is Material:
          let material = (entity as! Material)
          pushInput(
            input: entity as! NSManagedObject, type: .material, unit: ArticleUnitEnum(rawValue: material.unit!)!)
        case is Storage:
          pushStorage(storage: entity as! Storage)
        default:
          return
        }
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not fetch or save. \(error), \(error.userInfo)")
    }
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

  private func defineEquipmentAttributesFrom(intervention: Intervention) -> [InterventionToolAttributes] {
    let equipments = intervention.interventionEquipments
    var equipmentsAttributes = [InterventionToolAttributes]()

    for equipment in equipments! {
      let equipmentID = (equipment as! InterventionEquipment).equipment!.ekyID
      let equipmentAttributes = InterventionToolAttributes(equipmentId: (equipmentID as NSNumber?)?.stringValue)

      equipmentsAttributes.append(equipmentAttributes)
    }
    return equipmentsAttributes
  }

  private func pushPerson(person: Person) {
    let mutation = PushPersonMutation(farmID: farmID, firstName: person.firstName, lastName: person.lastName!)

    _ = apolloClient.clearCache()
    apolloClient.perform(mutation: mutation, resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("ResultError: \(resultError)")
      } else if let dataError = result?.data?.createPerson?.errors {
        print("DataError: \(dataError)")
      }

      guard let graphqlID = result?.data?.createPerson?.person?.id, let id = Int32(graphqlID) else {
        print("Could not unwrap person id")
        return
      }

      person.ekyID = id
    })
  }

  private func defineOperatorAttributesFrom(intervention: Intervention) -> [InterventionOperatorAttributes] {
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

  private func defineWeatherAttributesFrom(intervention: Intervention) -> WeatherAttributes {
    var weather = WeatherAttributes()

    weather.temperature = intervention.weather?.temperature as? Double
    weather.windSpeed = intervention.weather?.windSpeed as? Double
    weather.description = (intervention.weather?.weatherDescription).map { WeatherEnum(rawValue: $0) }
    return weather
  }

  private func setupMutation(_ intervention: Intervention) -> PushInterMutation {
    let mutation = PushInterMutation(
      farmID: farmID,
      procedure: InterventionTypeEnum(rawValue: intervention.type!)!,
      cropList: defineTargetAttributesFrom(intervention: intervention),
      workingDays: defineWorkingDayAttributesFrom(intervention: intervention),
      waterQuantity: intervention.type == "IRRIGATION" ? Int(intervention.waterQuantity) : nil,
      waterUnit: intervention.type == "IRRIGATION" ?
        InterventionWaterVolumeUnitEnum(rawValue: intervention.waterUnit!) : nil,
      inputs: defineInputsAttributesFrom(intervention: intervention),
      outputs: defineHarvestAttributesFrom(intervention: intervention),
      globalOutputs: false,
      tools: defineEquipmentAttributesFrom(intervention: intervention),
      operators: defineOperatorAttributesFrom(intervention: intervention),
      weather: defineWeatherAttributesFrom(intervention: intervention),
      description: intervention.infos)

    return mutation
  }

  func pushIntervention(_ intervention: Intervention) {
    let mutation = setupMutation(intervention)

    _ = apolloClient.clearCache()
    apolloClient.perform(mutation: mutation, resultHandler: { (result, error) in
      if let error = error {
        print("Error: \(error)")
      } else if let resultError = result?.errors {
        print("Result error: \(resultError)")
      } else if let dataError = result?.data?.createIntervention?.errors {
        print("Data error: \(dataError)")
      }

      guard let graphqlID = result?.data?.createIntervention?.intervention?.id, let id = Int32(graphqlID) else {
        print("Could not unwrap intervention id")
        return
      }

      intervention.ekyID = id
    })
  }

  func pushUpdatedIntervention(intervention: Intervention) {
    let updateMutation = UpdateInterMutation(
      interventionID: String(intervention.ekyID),
      farmID: farmID!,
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

    _ = apolloClient.clearCache()
    apolloClient.perform(mutation: updateMutation, resultHandler: { (error, result) in
      if let error = error?.errors {
        print("Error: \(String(describing: error))")
      } else {
        intervention.status = InterventionState.Synced.rawValue
      }
    })
  }
}
