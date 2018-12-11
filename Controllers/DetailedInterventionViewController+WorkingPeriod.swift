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
    workingPeriodDurationTextField.placeholder = "0"
    workingPeriodDurationTextField.text = "7"
    workingPeriodDurationTextField.layer.borderWidth = 0.5
    workingPeriodDurationTextField.layer.borderColor = UIColor.lightGray.cgColor
    workingPeriodDurationTextField.layer.cornerRadius = 5
    workingPeriodDurationTextField.clipsToBounds = true
    workingPeriodDurationTextField.addTarget(self, action: #selector(updateDurationUnit), for: .editingChanged)
    selectDateView.cancelButton.addTarget(self, action: #selector(cancelSelection), for: .touchUpInside)
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

  @objc private func cancelSelection() {
    selectDateView.close()

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    }, completion: { _ in
      self.resetPickerDate()
    })
  }

  private func resetPickerDate() {
    guard let title = self.workingPeriodDateButton.titleLabel?.text else { return }
    let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter
    }()
    guard let titleDate = dateFormatter.date(from: title) else { return }
    var components = Calendar.current.dateComponents([.day, .month, .year], from: titleDate)
    components.year = Calendar.current.component(.year, from: Date())
    guard let selectedDate = Calendar.current.date(from: components) else { return }

    self.selectDateView.datePicker.date = selectedDate
  }

  @objc private func validateDate() {
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
