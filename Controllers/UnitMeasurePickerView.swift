//
//  UnitMeasurePickerView.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 27/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func initUnitMeasurePickerView() {
    liquidUnitPicker.backgroundColor = AppColor.CellColors .white
    liquidUnitPicker.frame = CGRect(x: 0, y: view.frame.maxY - 200, width: view.bounds.width, height: 200)
    liquidUnitPicker.delegate = self
    liquidUnitPicker.dataSource = self
    liquidUnitPicker.isHidden = true
    view.addSubview(liquidUnitPicker)

    solidUnitPicker.backgroundColor = AppColor.CellColors.white
    solidUnitPicker.frame = CGRect(x: 0, y: view.frame.maxY - 200, width: view.bounds.width, height: 200)
    solidUnitPicker.delegate = self
    solidUnitPicker.dataSource = self
    solidUnitPicker.isHidden = true
    view.addSubview(solidUnitPicker)
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == liquidUnitPicker {
      return liquidUnitMeasure.count
    } else {
      return solidUnitMeasure.count
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == liquidUnitPicker {
      return liquidUnitMeasure[row]
    } else {
      return solidUnitMeasure[row]
    }
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    dimView.isHidden = true

    let cell = selectedInputsTableView.cellForRow(at: cellIndexPath) as! SelectedInputCell

    if pickerView == liquidUnitPicker {
      liquidUnitPicker.isHidden = true
      cell.unitMeasureButton.setTitle(liquidUnitMeasure[row], for: .normal)
    } else {
      solidUnitPicker.isHidden = true
      cell.unitMeasureButton.setTitle(solidUnitMeasure[row], for: .normal)
    }
  }
}
