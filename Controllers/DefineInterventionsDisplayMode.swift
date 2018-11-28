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

  private func disableUserInteraction() {
    if interventionState == InterventionState.Validated.rawValue {
      harvestTableView.isUserInteractionEnabled = false
      harvestType.isUserInteractionEnabled = false
      cropsView.tableView.isUserInteractionEnabled = false
      workingPeriodTapGesture.isEnabled = false
      selectedInputsTableView.isUserInteractionEnabled = false
      irrigationTapGesture.isEnabled = false
      selectedEquipmentsTableView.isUserInteractionEnabled = false
      selectedPersonsTableView.isUserInteractionEnabled = false
      temperatureTextField.isUserInteractionEnabled = false
      windSpeedTextField.isUserInteractionEnabled = false
      temperatureSign.isUserInteractionEnabled = false
      notesTextView.isUserInteractionEnabled = false
      for weatherButton in weatherButtons {
        weatherButton.isUserInteractionEnabled = false
      }
    }
  }

  private func loadWorkingPeriod() {
    let dateFormatter = DateFormatter()
    let selectedDate: String
    let workingPeriods = (currentIntervention?.workingPeriods?.allObjects.first as? WorkingPeriod)
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
    }
  }

  private func loadIrrigation() {
    if interventionType == InterventionType.Irrigation.rawValue {
      let waterQuantity = currentIntervention?.waterQuantity

      irrigationVolumeTextField.text = (waterQuantity as NSNumber?)?.stringValue
      irrigationUnitButton.setTitle(currentIntervention?.waterUnit?.localized, for: .normal)
      updateIrrigation()
      if interventionState == InterventionState.Validated.rawValue {
        irrigationExpandImageView.isHidden = true
      }
      tapIrrigationView(self)
    }
  }

  private func loadInputs() {
    let interventionSeeds = currentIntervention?.interventionSeeds
    let interventionPhytosanitaries = currentIntervention?.interventionPhytosanitaries
    let interventionFertilizers = currentIntervention?.interventionFertilizers

    for case let interventionSeed as InterventionSeed in interventionSeeds! {
      let seed = interventionSeed.seed
      let quantity = interventionSeed.quantity
      let unit = interventionSeed.unit

      if seed != nil {
        selectInput(seed!, quantity: quantity, unit: unit, calledFromCreatedIntervention: true)
      }
    }
    for case let interventionPhyto as InterventionPhytosanitary in interventionPhytosanitaries! {
      let phyto = interventionPhyto.phyto
      let quantity = interventionPhyto.quantity
      let unit = interventionPhyto.unit

      if phyto != nil {
        selectInput(phyto!, quantity: quantity, unit: unit, calledFromCreatedIntervention: true)
      }
    }
    for case let interventionFertilizer as InterventionFertilizer in interventionFertilizers! {
      let fertilizer = interventionFertilizer.fertilizer
      let quantity = interventionFertilizer.quantity
      let unit = interventionFertilizer.unit

      if fertilizer != nil {
        selectInput(fertilizer!, quantity: quantity, unit: unit, calledFromCreatedIntervention: true)
      }
    }
    refreshSelectedInputs()
  }

  private func loadMaterials() {
    if let interventionMaterials = currentIntervention?.interventionMaterials {
      for case let interventionMaterial as InterventionMaterial in interventionMaterials {
        let material = interventionMaterial.material
        let quantity = interventionMaterial.quantity
        let unit = interventionMaterial.unit

        if material != nil {
          selectMaterial(material!, quantity: quantity, unit: unit!, calledFromCreatedIntervention: true)
        }
      }
    }
    updateSelectedMaterialsView(calledFromCreatedIntervention: true)
  }

  private func loadHarvest() {
    if let interventionHarvests = currentIntervention?.harvests {
      for case let harvest as Harvest in interventionHarvests {
        let storage = harvest.storage
        let type = harvest.type
        let number = harvest.number
        let unit = harvest.unit
        let quantity = harvest.quantity

        createHarvest(storage, type, number, unit, quantity)
      }
    }
    harvestAddButton.isHidden = (interventionState == InterventionState.Validated.rawValue)
    if selectedHarvests.count > 0 {
      harvestType.setTitle(selectedHarvests.first?.type, for: .normal)
      refreshHarvestView()
    }
  }

  private func loadEquipments() {
    if let interventionEquipments = currentIntervention?.interventionEquipments {
      for case let interventionEquipment as InterventionEquipment in interventionEquipments {
        let equipment = interventionEquipment.equipment

        if equipment != nil {
          selectEquipment(equipment!, calledFromCreatedIntervention: true)
        }
      }
    }
    updateSelectedEquipmentsView(calledFromCreatedIntervention: true)
  }

  private func loadPersons() {
    let interventionPersons = currentIntervention?.interventionPersons
    for case let interventionPerson as InterventionPerson in interventionPersons! {
      let person = interventionPerson.person
      let isDriver = interventionPerson.isDriver

      if person != nil {
        selectPerson(person!, isDriver: isDriver, calledFromCreatedIntervention: true)
      }
    }
    updateSelectedPersonsView(calledFromCreatedIntervention: true)
  }

  private func changeTemperatureSignButton() {
    let temperature = weather.temperature

    if temperature != nil {
      temperatureSign.setTitle((Int(truncating: temperature!) > 0 ? "+" : "-"), for: .normal)
    } else {
      temperatureSign.setTitle("+", for: .selected)
    }
    interventionState == InterventionState.Validated.rawValue ?
      temperatureSign.setTitleColor(.lightGray, for: .normal) : nil
  }

  private func loadInterventionInReadOnlyMode() {
    dimView.isHidden = true
    cropsView.isHidden = true
    warningView.isHidden = false
    warningMessage.text = "you_are_in_consult_mode".localized
    notesTextView.text = (currentIntervention?.infos == "" ? "notes".localized : currentIntervention?.infos)
    notesTextView.textColor = .lightGray
    bottomBarView.isHidden = true
    bottomView.isHidden = true
    scrollViewBottomConstraint.isActive = false
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    interventionLogo.isHidden = false
    interventionLogo.image = UIImage(named: "read-only")
    cropsView.validateButton.setTitle("ok".localized.uppercased(), for: .normal)
    interventionType = currentIntervention?.type
    loadWorkingPeriod()
    loadInputs()
    loadMaterials()
    loadIrrigation()
    loadEquipments()
    loadPersons()
    loadHarvest()
    weather = currentIntervention?.weather
    changeTemperatureSignButton()
    loadWeatherInReadOnlyMode()
    disableUserInteraction()
  }

  private func loadInterventionInEditableMode() {
    interventionLogo.isHidden = false
    interventionLogo.image = UIImage(named: "edit")
    notesTextView.text = (currentIntervention?.infos == "" ? "notes".localized : currentIntervention?.infos)
    notesTextView.textColor = .lightGray
    interventionType = currentIntervention?.type
    loadWorkingPeriod()
    weather = currentIntervention?.weather
    changeTemperatureSignButton()
    loadInputs()
    loadMaterials()
    loadIrrigation()
    loadEquipments()
    loadPersons()
    loadHarvest()
    loadWeatherInEditableMode()
    dimView.isHidden = false
  }

  func loadInterventionInAppropriateMode() {
    if interventionState == InterventionState.Validated.rawValue {
      loadInterventionInReadOnlyMode()
    } else if interventionState == InterventionState.Created.rawValue ||
      interventionState == InterventionState.Synced.rawValue {
      loadInterventionInEditableMode()
    }
  }
}
