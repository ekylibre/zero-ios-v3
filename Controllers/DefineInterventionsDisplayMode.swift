//
//  DefineInterventionsDisplayMode.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController {

  func disableUserInteraction() {
    if interventionState == InterventionState.Validated.rawValue {
      cropsView.tableView.isUserInteractionEnabled = false
      selectedInputsTableView.isUserInteractionEnabled = false
      selectedEquipmentsTableView.isUserInteractionEnabled = false
      selectedPersonsTableView.isUserInteractionEnabled = false
      temperatureTextField.isUserInteractionEnabled = false
      windSpeedTextField.isUserInteractionEnabled = false
      notesTextField.isUserInteractionEnabled = false
      for weatherButton in weatherButtons {
        weatherButton.isUserInteractionEnabled = false
      }
    }
  }

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
      workingPeriodDateButton.setTitle(selectedDate, for: .normal)
      workingPeriodDurationTextField.text = (duration as NSNumber?)?.stringValue
      selectDateView.datePicker.date = date!
    }
    if interventionState == InterventionState.Validated.rawValue {
      workingPeriodExpandImageView.isHidden = true
      //workingPeriodGestureRecognizer.isEnabled = false
    }
  }

  func loadIrrigation() {
    if interventionType == InterventionType.Irrigation.rawValue {
      //irrigationValueTextField.text = String(currentIntervention.waterQuantity)
      irrigationUnitButton.setTitle(currentIntervention.waterUnit, for: .normal)
      updateIrrigation(self)
      if interventionState == InterventionState.Validated.rawValue {
        //irrigationExpandCollapseImage.isHidden = true
        //irrigationGestureRecognizer.isEnabled = false
      }
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
    for interventionPerson in currentIntervention.interventionPersons?.allObjects as! [InterventionPersons] {
      selectedPersons[1].append(interventionPerson)
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
    loadIrrigation()
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
    loadIrrigation()
    loadEquipments()
    loadPersons()
    loadWeatherInEditableMode()
  }

  func loadInterventionInAppropriateMode() {
    if interventionState == InterventionState.Validated.rawValue {
      loadInterventionInReadOnlyMode()
    } else if interventionState == InterventionState.Created.rawValue {
      loadInterventionInEditableMode()
    }
  }
}
