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

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {

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
    setupGestureRecognizers()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      bottomAnchor.constraint(equalTo: superview!.bottomAnchor),
      heightAnchor.constraint(equalToConstant: 216),
      centerXAnchor.constraint(equalTo: superview!.centerXAnchor),
      widthAnchor.constraint(equalTo: superview!.widthAnchor)
      ])
  }

  private func setupGestureRecognizers() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))

    tapGesture.delegate = self
    addGestureRecognizer(tapGesture)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Picker view

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return values.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return values[row].localized
  }

  // MARK: - Gesture recognizer

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }

  // MARK: - Actions

  @objc private func pickerTapped(tapRecognizer: UITapGestureRecognizer) {
    if tapRecognizer.state != .ended { return }
    let rowHeight = rowSize(forComponent: 0).height
    let selectedRowFrame = bounds.insetBy(dx: 0, dy: (frame.height - rowHeight) / 2)
    let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: self))

    if userTappedOnSelectedRow {
      let selectedRow = self.selectedRow(inComponent: 0)
      let selectedValue = values[selectedRow]

      reference?.customPickerDidSelectRow(self, selectedValue)
    }
  }
}
