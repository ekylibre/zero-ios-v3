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

  func moveViewWhenKeyboardAppears() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
    view.frame.origin.y = 0
  }

  @objc func keyboardWillShow(notification: NSNotification) {
    let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)!.cgRectValue
    let offset = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue

    if keyboardSize.height == offset.height {
      if view.frame.origin.y == 0 {
        UIView.animate(withDuration: 0.1, animations: {
          self.view.frame.origin.y -= keyboardSize.height
        })
      }
    } else {
      UIView.animate(withDuration: 0.1, animations: {
        self.view.frame.origin.y += keyboardSize.height - offset.height
      })
    }
  }

  @objc func keyboardWillHide(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y += keyboardSize.height
      }
    }
  }
}
