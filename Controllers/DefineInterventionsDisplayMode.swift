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
      negativeTemperature.isUserInteractionEnabled = false
      notesTextField.isUserInteractionEnabled = false
      for weatherButton in weatherButtons {
        weatherButton.isUserInteractionEnabled = false
      }
    }
  }

  private func loadWorkingPeriod() {
    let dateFormatter = DateFormatter()
    let selectedDate: String
    let workingPeriods = (currentIntervention.workingPeriods?.allObjects.first as? WorkingPeriod)
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
      irrigationVolumeTextField.text = String(currentIntervention.waterQuantity)
      irrigationUnitButton.setTitle(currentIntervention.waterUnit?.localized, for: .normal)
      updateIrrigation(self)
      if interventionState == InterventionState.Validated.rawValue {
        irrigationExpandImageView.isHidden = true
      }
      tapIrrigationView(self)
    }
  }

  private func loadInputs() {
    let interventionSeeds = currentIntervention.interventionSeeds
    let interventionPhytosanitaries = currentIntervention.interventionPhytosanitaries
    let interventionFertilizers = currentIntervention.interventionFertilizers

    for case let interventionSeed as InterventionSeed in interventionSeeds! {
      let seed = interventionSeed.seed
      let quantity = interventionSeed.quantity
      let unit = interventionSeed.unit

      removeObjectFromCoreData(interventionSeed)
      if seed != nil {
        selectInput(seed!, quantity, unit)
      }
    }
    for case let interventionPhyto as InterventionPhytosanitary in interventionPhytosanitaries! {
      let phyto = interventionPhyto.phyto
      let quantity = interventionPhyto.quantity
      let unit = interventionPhyto.unit

      removeObjectFromCoreData(interventionPhyto)
      if phyto != nil {
        selectInput(phyto!, quantity, unit)
      }
    }
    for case let interventionFertilizer as InterventionFertilizer in interventionFertilizers! {
      let fertilizer = interventionFertilizer.fertilizer
      let quantity = interventionFertilizer.quantity
      let unit = interventionFertilizer.unit

      removeObjectFromCoreData(interventionFertilizer)
      if fertilizer != nil {
        selectInput(fertilizer!, quantity, unit)
      }
    }
    refreshSelectedInputs()
  }

  private func loadMaterials() {
    let interventionMaterials = currentIntervention.interventionMaterials

    for case let interventionMaterial as InterventionMaterial in interventionMaterials! {
      let material = interventionMaterial.material
      let quantity = interventionMaterial.quantity
      let unit = interventionMaterial.unit

      removeObjectFromCoreData(interventionMaterial)
      if material != nil {
        selectMaterial(material!, quantity: quantity, unit: unit!)
      }
    }
    refreshSelectedMaterials()
  }

  private func loadHarvest() {
    let interventionHarvests = currentIntervention.harvests

    for case let harvest as Harvest in interventionHarvests! {
      let storage = harvest.storage
      let type = harvest.type
      let number = harvest.number
      let unit = harvest.unit
      let quantity = harvest.quantity

      removeObjectFromCoreData(harvest)
      createHarvest(storage, type, number, unit, quantity)
    }
    addALoad.isHidden = (interventionState == InterventionState.Validated.rawValue)
    if selectedHarvests.count > 0 {
      harvestType.setTitle(selectedHarvests.first?.type, for: .normal)
      refreshHarvestView()
    }
  }

  private func loadEquipments() {
    let interventionEquipments = currentIntervention.interventionEquipments

    for case let interventionEquipment as InterventionEquipment in interventionEquipments! {
      let equipment = interventionEquipment.equipment

      removeObjectFromCoreData(interventionEquipment)
      if equipment != nil {
        selectEquipment(equipment!)
      }
    }
    refreshSelectedEquipments()
  }

  private func loadPersons() {
    let interventionPersons = currentIntervention.interventionPersons

    for case let interventionPerson as InterventionPerson in interventionPersons! {
      let person = interventionPerson.person
      let isDriver = interventionPerson.isDriver

      removeObjectFromCoreData(interventionPerson)
      if person != nil {
        selectPerson(person!, isDriver)
      }
    }
    refreshSelectedPersons()
  }

  private func changeNegativeTemperatureButton() {
    let temperature = weather.temperature

    if temperature != nil {
      negativeTemperature.setTitle((Int(truncating: temperature!) > 0 ? "+" : "-"), for: .normal)
    } else {
      negativeTemperature.setTitle("+", for: .selected)
    }
    interventionState == InterventionState.Validated.rawValue ?
      negativeTemperature.setTitleColor(.lightGray, for: .normal) : nil
  }

  private func loadInterventionInReadOnlyMode() {
    dimView.isHidden = true
    cropsView.isHidden = true
    warningView.isHidden = false
    warningMessage.text = "you_are_in_consult_mode".localized
    notesTextField.placeholder = (currentIntervention.infos == "" ? "Notes" : currentIntervention.infos)
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
    changeNegativeTemperatureButton()
    loadWeatherInReadOnlyMode()
    disableUserInteraction()
  }

  private func loadInterventionInEditableMode() {
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
    changeNegativeTemperatureButton()
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
