//
//  HandleAddInterventionErrors.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 11/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {

  private func implantationErrorHandler() -> Bool {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

    if selectedInputs.count == 0 {
      alert.title = "you_must_select_seed".localized
    } else {
      for selectedInput in selectedInputs {
        if (selectedInput.value(forKey: "quantity") as? Double) == 0 {
          alert.title = "you_have_to_enter_seed_quantity".localized
        }
      }
    }
    if alert.title != nil {
      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func cropProtectionErrorHandler() -> Bool {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

    if selectedInputs.count == 0 {
      alert.title = "you_have_to_enter_phyto".localized
    } else {
      for selectedInput in selectedInputs {
        if (selectedInput.value(forKey: "quantity") as? Double) == 0 {
          alert.title = "you_have_to_enter_a_product_quantity".localized
        }
      }
    }
    if alert.title != nil {
      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func fertilizationErrorHandler() -> Bool {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

    if selectedInputs.count == 0 {
      alert.title = "you_must_select_a_fertilizer".localized
    } else {
      for selectedInput in selectedInputs {
        if (selectedInput.value(forKey: "quantity") as? Double) == 0 {
          alert.title = "you_have_to_enter_a_product_quantity".localized
        }
      }
    }
    if alert.title != nil {
      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func harvestErrorHandler() -> Bool {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

    if harvests.count == 0 {
      alert.title = "you_must_create_a_harvest_load".localized
    } else {
      for harvest in harvests {
        if harvest.quantity == 0 {
          alert.title = "you_must_enter_harvest_quantity".localized
        }
      }
    }
    if alert.title != nil {
      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func cropErrorHandler() -> Bool {
    let selectedCrops = fetchSelectedCrops()

    if selectedCrops.count == 0 {
      let alert = UIAlertController(title: "you_have_to_select_a_crop".localized, message: nil, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func irrigationErrorHandler() -> Bool {
    if irrigationVolumeTextField.text?.floatValue == 0 {
      let alert = UIAlertController(title: "you_must_enter_a_water_volume".localized, message: nil,
                                    preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func checkIfSelectedDateMatchProductionPeriod(selectedDate: Date) -> Bool {
    let selectedCrops = fetchSelectedCrops()

    if selectedCrops.count > 0 {
      var startDate = selectedCrops.first?.startDate
      var stopDate = selectedCrops.first?.stopDate

      for selectedCrop in selectedCrops {
        startDate = (selectedCrop.startDate! > startDate! ? selectedCrop.startDate! : startDate)
        stopDate = (selectedCrop.stopDate! < stopDate! ? selectedCrop.stopDate! : stopDate)
      }
      if selectedDate < startDate! || selectedDate > stopDate! {
        var message: String!

        if selectedDate < startDate! {
          message = String(format: "started_must_be_on_or_after".localized,
                           DateConverter.convertDateStringInLocalizedFormat(startDate!))
        } else {
          message = String(format: "started_must_be_on_or_before".localized,
                           DateConverter.convertDateStringInLocalizedFormat(stopDate!))
        }
        let alert = UIAlertController(
          title: "working_periods_is_invalid".localized,
          message: message,
          preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
        return false
      }
    }
    return true
  }

  func checkErrorsAccordingInterventionType() -> Bool {
    if !cropErrorHandler() {
      return false
    } else if !checkIfSelectedDateMatchProductionPeriod(selectedDate: selectDateView.datePicker.date) {
      return false
    }
    switch interventionType {
    case InterventionType.CropProtection.rawValue:
      return cropProtectionErrorHandler()
    case InterventionType.Fertilization.rawValue:
      return fertilizationErrorHandler()
    case InterventionType.Harvest.rawValue:
      return harvestErrorHandler()
    case InterventionType.Implantation.rawValue:
      return implantationErrorHandler()
    case InterventionType.Irrigation.rawValue:
      return irrigationErrorHandler()
    default:
      return true
    }
  }
}
