//
//  Command.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 03/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation

class Command {

  let name: String
  let assetName: String
  let closure: () -> Void

  init(name: String, assetName: String, closure: @escaping () -> Void) {
    self.name = name
    self.assetName = assetName
    self.closure = closure
  }
}
