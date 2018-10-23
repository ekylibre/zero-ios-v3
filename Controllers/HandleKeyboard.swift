//
//  HandleKeyboard.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 14/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//
import UIKit

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))

    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
    view.frame.origin.y = 0
  }
}
