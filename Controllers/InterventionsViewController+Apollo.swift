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
    let crops = fetchCrops()

    initializeApolloClient()

    if crops.count == 0 {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      queryFarms()
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  }

  private func fetchCrops() -> [Crops] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return [Crops]()
    }

    var crops: [Crops]!
    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crops> = Crops.fetchRequest()

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return crops
  }

  private func initializeApolloClient() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let url = URL(string: "https://api.ekylibre-test.com/v1/graphql")!
    let configuation = URLSessionConfiguration.default
    let authService = AuthentificationService(username: "", password: "")
    let token = authService.oauth2.accessToken!

    configuation.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    appDelegate.apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuation))
  }

  private func queryFarms() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let apollo = appDelegate.apollo!
    let query = FarmQuery()

    apollo.fetch(query: query) { result, error in
      if let error = error { print("Error: \(error)"); return }

      guard let farms = result?.data?.farms else { print("Could not retrieve farms"); return }
      self.saveCrops(crops: farms.first!.crops!)
      self.saveArticles(articles: farms.first!.articles!)
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
      seed.variety = article.variety
      seed.specie = article.species?.rawValue
      seed.unit = article.unit.rawValue
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
    }
  }

  private func saveMaterial(_ managedContext: NSManagedObjectContext, _ article: FarmQuery.Data.Farm.Article) {
    let material = Materials(context: managedContext)

    material.name = article.name
    material.ekyID = Int32(article.id)!
    material.unit = article.unit.rawValue
  }
}
