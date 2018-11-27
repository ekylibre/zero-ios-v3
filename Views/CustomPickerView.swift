//
//  CustomPickerView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 12/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

protocol CustomPickerViewProtocol {
  func customPickerDidSelectRow(_ pickerView: UIPickerView, _ selectedValue: String?)
}

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

  // MARK: - Properties

  var reference: CustomPickerViewProtocol?
  var values: [String]

  // MARK: - Initialization

  init(frame: CGRect, _ values: [String], superview: UIView) {
    self.values = values
    super.init(frame: frame)
    setupView(superview)
  }

  private func setupView(_ superview: UIView) {
    isHidden = true
    backgroundColor = AppColor.CellColors.LightGray
    delegate = self
    dataSource = self
    translatesAutoresizingMaskIntoConstraints = false
    superview.addSubview(self)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
      heightAnchor.constraint(equalToConstant: 216),
      centerXAnchor.constraint(equalTo: superview!.centerXAnchor),
      widthAnchor.constraint(equalTo: superview!.widthAnchor)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Data source

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return values.count
  }

  // MARK: - Delegate

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return values[row].localized
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectedValue = values[row]

    reference?.customPickerDidSelectRow(pickerView, selectedValue)
  }
}
