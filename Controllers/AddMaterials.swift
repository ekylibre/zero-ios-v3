//
//  AddMaterials.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 01/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {

  func setupMaterialsView() {
    materialsView = MaterialsView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    materialsView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(materialsView)

    NSLayoutConstraint.activate([
      materialsView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      materialsView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -30),
      materialsView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      materialsView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -30)
      ])

    materialsView.creationView.unitButton.addTarget(self, action: #selector(showUnits), for: .touchUpInside)
  }

  @objc private func showUnits() {
    self.performSegue(withIdentifier: "showMaterialUnitList", sender: self)
  }
}
