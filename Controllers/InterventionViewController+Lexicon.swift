//
//  InterventionViewController+Lexicon.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 08/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension InterventionViewController {

  func loadRegisteredInputs() {
    let assets = openAssets()
    let decoder = JSONDecoder()

    do {
      let registeredSeeds = try decoder.decode([RegisteredSeed].self, from: assets[0].data)
      let registeredPhytos = try decoder.decode([RegisteredPhyto].self, from: assets[1].data)
      let registeredFertilizers = try decoder.decode([RegisteredFertilizer].self, from: assets[2].data)

      saveSeeds(registeredSeeds)
      savePhytos(registeredPhytos)
      saveFertilizers(registeredFertilizers)
    } catch let jsonError {
      print(jsonError)
    }
  }

  private func openAssets() -> [NSDataAsset] {
    var assets = [NSDataAsset]()
    let assetNames = ["seeds", "phytosanitary-products", "fertilizers"]

    for assetName in assetNames {
      if let asset = NSDataAsset(name: assetName) {
        assets.append(asset)
      } else {
        fatalError(assetName + " not found")
      }
    }
    return assets
  }

  func saveSeeds(_ registeredSeeds: [RegisteredSeed]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for registeredSeed in registeredSeeds {
      let seed = Seeds(context: managedContext)

      seed.registered = true
      seed.ekyID = 0
      seed.referenceID = Int32(registeredSeed.id)
      seed.specie = registeredSeed.specie.uppercased()
      seed.variety = registeredSeed.variety
      seed.unit = "KILOGRAM_PER_HECTARE"
      seed.used = false
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func savePhytos(_ registeredPhytos: [RegisteredPhyto]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for registeredPhyto in registeredPhytos {
      let phyto = Phytos(context: managedContext)

      phyto.registered = true
      phyto.ekyID = 0
      phyto.referenceID = Int32(registeredPhyto.id)
      phyto.name = registeredPhyto.name
      phyto.nature = registeredPhyto.nature
      phyto.maaID = registeredPhyto.maaid
      phyto.mixCategoryCode = registeredPhyto.mixCategoryCode
      phyto.inFieldReentryDelay = Int32(registeredPhyto.inFieldReentryDelay)
      phyto.firmName = registeredPhyto.firmName
      phyto.unit = "LITER_PER_HECTARE"
      phyto.used = false
    }


    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func saveFertilizers(_ registeredFertilizers: [RegisteredFertilizer]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for registeredFertilizer in registeredFertilizers {
      let fertilizer = Fertilizers(context: managedContext)

      fertilizer.registered = true
      fertilizer.ekyID = 0
      fertilizer.referenceID = Int32(registeredFertilizer.id)
      fertilizer.name = registeredFertilizer.name.uppercased()
      fertilizer.variant = registeredFertilizer.variant
      fertilizer.variety = registeredFertilizer.variety
      fertilizer.derivativeOf = registeredFertilizer.derivativeOf
      fertilizer.nature = registeredFertilizer.nature
      fertilizer.nitrogenConcentration = registeredFertilizer.nitrogenConcentration
      fertilizer.phosphorusConcentration = registeredFertilizer.phosphorusConcentration as NSNumber?
      fertilizer.potassiumConcentration = registeredFertilizer.potassiumConcentration as NSNumber?
      fertilizer.sulfurTrioxydeConcentration = registeredFertilizer.sulfurTrioxydeConcentration as NSNumber?
      fertilizer.unit = "KILOGRAM_PER_HECTARE"
      fertilizer.used = false
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}
