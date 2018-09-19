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

  func initializeApolloClient() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let url = URL(string: "https://api.ekylibre-test.com/v1/graphql")!
    let configuation = URLSessionConfiguration.default
    let authService = AuthentificationService(username: "", password: "")
    let token = authService.oauth2.accessToken!

    configuation.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    appDelegate.apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuation))
  }

  func queryFarms() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let apollo = appDelegate.apollo!
    let query = FarmQuery()

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    apollo.fetch(query: query) { result, error in
      if let error = error { print("Error: \(error)"); return }

      guard let farms = result?.data?.farms else { print("Could not retrieve farms"); return }
      //self.savePlots(plots: farms.first!.plots!)
      //self.saveCrops(crops: farms.first!.crops!)
      self.saveArticles(articles: farms.first!.articles!)
    }
  }

  // MARK: - Crops

  private func savePlots(plots: [FarmQuery.Data.Farm.Plot]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for plot in plots {
      let newPlot = Plots(context: managedContext)

      newPlot.uuid = UUID(uuidString: plot.uuid)
      newPlot.name = plot.name
      let splitString = plot.surfaceArea.split(separator: " ", maxSplits: 1)
      let surfaceArea = Double(splitString.first!)!
      newPlot.surfaceArea = surfaceArea
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

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
      newCrop.name = crop.name
      newCrop.productionMode = crop.productionMode
      newCrop.provisionalYield = crop.provisionalYield
      newCrop.species = crop.species.rawValue
      newCrop.startDate = dateFormatter.date(from: crop.startDate!)
      newCrop.startDate = dateFormatter.date(from: crop.stopDate!)
      let splitString = crop.surfaceArea.split(separator: " ", maxSplits: 1)
      let surfaceArea = Double(splitString.first!)!
      newCrop.surfaceArea = surfaceArea

      let plot = fetchPlot(withName: crop.name)
      newCrop.plots = plot
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func fetchPlot(withName plotName: String) -> Plots {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return Plots()
    }

    var plots: [Plots]!
    let managedContext = appDelegate.persistentContainer.viewContext
    let plotsFetchRequest: NSFetchRequest<Plots> = Plots.fetchRequest()
    let predicate = NSPredicate(format: "name == %@", plotName)
    plotsFetchRequest.predicate = predicate

    do {
      plots = try managedContext.fetch(plotsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    if plots.count == 1 {
      return plots.first!
    }
    return Plots()
  }

  // MARK: - Articles

  private func saveArticles(articles: [FarmQuery.Data.Farm.Article]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    print("count: \(articles.count)")
    for article in articles {
      print("type: ", article.type.rawValue)
      print("name: ", article.name)
      print("id: ", article.id)
      print("refID: ", article.referenceId)
      print("unit: ", article.unit.rawValue)
      print("variety: ", article.variety)
      print("specie: ", article.species?.rawValue)
      print("amm: ", article.marketingAuthorizationNumber, "\n")
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

  private func saveSeed(_ managedContext: NSManagedObjectContext,_ article: FarmQuery.Data.Farm.Article) {
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

  private func savePhyto(_ managedContext: NSManagedObjectContext,_ article: FarmQuery.Data.Farm.Article) {
    let phyto = Phytos(context: managedContext)

    if article.referenceId == nil {
      phyto.registered = false
      phyto.name = article.name
      phyto.unit = article.unit.rawValue
    }
  }

  private func saveFertilizer(_ managedContext: NSManagedObjectContext,_ article: FarmQuery.Data.Farm.Article) {
    let fertilizer = Fertilizers(context: managedContext)

    if article.referenceId == nil {
      fertilizer.registered = false
      fertilizer.name = article.name
      fertilizer.unit = article.unit.rawValue
    }
  }

  private func saveMaterial(_ managedContext: NSManagedObjectContext,_ article: FarmQuery.Data.Farm.Article) {
    let material = Materials(context: managedContext)

    if article.referenceId == nil {
      material.name = article.name
      material.unit = article.unit.rawValue
    }
  }
}
