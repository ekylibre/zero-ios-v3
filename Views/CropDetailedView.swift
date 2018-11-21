//
//  CropDetailedView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 29/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CropDetailedView: UIView, UITableViewDataSource, UITableViewDelegate {

  // MARK: - Properties

  lazy var headerView: UIView = {
    let headerView = UIView(frame: CGRect.zero)
    headerView.addSubview(nameLabel)
    headerView.addSubview(closeButton)
    headerView.addSubview(specieLabel)
    headerView.addSubview(surfaceAreaLabel)
    headerView.addSubview(dateLabel)
    headerView.addSubview(yieldLabel)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    return headerView
  }()

  lazy var nameLabel: UILabel = {
    let nameLabel = UILabel(frame: CGRect.zero)
    nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
    nameLabel.textColor = AppColor.TextColors.DarkGray
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    return nameLabel
  }()

  lazy var closeButton: UIButton = {
    let closeButton = UIButton(frame: CGRect.zero)
    closeButton.setTitle("close".localized, for: .normal)
    closeButton.setTitleColor(AppColor.TextColors.Blue, for: .normal)
    closeButton.setTitleColor(AppColor.TextColors.LightBlue, for: .highlighted)
    closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    return closeButton
  }()

  lazy var specieLabel: UILabel = {
    let specieLabel = UILabel(frame: CGRect.zero)
    specieLabel.font = UIFont.systemFont(ofSize: 14)
    specieLabel.textColor = AppColor.TextColors.DarkGray
    specieLabel.translatesAutoresizingMaskIntoConstraints = false
    return specieLabel
  }()

  lazy var dateLabel: UILabel = {
    let dateLabel = UILabel(frame: CGRect.zero)
    dateLabel.font = UIFont.systemFont(ofSize: 14)
    dateLabel.textColor = AppColor.TextColors.DarkGray
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    return dateLabel
  }()

  lazy var surfaceAreaLabel: UILabel = {
    let surfaceAreaLabel = UILabel(frame: CGRect.zero)
    surfaceAreaLabel.font = UIFont.systemFont(ofSize: 14)
    surfaceAreaLabel.textColor = AppColor.TextColors.DarkGray
    surfaceAreaLabel.translatesAutoresizingMaskIntoConstraints = false
    return surfaceAreaLabel
  }()

  lazy var yieldLabel: UILabel = {
    let yieldLabel = UILabel(frame: CGRect.zero)
    yieldLabel.font = UIFont.systemFont(ofSize: 14)
    yieldLabel.textColor = AppColor.TextColors.DarkGray
    yieldLabel.translatesAutoresizingMaskIntoConstraints = false
    return yieldLabel
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.rowHeight = 80
    tableView.register(InterventionCell.self, forCellReuseIdentifier: "InterventionCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  var interventions = [Intervention]()
  var toUpdateIntervention: Intervention?

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.isHidden = true
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    self.addSubview(headerView)
    self.addSubview(tableView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
      nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      closeButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
      closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
      closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
      specieLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
      specieLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      dateLabel.topAnchor.constraint(equalTo: specieLabel.bottomAnchor, constant: 5),
      dateLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      surfaceAreaLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
      surfaceAreaLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
      yieldLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
      yieldLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
      headerView.topAnchor.constraint(equalTo: self.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 120),
      headerView.leftAnchor.constraint(equalTo: self.leftAnchor),
      headerView.rightAnchor.constraint(equalTo: self.rightAnchor),
      tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Table view

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let interventionsByCropVC = parentViewController as? InterventionsByCropViewController else {
      return
    }

    toUpdateIntervention = interventions[indexPath.row]
    interventionsByCropVC.performSegue(withIdentifier: "updateInterventionByCrop", sender: self)
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return interventions.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InterventionCell", for: indexPath) as! InterventionCell
    let intervention = interventions[indexPath.row]
    let assetName = intervention.type!.lowercased().replacingOccurrences(of: "_", with: "-")
    let stateImages: [Int16: UIImage] = [0: UIImage(named: "created")!, 1: UIImage(named: "synced")!, 2: UIImage(named: "validated")!]

    cell.typeImageView.image = UIImage(named: assetName)
    cell.typeLabel.text = intervention.type?.localized
    cell.stateImageView.image = stateImages[intervention.status]?.withRenderingMode(.alwaysTemplate)
    cell.stateImageView.tintColor = (intervention.status == 0) ? UIColor.orange : UIColor.green
    cell.dateLabel.text = updateDateLabel(intervention.workingPeriods!)
    cell.cropsLabel.text = updateCropsLabel(intervention.targets!)
    cell.notesLabel.text = intervention.infos
    cell.backgroundColor = (indexPath.row % 2 == 0) ? AppColor.CellColors.LightGray : AppColor.CellColors.White
    return cell
  }

  private func updateDateLabel(_ workingPeriods: NSSet) -> String {
    let date = (workingPeriods.allObjects as! [WorkingPeriod]).first!.executionDate!
    let calendar = Calendar.current
    let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter
    }()
    var dateString = dateFormatter.string(from: date)
    let year = calendar.component(.year, from: date)

    if calendar.isDateInToday(date) {
      return "today".localized.lowercased()
    } else if calendar.isDateInYesterday(date) {
      return "yesterday".localized.lowercased()
    } else {
      if !calendar.isDate(Date(), equalTo: date, toGranularity: .year) {
        dateString.append(" \(year)")
      }
      return dateString
    }
  }

  private func updateCropsLabel(_ targets: NSSet) -> String {
    let cropString = (targets.count < 2) ? "crop".localized : "crops".localized
    var totalSurfaceArea: Float = 0

    for case let target as Target in targets {
      let crop = target.crop!

      totalSurfaceArea += crop.surfaceArea
    }
    return String(format: cropString, targets.count) + String(format: " • %.1f ha", totalSurfaceArea)
  }
}
