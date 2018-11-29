//
//  CustomPickerView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 12/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

protocol CustomPickerViewProtocol {
  func customPickerDidSelectValue(_ pickerView: CustomPickerView, value: String)
}

class CustomPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {

  // MARK: - Properties

  var reference: CustomPickerViewProtocol?
  var values: [String]

  lazy var dimView: UIView = {
    let dimView = UIView(frame: CGRect.zero)
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    dimView.translatesAutoresizingMaskIntoConstraints = false
    return dimView
  }()

  lazy var pickerView: UIPickerView = {
    let pickerView = UIPickerView(frame: CGRect.zero)
    pickerView.backgroundColor = AppColor.CellColors.LightGray
    pickerView.delegate = self
    pickerView.dataSource = self
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    return pickerView
  }()

  // MARK: - Initialization

  init(values: [String], superview: UIView) {
    self.values = values
    super.init(frame: CGRect.zero)
    setupView(superview)
  }

  private func setupView(_ superview: UIView) {
    isHidden = true
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(dimView)
    addSubview(pickerView)
    superview.addSubview(self)
    setupLayout(superview)
    setupGestureRecognizers()
  }

  private func setupLayout(_ superview: UIView) {
    NSLayoutConstraint.activate([
      leftAnchor.constraint(equalTo: superview.leftAnchor),
      rightAnchor.constraint(equalTo: superview.rightAnchor),
      topAnchor.constraint(equalTo: superview.topAnchor),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor),
      dimView.leftAnchor.constraint(equalTo: leftAnchor),
      dimView.rightAnchor.constraint(equalTo: rightAnchor),
      dimView.topAnchor.constraint(equalTo: topAnchor),
      dimView.bottomAnchor.constraint(equalTo: pickerView.bottomAnchor),
      pickerView.leftAnchor.constraint(equalTo: leftAnchor),
      pickerView.rightAnchor.constraint(equalTo: rightAnchor),
      pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      pickerView.heightAnchor.constraint(equalToConstant: 216)
      ])
  }

  private func setupGestureRecognizers() {
    let dimViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dimViewTapped))
    let pickerTapGesture = UITapGestureRecognizer(target: self, action: #selector(pickerTapped))

    dimView.addGestureRecognizer(dimViewTapGesture)
    pickerTapGesture.delegate = self
    pickerView.addGestureRecognizer(pickerTapGesture)
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

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }

  // MARK: - Actions

  @objc private func dimViewTapped() {
    let selectedRow = pickerView.selectedRow(inComponent: 0)
    let selectedValue = values[selectedRow]

    reference?.customPickerDidSelectValue(self, value: selectedValue)
  }

  @objc private func pickerTapped(tapRecognizer: UITapGestureRecognizer) {
    if tapRecognizer.state != .ended { return }
    let rowHeight = pickerView.rowSize(forComponent: 0).height
    let selectedRowFrame = pickerView.bounds.insetBy(dx: 0, dy: (pickerView.frame.height - rowHeight) / 2)
    let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: pickerView))

    if userTappedOnSelectedRow {
      let selectedRow = pickerView.selectedRow(inComponent: 0)
      let selectedValue = values[selectedRow]

      reference?.customPickerDidSelectValue(self, value: selectedValue)
    }
  }
}
