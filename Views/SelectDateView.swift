//
//  SelectDateView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SelectDateView: UIView {

  // MARK: - Properties

  lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker(frame: CGRect.zero)
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "locale".localized)
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    return datePicker
  }()

  lazy var validateButton: UIButton = {
    let validateButton = UIButton(frame: CGRect.zero)
    validateButton.backgroundColor = UIColor.white
    validateButton.setTitle("validate".localized.uppercased(), for: .normal)
    validateButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    validateButton.translatesAutoresizingMaskIntoConstraints = false
    return validateButton
  }()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    backgroundColor = UIColor.white
    layer.cornerRadius = 3
    clipsToBounds = true
    isHidden = true
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(datePicker)
    addSubview(validateButton)
    setupLayout()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      datePicker.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      datePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
      validateButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      validateButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
      validateButton.heightAnchor.constraint(equalToConstant: 30),
      validateButton.widthAnchor.constraint(equalToConstant: 100)
      ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
