//
//  CropsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 27/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class CropsView: UIView, UITableViewDataSource, UITableViewDelegate {

  //MARK: - Properties

  public var titleLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "Sélectionnez des cultures"
    label.font = UIFont.systemFont(ofSize: 19)
    label.textColor = AppColor.TextColors.White
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var headerView: UIView = {
    let view = UIView(frame: CGRect.zero)
    view.backgroundColor = AppColor.BarColors.Green
    view.addSubview(titleLabel)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  var selectedIndexPath: IndexPath?
  var indexPaths: [IndexPath] = []

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.separatorInset = UIEdgeInsets.zero
    tableView.tableFooterView = UIView()
    tableView.bounces = false
    tableView.register(PlotCell.self, forCellReuseIdentifier: "PlotCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  public var selectedCropsLabel: UILabel = {
    let label = UILabel(frame: CGRect.zero)
    label.text = "Aucune sélection"
    label.font = UIFont.systemFont(ofSize: 17)
    label.textColor = AppColor.TextColors.White
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  public var validateButton: UIButton = {
    let button = UIButton(frame: CGRect.zero)
    button.setTitle("VALIDER", for: .normal)
    button.setTitleColor(AppColor.TextColors.Black, for: .normal)
    button.backgroundColor = UIColor.white
    button.layer.cornerRadius = 5
    button.clipsToBounds = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  lazy var bottomView: UIView = {
    let view = UIView(frame: CGRect.zero)
    view.backgroundColor = AppColor.BarColors.Green
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(selectedCropsLabel)
    view.addSubview(validateButton)
    return view
  }()

  var plots = [NSManagedObject]()
  var crops = [NSManagedObject]()
  var viewsArray = [[UIView]]()
  var cropPlots = [[NSManagedObject]]()
  var selectedCrops = [NSManagedObject]()
  var cropsCount = 0
  var totalSurfaceArea: Double = 0

  //MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    if !fetchPlots() {
      loadSamplePlots()
    }
    setupView()
  }

  private func setupView() {
    self.isHidden = true
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.addSubview(headerView)
    self.addSubview(tableView)
    self.addSubview(bottomView)
    setupLayout()
  }

  private func setupLayout() {
    let viewsDict = [
      "header" : headerView,
      "title" : titleLabel,
      "table" : tableView,
      "bottom" : bottomView,
      "selected" : selectedCropsLabel,
      "validate" : validateButton,
      ] as [String : Any]

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[title]", options: [], metrics: nil, views: viewsDict))
    NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[selected]", options: [], metrics: nil, views: viewsDict))
    NSLayoutConstraint(item: selectedCropsLabel, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[validate(>=90)]-13-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-13-[validate]-13-|", options: [], metrics: nil, views: viewsDict))

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[header]|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottom]|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[header(60)][table][bottom(60)]|", options: [], metrics: nil, views: viewsDict))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Table view

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return plots.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PlotCell", for: indexPath) as! PlotCell
    let plot = plots[indexPath.row]
    let crops = fetchCrops(fromPlot: plot)

    cell.checkboxButton.addTarget(self, action: #selector(tapCheckbox), for: .touchUpInside)
    cell.nameLabel.text = plot.value(forKey: "name") as? String
    cell.nameLabel.sizeToFit()
    cell.surfaceAreaLabel.text = String(format: "%.1f ha", plot.value(forKey: "surfaceArea") as! Double)
    cell.surfaceAreaLabel.sizeToFit()

    var views = [UIView]()

    for (index, crop) in crops.enumerated() {
      let view = UIView(frame: CGRect(x: 15, y: 60 + index * 60, width: Int(cell.frame.size.width - 30), height: 60))
      view.backgroundColor = UIColor.white
      view.layer.borderColor = UIColor.lightGray.cgColor
      view.layer.borderWidth = 0.5
      let cropImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
      cropImageView.backgroundColor = UIColor.lightGray
      view.addSubview(cropImageView)
      let checkboxImage = UIImageView(frame: CGRect(x: 7, y: 7, width: 16, height: 16))
      checkboxImage.image = #imageLiteral(resourceName: "uncheckedCheckbox")
      view.addSubview(checkboxImage)
      let nameLabel = UILabel(frame: CGRect(x: 70, y: 7, width: 200, height: 20))
      nameLabel.textColor = UIColor.black
      let name = crop.value(forKey: "name") as! String
      let calendar = Calendar.current
      let date = crop.value(forKey: "startDate") as! Date
      let year = calendar.component(.year, from: date)
      nameLabel.text = name + " | \(year)"
      nameLabel.font = UIFont.systemFont(ofSize: 13.0)
      view.addSubview(nameLabel)
      let surfaceAreaLabel = UILabel(frame: CGRect(x: 70, y: 33, width: 200, height: 20))
      surfaceAreaLabel.textColor = UIColor.darkGray
      let surfaceArea = crop.value(forKey: "surfaceArea") as! Double
      surfaceAreaLabel.text = String(format: "%.1f ha travaillés", surfaceArea)
      surfaceAreaLabel.font = UIFont.systemFont(ofSize: 13.0)
      view.addSubview(surfaceAreaLabel)
      let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCropView))
      gesture.numberOfTapsRequired = 1
      view.addGestureRecognizer(gesture)
      view.isHidden = true
      cell.addSubview(view)
      views.append(view)
    }
    viewsArray.append(views)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndexPath = indexPath

    let cell = tableView.cellForRow(at: selectedIndexPath!) as! PlotCell
    if !indexPaths.contains(selectedIndexPath!) {
      indexPaths += [selectedIndexPath!]
      cell.expandCollapseImageView.transform = cell.expandCollapseImageView.transform.rotated(by: CGFloat.pi)
    } else {
      let index = indexPaths.index(of: selectedIndexPath!)
      indexPaths.remove(at: index!)
      cell.expandCollapseImageView.transform = cell.expandCollapseImageView.transform.rotated(by: CGFloat.pi)
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPaths.contains(indexPath) {
      guard let cell = tableView.cellForRow(at: indexPath) else {
        return 0
      }
      let count = cell.subviews.count - 1
      return CGFloat(count * 60 + 15)
    }
    return 60
  }

  //MARK: - Core Data

  private func loadSamplePlots() {
    createPlot(name: "Crop 1", surfaceArea: 7.5)
    createCrop(plotName: "Crop 1", name: "Blé tendre", surfaceArea: 3, startDate: Date())
    createCrop(plotName: "Crop 1", name: "Maïs", surfaceArea: 4.5, startDate: Date())

    createPlot(name: "Epoisses", surfaceArea: 0.651)
    createCrop(plotName: "Epoisses", name: "Artichaut", surfaceArea: 0.651, startDate: Date())

    createPlot(name: "Cabécou", surfaceArea: 12.06)
    createCrop(plotName: "Cabécou", name: "Avoine", surfaceArea: 6.3, startDate: Date())
    createCrop(plotName: "Cabécou", name: "Ciboulette", surfaceArea: 0.92, startDate: Date())
    createCrop(plotName: "Cabécou", name: "Cornichon", surfaceArea: 4.84, startDate: Date())
  }

  func createPlot(name: String, surfaceArea: Double) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let plotsEntity = NSEntityDescription.entity(forEntityName: "Plots", in: managedContext)!
    let plot = NSManagedObject(entity: plotsEntity, insertInto: managedContext)

    plot.setValue(name, forKey: "name")
    plot.setValue(surfaceArea, forKey: "surfaceArea")

    do {
      try managedContext.save()
      plots.append(plot)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createCrop(plotName: String, name: String, surfaceArea: Double, startDate: Date) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsEntity = NSEntityDescription.entity(forEntityName: "Crops", in: managedContext)!
    let crop = NSManagedObject(entity: cropsEntity, insertInto: managedContext)
    let plot = fetchPlot(withName: plotName)

    crop.setValue(plot, forKey: "plots")
    crop.setValue(name, forKey: "name")
    crop.setValue(surfaceArea, forKey: "surfaceArea")
    crop.setValue(startDate, forKey: "startDate")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func fetchPlots() -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return false
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let plotsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Plots")

    do {
      plots = try managedContext.fetch(plotsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    if plots.count < 1 {
      return false
    }
    return true
  }

  func fetchPlot(withName plotName: String) -> NSManagedObject {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return NSManagedObject()
    }

    var plots: [NSManagedObject]!
    let managedContext = appDelegate.persistentContainer.viewContext
    let plotsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Plots")
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
    return NSManagedObject()
  }

  func fetchCrops(fromPlot plot: NSManagedObject) -> [NSManagedObject] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return [NSManagedObject]()
    }

    var crops: [NSManagedObject]!
    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Crops")
    let predicate = NSPredicate(format: "plots == %@", plot)
    cropsFetchRequest.predicate = predicate

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    return crops
  }

  //MARK: - Actions

  @objc func tapCheckbox(_ sender: UIButton) {
    guard let cell = sender.superview?.superview as? PlotCell else {
      return
    }

    let indexPath = tableView.indexPath(for: cell)!
    let plot = plots[indexPath.row]
    let plotSurfaceArea = plot.value(forKey: "surfaceArea") as! Double
    let crops = fetchCrops(fromPlot: plot)

    print(cell.subviews)
    if !sender.isSelected {
      sender.isSelected = true
      cropsCount += crops.count
      totalSurfaceArea += plotSurfaceArea
      for view in cell.subviews[1...crops.count] {
        let checkboxImage = view.subviews[1] as! UIImageView
        checkboxImage.image = #imageLiteral(resourceName: "checkedCheckbox")
      }
      for crop in crops {
        selectedCrops.append(crop)
      }
    } else {
      sender.isSelected = false
      for (index, view) in cell.subviews[1...crops.count].enumerated() {
        let checkboxImage = view.subviews[1] as! UIImageView
        if checkboxImage.image == #imageLiteral(resourceName: "checkedCheckbox") {
          checkboxImage.image = #imageLiteral(resourceName: "uncheckedCheckbox")
          cropsCount -= 1
          totalSurfaceArea -= crops[index].value(forKey: "surfaceArea") as! Double
          if let index = selectedCrops.index(of: crops[index]) {
            selectedCrops.remove(at: index)
          }
        }
      }
    }

    if cropsCount == 0 {
      selectedCropsLabel.text = "Aucune sélection"
    } else if cropsCount == 1 {
      selectedCropsLabel.text = String(format: "1 culture • %.1f ha", totalSurfaceArea)
    } else {
      selectedCropsLabel.text = String(format: "%d cultures • %.1f ha", cropsCount, totalSurfaceArea)
    }
  }

  @objc func tapCropView(sender: UIGestureRecognizer) {
    let cell = sender.view?.superview as! PlotCell
    let view = sender.view!

    var plot: NSManagedObject!
    var crops: [NSManagedObject]!
    var crop: NSManagedObject!

    for views in viewsArray {
      if let indexView = views.index(of: view) {
        plot = plots[viewsArray.index(of: views)!]
        crops = fetchCrops(fromPlot: plot)
        crop = crops[indexView]
        break
      }
    }

    let checkboxImage = view.subviews[1] as! UIImageView

    if checkboxImage.image == #imageLiteral(resourceName: "uncheckedCheckbox") {
      checkboxImage.image = #imageLiteral(resourceName: "checkedCheckbox")
      cropsCount += 1
      totalSurfaceArea += crop.value(forKey: "surfaceArea") as! Double
      if !cell.checkboxButton.isSelected {
        cell.checkboxButton.isSelected = true
      }
      selectedCrops.append(crop)
    } else if checkboxImage.image == #imageLiteral(resourceName: "checkedCheckbox") {
      checkboxImage.image = #imageLiteral(resourceName: "uncheckedCheckbox")
      cropsCount -= 1
      totalSurfaceArea -= crop.value(forKey: "surfaceArea") as! Double
      for (index, view) in cell.subviews[2...crops.count + 1].enumerated() {
        let checkboxImage = view.subviews[1] as! UIImageView
        if checkboxImage.image == #imageLiteral(resourceName: "checkedCheckbox") {
          break
        } else if checkboxImage.image == #imageLiteral(resourceName: "uncheckedCheckbox") && index == crops.count - 1 {
          cell.checkboxButton.isSelected = false
        }

        if let index = selectedCrops.index(of: crop) {
          selectedCrops.remove(at: index)
        }
      }
    }

    if cropsCount == 0 {
      selectedCropsLabel.text = "Aucune sélection"
    } else if cropsCount == 1 {
      selectedCropsLabel.text = String(format: "1 culture • %.1f ha", totalSurfaceArea)
    } else {
      selectedCropsLabel.text = String(format: "%d cultures • %.1f ha", cropsCount, totalSurfaceArea)
    }
  }
}
