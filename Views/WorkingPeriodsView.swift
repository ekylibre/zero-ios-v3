//
//  WorkingPeriodsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class WorkingPeriodsView: UIView {
  var topView: UIView!
  var dateLabel: UILabel!
  var datePicker: UIDatePicker!
  var durationLabel: UILabel!
  var durationTextField: UITextField!

  override init(frame: CGRect) {
    super.init(frame: frame)

    topView = UIView(frame: CGRect.zero)
    topView.backgroundColor = AppColor.BarColors.Green
    self.addSubview(topView)
    topView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: topView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: topView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: topView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: topView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true

    dateLabel = UILabel(frame: CGRect.zero)
    dateLabel.text = "Débuté le"
    dateLabel.textColor = AppColor.TextColors.Black
    self.addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true

    datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    self.addSubview(datePicker)
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: dateLabel, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: datePicker, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150).isActive = true

    durationLabel = UILabel(frame: CGRect.zero)
    durationLabel.text = "Durée"
    durationLabel.textColor = AppColor.TextColors.Black
    self.addSubview(durationLabel)
    durationLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: durationLabel, attribute: .top, relatedBy: .equal, toItem: datePicker, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: durationLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true

    durationTextField = UITextField(frame: CGRect.zero)
    durationTextField.keyboardType = .numberPad
    self.addSubview(durationTextField)
    durationLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: durationTextField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -35).isActive = true
    NSLayoutConstraint(item: durationTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true

    self.layer.cornerRadius = 5
    self.clipsToBounds = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
