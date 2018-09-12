//
//  CustomPickerView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 12/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class CustomPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

  // MARK: - Properties

  lazy var cancelButton: UIButton = {
    let cancelButton = UIButton(frame: CGRect.zero)
    cancelButton.setTitle("Annuler", for: .normal)
    cancelButton.setTitleColor(AppColor.TextColors.Blue, for: .normal)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    return cancelButton
  }()

  lazy var validateButton: UIButton = {
    let validateButton = UIButton(frame: CGRect.zero)
    validateButton.setTitle("Valider", for: .normal)
    validateButton.setTitleColor(AppColor.TextColors.Blue, for: .normal)
    validateButton.translatesAutoresizingMaskIntoConstraints = false
    return validateButton
  }()

  lazy var headerView: UIView = {
    let headerView = UIView(frame: CGRect.zero)
    headerView.backgroundColor = AppColor.ThemeColors.White
    headerView.addSubview(cancelButton)
    headerView.addSubview(validateButton)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    return headerView
  }()

  lazy var pickerView: UIPickerView = {
    let pickerView = UIPickerView(frame: CGRect.zero)
    pickerView.backgroundColor = AppColor.CellColors.LightGray
    pickerView.delegate = self
    pickerView.dataSource = self
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    return pickerView
  }()

  var values: [String]

  // MARK: - Initialization

  init(frame: CGRect, _ values: [String]) {
    self.values = values
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.addSubview(headerView)
    self.addSubview(pickerView)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      cancelButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
      cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      validateButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
      validateButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 50),
      headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      headerView.widthAnchor.constraint(equalTo: self.widthAnchor),
      pickerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
      pickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      pickerView.heightAnchor.constraint(equalToConstant: 200),
      pickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      pickerView.widthAnchor.constraint(equalTo: self.widthAnchor)
      ])
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
    return values[row]
  }
}
