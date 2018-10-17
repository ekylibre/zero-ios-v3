//
//  DecimalMinusPad.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 17/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class DecimalMinusTextField: UITextField {

  // MARK: - Properties

  lazy var view: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: superview!.frame.size.width, height: 44))

    view.backgroundColor = .lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var minusButton: UIButton = {
    let minusButton = UIButton()

    minusButton.setTitle("-", for: .normal)
    minusButton.translatesAutoresizingMaskIntoConstraints = false
    return minusButton
  }()

  lazy var doneButton: UIButton = {
    let doneButton = UIButton()

    doneButton.setTitle("done", for: .normal)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    return doneButton
  }()

  // MARK: - Initialization

  override func layoutSubviews() {
    super.layoutSubviews()
    self.inputAccessoryView = getAccessoryButtons()
  }

  private func getAccessoryButtons() -> UIView {
    view.addSubview(minusButton)
    view.addSubview(doneButton)
    setupLayout()
    setupActions()
    return view
  }

  private func setupLayout() {
    let buttonWidth = view.frame.size.width / 3

    minusButton.translatesAutoresizingMaskIntoConstraints = false
    minusButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    minusButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
    minusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    minusButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    minusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    doneButton.translatesAutoresizingMaskIntoConstraints = false
    doneButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    doneButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
    doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    doneButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }

  private func setupActions() {
    minusButton.addTarget(self, action: #selector(minusTouchUpInside), for: UIControl.Event.touchUpInside)
    doneButton.addTarget(self, action: #selector(doneTouchUpInside), for: UIControl.Event.touchUpInside)
  }

  // MARK: - Actions

  @objc func minusTouchUpInside(_ sender: UIButton!) {
    let text = self.text!

    if text.count > 0 {
      let index: String.Index = text.index(text.startIndex, offsetBy: 1)
      let firstChar = text[..<index]
      if firstChar == "-" {
        self.text = String(text[index...])
      } else {
        self.text = "-" + text
      }
    }
  }

  @objc func doneTouchUpInside(_ sender: UIButton!) {
    self.resignFirstResponder()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.keyboardType = UIKeyboardType.decimalPad
  }
}
