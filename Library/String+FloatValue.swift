//
//  String+FloatValue.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 02/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation

extension String {
  var floatValue: Float {
    let nf = NumberFormatter()
    nf.decimalSeparator = "."
    if let result = nf.number(from: self) {
      return result.floatValue
    } else {
      nf.decimalSeparator = ","
      if let result = nf.number(from: self) {
        return result.floatValue
      }
    }
    return 0
  }
}
