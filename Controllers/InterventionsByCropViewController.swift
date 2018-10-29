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

  var cropsByPlot: [[Crops]]!

  // MARK: - Initialization

  override func viewDidLoad() {
    cropsTableView.register(CropCell.self, forCellReuseIdentifier: "CropCell")
    cropsTableView.rowHeight = 50
    cropsTableView.delegate = self
    cropsTableView.dataSource = self
  }

  // MARK: - Core Data

  private func fetchCrops() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crops> = Crops.fetchRequest()
    let sort = NSSortDescriptor(key: "plotName", ascending: true)
    cropsFetchRequest.sortDescriptors = [sort]

    do {
      let crops = try managedContext.fetch(cropsFetchRequest)
      organizeCropsByPlot(crops)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func organizeCropsByPlot(_ crops: [Crops]) {
    var cropsFromSamePlot = [Crops]()
    var name = crops.first?.plotName

    for crop in crops {
      if crop.plotName != name {
        name = crop.plotName
        self.cropsByPlot.append(cropsFromSamePlot)
        cropsFromSamePlot = [Crops]()
      }
      cropsFromSamePlot.append(crop)
    }
    self.cropsByPlot.append(cropsFromSamePlot)
  }

  // MARK: - Table view

  func numberOfSections(in tableView: UITableView) -> Int {
    return cropsByPlot.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cropsByPlot[section].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  }

  // MARK: - Actions

  @IBAction func dismissViewController(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}
