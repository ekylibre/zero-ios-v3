//
//  WorkingPeriodsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class WorkingPeriodsView: UIView {
  var bannerView: UIView!
  var bannerLabel: UILabel!
  var dateLabel: UILabel!
  var datePicker: UIDatePicker!
  var durationLabel: UILabel!
  var durationTextField: UITextField!
  var unitLabel: UILabel!
  var bottomView: UIView!
  var validateButton: UIButton!

  override init(frame: CGRect) {
    super.init(frame: frame)

    bannerView = UIView(frame: CGRect.zero)
    bannerView.backgroundColor = AppColor.BarColors.Green
    self.addSubview(bannerView)
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: bannerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: bannerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: bannerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true

    bannerLabel = UILabel(frame: CGRect.zero)
    bannerLabel.text = "Sélectionnez un temps de travail"
    bannerLabel.textColor = AppColor.TextColors.White
    self.addSubview(bannerLabel)
    bannerLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: bannerLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: bannerLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true

    dateLabel = UILabel(frame: CGRect.zero)
    dateLabel.text = "Débuté le"
    dateLabel.textColor = AppColor.TextColors.DarkGray
    self.addSubview(dateLabel)
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: bannerView, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true

    datePicker = UIDatePicker()
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "fr")
    self.addSubview(datePicker)
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: dateLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
    NSLayoutConstraint(item: datePicker, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: datePicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 175).isActive = true

    durationLabel = UILabel(frame: CGRect.zero)
    durationLabel.text = "Durée"
    durationLabel.textColor = AppColor.TextColors.DarkGray
    self.addSubview(durationLabel)
    durationLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: durationLabel, attribute: .top, relatedBy: .equal, toItem: datePicker, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: durationLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true

    durationTextField = UITextField(frame: CGRect.zero)
    durationTextField.keyboardType = .numberPad
    durationTextField.textAlignment = .center
    durationTextField.text = "7"
    self.addSubview(durationTextField)
    durationTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: durationTextField, attribute: .top, relatedBy: .equal, toItem: datePicker, attribute: .bottom, multiplier: 1, constant: 12).isActive = true
    NSLayoutConstraint(item: durationTextField, attribute: .leading, relatedBy: .equal, toItem: durationLabel, attribute: .trailing, multiplier: 1, constant: 20).isActive = true
    NSLayoutConstraint(item: durationTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
    NSLayoutConstraint(item: durationTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
    durationTextField.layer.cornerRadius = 5
    durationTextField.layer.borderWidth = 1
    durationTextField.layer.borderColor = AppColor.TextColors.DarkGray.cgColor
    durationTextField.clipsToBounds = true

    unitLabel = UILabel(frame: CGRect.zero)
    unitLabel.text = "heures"
    unitLabel.textColor = AppColor.TextColors.DarkGray
    self.addSubview(unitLabel)
    unitLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: unitLabel, attribute: .top, relatedBy: .equal, toItem: datePicker, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: unitLabel, attribute: .leading, relatedBy: .equal, toItem: durationTextField, attribute: .trailing, multiplier: 1, constant: 10).isActive = true

    bottomView = UIView(frame: CGRect.zero)
    bottomView.backgroundColor = AppColor.BarColors.Green
    self.addSubview(bottomView)
    bottomView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: bottomView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: bottomView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true

    validateButton = UIButton(frame: CGRect.zero)
    validateButton.backgroundColor = UIColor.white
    validateButton.setTitle("VALIDER", for: .normal)
    validateButton.setTitleColor(AppColor.TextColors.Black, for: .normal)
    validateButton.addTarget(self, action: #selector(validateWorkingPeriod), for: .touchUpInside)
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
    fatalError("NSCoder has not been implemented.")
  }

  @objc func validateWorkingPeriod() {
    self.isHidden = true
  }
}
