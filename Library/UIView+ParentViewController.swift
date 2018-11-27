//
//  UIView+ParentViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 21/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self
    while parentResponder != nil {
      parentResponder = parentResponder!.next
      if let viewController = parentResponder as? UIViewController {
        return viewController
      }
    }
    return nil
  }
}
