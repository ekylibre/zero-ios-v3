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
    titleLabel.text = "selecting_crops".localized
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
    selectedCropsLabel.text = "no_crop_selected".localized
    selectedCropsLabel.font = UIFont.boldSystemFont(ofSize: 17)
    selectedCropsLabel.textColor = AppColor.TextColors.White
    selectedCropsLabel.translatesAutoresizingMaskIntoConstraints = false
    return selectedCropsLabel
  }()

  public var validateButton: UIButton = {
    let validateButton = UIButton(frame: CGRect.zero)
    validateButton.setTitle("validate".localized.uppercased(), for: .normal)
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
  var totalSurfaceArea: Float = 0

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
    var views = [UIView]()

    cell.checkboxButton.addTarget(self, action: #selector(tapCheckbox), for: .touchUpInside)
    cell.nameLabel.text = plot.name
    cell.nameLabel.sizeToFit()
    cell.surfaceAreaLabel.text = String(format: "%.1f ha", plot.surfaceArea)
    cell.surfaceAreaLabel.sizeToFit()

    for (index, crop) in crops.enumerated() {
      let frame = CGRect(x: 15, y: 60 + index * 60, width: Int(cell.frame.size.width - 30), height: 60)
      let view = CropView(frame: frame, crop)

      view.gesture.addTarget(self, action: #selector(tapCropView))
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

    return (plots.count > 0)
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
    let predicate = NSPredicate(format: "plot == %@", plot)
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

  func createPlot(name: String, surfaceArea: Float) {
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

  func createCrop(plotName: String, name: String, surfaceArea: Float, startDate: Date) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let crop = Crops(context: managedContext)
    let plot = fetchPlot(withName: plotName)

    crop.plot = plot
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
    let cell = sender.superview?.superview as! PlotCell
    let indexPath = tableView.indexPath(for: cell)!
    let plot = plots[indexPath.row]
    let plotSurfaceArea = plot.surfaceArea
    let crops = fetchCrops(fromPlot: plot)

    if !sender.isSelected {
      sender.isSelected = true
      selectPlot(crops, plotSurfaceArea, cell)
    } else {
      sender.isSelected = false
      deselectPlot(crops, cell)
    }
    updateSelectedCropsLabel()
  }

  private func selectPlot(_ crops: [Crops], _ plotSurfaceArea: Float, _ cell: PlotCell) {
    cropsCount += crops.count
    totalSurfaceArea += plotSurfaceArea

    for view in cell.subviews[1...crops.count] {
      let checkboxImage = view.subviews[1] as! UIImageView

      checkboxImage.image = #imageLiteral(resourceName: "check-box")
    }

    for crop in crops {
      selectedCrops.append(crop)
    }
  }

  private func deselectPlot(_ crops: [Crops], _ cell: PlotCell) {
    for (index, view) in cell.subviews[1...crops.count].enumerated() {
      let checkboxImage = view.subviews[1] as! UIImageView

      if checkboxImage.image == #imageLiteral(resourceName: "check-box") {
        cropsCount -= 1
        totalSurfaceArea -= crops[index].surfaceArea
        checkboxImage.image = #imageLiteral(resourceName: "check-box-blank")

        if let index = selectedCrops.index(of: crops[index]) {
          selectedCrops.remove(at: index)
        }
      }
    }
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
      selectCrop(crop, cell)
    } else {
      checkboxImage.image = #imageLiteral(resourceName: "check-box-blank")
      deselectCrop(crop, crops, cell)
    }
    updateSelectedCropsLabel()
  }

  private func selectCrop(_ crop: Crops, _ cell: PlotCell) {
    cropsCount += 1
    totalSurfaceArea += crop.surfaceArea

    if !cell.checkboxButton.isSelected {
      cell.checkboxButton.isSelected = true
    }
    selectedCrops.append(crop)
  }

  private func deselectCrop(_ crop: Crops, _ crops: [Crops], _ cell: PlotCell) {
    cropsCount -= 1
    totalSurfaceArea -= crop.surfaceArea

    for (index, view) in cell.subviews[1...crops.count].enumerated() {
      let checkboxImage = view.subviews[1] as! UIImageView

      if checkboxImage.image == #imageLiteral(resourceName: "check-box") {
        break
      } else if checkboxImage.image == #imageLiteral(resourceName: "check-box-blank") && index == crops.count - 1 {
        cell.checkboxButton.isSelected = false
      }
    }

    if let index = selectedCrops.index(of: crop) {
      selectedCrops.remove(at: index)
    }
  }

  private func updateSelectedCropsLabel() {
    if cropsCount == 0 {
      selectedCropsLabel.text = "no_crop_selected".localized
    } else {
      let cropString = cropsCount < 2 ? "crop".localized : "crops".localized

      selectedCropsLabel.text = String(format: cropString, cropsCount) + String(format: " • %.1f ha", totalSurfaceArea)
    }
  }
}
