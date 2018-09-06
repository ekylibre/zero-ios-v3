//
//  StringExtension.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 06/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation

extension String {
  func localized(string: String) -> String {
    return NSLocalizedString(string, comment: "")
  }
}
