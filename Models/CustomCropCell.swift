//
//  CustomCropCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 08/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class CustomCropCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

  var plots = [NSManagedObject]()

  init(style: UITableViewCellStyle, reuseIdentifier: String?, cropId: Int16) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    fetchPlots(cropId: cropId)
    setUpTable()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    setUpTable()
  }

  func fetchPlots(cropId: Int16) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let plotsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Plots")
    let predicate = NSPredicate(format: "cropId = %@", cropId)
    plotsFetchRequest.predicate = predicate

    do {
      plots = try managedContext.fetch(plotsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  func setUpTable() {
    return
    //plotsTableView.delegate = self
    //plotsTableView.dataSource = self
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return plots.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let plot = plots[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: "PlotTableViewCell", for: indexPath) as! PlotTableViewCell

    cell.nameLabel.text = plot.value(forKey: "name") as? String
    cell.surfaceAreaLabel.text = String(format: "%.1f ha",plot.value(forKey: "surfaceArea") as! Double)
    return cell
  }
}
