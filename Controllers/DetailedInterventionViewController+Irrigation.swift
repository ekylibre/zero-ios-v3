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

  func setupIrrigationView() {
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    let units = ["CUBIC_METER", "LITER", "HECTOLITER"]

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

    switch pickerView {
    case harvestNaturePickerView:
      harvestType.setTitle(unit.localized, for: .normal)
      harvestSelectedType = unit
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
    case storagesTypes:
      storageCreationView.typeButton.setTitle(unit.localized, for: .normal)
      storageCreationView.selectedType = unit
      storagesTypes.isHidden = true
    case irrigationPickerView:
      let volume = irrigationVolumeTextField.text!.floatValue

      self.irrigationUnitButton.setTitle(selectedValue?.localized, for: .normal)
      selectedIrrigationLabel.text = String(format: "%@ • %g %@", "volume".localized, volume, unit.localized)
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
    selectedIrrigationLabel.isHidden = shouldExpand
    irrigationVolumeTextField.isHidden = !shouldExpand
    irrigationUnitButton.isHidden = !shouldExpand
    irrigationExpandImageView.transform = irrigationExpandImageView.transform.rotated(by: CGFloat.pi)
  }

  @objc public func updateIrrigation(_ sender: Any) {
    let volume = irrigationVolumeTextField.text!.floatValue
    let unit = irrigationUnitButton.titleLabel!.text!

    selectedIrrigationLabel.text = String(format: "%@ • %g %@", "volume".localized, volume, unit.localized)
    updateInfoLabel(volume, unit)
  }

  private func updateInfoLabel(_ volume: Float, _ unit: String) {
    if volume == 0 {
      irrigationErrorLabel.text = "volume_cannot_be_null".localized
      irrigationErrorLabel.textColor = AppColor.TextColors.Red
    } else if totalLabel.text == "select_crops".localized {
      irrigationErrorLabel.text = "no_crop_selected".localized
      irrigationErrorLabel.textColor = AppColor.TextColors.Red
    } else {
      let efficiency = volume / cropsView.selectedSurfaceArea

      irrigationErrorLabel.text = String(format: "input_quantity_per_surface".localized, efficiency, unit.localized)
      irrigationErrorLabel.textColor = AppColor.TextColors.DarkGray
    }
  }

  @IBAction func tapUnit() {
    dimView.isHidden = false
    irrigationPickerView.isHidden = false
  }
}
