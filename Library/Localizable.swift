//
//  Localizable.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 06/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

protocol Localizable {
  var localized: String { get }
}

extension String: Localizable {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
}

protocol XIBLocalizable {
  var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
  @IBInspectable var xibLocKey: String? {
    get { return nil }
    set(key) {
      text = key?.localized
    }
  }
}

extension UIButton: XIBLocalizable {
  @IBInspectable var xibLocKey: String? {
    get { return nil }
    set(key) {
      setTitle(key?.localized, for: .normal)
    }
  }
}

extension UIButton {
  func underline() {
    guard let text = self.titleLabel?.text else { return }

    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))

    self.setAttributedTitle(attributedString, for: .normal)
  }
}

extension UILabel {
  func underline() {
    if let textString = self.text {
      let attributedString = NSMutableAttributedString(string: textString)
      attributedString.addAttribute(kCTUnderlineStyleAttributeName as NSAttributedString.Key, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
