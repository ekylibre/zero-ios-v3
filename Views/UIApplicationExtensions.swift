//
//  UIApplicationExtensions.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 20/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
  var statusBarView: UIView? {
    if responds(to: Selector(("statusBar"))) {
      return value(forKey: "statusBar") as? UIView
    }
    return nil
  }
}
