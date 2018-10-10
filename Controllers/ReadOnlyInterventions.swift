//
//  ReadOnlyInterventions.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController {

  func updateWorkingPeriod() {
    let dateFormatter = DateFormatter()
    let selectedDate: String
    let workingPeriods = currentIntervention.workingPeriods?.allObjects as! [WorkingPeriods]
    let date = workingPeriods.first?.executionDate
    let duration = workingPeriods.first?.hourDuration

    dateFormatter.locale = Locale(identifier: "locale".localized)
    dateFormatter.dateFormat = "d MMM"
    selectedDate = dateFormatter.string(from: date!)
    selectedWorkingPeriodLabel.text = String(format: "%@ • %g h", selectedDate, duration!)
    collapseWorkingPeriodImage.isHidden = true
    workingPeriodGestureRecognizer.isEnabled = false
  }

  func loadSelectedTargets() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let targetsFetchRequest: NSFetchRequest<Targets> = Targets.fetchRequest()
    let predicate = NSPredicate(format: "interventions == %@", currentIntervention)

    targetsFetchRequest.predicate = predicate

    do {
      let targets = try managedContext.fetch(targetsFetchRequest)

      for target in targets {
        target.crops?.isSelected = true
        cropsView.selectedCropsCount += 1
        cropsView.selectedSurfaceArea += (target.crops?.surfaceArea)!
      }
    } catch let error as NSError {
      print("Could not fetch: \(error), \(error.userInfo)")
    }
  }

  func loadInputsInReadOnlyMode() {
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

  func loadEquipmentsInReadOnlyMode() {
    for interventionEquipment in currentIntervention?.interventionEquipments?.allObjects as! [InterventionEquipments] {
      selectedEquipments.append(interventionEquipment)
    }
    refreshSelectedEquipment()
  }

  func loadPersonsInReadOnlyMode() {
    for doer in currentIntervention.doers?.allObjects as! [Doers] {
      doers.append(doer)
    }
    refreshSelectedPersons()
  }

  func loadInterventionInReadOnlyMode() {
    if interventionState == Intervention.State.Validated.rawValue {
      warningView.isHidden = false
      warningMessage.text = "you_are_in_consult_mode".localized
      notesTextField.placeholder = (currentIntervention.infos == "" ? "Notes" : currentIntervention.infos)
      interventionLogo.isHidden = false
      bottomBarView.isHidden = true
      bottomView.isHidden = true
      interventionLogo.image = UIImage(named: "read-only")
      cropsView.validateButton.setTitle("ok".localized.uppercased(), for: .normal)
      interventionType = currentIntervention?.type
      updateWorkingPeriod()
      loadSelectedTargets()
      loadInputsInReadOnlyMode()
      loadIrrigationInReadOnlyMode()
      loadEquipmentsInReadOnlyMode()
      loadPersonsInReadOnlyMode()
      weather = currentIntervention?.weather
      refreshWeather()
      disableUserInteraction()
    }
  }
}
