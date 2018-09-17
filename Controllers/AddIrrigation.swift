//
//  AddIrrigation.swift
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

    irrigationPickerView = CustomPickerView(frame: frame, units, superview: self.view)
    irrigationPickerView.reference = self
    setupActions()
  }

  private func setupActions() {
    irrigationValueTextField.addTarget(self, action: #selector(updateIrrigation), for: .editingChanged)
  }

  // MARK: - Picker view

  func customPickerDidSelectRow(_ selectedValue: String?, pickerView: CustomPickerView) {
    guard let unit = selectedValue else {
      return
    }

    switch pickerView {
    case harvestNaturePickerView:
      print("Toto")
      for harvest in harvests {
        harvest.setValue(unit, forKey: "type")
      }
      harvestType.setTitle(unit, for: .normal)
      harvestNaturePickerView.isHidden = true
      dimView.isHidden = true
    case harvestUnitPickerView:
      harvests[cellIndexPath.row].setValue(unit, forKey: "unit")
      harvestUnitPickerView.isHidden = true
      dimView.isHidden = true
      harvestTableView.reloadData()
    case irrigationPickerView:
      let volumeString = irrigationValueTextField.text!.replacingOccurrences(of: ",", with: ".")
      let volume = Float(volumeString) ?? 0

      irrigationUnitButton.setTitle(selectedValue, for: .normal)
      irrigationLabel.text = String(format: "Volume • %g %@", volume, unit)
      updateInfoLabel(Double(volume), unit)
      irrigationPickerView.isHidden = true
      dimView.isHidden = true
    default:
      return
    }
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
}
