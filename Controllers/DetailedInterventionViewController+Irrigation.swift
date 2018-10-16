//
//  DetailedInterventionViewController+Irrigation.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 06/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController: UITextFieldDelegate, CustomPickerViewProtocol {

  // MARK: - Initialization

  func setupIrrigation() {
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    let units = ["m³", "l", "hl"]

    irrigationVolumeTextField.layer.borderWidth = 0.5
    irrigationVolumeTextField.layer.borderColor = UIColor.lightGray.cgColor
    irrigationVolumeTextField.layer.cornerRadius = 5
    irrigationVolumeTextField.clipsToBounds = false
    irrigationUnitButton.layer.borderWidth = 0.5
    irrigationUnitButton.layer.borderColor = UIColor.lightGray.cgColor
    irrigationUnitButton.layer.cornerRadius = 5
    irrigationUnitButton.clipsToBounds = false
    irrigationPickerView = CustomPickerView(frame: frame, units, superview: self.view)
    irrigationPickerView.reference = self
    setupActions()
  }

  private func setupActions() {
    irrigationVolumeTextField.addTarget(self, action: #selector(updateIrrigation), for: .editingChanged)
  }

  // MARK: - Picker view

  func customPickerDidSelectRow(_ pickerView: UIPickerView, _ selectedValue: String?) {
    guard let unit = selectedValue else {
      return
    }

    let volumeString = irrigationVolumeTextField.text!.replacingOccurrences(of: ",", with: ".")
    let volume = Float(volumeString) ?? 0

    self.irrigationUnitButton.setTitle(selectedValue, for: .normal)
    irrigationLabel.text = String(format: "Volume • %g %@", volume, unit)
    updateInfoLabel(Double(volume), unit)
    irrigationPickerView.isHidden = true
    dimView.isHidden = true
  }

  // MARK: - Actions

  @IBAction func tapIrrigationView(_ sender: Any) {
    let shouldExapand: Bool = (irrigationHeightConstraint.constant == 70)

    irrigationHeightConstraint.constant = shouldExapand ? 140 : 70
    irrigationLabel.isHidden = shouldExapand
    irrigationVolumeTextField.isHidden = !shouldExapand
    irrigationUnitButton.isHidden = !shouldExapand
    irrigationExpandImageView.transform = irrigationExpandImageView.transform.rotated(by: CGFloat.pi)
  }

  @objc public func updateIrrigation(_ sender: Any) {
    let volumeString = irrigationVolumeTextField.text!.replacingOccurrences(of: ",", with: ".")
    let volume = Float(volumeString) ?? 0
    let unit = irrigationUnitButton.titleLabel!.text!

    irrigationLabel.text = String(format: "Volume • %g %@", volume, unit)
    updateInfoLabel(Double(volume), unit)
  }

  private func updateInfoLabel(_ volume: Double, _ unit: String) {
    if volume == 0 {
      irrigationErrorLabel.text = "Le volume ne peut être nul"
      irrigationErrorLabel.textColor = AppColor.TextColors.Red
    } else if totalLabel.text == "+ SÉLECTIONNER" {
      irrigationErrorLabel.text = "Aucune culture sélectionnée"
      irrigationErrorLabel.textColor = AppColor.TextColors.Red
    } else {
      let efficiency = Double(volume) / cropsView.totalSurfaceArea

      irrigationErrorLabel.text = String(format: "Soit %.1f %@ par hectare", efficiency, unit)
      irrigationErrorLabel.textColor = AppColor.TextColors.DarkGray
    }
  }

  @IBAction func tapUnit() {
    dimView.isHidden = false
    irrigationPickerView.isHidden = false
  }
}
