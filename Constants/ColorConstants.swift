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

  // These values may need changes
  struct TextColors {
    static let Black = UIColor.black
    static let White = UIColor.white
    static let Blue = UIColor(red: 0/255, green: 98/255, blue: 202/255, alpha: 1)
    static let Green = UIColor(red: 154/255, green: 200/255, blue: 106/255, alpha: 1)
    static let DarkGray = UIColor.darkGray
    static let Red = UIColor.red
  }

  struct ThemeColors {
    static let DarkWhite = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    static let Blue = UIColor(red: 23/255, green: 107/255, blue: 204/255, alpha: 1)
    static let White = UIColor.white
  }

  struct cgColor {
    static let Green = UIColor(red: 128/255, green: 187/255, blue: 65/255, alpha: 1).cgColor
    static let LightGray = UIColor.lightGray.cgColor
  }
}
