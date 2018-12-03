//
//  ColorConstants.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 09/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

struct AppColor {

  struct BarColors {
    static let Blue = UIColor(red: 29/255, green: 139/255, blue: 241/255, alpha: 1)
    static let Green = UIColor(red: 128/255, green: 187/255, blue: 65/255, alpha: 1)
  }

  struct StatusBarColors {
    static let Blue = UIColor(red: 23/255, green: 107/255, blue: 204/255, alpha: 1)
    static let Black = UIColor.black
  }

  struct CellColors {
    static let White = UIColor.white
    static let LightGray = UIColor(red: 236/255, green: 235/255, blue: 235/255, alpha: 1)
  }

  struct TextColors {
    static let Black = UIColor.black
    static let Blue = UIColor(red: 0/255, green: 98/255, blue: 202/255, alpha: 1)
    static let DarkGray = UIColor.darkGray
    static let Green = UIColor(red: 154/255, green: 200/255, blue: 106/255, alpha: 1)
    static let LightBlue = Blue.withAlphaComponent(0.3)
    static let LightGreen = Green.withAlphaComponent(0.3)
    static let Red = UIColor.red
    static let White = UIColor.white
  }

  struct ThemeColors {
    static let DarkWhite = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    static let Blue = UIColor(red: 23/255, green: 107/255, blue: 204/255, alpha: 1)
    static let White = UIColor.white
  }

  struct AppleColors {
    static let Red = UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 1)
    static let Orange = UIColor(red: 1, green: 149/255, blue: 0, alpha: 1)
    static let Yellow = UIColor(red: 1, green: 204/255, blue: 0, alpha: 1)
    static let Green = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    static let TealBlue = UIColor(red: 90, green: 200/255, blue: 250/255, alpha: 1)
    static let Blue = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    static let Purple = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
    static let Pink = UIColor(red: 1, green: 45/255, blue: 85/255, alpha: 1)
  }
}
