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
      alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil))
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
      alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil))
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
      alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func harvestErrorHandler() -> Bool {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

    if selectedHarvests.count == 0 {
      alert.title = "you_must_create_a_harvest_load".localized
    } else {
      for harvest in selectedHarvests {
        if harvest.quantity == 0 {
          alert.title = "you_must_enter_harvest_quantity".localized
        }
      }
    }
    if alert.title != nil {
      alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func cropErrorHandler() -> Bool {
    if cropsView.selectedCrops.count == 0 {
      let alert = UIAlertController(title: "you_have_to_select_a_crop".localized, message: nil, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func irrigationErrorHandler() -> Bool {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    let errorMessage: [Int: String] = [0: "you_have_to_enter_seed_quantity", 1: "you_have_to_enter_a_product_quantity",
                                       2: "you_have_to_enter_a_product_quantity"]

    if irrigationVolumeTextField.text?.floatValue == 0 {
      alert.title = "you_must_enter_a_water_volume".localized
    } else if selectedInputs.count == 1 {
      for selectedInput in selectedInputs {
        if (selectedInput.value(forKey: "quantity") as? Double) == 0 {
          alert.title = errorMessage[inputsSelectionView.segmentedControl.selectedSegmentIndex]?.localized
        }
      }
    } else {
      if selectedInputs.count > 1 {
        alert.title = "you_have_to_enter_inputs_quantities".localized
      }
    }
    if alert.title != nil {
      alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil))
      present(alert, animated: true)
      return false
    }
    return true
  }

  private func checkIfSelectedDateMatchProductionPeriod(selectedDate: Date) -> Bool {
    let selectedCrops = cropsView.selectedCrops
    guard var startDate = selectedCrops.first?.startDate else { return false }
    guard var stopDate = selectedCrops.first?.stopDate else { return false }
    let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "date_format".localized
      return dateFormatter
    }()

    for selectedCrop in selectedCrops {
      startDate = (selectedCrop.startDate! > startDate ? selectedCrop.startDate! : startDate)
      stopDate = (selectedCrop.stopDate! < stopDate ? selectedCrop.stopDate! : stopDate)
    }

    if selectedDate < startDate {
      let dateString = dateFormatter.string(from: startDate)
      let message = String(format: "crops_start_date".localized, dateString)
      presentWorkingPeriodAlert(message)
      return false
    } else if selectedDate > stopDate {
      let dateString = dateFormatter.string(from: stopDate)
      let message = String(format: "crops_end_date".localized, dateString)
      presentWorkingPeriodAlert(message)
      return false
    }
    return true
  }

  private func presentWorkingPeriodAlert(_ message: String) {
    let alert = UIAlertController(title: "date_not_corresponding_to_crop".localized,
                                  message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil)

    alert.addAction(cancelAction)
    present(alert, animated: true)
  }

  func checkErrorsAccordingInterventionType() -> Bool {
    if !cropErrorHandler() || !checkIfSelectedDateMatchProductionPeriod(selectedDate: selectDateView.datePicker.date) {
      return false
    }
    switch interventionType! {
    case .CropProtection:
      return cropProtectionErrorHandler()
    case .Fertilization:
      return fertilizationErrorHandler()
    case .Harvest:
      return harvestErrorHandler()
    case .Implantation:
      return implantationErrorHandler()
    case .Irrigation:
      return irrigationErrorHandler()
    default:
      return true
    }
  }
}
