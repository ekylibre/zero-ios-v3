//
//  AddIrrigation.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 06/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController: UITextFieldDelegate {

  // MARK: - Initialization

  func setupIrrigation() {
    let units = ["l", "hl", "m³"]
    irrigationPickerView = CustomPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), units)
    irrigationPickerView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(irrigationPickerView)
    irrigationPickerView.isHidden = true

    setupLayout()
    setupActions()
  }

  private func setupLayout() {
    NSLayoutConstraint.activate([
      irrigationPickerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      irrigationPickerView.heightAnchor.constraint(equalToConstant: 300),
      irrigationPickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      irrigationPickerView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
      ])
  }

  private func setupActions() {
    irrigationValueTextField.addTarget(self, action: #selector(updateIrrigation), for: .editingChanged)
    irrigationPickerView.cancelButton.addTarget(self, action: #selector(cancelPicking), for: .touchUpInside)
    irrigationPickerView.validateButton.addTarget(self, action: #selector(validatePick), for: .touchUpInside)
  }

  // MARK: - Actions

  @IBAction func tapIrrigationView(_ sender: Any) {
    if irrigationHeightConstraint.constant == 70 {
      irrigationHeightConstraint.constant = 140
      irrigationLabel.isHidden = true
      irrigationValueTextField.isHidden = false
    } else {
      irrigationHeightConstraint.constant = 70
      irrigationLabel.isHidden = false
      irrigationValueTextField.isHidden = true
    }
    irrigationExpandCollapseImage.transform = irrigationExpandCollapseImage.transform.rotated(by: CGFloat.pi)
  }

  @objc public func updateIrrigation(_ sender: Any) {
    let volumeString = irrigationValueTextField.text!.replacingOccurrences(of: ",", with: ".")
    let volume = Float(volumeString) ?? 0
    let unit = irrigationUnitButton.titleLabel!.text!

    irrigationLabel.text = String(format: "Volume • %g %@", volume, unit)
    updateInfoLabel(Double(volume), unit)
  }

  private func updateInfoLabel(_ volume: Double, _ unit: String) {
    if volume == 0 {
      irrigationInfoLabel.text = "Le volume ne peut être nul"
      irrigationInfoLabel.textColor = AppColor.TextColors.Red
    } else if totalLabel.text == "+ SÉLECTIONNER" {
      irrigationInfoLabel.text = "Aucune culture sélectionnée"
      irrigationInfoLabel.textColor = AppColor.TextColors.Red
    } else {
      let efficiency = Double(volume) / cropsView.totalSurfaceArea

      irrigationInfoLabel.text = String(format: "Soit %.1f %@ par hectare", efficiency, unit)
      irrigationInfoLabel.textColor = AppColor.TextColors.DarkGray
    }
  }

  @IBAction func tapUnit() {
    dimView.isHidden = false
    irrigationPickerView.isHidden = false
  }

  @objc func cancelPicking() {
    let selectedRow = irrigationPickerView.selectedRow

    irrigationPickerView.pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
    irrigationPickerView.isHidden = true
    dimView.isHidden = true
  }

  @objc func validatePick() {
    let selectedRow = irrigationPickerView.pickerView.selectedRow(inComponent: 0)
    let unit = irrigationPickerView.values[selectedRow]
    let volumeString = irrigationValueTextField.text!.replacingOccurrences(of: ",", with: ".")
    let volume = Float(volumeString) ?? 0

    self.irrigationUnitButton.setTitle(unit, for: .normal)
    irrigationLabel.text = String(format: "Volume • %g %@", volume, unit)
    updateInfoLabel(Double(volume), unit)
    irrigationPickerView.selectedRow = selectedRow
    irrigationPickerView.isHidden = true
    dimView.isHidden = true
  }
}
