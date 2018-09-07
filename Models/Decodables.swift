//
//  Decodables.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 04/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation

struct RegisteredSeed: Decodable {
  var id: Int
  var specie: String
  var variety: String

  enum CodingKeys: String, CodingKey {
    case id, specie, variety
  }
}

struct RegisteredPhyto: Decodable {
  var id: Int
  var name: String
  var nature: String
  var maaid: String
  var mixCategoryCode: String
  var inFieldReentryDelay: Int
  var firmName: String

  enum CodingKeys: String, CodingKey {
    case id, name, nature, maaid
    case mixCategoryCode = "mix_category_code"
    case inFieldReentryDelay = "in_field_reentry_delay"
    case firmName = "firm_name"
  }
}

struct RegisteredFertilizer: Decodable {
  var id: Int
  var name: String
  var labelFra: String
  var variant: String
  var variety: String
  var derivativeOf: String?
  var nature: String
  var nitrogenConcentration: Float
  var phosphorusConcentration: Float?
  var potassiumConcentration: Float?
  var sulfurTrioxydeConcentration: Float?

  enum CodingKeys: String, CodingKey {
    case id, name, variant, variety, nature
    case labelFra = "label_fra"
    case derivativeOf = "derivative_of"
    case nitrogenConcentration = "nitrogen_concentration"
    case phosphorusConcentration = "phosphorus_concentration"
    case potassiumConcentration = "potassium_concentration"
    case sulfurTrioxydeConcentration = "sulfur_trioxyde_concentration"
  }
}
