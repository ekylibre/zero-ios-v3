//
//  Intervention.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import os.log

struct InterventionType {
  static var care = "care".localized
  static var cropProtection = "crop_protection".localized
  static var fertilization = "fertilization".localized
  static var groundWork = "ground_work".localized
  static var harvest = "Harvest".localized
  static var implantation = "Implantation".localized
  static var irrigation = "Irrigation".localized
}

class Intervention {

  enum Status: Int16 {
    case OutOfSync = 0
    case Synchronised = 1
    case Validated = 2
  }

  var crops: String
  var infos: String
  var date: Date
  var status: Status

  // MARK: - Initialization

  init(crops: String, infos: String, date: Date, status: Status) {
    self.crops = crops
    self.infos = infos
    self.date = date
    self.status = status
  }
}
