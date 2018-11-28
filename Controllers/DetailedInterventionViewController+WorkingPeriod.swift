//
//  DetailedInterventionViewController+WorkingPeriod.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {

  // MARK: - Initialization

  func setupWorkingPeriodView() {
    let currentDateString: String = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: Date())
    }()

    selectDateView = SelectDateView(frame: CGRect.zero)
    workingPeriodDurationTextField.delegate = self
    workingPeriodDateButton.setTitle(currentDateString, for: .normal)
    workingPeriodDateButton.layer.borderWidth = 0.5
    workingPeriodDateButton.layer.borderColor = UIColor.lightGray.cgColor
    workingPeriodDateButton.layer.cornerRadius = 5
    workingPeriodDateButton.clipsToBounds = true
    workingPeriodDurationTextField.layer.borderWidth = 0.5
    workingPeriodDurationTextField.layer.borderColor = UIColor.lightGray.cgColor
    workingPeriodDurationTextField.layer.cornerRadius = 5
    workingPeriodDurationTextField.clipsToBounds = true
    workingPeriodDurationTextField.addTarget(self, action: #selector(updateDurationUnit), for: .editingChanged)
    selectDateView.doneButton.addTarget(self, action: #selector(validateDate), for: .touchUpInside)
  }

  // MARK: - Actions

  @IBAction func tapWorkingPeriodView(_ sender: Any) {
    let shouldExpand = (workingPeriodHeightConstraint.constant == 70)
    let dateString = workingPeriodDateButton.titleLabel!.text!
    let duration = workingPeriodDurationTextField.text!.floatValue

    view.endEditing(true)
    workingPeriodHeightConstraint.constant = shouldExpand ? 155 : 70
    if duration.truncatingRemainder(dividingBy: 1) == 0 {
      selectedWorkingPeriodLabel.text = String(format: "%@ • %g h", dateString, duration)
    } else {
      selectedWorkingPeriodLabel.text = String(format: "%@ • %.1f h", dateString, duration)
    }
    selectedWorkingPeriodLabel.isHidden = shouldExpand
    workingPeriodDateButton.isHidden = !shouldExpand
    workingPeriodExpandImageView.transform = workingPeriodExpandImageView.transform.rotated(by: CGFloat.pi)
  }

  @IBAction private func selectDate(_ sender: Any) {
    selectDateView.show()

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @objc func validateDate() {
    let selectedDate: String = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: selectDateView.datePicker.date)
    }()

    workingPeriodDateButton.setTitle(selectedDate, for: .normal)
    selectDateView.close()

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
  }

  @objc private func updateDurationUnit() {
    let duration = workingPeriodDurationTextField.text!.floatValue

    workingPeriodUnitLabel.text = (duration <= 1) ? "hour".localized : "hours".localized
  }
}
