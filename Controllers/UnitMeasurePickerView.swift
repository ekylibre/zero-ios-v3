//
//  File.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 27/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func initUnitMeasurePickerView() {
    unitMeasurePicker.backgroundColor = AppColor.CellColors.white
    unitMeasurePicker.frame = CGRect(x: 0, y: view.frame.maxY - 200, width: view.bounds.width, height: 200)
    unitMeasurePicker.delegate = self
    unitMeasurePicker.dataSource = self
    unitMeasurePicker.isHidden = true
    view.addSubview(unitMeasurePicker)
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerType == 1 {
      return liquidUnitMeasure.count
    } else {
      return solidUnitMeasure.count
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerType == 1 {
      return liquidUnitMeasure[row]
    } else {
      return solidUnitMeasure[row]
    }
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    unitMeasurePicker.isHidden = true
    dimView.isHidden = true
    if pickerType == 1 {
      let cell = selectedInputsTableView.cellForRow(at: cellIndexPath) as! SelectedInputsTableViewCell

      cell.unitMeasureButton.setTitle(liquidUnitMeasure[row], for: .normal)
    } else {
      let cell = selectedInputsTableView.cellForRow(at: cellIndexPath) as! SelectedInputsTableViewCell

      cell.unitMeasureButton.setTitle(solidUnitMeasure[row], for: .normal)
    }
  }
}
