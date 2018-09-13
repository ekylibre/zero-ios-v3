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

  // MARK: - Properties

  public var titleLabel: UILabel = {
    let titleLabel = UILabel(frame: CGRect.zero)
    titleLabel.text = "Sélectionnez des cultures"
    titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
    titleLabel.textColor = AppColor.TextColors.White
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  lazy var headerView: UIView = {
    let headerView = UIView(frame: CGRect.zero)
    headerView.backgroundColor = AppColor.BarColors.Green
    headerView.addSubview(titleLabel)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    return headerView
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
    let selectedCropsLabel = UILabel(frame: CGRect.zero)
    selectedCropsLabel.text = "Aucune sélection"
    selectedCropsLabel.font = UIFont.boldSystemFont(ofSize: 17)
    selectedCropsLabel.textColor = AppColor.TextColors.White
    selectedCropsLabel.translatesAutoresizingMaskIntoConstraints = false
    return selectedCropsLabel
  }()

  public var validateButton: UIButton = {
    let validateButton = UIButton(frame: CGRect.zero)
    validateButton.setTitle("VALIDER", for: .normal)
    validateButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    validateButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    validateButton.backgroundColor = UIColor.white
    validateButton.layer.cornerRadius = 3
    validateButton.clipsToBounds = true
    validateButton.translatesAutoresizingMaskIntoConstraints = false
    return validateButton
  }()

  lazy var bottomView: UIView = {
    let bottomView = UIView(frame: CGRect.zero)
    bottomView.backgroundColor = AppColor.BarColors.Green
    bottomView.translatesAutoresizingMaskIntoConstraints = false
    bottomView.addSubview(selectedCropsLabel)
    bottomView.addSubview(validateButton)
    return bottomView
  }()

  var plots = [Plots]()
  var viewsArray = [[UIView]]()
  var selectedCrops = [Crops]()
  var cropsCount = 0
  var totalSurfaceArea: Double = 0

  // MARK: - Initialization

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
    self.layer.cornerRadius = 3
    self.clipsToBounds = true
    self.addSubview(headerView)
    self.addSubview(tableView)
    self.addSubview(bottomView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      headerView.topAnchor.constraint(equalTo: self.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 60),
      headerView.leftAnchor.constraint(equalTo: self.leftAnchor),
      headerView.widthAnchor.constraint(equalTo: self.widthAnchor),
      tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
      tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
      tableView.widthAnchor.constraint(equalTo: self.widthAnchor),
      selectedCropsLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
      selectedCropsLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 30),
      validateButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 13),
      validateButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -13),
      validateButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -13),
      validateButton.widthAnchor.constraint(equalToConstant: 100),
      bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      bottomView.heightAnchor.constraint(equalToConstant: 60),
      bottomView.leftAnchor.constraint(equalTo: self.leftAnchor),
      bottomView.widthAnchor.constraint(equalTo: self.widthAnchor)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Table view

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
      let cropImage = #imageLiteral(resourceName: "crop")
      let tintedImage = cropImage.withRenderingMode(.alwaysTemplate)
      cropImageView.image = tintedImage
      cropImageView.tintColor = UIColor.darkGray
      cropImageView.backgroundColor = UIColor.lightGray
      view.addSubview(cropImageView)
      let checkboxImage = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
      checkboxImage.image = #imageLiteral(resourceName: "check-box-blank")
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
    } else {
      let index = indexPaths.index(of: selectedIndexPath!)
      indexPaths.remove(at: index!)
    }
    cell.expandCollapseImageView.transform = cell.expandCollapseImageView.transform.rotated(by: CGFloat.pi)
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

  // MARK: - Core Data

  func fetchPlots() -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return false
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let plotsFetchRequest: NSFetchRequest<Plots> = Plots.fetchRequest()

    do {
      plots = try managedContext.fetch(plotsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    return (plots.count > 0) ? true : false
  }

  func fetchPlot(withName plotName: String) -> Plots {
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

  func fetchCrops(fromPlot plot: Plots) -> [Crops] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return [Crops]()
    }

    var crops: [Crops]!
    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crops> = Crops.fetchRequest()
    let predicate = NSPredicate(format: "plots == %@", plot)
    cropsFetchRequest.predicate = predicate

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    return crops
  }

  private func loadSamplePlots() {
    createPlot(name: "Plot 1", surfaceArea: 7.5)
    createCrop(plotName: "Plot 1", name: "Blé tendre", surfaceArea: 3, startDate: Date())
    createCrop(plotName: "Plot 1", name: "Maïs", surfaceArea: 4.5, startDate: Date())

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
    let plot = Plots(context: managedContext)

    plot.name = name
    plot.surfaceArea = surfaceArea

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
    let crop = Crops(context: managedContext)
    let plot = fetchPlot(withName: plotName)

    crop.plots = plot
    crop.name = name
    crop.surfaceArea = surfaceArea
    crop.startDate = startDate

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Actions

  @objc func tapCheckbox(_ sender: UIButton) {
    guard let cell = sender.superview?.superview as? PlotCell else {
      return
    }

    let indexPath = tableView.indexPath(for: cell)!
    let plot = plots[indexPath.row]
    let plotSurfaceArea = plot.value(forKey: "surfaceArea") as! Double
    let crops = fetchCrops(fromPlot: plot)

    if !sender.isSelected {
      sender.isSelected = true
      cropsCount += crops.count
      totalSurfaceArea += plotSurfaceArea
      for view in cell.subviews[1...crops.count] {
        let checkboxImage = view.subviews[1] as! UIImageView
        checkboxImage.image = #imageLiteral(resourceName: "check-box")
      }
      for crop in crops {
        selectedCrops.append(crop)
      }
    } else {
      sender.isSelected = false
      for (index, view) in cell.subviews[1...crops.count].enumerated() {
        let checkboxImage = view.subviews[1] as! UIImageView
        if checkboxImage.image == #imageLiteral(resourceName: "check-box") {
          checkboxImage.image = #imageLiteral(resourceName: "check-box-blank")
          cropsCount -= 1
          totalSurfaceArea -= crops[index].value(forKey: "surfaceArea") as! Double
          if let index = selectedCrops.index(of: crops[index]) {
            selectedCrops.remove(at: index)
          }
        }
      }
    }
    updateSelectedCropsLabel()
  }

  @objc func tapCropView(sender: UIGestureRecognizer) {
    let cell = sender.view?.superview as! PlotCell
    let view = sender.view!

    var plot: Plots!
    var crops: [Crops]!
    var crop: Crops!

    for views in viewsArray {
      if let indexView = views.index(of: view) {
        plot = plots[viewsArray.index(of: views)!]
        crops = fetchCrops(fromPlot: plot)
        crop = crops[indexView]
        break
      }
    }

    let checkboxImage = view.subviews[1] as! UIImageView

    if checkboxImage.image == #imageLiteral(resourceName: "check-box-blank") {
      checkboxImage.image = #imageLiteral(resourceName: "check-box")
      cropsCount += 1
      totalSurfaceArea += crop.value(forKey: "surfaceArea") as! Double
      if !cell.checkboxButton.isSelected {
        cell.checkboxButton.isSelected = true
      }
      selectedCrops.append(crop)
    } else {
      checkboxImage.image = #imageLiteral(resourceName: "check-box-blank")
      cropsCount -= 1
      totalSurfaceArea -= crop.value(forKey: "surfaceArea") as! Double
      for (index, view) in cell.subviews[1...crops.count].enumerated() {
        let checkboxImage = view.subviews[1] as! UIImageView
        if checkboxImage.image == #imageLiteral(resourceName: "check-box") {
          break
        } else if checkboxImage.image == #imageLiteral(resourceName: "check-box-blank") && index == crops.count - 1 {
          cell.checkboxButton.isSelected = false
        }

        if let index = selectedCrops.index(of: crop) {
          selectedCrops.remove(at: index)
        }
      }
    }
    updateSelectedCropsLabel()
  }

  private func updateSelectedCropsLabel() {
    if cropsCount == 0 {
      selectedCropsLabel.text = "Aucune sélection"
    } else if cropsCount == 1 {
      selectedCropsLabel.text = String(format: "1 culture • %.1f ha", totalSurfaceArea)
    } else {
      selectedCropsLabel.text = String(format: "%d cultures • %.1f ha", cropsCount, totalSurfaceArea)
    }
  }
}
