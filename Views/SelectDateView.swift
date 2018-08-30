//
//  SelectDateView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SelectDateView: UIView {
  var datePicker: UIDatePicker!
  var validateButton: UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)

    datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "fr")
    self.addSubview(datePicker)
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 5).isActive = true
    NSLayoutConstraint(item: datePicker, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    //NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 175).isActive = true

    validateButton = UIButton(frame: CGRect.zero)
    validateButton.backgroundColor = UIColor.white
    validateButton.setTitle("VALIDER", for: .normal)
    validateButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    self.addSubview(validateButton)
    validateButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: validateButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
    NSLayoutConstraint(item: validateButton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10).isActive = true
    NSLayoutConstraint(item: validateButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
    NSLayoutConstraint(item: validateButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
    validateButton.layer.cornerRadius = 5
    validateButton.clipsToBounds = true

    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
