//
//  Intervention.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import os.log

class Intervention {

  // MARK: - Properties

  enum InterventionType: String {
    case Care = "Entretien"
    case CropProtection = "Pulvérisation"
    case Fertilization = "Fertilisation"
    case GroundWork = "Travail du sol"
    case Harvest = "Récolte"
    case Implantation = "Semis"
    case Irrigation = "Irrigation"
  }

  enum Status: Int16 {
    case OutOfSync = 0
    case Synchronised = 1
    case Validated = 2
  }

  var type: InterventionType
  var crops: String
  var infos: String
  var date: Date
  var status: Status

  // MARK: - Initialization

  init(type: InterventionType, crops: String, infos: String, date: Date, status: Status) {
    self.type = type
    self.crops = crops
    self.infos = infos
    self.date = date
    self.status = status
  }

  init() {
    <#statements#>
  }
}
