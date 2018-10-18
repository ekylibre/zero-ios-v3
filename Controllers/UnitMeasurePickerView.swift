//
//  UnitMeasurePickerView.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 27/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController: UIPickerViewDelegate, UIPickerViewDataSource {

  // MARK: - Initialization

  func initUnitMeasurePickerView() {
    volumeUnitPicker.backgroundColor = AppColor.CellColors.White
    volumeUnitPicker.frame = CGRect(x: 0, y: view.frame.maxY - 200, width: view.bounds.width, height: 200)
    volumeUnitPicker.delegate = self
    volumeUnitPicker.dataSource = self
    volumeUnitPicker.isHidden = true
    view.addSubview(volumeUnitPicker)

    massUnitPicker.backgroundColor = AppColor.CellColors.White
    massUnitPicker.frame = CGRect(x: 0, y: view.frame.maxY - 200, width: view.bounds.width, height: 200)
    massUnitPicker.delegate = self
    massUnitPicker.dataSource = self
    massUnitPicker.isHidden = true
    view.addSubview(massUnitPicker)
  }

  // MARK: Picker View Data Source

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == volumeUnitPicker {
      return volumeUnitMeasure.count
    } else {
      return massUnitMeasure.count
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == volumeUnitPicker {
      return volumeUnitMeasure[row].localized
    } else {
      return massUnitMeasure[row].localized
    }
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    dimView.isHidden = true

    let cell = selectedInputsTableView.cellForRow(at: cellIndexPath) as! SelectedInputCell

    if pickerView == volumeUnitPicker {
      volumeUnitPicker.isHidden = true
      selectedInputs[cellIndexPath.row].setValue(volumeUnitMeasure[row], forKey: "unit")
      cell.unitMeasureButton.setTitle(volumeUnitMeasure[row].localized, for: .normal)
    } else {
      massUnitPicker.isHidden = true
      selectedInputs[cellIndexPath.row].setValue(massUnitMeasure[row], forKey: "unit")
      cell.unitMeasureButton.setTitle(massUnitMeasure[row].localized, for: .normal)
    }
    selectedInputsTableView.reloadData()
    updateInputQuantity(indexPath: cellIndexPath)
  }
}
