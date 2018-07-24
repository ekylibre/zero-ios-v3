//
//  UIColorExtensions.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 20/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
