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

  lazy var titleLabel: UILabel = {
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
    tableView.register(PlotCell.self, forCellReuseIdentifier: "PlotCell")
    tableView.rowHeight = UITableView.automaticDimension
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  lazy var selectedCropsLabel: UILabel = {
    let selectedCropsLabel = UILabel(frame: CGRect.zero)
    selectedCropsLabel.text = "no_crop_selected".localized
    selectedCropsLabel.font = UIFont.boldSystemFont(ofSize: 17)
    selectedCropsLabel.textColor = AppColor.TextColors.White
    selectedCropsLabel.translatesAutoresizingMaskIntoConstraints = false
    return selectedCropsLabel
  }()

  lazy var validateButton: UIButton = {
    let validateButton = UIButton(frame: CGRect.zero)
    validateButton.setTitle("validate".localized.uppercased(), for: .normal)
    validateButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    validateButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    validateButton.setTitleColor(AppColor.TextColors.Black.withAlphaComponent(0.3), for: .highlighted)
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

  var currentIntervention: Intervention?
  var interventionState: InterventionState.RawValue!
  var crops = [[Crop]]()
  var selectedCrops = [Crop]()
  var cropViews = [[CropView]]()
  var selectedSurfaceArea: Float = 0

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    backgroundColor = UIColor.white
    layer.cornerRadius = 3
    clipsToBounds = true
    addSubview(headerView)
    addSubview(tableView)
    addSubview(bottomView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      headerView.topAnchor.constraint(equalTo: topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 60),
      headerView.leftAnchor.constraint(equalTo: leftAnchor),
      headerView.widthAnchor.constraint(equalTo: widthAnchor),
      tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.widthAnchor.constraint(equalTo: widthAnchor),
      selectedCropsLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
      selectedCropsLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 30),
      validateButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 13),
      validateButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -13),
      validateButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -13),
      validateButton.widthAnchor.constraint(equalToConstant: 100),
      bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
      bottomView.heightAnchor.constraint(equalToConstant: 60),
      bottomView.leftAnchor.constraint(equalTo: leftAnchor),
      bottomView.widthAnchor.constraint(equalTo: widthAnchor)
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
    return crops.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PlotCell", for: indexPath) as! PlotCell
    let crops = self.crops[indexPath.row]
    let surfaceArea = getPlotSurfaceArea(crops)

    for case let view as CropView in cell.contentView.subviews {
      view.removeFromSuperview()
    }

    for (index, _) in crops.enumerated() {
      cropViews[indexPath.row][index].frame.size.width = cell.frame.size.width - 30
      cell.contentView.addSubview(cropViews[indexPath.row][index])
    }

    cell.checkboxButton.addTarget(self, action: #selector(tapCheckbox), for: .touchUpInside)
    cell.nameLabel.text = crops.first?.plotName
    cell.nameLabel.sizeToFit()
    cell.surfaceAreaLabel.text = String(format: "%.1f ha", surfaceArea)
    cell.surfaceAreaLabel.sizeToFit()
    cell.selectionStyle = UITableViewCell.SelectionStyle.none
    for crop in crops {
      if selectedCrops.contains(crop) {
        cell.checkboxButton.isSelected = true
        break
      }
    }
    return cell
  }

  private func getPlotSurfaceArea(_ crops: [Crop]) -> Float {
    var surfaceArea: Float = 0

    for crop in crops {
      surfaceArea += crop.surfaceArea
    }
    return surfaceArea
  }

  func showPlotIfReadOnly() {
    if interventionState == InterventionState.Validated.rawValue {
      for index in 0..<selectedCrops.count {
        let indexPath = IndexPath.init(row: index, section: 0)

        selectedIndexPath = indexPath
        if !indexPaths.contains(selectedIndexPath!) {
          indexPaths += [selectedIndexPath!]
        }
      }
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndexPath = indexPath
    let cell = tableView.cellForRow(at: indexPath) as! PlotCell

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
      let count = crops[indexPath.row].count + 1
      return CGFloat(count * 60 + 15)
    }
    return 60
  }

  // MARK: - Core Data

  func fetchCrops() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crop> = Crop.fetchRequest()
    let sort = NSSortDescriptor(key: "plotName", ascending: true)
    cropsFetchRequest.sortDescriptors = [sort]

    do {
      let crops = try managedContext.fetch(cropsFetchRequest)

      if interventionState == InterventionState.Validated.rawValue {
        loadSelectedTargets()
      } else if interventionState == InterventionState.Created.rawValue ||
        interventionState == InterventionState.Synced.rawValue {
        loadAllTargetAndSelectThem(crops)
      } else {
        organizeCropsByPlot(crops)
      }
      createCropViews()
      showPlotIfReadOnly()
    } catch let error as NSError {
      print("Could not fetch: \(error), \(error.userInfo)")
    }
  }

  private func loadSelectedTargets() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let targetsFetchRequest: NSFetchRequest<Target> = Target.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", currentIntervention!)

    targetsFetchRequest.predicate = predicate

    do {
      let targets = try managedContext.fetch(targetsFetchRequest)

      var cropsFromSamePlot = [Crop]()
      var name: String!
      for target in targets {
        if name == nil {
          name = target.crop?.plotName
        }
        if target.crop?.plotName != name {
          name = target.crop?.plotName
          self.crops.append(cropsFromSamePlot)
          cropsFromSamePlot = [Crop]()
        }
        selectedSurfaceArea += (target.crop?.surfaceArea)!
        selectedCrops.append(target.crop!)
        cropsFromSamePlot.append(target.crop!)
      }
      self.crops.append(cropsFromSamePlot)
    } catch let error as NSError {
      print("Could not fetch: \(error), \(error.userInfo)")
    }
  }

  private func organizeCropsByPlot(_ crops: [Crop]) {
    var cropsFromSamePlot = [Crop]()
    var name = crops.first?.plotName

    for crop in crops {
      if crop.plotName != name {
        name = crop.plotName
        self.crops.append(cropsFromSamePlot)
        cropsFromSamePlot = [Crop]()
      }
      cropsFromSamePlot.append(crop)
    }
    self.crops.append(cropsFromSamePlot)
  }

  private func checkIfTargetMatch() -> [Target]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let targetsFetchRequest: NSFetchRequest<Target> = Target.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", currentIntervention!)

    targetsFetchRequest.predicate = predicate
    do {
      return try managedContext.fetch(targetsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch: \(error), \(error.userInfo)")
    }
    return nil
  }

  private func loadAllTargetAndSelectThem(_ crops: [Crop]) {
    let targets = checkIfTargetMatch()
    var cropsFromSamePlot = [Crop]()
    var name = crops.first?.plotName

    for crop in crops {
      if crop.plotName != name {
        name = crop.plotName
        self.crops.append(cropsFromSamePlot)
        cropsFromSamePlot = [Crop]()
      }
      for target in targets! {
        if crop == target.crop {
          selectedSurfaceArea += crop.surfaceArea
          selectedCrops.append(crop)
          break
        }
      }
      cropsFromSamePlot.append(crop)
    }
    self.crops.append(cropsFromSamePlot)
  }

  private func createCropViews() {
    var frame: CGRect
    var cropViews = [CropView]()
    var view: CropView
    var targets: [Target]?

    if interventionState != nil {
      targets = checkIfTargetMatch()
    }

    for crops in crops {
      for (index, crop) in crops.enumerated() {
        frame = CGRect(x: 15, y: 60 + index * 60, width: 0, height: 60)
        view = CropView(frame: frame, crop)
        view.gesture.addTarget(self, action: #selector(tapCropView))
        if targets != nil {
          var matched = false
          for target in targets! {
            if view.crop == target.crop {
              matched = true
            }
          }
          if !matched, let index = selectedCrops.firstIndex(of: view.crop) {
            selectedCrops.remove(at: index)
          }
        }
        initCropsViewInAppropriateMode(view: view)
        cropViews.append(view)
      }
      self.cropViews.append(cropViews)
      cropViews = [CropView]()
    }
    self.cropViews.append(cropViews)
  }

  // MARK: - Actions

  @objc private func tapCheckbox(_ sender: UIButton) {
    if interventionState == InterventionState.Validated.rawValue {
      return
    }
    let cell = sender.superview?.superview as! PlotCell
    let indexPath = tableView.indexPath(for: cell)!
    let crops = self.crops[indexPath.row]

    if !sender.isSelected {
      sender.isSelected = true
      selectPlot(crops, indexPath)
    } else {
      sender.isSelected = false
      deselectPlot(crops, cell)
    }
    updateSelectedCropsLabel()
  }

  private func selectPlot(_ crops: [Crop], _ indexPath: IndexPath) {
    selectedSurfaceArea += getPlotSurfaceArea(crops)

    for (index, crop) in crops.enumerated() {
      cropViews[indexPath.row][index].checkboxImageView.isHighlighted = true
      selectedCrops.append(crop)
    }
  }

  private func deselectPlot(_ crops: [Crop], _ cell: PlotCell) {
    var index: Int = 0

    for case let view as CropView in cell.contentView.subviews {
      if view.checkboxImageView.isHighlighted {
        view.checkboxImageView.isHighlighted = false
        selectedSurfaceArea -= crops[index].surfaceArea

        if let index = selectedCrops.firstIndex(of: crops[index]) {
          selectedCrops.remove(at: index)
        }
      }
      index += 1
    }
  }

  func initCropsViewInAppropriateMode(view: CropView) {
    if interventionState != nil {
      if selectedCrops.contains(view.crop) {
        view.checkboxImageView.isHighlighted = true
      }
      updateSelectedCropsLabel()
    }
  }

  @objc private func tapCropView(sender: UIGestureRecognizer) {
    if interventionState == InterventionState.Validated.rawValue {
      return
    }
    let cell = sender.view?.superview?.superview as! PlotCell
    let plotIndex = tableView.indexPath(for: cell)!.row
    let view = sender.view as! CropView
    let cropIndex = cropViews[plotIndex].firstIndex(of: view)!
    let crops = self.crops[plotIndex]
    let crop = crops[cropIndex]

    if !view.checkboxImageView.isHighlighted {
      view.checkboxImageView.isHighlighted = true
      selectCrop(crop, cell)
    } else {
      view.checkboxImageView.isHighlighted = false
      deselectCrop(crop, crops, cell)
    }
    updateSelectedCropsLabel()
  }

  private func selectCrop(_ crop: Crop, _ cell: PlotCell) {
    if !cell.checkboxButton.isSelected {
      cell.checkboxButton.isSelected = true
    }

    selectedSurfaceArea += crop.surfaceArea
    selectedCrops.append(crop)
  }

  private func deselectCrop(_ crop: Crop, _ crops: [Crop], _ cell: PlotCell) {
    var index: Int = 1

    for case let view as CropView in cell.contentView.subviews {
      if view.checkboxImageView.isHighlighted {
        break
      } else if (!view.checkboxImageView.isHighlighted) && (index == crops.count) {
        cell.checkboxButton.isSelected = false
      }
      index += 1
    }

    selectedSurfaceArea -= crop.surfaceArea

    if let index = selectedCrops.firstIndex(of: crop) {
      selectedCrops.remove(at: index)
    }
  }

  func updateSelectedCropsLabel() {
    if selectedCrops.count == 0 {
      selectedCropsLabel.text = "no_crop_selected".localized
    } else {
      let cropString = selectedCrops.count < 2 ? "crop".localized :
        String(format: "crops".localized, selectedCrops.count)

      selectedCropsLabel.text = cropString + String(format: " • %.1f ha", selectedSurfaceArea)
    }
  }
}
