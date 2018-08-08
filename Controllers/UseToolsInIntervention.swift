//
//  UseToolsInIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {

  @IBAction func selectTools(_ sender: Any) {
    dimView.isHidden = false
    selectToolsView.isHidden = false
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
    })
  }

  @IBAction func createTools(_ sender: Any) {
    darkLayerView.isHidden = false
    createToolsView.isHidden = false
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
    })
  }

  @IBAction func cancelToolCreation(_ sender: Any) {
    toolName.text = nil
    toolNumber.text = nil
    darkLayerView.isHidden = true
    createToolsView.isHidden = true
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
    })
  }
}
