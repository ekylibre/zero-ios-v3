//
//  DetailedInterventionViewController+Irrigation.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 06/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController: UITextFieldDelegate {

  // MARK: - Initialization

  func setupIrrigationView() {
    irrigationVolumeTextField.delegate = self
    irrigationVolumeTextField.layer.borderWidth = 0.5
    irrigationVolumeTextField.layer.borderColor = UIColor.lightGray.cgColor
    irrigationVolumeTextField.layer.cornerRadius = 5
    irrigationVolumeTextField.placeholder = "0"
    irrigationVolumeTextField.clipsToBounds = false
    irrigationUnitButton.layer.borderWidth = 0.5
    irrigationUnitButton.layer.borderColor = UIColor.lightGray.cgColor
    irrigationUnitButton.layer.cornerRadius = 5
    irrigationUnitButton.clipsToBounds = false
    irrigationUnitButton.setTitle("m³", for: .normal)
    setupActions()
  }

  private func setupActions() {
    irrigationVolumeTextField.addTarget(self, action: #selector(updateIrrigation), for: .editingChanged)
  }

  // MARK: - Actions

  @IBAction func tapIrrigationView(_ sender: Any) {
    let shouldExpand: Bool = (irrigationHeightConstraint.constant == 70)

    view.endEditing(true)
    irrigationHeightConstraint.constant = shouldExpand ? 140 : 70
    selectedIrrigationLabel.isHidden = shouldExpand
    irrigationVolumeTextField.isHidden = !shouldExpand
    irrigationUnitButton.isHidden = !shouldExpand
    irrigationExpandImageView.transform = irrigationExpandImageView.transform.rotated(by: CGFloat.pi)
  }

  @objc func updateIrrigation() {
    let volume = irrigationVolumeTextField.text!.floatValue
    let unit = irrigationUnitButton.title(for: .normal)

    selectedIrrigationLabel.text = String(format: "%@ • %g %@", "volume".localized, volume, unit!)
    updateInfoLabel(volume, unit!)
  }

  private func updateInfoLabel(_ volume: Float, _ unit: String) {
    if volume == 0 {
      irrigationErrorLabel.text = "volume_cannot_be_null".localized
      irrigationErrorLabel.textColor = AppColor.TextColors.Red
    } else if totalLabel.text == "select_crops".localized.uppercased() {
      irrigationErrorLabel.text = "no_crop_selected".localized
      irrigationErrorLabel.textColor = AppColor.TextColors.Red
    } else {
      let efficiency = volume / cropsView.selectedSurfaceArea

      irrigationErrorLabel.text = String(format: "input_quantity_per_surface".localized, efficiency, unit.localized)
      irrigationErrorLabel.textColor = AppColor.TextColors.DarkGray
    }
  }

  @IBAction func tapUnit() {
    customPickerView.values = ["CUBIC_METER", "LITER", "HECTOLITER"]
    customPickerView.pickerView.reloadComponent(0)
    customPickerView.closure = { (_ value: String) in
      let volume = self.irrigationVolumeTextField.text!.floatValue

      self.irrigationUnitButton.setTitle(value.localized, for: .normal)
      self.selectedIrrigationLabel.text = String(format: "%@ • %g %@", "volume".localized, volume, value.localized)
      self.updateInfoLabel(volume, value)
    }
    customPickerView.isHidden = false
  }
}
