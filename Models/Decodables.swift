//
//  Decodables.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 05/09/2018.
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
