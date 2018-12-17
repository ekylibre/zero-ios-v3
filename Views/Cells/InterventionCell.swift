//
//  InterventionCell.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class InterventionCell: UITableViewCell {

  // MARK: - Properties

  lazy var typeImageView: UIImageView = {
    let typeImageView = UIImageView(frame: CGRect.zero)
    typeImageView.translatesAutoresizingMaskIntoConstraints = false
    return typeImageView
  }()

  lazy var typeLabel: UILabel = {
    let typeLabel = UILabel(frame: CGRect.zero)
    typeLabel.font = UIFont.boldSystemFont(ofSize: 14)
    typeLabel.textColor = AppColor.TextColors.Blue
    typeLabel.translatesAutoresizingMaskIntoConstraints = false
    return typeLabel
  }()

  lazy var stateImageView: UIImageView = {
    let stateImageView = UIImageView(frame: CGRect.zero)
    stateImageView.translatesAutoresizingMaskIntoConstraints = false
    return stateImageView
  }()

  lazy var dateLabel: UILabel = {
    let dateLabel = UILabel(frame: CGRect.zero)
    dateLabel.font = UIFont.systemFont(ofSize: 14)
    dateLabel.textColor = AppColor.TextColors.DarkGray
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    return dateLabel
  }()

  lazy var cropsLabel: UILabel = {
    let cropsLabel = UILabel(frame: CGRect.zero)
    cropsLabel.font = UIFont.systemFont(ofSize: 14)
    cropsLabel.textColor = AppColor.TextColors.DarkGray
    cropsLabel.translatesAutoresizingMaskIntoConstraints = false
    return cropsLabel
  }()

  lazy var infosLabel: UILabel = {
    let infosLabel = UILabel(frame: CGRect.zero)
    infosLabel.font = UIFont.systemFont(ofSize: 14)
    infosLabel.numberOfLines = 0
    infosLabel.translatesAutoresizingMaskIntoConstraints = false
    return infosLabel
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }

  private func setupCell() {
    contentView.addSubview(typeImageView)
    contentView.addSubview(typeLabel)
    contentView.addSubview(stateImageView)
    contentView.addSubview(dateLabel)
    contentView.addSubview(cropsLabel)
    contentView.addSubview(infosLabel)
    setupLayout()
  }

  private func setupLayout() {
    let contentHeightAnchor = contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)

    contentHeightAnchor.priority = UILayoutPriority(999)

    NSLayoutConstraint.activate([
      contentHeightAnchor,
      typeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.5),
      typeImageView.widthAnchor.constraint(equalToConstant: 55),
      typeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.5),
      typeImageView.heightAnchor.constraint(equalToConstant: 55),
      typeLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.5),
      stateImageView.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 10),
      stateImageView.widthAnchor.constraint(equalToConstant: 20),
      stateImageView.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
      stateImageView.heightAnchor.constraint(equalToConstant: 20),
      dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      dateLabel.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
      cropsLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      cropsLabel.centerYAnchor.constraint(equalTo: typeImageView.centerYAnchor),
      infosLabel.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 15),
      infosLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      infosLabel.topAnchor.constraint(equalTo: cropsLabel.bottomAnchor, constant: 2),
      infosLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.5)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Update

  func updateDateLabel(_ workingPeriods: NSSet) -> String? {
    guard let workingPeriod = workingPeriods.allObjects.first as? WorkingPeriod else { return nil }
    guard let date = workingPeriod.executionDate else { return nil }
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

  func updateCropsLabel(_ targets: NSSet) -> String? {
    let cropString = (targets.count == 1) ? "crop".localized : String(format: "crops".localized, targets.count)
    var totalSurfaceArea: Float = 0

    for case let target as Target in targets {
      guard let crop = target.crop else { return nil }

      totalSurfaceArea += crop.surfaceArea
    }
    return cropString + String(format: " • %.1f ha", totalSurfaceArea)
  }

  func updateInfosLabel(_ intervention: Intervention) -> String? {
    if let infos = getInfos(intervention) {
      return infos
    }
    return intervention.infos
  }

  private func getInfos(_ intervention: Intervention) -> String? {
    guard let interventionType = InterventionType(rawValue: intervention.type!) else { return nil }
    var infos = ""

    switch interventionType {
    case .Care:
      for case let interventionMaterial as InterventionMaterial in intervention.interventionMaterials! {
        guard let material = interventionMaterial.material else { return infos }
        guard let unit = interventionMaterial.unit?.localized else { return infos }
        let materialInfos = String(format: "%@ • %g %@", material.name!, interventionMaterial.quantity, unit)

        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(materialInfos)
      }
    case .CropProtection:
      for case let interventionPhyto as InterventionPhytosanitary in intervention.interventionPhytosanitaries! {
        guard let phyto = interventionPhyto.phyto else { return infos }
        guard let unit = interventionPhyto.unit?.localized else { return infos }
        let phytoInfos = String(format: "%@ • %g %@", phyto.name!, interventionPhyto.quantity, unit)

        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(phytoInfos)
      }
    case .Fertilization:
      for case let interventionFertilizer as InterventionFertilizer in intervention.interventionFertilizers! {
        guard let name = interventionFertilizer.fertilizer?.name?.localized else { return infos }
        guard let unit = interventionFertilizer.unit?.localized else { return infos }
        let fertilizerInfos = String(format: "%@ • %g %@", name, interventionFertilizer.quantity, unit)

        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(fertilizerInfos)
      }
    case .GroundWork:
      for case let interventionEquipment as InterventionEquipment in intervention.interventionEquipments! {
        guard let equipment = interventionEquipment.equipment else { return infos }
        var equipmentInfos = equipment.name!

        if let number = equipment.number {
          equipmentInfos.append(String(format: " #%@", number))
        }
        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(equipmentInfos)
      }
    case .Harvest:
      guard let loads = intervention.harvests?.allObjects as? [Harvest] else { return nil }
      guard let load = loads.first else { return nil }
      guard let type = load.type?.localized else { return nil }
      guard let unit = load.unit?.localized else { return nil }
      var harvestInfos = String(format: "%@ • %g %@", type, load.quantity, unit)

      if loads.count > 2 {
        harvestInfos.append("\n")
        harvestInfos.append(String(format: "and_x_more_loads".localized, loads.count - 1))
      } else if loads.count == 2 {
        harvestInfos.append("\n")
        harvestInfos.append("and_1_more_load".localized)
      }
      infos.append(harvestInfos)
    case .Implantation:
      for case let interventionSeed as InterventionSeed in intervention.interventionSeeds! {
        guard let seed = interventionSeed.seed else { return infos }
        guard let unit = interventionSeed.unit?.localized else { return infos }
        let seedInfos = String(format: "%@ • %g %@", seed.variety!, interventionSeed.quantity, unit)

        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(seedInfos)
      }
    case .Irrigation:
      guard let unit = intervention.waterUnit?.localized else { return nil }

      infos = String(format: "%@ • %g %@", "volume".localized, intervention.waterQuantity, unit)
    }
    return infos
  }
}
