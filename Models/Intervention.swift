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
    case Care = "CARE"
    case CropProtection = "CROP_PROTECTION"
    case Fertilization = "FERTILIZATION"
    case GroundWork = "GROUND_WORK"
    case Harvest = "HARVEST"
    case Implantation = "IMPLANTATION"
    case Irrigation = "IRRIGATION"
  }

  enum Status: Int16 {
    case OutOfSync = 0
    case Synchronised = 1
    case Validated = 2
  }

  enum State: Int16 {
    case New = 0
    case Created = 1
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
}
