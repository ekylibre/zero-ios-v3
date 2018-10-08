//
//  InterventionsViewController+Apollo.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 19/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import Apollo
import CoreData

extension InterventionViewController {

  func checkLocalData() {
    initializeApolloClient()

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    queryFarms()
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
        self.saveCrops(crops: farms.first!.crops)
        self.saveArticles(articles: farms.first!.articles)
      } else {
        self.registerFarmID()
        self.checkCropsData(crops: farms.first!.crops)
        self.checkArticlesData(articles: farms.first!.articles)
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

    if new.type.rawValue != "MATERIAL" {
      article.setValue((new.referenceId != nil), forKey: "registered")
    }
    
    article.setValue(Int(new.id), forKey: "ekyID")
    article.setValue(new.unit.rawValue.lowercased(), forKey: "unit")

    if new.referenceId != nil {
      article.setValue(Int(new.referenceId!), forKey: "referenceID")
    }

    if new.type.rawValue == "SEED" {
      article.setValue(new.species?.rawValue.lowercased(), forKey: "specie")
      article.setValue(new.variety, forKey: "variety")
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
}
