//
//  UpdateIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {
  func loadInterventionData() {
    if interventionState == Intervention.State.Created.rawValue {
      interventionType = currentIntervention?.type
      weather = currentIntervention?.weather
      for interventionEquipment in currentIntervention?.interventionEquipments?.allObjects as! [InterventionEquipments] {
        selectedEquipments.append(interventionEquipment)
      }
      for doer in currentIntervention.doers?.allObjects as! [Doers] {
        doers.append(doer)
      }
      for target in currentIntervention?.targets?.allObjects as! [Targets] {
        cropsView.selectedCrops.append(target.crops!)
      }
      for interventionSeed in currentIntervention?.interventionSeeds?.allObjects as! [InterventionSeeds] {
        selectedInputs.append(interventionSeed)
      }
      for interventionPhyto in currentIntervention?.interventionPhytosanitaries?.allObjects as! [InterventionPhytosanitaries] {
        selectedInputs.append(interventionPhyto)
      }
      for interventionFertilizer in currentIntervention.interventionFertilizers?.allObjects as! [InterventionFertilizers] {
        selectedInputs.append(interventionFertilizer)
      }
    }
  }
}
