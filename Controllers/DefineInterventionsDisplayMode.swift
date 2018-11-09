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

  func loadWorkingPeriod() {
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

  func loadIrrigation() {
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

  func loadInputsFromIntervention(_ entityName: String, _ intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let inputsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let predicate = NSPredicate(format: "intervention == %@", intervention)

    inputsFetchRequest.predicate = predicate
    do {
      let inputs = try managedContext.fetch(inputsFetchRequest)
      managedContext.performAndWait {
        for input in inputs as! [NSManagedObject] {
          selectedInputs.append(input)
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  func loadInputs() {
    loadInputsFromIntervention("InterventionSeed", currentIntervention)
    loadInputsFromIntervention("InterventionPhytosanitary", currentIntervention)
    loadInputsFromIntervention("InterventionFertilizer", currentIntervention)
    refreshSelectedInputs()
  }

  func loadMaterials() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionMaterialsFetchRequest: NSFetchRequest<InterventionMaterial> = InterventionMaterial.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", currentIntervention)

    interventionMaterialsFetchRequest.predicate = predicate

    do {
      let interventionMaterials = try managedContext.fetch(interventionMaterialsFetchRequest)

      for interventionMaterial in interventionMaterials {
        if interventionMaterial.material != nil {
          selectMaterial(interventionMaterial.material!)
        }
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    refreshSelectedMaterials()
  }

  func loadHarvest() {
    for harvest in currentIntervention.harvests?.allObjects as! [Harvest] {
      harvests.append(harvest)
    }
    addALoad.isHidden = (interventionState == InterventionState.Validated.rawValue)
    if harvests.count > 0 {
      harvestType.setTitle(harvests.first?.type, for: .normal)
      refreshHarvestView()
    }
  }

  func loadEquipments() {
    for interventionEquipment in currentIntervention?.interventionEquipments?.allObjects as! [InterventionEquipment] {
      if interventionEquipment.equipment != nil {
        selectEquipment(interventionEquipment.equipment!)
      }
    }
    refreshSelectedEquipments()
  }

  func loadPersons() {
    for interventionPerson in currentIntervention.interventionPersons?.allObjects as! [InterventionPerson] {
      if interventionPerson.person != nil {
        selectPerson(interventionPerson.person!, interventionPerson.isDriver)
      }
    }
    refreshSelectedPersons()
  }

  func changeNegativeTemperatureButton() {
    let temperature = weather.temperature

    if temperature != nil {
      negativeTemperature.setTitle((Int(truncating: temperature!) > 0 ? "+" : "-"), for: .normal)
    } else {
      negativeTemperature.setTitle("+", for: .selected)
    }
    interventionState == InterventionState.Validated.rawValue ? negativeTemperature.setTitleColor(.lightGray, for: .normal) : nil
  }

  func loadInterventionInReadOnlyMode() {
    dimView.isHidden = true
    cropsView.isHidden = true
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
    changeNegativeTemperatureButton()
    loadInputs()
    loadMaterials()
    loadIrrigation()
    loadEquipments()
    loadPersons()
    loadWeatherInEditableMode()
    dimView.isHidden = false
  }

  func loadInterventionInAppropriateMode() {
    if interventionState == InterventionState.Validated.rawValue {
      loadInterventionInReadOnlyMode()
    } else if interventionState == InterventionState.Created.rawValue || interventionState == InterventionState.Synced.rawValue {
      loadInterventionInEditableMode()
    }
  }
}