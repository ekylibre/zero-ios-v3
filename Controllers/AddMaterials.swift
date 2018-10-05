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
    materialsView.addInterventionViewController = self
    setupExitAction()
  }

  func selectMaterial(_ material: Materials) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let selectedMaterial = InterventionMaterials(context: managedContext)

    selectedMaterial.unit = material.unit
    selectedMaterial.materials = material
    selectedMaterials.append(selectedMaterial)
    closeView()
    updateTableView()
  }

  func setupExitAction() {
    materialsView.exitButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
  }

  @objc private func closeView() {
    materialsView.isHidden = true
    dimView.isHidden = true
  }

  private func updateTableView() {

  }

  @objc private func showUnits() {
    self.performSegue(withIdentifier: "showMaterialUnits", sender: self)
  }
}
