//
//  HandleAddInterventionErrors.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 11/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {

  func implantationErrorHandler() -> Bool {
    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

    if selectedInputs.count == 0 {
      alert.message = "you_must_select_seed".localized
    } else {
      for selectedInput in selectedInputs {
        if (selectedInput.value(forKey: "quantity") as? Double) == 0 {
          alert.message = "you_have_to_enter_seed_quantity".localized
        }
      }
    }
    if alert.message != "" {
      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  func cropProtectionErrorHandler() -> Bool {
    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

    if selectedInputs.count == 0 {
      alert.message = "you_have_to_enter_phyto".localized
    } else {
      for selectedInput in selectedInputs {
        if (selectedInput.value(forKey: "quantity") as? Double) == 0 {
          alert.message = "you_have_to_enter_a_product_quantity".localized
        }
      }
    }
    if alert.message != "" {
      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  func fertilizationErrorHandler() -> Bool {
    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)

    if selectedInputs.count == 0 {
      alert.message = "you_must_select_a_fertilizer".localized
    } else {
      for selectedInput in selectedInputs {
        if (selectedInput.value(forKey: "quantity") as? Double) == 0 {
          alert.message = "you_have_to_enter_a_product_quantity".localized
        }
      }
    }
    if alert.message != "" {
      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  func cropErrorHandler() -> Bool {
    if cropsView.selectedCrops.count == 0 {
      let alert = UIAlertController(title: "", message: "you_have_to_select_a_crop".localized, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  func irrigationErrorHandler() -> Bool {
    if cropsView.selectedCrops.count == 0 {
      let alert = UIAlertController(title: "", message: "you_have_to_select_a_crop".localized, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    } else if irrigationValueTextField.text?.floatValue == 0 {
      let alert = UIAlertController(title: "", message: "you_must_enter_a_water_volume".localized, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  func checkErrorsInFunctionOfIntervention() -> Bool {
    if !cropErrorHandler() {
      return false
    }
    switch interventionType {
    case Intervention.InterventionType.CropProtection.rawValue.localized:
      return cropProtectionErrorHandler()
    case Intervention.InterventionType.Fertilization.rawValue.localized:
      return fertilizationErrorHandler()
    case Intervention.InterventionType.Harvest.rawValue.localized:
      return true
    case Intervention.InterventionType.Implantation.rawValue.localized:
      return implantationErrorHandler()
    case Intervention.InterventionType.Irrigation.rawValue.localized:
      return irrigationErrorHandler()
    default:
      return true
    }
  }
}
