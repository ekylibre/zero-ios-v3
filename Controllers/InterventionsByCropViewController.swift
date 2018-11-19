//
//  InterventionsByCropViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 29/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class InterventionsByCropViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  // MARK: - Properties

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var cropsTableView: UITableView!

  var cropsByProduction = [[Crop]]()
  let headerView = UIView(frame: CGRect.zero)
  let locationSwitch = UISwitch(frame: CGRect.zero)
  let dimView = UIView(frame: CGRect.zero)
  let cropDetailedView = CropDetailedView(frame: CGRect.zero)
  let locationManager = CLLocationManager()

  // MARK: - Initialization

  override func viewDidLoad() {
    setupNavigationBar()
    fetchCrops()
    sortProductions()
    setupLocationManager()

    dimView.isHidden = true
    dimView.backgroundColor = UIColor.black
    dimView.alpha = 0.6
    dimView.translatesAutoresizingMaskIntoConstraints = false
    cropDetailedView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(dimView)
    view.addSubview(cropDetailedView)

    NSLayoutConstraint.activate([
      dimView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      dimView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      dimView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      cropDetailedView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      cropDetailedView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -30),
      cropDetailedView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      cropDetailedView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -30)
      ])

    setupTableHeaderView()
    cropsTableView.register(ProductionCell.self, forCellReuseIdentifier: "ProductionCell")
    cropsTableView.register(CropCell.self, forCellReuseIdentifier: "CropCell")
    cropsTableView.separatorInset = UIEdgeInsets.zero
    cropsTableView.tableFooterView = UIView()
    cropsTableView.rowHeight = 70
    cropsTableView.delegate = self
    cropsTableView.dataSource = self
    cropDetailedView.cancelButton.addTarget(self, action: #selector(hideCropDetailedView), for: .touchUpInside)
  }

  private func setupNavigationBar() {
    let titleLabel = UILabel()
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(dismissViewController))

    titleLabel.text = "my_crops_title".localized
    titleLabel.textColor = UIColor.white
    titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
    cancelButton.tintColor = UIColor.white

    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    navigationItem.rightBarButtonItem = cancelButton
    navigationBar.setItems([navigationItem], animated: false)
  }

  private func sortProductions() {
    cropsByProduction = cropsByProduction.sorted(by: {
      $0.first!.species!.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        <
      $1.first!.species!.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
    })
  }

  private func setupTableHeaderView() {
    let locationLabel = UILabel(frame: CGRect.zero)

    locationLabel.text = "location".localized
    locationSwitch.onTintColor = AppColor.BarColors.Green
    locationSwitch.tintColor = UIColor.lightGray
    locationSwitch.layer.cornerRadius = 16
    locationSwitch.backgroundColor = UIColor.lightGray
    locationSwitch.addTarget(self, action: #selector(updateLocationParameter), for: .valueChanged)
    locationLabel.translatesAutoresizingMaskIntoConstraints = false
    locationSwitch.translatesAutoresizingMaskIntoConstraints = false
    headerView.addSubview(locationLabel)
    headerView.addSubview(locationSwitch)

    NSLayoutConstraint.activate([
      locationLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20),
      locationLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      locationSwitch.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20),
      locationSwitch.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
      ])

    headerView.frame = CGRect(x: 0, y: 0, width: cropsTableView.frame.width, height: 50)
    cropsTableView.tableHeaderView = headerView
  }

  // MARK: - Core Data

  private func fetchCrops() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crop> = Crop.fetchRequest()
    let predicate = NSPredicate(format: "targets.@count > 0")
    let sort = NSSortDescriptor(key: "productionID", ascending: true)
    cropsFetchRequest.predicate = predicate
    cropsFetchRequest.sortDescriptors = [sort]

    do {
      let crops = try managedContext.fetch(cropsFetchRequest)
      organizeCropsByProduction(crops)
      sortCropsByPlotName()
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func organizeCropsByProduction(_ crops: [Crop]) {
    var cropsFromSameProduction = [Crop]()
    var productionID = crops.first?.productionID

    for crop in crops {
      if crop.productionID != productionID {
        productionID = crop.productionID
        cropsByProduction.append(cropsFromSameProduction)
        cropsFromSameProduction = [Crop]()
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

  private func fetchInterventions(fromCrop crop: Crop) -> [Intervention]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsFetchRequest: NSFetchRequest<Intervention> = Intervention.fetchRequest()
    let predicate = NSPredicate(format: "ANY targets.crop == %@", crop)
    interventionsFetchRequest.predicate = predicate

    do {
      let interventions = try managedContext.fetch(interventionsFetchRequest)
      return interventions.sorted(by: {
        let first = ($0.workingPeriods!.allObjects as! [WorkingPeriod]).first!
        let second = ($1.workingPeriods!.allObjects as! [WorkingPeriod]).first!

        return second.executionDate! < first.executionDate!
      })
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "CropCell", for: indexPath) as! CropCell
    let crop = cropsByProduction[indexPath.section][indexPath.row]

    cell.plotNameLabel.text = crop.plotName
    if locationSwitch.isOn {
      updateDistanceLabel(crop: crop, cell: cell)
    } else {
      cell.distanceLabel.isHidden = true
    }
    cell.surfaceAreaLabel.text = String(format: "%.1f ha", crop.surfaceArea)
    updateInterventionImages(crop: crop, cell: cell)
    return cell
  }

  private func updateInterventionImages(crop: Crop, cell: CropCell) {
    var column = 0

    for imageView in cell.interventionImageViews {
      imageView.isHidden = true
    }

    for case let target as Target in crop.targets! {
      let assetName = target.intervention!.type!.lowercased().replacingOccurrences(of: "_", with: "-")

      cell.interventionImageViews[column].image = UIImage(named: assetName)
      cell.interventionImageViews[column].isHidden = false
      column += 1

      if column == cell.interventionImageViews.count {
        return
      }
    }
  }

  private func updateDistanceLabel(crop: Crop, cell: CropCell) {
    if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus().rawValue > 2 {
      guard let cropLocation = getLocation(string: crop.centroid!) else { return }
      guard let distance = locationManager.location?.distance(from: cropLocation) else { return }
      let value = distance < 1000 ? distance : distance / 1000
      let unit = distance < 1000 ? "m" : "km"

      cell.distanceLabel.isHidden = false
      cell.distanceLabel.text = String(format: "%.1f %@", value, unit)
    } else {
      cell.distanceLabel.isHidden = true
    }
  }

  private func getLocation(string: String) -> CLLocation? {
    let coordinates = string[1 ..< string.count - 1].split(separator: ",")

    if coordinates.count != 2 {
      return nil
    }
    guard let longitude = Double(coordinates.first!), let latitude = Double(coordinates.last!) else {
      return nil
    }
    return CLLocation(latitude: latitude, longitude: longitude)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let crop = cropsByProduction[indexPath.section][indexPath.row]

    updateCropDetailedView(crop)
    dimView.isHidden = false
    cropDetailedView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  private func updateCropDetailedView(_ crop: Crop) {
    let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "dd/MM/yyyy"
      return dateFormatter
    }()
    let startDate = dateFormatter.string(from: crop.startDate!)
    let stopDate = dateFormatter.string(from: crop.stopDate!)

    cropDetailedView.nameLabel.text = crop.plotName?.uppercased()
    cropDetailedView.surfaceAreaLabel.text = String(format: "%.1f ha", crop.surfaceArea)
    cropDetailedView.specieLabel.text = crop.species?.localized
    cropDetailedView.dateLabel.text = String(format: "%@ %@ %@ %@", "from".localized, startDate,
                                             "to".localized.lowercased(), stopDate)
    cropDetailedView.yieldLabel.text = String(format: "%@: %@", "yield".localized, crop.provisionalYield!)
    cropDetailedView.interventions = fetchInterventions(fromCrop: crop) ?? [Intervention]()
    cropDetailedView.tableView.reloadData()
  }

  // MARK: - Actions

  @objc private func dismissViewController() {
    self.dismiss(animated: true, completion: nil)
  }

  @objc private func hideCropDetailedView() {
    if let selectedIndexPath = cropsTableView.indexPathForSelectedRow {
      cropsTableView.deselectRow(at: selectedIndexPath, animated: false)
    }

    cropDetailedView.isHidden = true
    dimView.isHidden = true

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
  }
}
