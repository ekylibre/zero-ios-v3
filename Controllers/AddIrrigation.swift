//
//  AddIrrigation.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 06/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController: UITextFieldDelegate {

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

  @objc public func textFieldDidChange(_ sender: Any) {
    let volumeString = irrigationValueTextField.text!.replacingOccurrences(of: ",", with: ".")
    let volume = Float(volumeString) ?? 0
    let unit = irrigationUnitButton.titleLabel!.text!

    irrigationLabel.text = String(format: "Volume • %g %@", volume, unit)
    irrigationLabel.isHidden = false
    changeInfoLabel(Double(volume), unit)
  }

  private func changeInfoLabel(_ volume: Double, _ unit: String) {
    if volume == 0 {
      irrigationInfoLabel.text = "Le volume ne peut être nul"
      irrigationInfoLabel.textColor = AppColor.TextColors.Red
    } else if totalLabel.text == "+ SÉLECTIONNER" {
      irrigationInfoLabel.text = "Aucune culture sélectionnée"
      irrigationInfoLabel.textColor = AppColor.TextColors.Red
    } else {
      var surfaceArea: Double = 0
      var efficiency: Double = 0

      for selectedCrop in cropsView.selectedCrops {
        surfaceArea += selectedCrop.value(forKey: "surfaceArea") as! Double
      }

      efficiency = Double(volume) / surfaceArea

      irrigationInfoLabel.text = String(format: "Soit %.1f %@ par hectare", efficiency, unit)
      irrigationInfoLabel.textColor = AppColor.TextColors.DarkGray
    }
  }
}
