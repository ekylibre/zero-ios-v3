//
//  AddIrrigation.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 06/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {

  @IBAction func tapIrrigationView(_ sender: Any) {
    if irrigationHeightConstraint.constant == 70 {
      irrigationHeightConstraint.constant = 140
      irrigationValueTextField.isHidden = false
    } else {
      irrigationHeightConstraint.constant = 70
      irrigationValueTextField.isHidden = true
    }
    irrigationExpandCollapseImage.transform = irrigationExpandCollapseImage.transform.rotated(by: CGFloat.pi)
  }
}
