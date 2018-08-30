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
    tableView.register(SeedCell.self, forCellReuseIdentifier: "SeedCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 44
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

  //MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    //self.translatesAutoresizingMaskIntoConstraints = false
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
      cell.expandCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    } else {
      let index = indexPaths.index(of: selectedIndexPath!)
      indexPaths.remove(at: index!)
      cell.expandCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
    }
    tableView.beginUpdates()
    tableView.endUpdates()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPaths.contains(indexPath) {
      guard let cell = tableView.cellForRow(at: indexPath) else {
        return 0
      }
      let count = cell.subviews.count - 2
      return CGFloat(count * 60 + 15)
    } else {
      return 60
    }
  }

  //MARK: - Core data

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

  func fetchPlots() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let plotsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Plots")

    do {
      plots = try managedContext.fetch(plotsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
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
}
