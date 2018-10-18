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

    irrigationValueTextField.layer.borderWidth = 0.5
    irrigationValueTextField.layer.borderColor = UIColor.lightGray.cgColor
    irrigationValueTextField.layer.cornerRadius = 5
    irrigationValueTextField.clipsToBounds = false
    irrigationUnitButton.layer.borderWidth = 0.5
    irrigationUnitButton.layer.borderColor = UIColor.lightGray.cgColor
    irrigationUnitButton.layer.cornerRadius = 5
    irrigationUnitButton.clipsToBounds = false
    irrigationPickerView = CustomPickerView(frame: frame, units, superview: self.view)
    irrigationPickerView.reference = self
    setupActions()
  }

  private func setupActions() {
    irrigationValueTextField.addTarget(self, action: #selector(updateIrrigation), for: .editingChanged)
  }

  // MARK: - Picker view
  
  func customPickerDidSelectRow(_ pickerView: UIPickerView, _ selectedValue: String?) {
    guard let unit = selectedValue else {
      return
    }

    switch pickerView {
    case harvestNaturePickerView:
      harvestType.setTitle(unit.localized, for: .normal)
      harvestNaturePickerView.isHidden = true
      dimView.isHidden = true
    case harvestUnitPickerView:
      harvests[cellIndexPath.row].unit = unit
      harvestUnitPickerView.isHidden = true
      dimView.isHidden = true
      harvestTableView.reloadData()
    case storagesPickerView:
      harvests[cellIndexPath.row].storages = searchStorage(name: unit)
      storagesPickerView.isHidden = true
      dimView.isHidden = true
      harvestTableView.reloadData()
    case irrigationPickerView:
      let volumeString = irrigationValueTextField.text!.replacingOccurrences(of: ",", with: ".")
      let volume = Float(volumeString) ?? 0

      self.irrigationUnitButton.setTitle(selectedValue, for: .normal)
      irrigationLabel.text = String(format: "Volume • %g %@", volume, unit)
      updateInfoLabel(volume, unit)
      irrigationPickerView.isHidden = true
      dimView.isHidden = true
    default:
      return
    }
  }

  // MARK: - Actions

  @IBAction func tapIrrigationView(_ sender: Any) {
    let shouldExpand: Bool = (irrigationHeightConstraint.constant == 70)

    irrigationHeightConstraint.constant = shouldExpand ? 140 : 70
    irrigationLabel.isHidden = shouldExpand
    irrigationValueTextField.isHidden = !shouldExpand
    irrigationUnitButton.isHidden = !shouldExpand
    irrigationExpandCollapseImage.transform = irrigationExpandCollapseImage.transform.rotated(by: CGFloat.pi)
  }

  @objc public func updateIrrigation(_ sender: Any) {
    let volumeString = irrigationValueTextField.text!.replacingOccurrences(of: ",", with: ".")
    let volume = Float(volumeString) ?? 0
    let unit = irrigationUnitButton.titleLabel!.text!

    irrigationLabel.text = String(format: "Volume • %g %@", volume, unit)
    updateInfoLabel(volume, unit)
  }

  private func updateInfoLabel(_ volume: Float, _ unit: String) {
    if volume == 0 {
      irrigationInfoLabel.text = "Le volume ne peut être nul"
      irrigationInfoLabel.textColor = AppColor.TextColors.Red
    } else if totalLabel.text == "+ SÉLECTIONNER" {
      irrigationInfoLabel.text = "Aucune culture sélectionnée"
      irrigationInfoLabel.textColor = AppColor.TextColors.Red
    } else {
      let efficiency = volume / cropsView.selectedSurfaceArea

      irrigationInfoLabel.text = String(format: "Soit %.1f %@ par hectare", efficiency, unit)
      irrigationInfoLabel.textColor = AppColor.TextColors.DarkGray
    }
  }

  @IBAction func tapUnit() {
    dimView.isHidden = false
    irrigationPickerView.isHidden = false
  }
}
