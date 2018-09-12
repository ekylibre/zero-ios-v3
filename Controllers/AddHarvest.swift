//
//  AddHarvest.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 12/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {
  func initializeHarvestTableView() {
    harvestTableView.layer.borderWidth  = 0.5
    harvestTableView.layer.borderColor = UIColor.lightGray.cgColor
    harvestTableView.layer.cornerRadius = 4
    harvestTableView.dataSource = self
    harvestTableView.delegate = self
    harvestTableView.bounces = false
  }
}
