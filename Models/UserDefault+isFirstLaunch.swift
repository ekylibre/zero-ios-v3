//
//  UserDefaults+isFirstLaunch.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 25/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation

extension UserDefaults {

  static func isFirstLaunch() -> Bool {
    let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBefore")

    if isFirstLaunch {
      UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBefore")
      UserDefaults.standard.synchronize()
    }
    return isFirstLaunch
  }
}
