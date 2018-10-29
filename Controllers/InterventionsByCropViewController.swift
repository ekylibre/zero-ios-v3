//
//  InterventionsByCropViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 29/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class InterventionsByCropViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  // MARK: - Properties

  @IBOutlet weak var cropsTableView: UITableView!

  var cropsByProduction = [[Crops]]()

  // MARK: - Initialization

  override func viewDidLoad() {
    fetchCrops()
    sortProductions()
    cropsTableView.register(ProductionCell.self, forCellReuseIdentifier: "ProductionCell")
    cropsTableView.register(MaterialCell.self, forCellReuseIdentifier: "MaterialCell")
    cropsTableView.separatorInset = UIEdgeInsets.zero
    cropsTableView.tableFooterView = UIView()
    cropsTableView.bounces = false
    cropsTableView.rowHeight = 50
    cropsTableView.delegate = self
    cropsTableView.dataSource = self
  }

  private func sortProductions() {
    cropsByProduction = cropsByProduction.sorted(by: {
      $0.first!.species!.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        <
      $1.first!.species!.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
    })
  }

  // MARK: - Core Data

  private func fetchCrops() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crops> = Crops.fetchRequest()
    let sort = NSSortDescriptor(key: "productionID", ascending: true)
    cropsFetchRequest.sortDescriptors = [sort]

    do {
      let crops = try managedContext.fetch(cropsFetchRequest)
      organizeCropsByProduction(crops)
      sortCropsByPlotName()
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func organizeCropsByProduction(_ crops: [Crops]) {
    var cropsFromSameProduction = [Crops]()
    var productionID = crops.first?.productionID

    for crop in crops {
      if crop.productionID != productionID {
        productionID = crop.productionID
        cropsByProduction.append(cropsFromSameProduction)
        cropsFromSameProduction = [Crops]()
      }
      cropsFromSameProduction.append(crop)
    }
    cropsByProduction.append(cropsFromSameProduction)
  }

  private func sortCropsByPlotName() {
    for (index, crops) in cropsByProduction.enumerated() {
      cropsByProduction[index] = crops.sorted(by: {
        $0.plotName!.lowercased().folding(options: .diacriticInsensitive, locale: .current)
          <
        $1.plotName!.lowercased().folding(options: .diacriticInsensitive, locale: .current)
      })
    }
  }

  // MARK: - Table view

  func numberOfSections(in tableView: UITableView) -> Int {
    return cropsByProduction.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cropsByProduction[section].count
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableCell(withIdentifier: "ProductionCell") as! ProductionCell
    let specie = cropsByProduction[section].first?.species?.localized.uppercased()
    let stopDate = cropsByProduction[section].first?.stopDate
    let calendar = Calendar.current
    let year = calendar.component(.year, from: stopDate!)

    header.nameLabel.text = String(format: "%@ %d", specie!, year)
    return header.contentView
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialCell", for: indexPath) as! MaterialCell

    cell.nameLabel.text = cropsByProduction[indexPath.section][indexPath.row].plotName
    return cell
  }

  // MARK: - Actions

  @IBAction func dismissViewController(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}
