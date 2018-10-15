//
//  DisplayInterventions.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController {

  func loadWorkingPeriod() {
    let dateFormatter = DateFormatter()
    let selectedDate: String
    let workingPeriods = currentIntervention.workingPeriods
    let date = workingPeriods?.executionDate
    let duration = workingPeriods?.hourDuration

    dateFormatter.locale = Locale(identifier: "locale".localized)
    dateFormatter.dateFormat = "d MMM"
    if date != nil && duration != nil {
      selectedDate = dateFormatter.string(from: date!)
      selectedWorkingPeriodLabel.text = String(format: "%@ • %g h", selectedDate, duration!)
      selectDateButton.setTitle(selectedDate, for: .normal)
      durationTextField.text = (duration as NSNumber?)?.stringValue
      selectDateView.datePicker.date = date!
    }
    if interventionState == Intervention.State.Validated.rawValue {
      collapseWorkingPeriodImage.isHidden = true
      workingPeriodGestureRecognizer.isEnabled = false
    }
  }

  func loadIrrigationInReadOnlyMode() {
    if interventionType == Intervention.InterventionType.Irrigation.rawValue {
      irrigationValueTextField.text = String(currentIntervention.waterQuantity)
      irrigationUnitButton.setTitle(currentIntervention.waterUnit, for: .normal)
      updateIrrigation(self)
      irrigationExpandCollapseImage.isHidden = true
      irrigationGestureRecognizer.isEnabled = false
      tapIrrigationView(self)
    }
  }

  func loadInputs() {
    for interventionSeed in currentIntervention?.interventionSeeds?.allObjects as! [InterventionSeeds] {
      selectedInputs.append(interventionSeed)
    }
    for interventionPhyto in currentIntervention?.interventionPhytosanitaries?.allObjects as! [InterventionPhytosanitaries] {
      selectedInputs.append(interventionPhyto)
    }
    for interventionFertilizer in currentIntervention.interventionFertilizers?.allObjects as! [InterventionFertilizers] {
      selectedInputs.append(interventionFertilizer)
    }
    refreshSelectedInputs()
  }

  func loadEquipments() {
    for interventionEquipment in currentIntervention?.interventionEquipments?.allObjects as! [InterventionEquipments] {
      selectedEquipments.append(interventionEquipment)
    }
    refreshSelectedEquipment()
  }

  func loadPersons() {
    for doer in currentIntervention.doers?.allObjects as! [Doers] {
      doers.append(doer)
    }
    refreshSelectedPersons()
  }

  func loadInterventionInReadOnlyMode() {
    warningView.isHidden = false
    warningMessage.text = "you_are_in_consult_mode".localized
    notesTextField.placeholder = (currentIntervention.infos == "" ? "Notes" : currentIntervention.infos)
    bottomBarView.isHidden = true
    bottomView.isHidden = true
    interventionLogo.isHidden = false
    interventionLogo.image = UIImage(named: "read-only")
    cropsView.validateButton.setTitle("ok".localized.uppercased(), for: .normal)
    interventionType = currentIntervention?.type
    loadWorkingPeriod()
    loadInputs()
    loadIrrigationInReadOnlyMode()
    loadEquipments()
    loadPersons()
    weather = currentIntervention?.weather
    loadWeatherInReadOnlyMode()
    disableUserInteraction()
  }

  func loadInterventionInEditableMode() {
    interventionLogo.isHidden = false
    interventionLogo.image = UIImage(named: "edit")
    if currentIntervention.infos == "" {
      notesTextField.placeholder = "Notes"
    } else {
      notesTextField.text = currentIntervention.infos
    }
    interventionType = currentIntervention?.type
    loadWorkingPeriod()
    weather = currentIntervention?.weather
    loadInputs()
    loadEquipments()
    loadPersons()
    loadWeatherInEditableMode()
  }

  func loadInterventionInAppropriateMode() {
    if interventionState == Intervention.State.Validated.rawValue {
      loadInterventionInReadOnlyMode()
    } else if interventionState == Intervention.State.Created.rawValue {
      loadInterventionInEditableMode()
    }
  }
}
