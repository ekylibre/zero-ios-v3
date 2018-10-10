//
//  AddMaterials.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 01/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {

  // MARK: - Initialization

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

    materialsTapGesture.delegate = self
    selectedMaterialsTableView.layer.borderWidth  = 0.5
    selectedMaterialsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedMaterialsTableView.layer.cornerRadius = 5
    selectedMaterialsTableView.bounces = false
    selectedMaterialsTableView.register(SelectedMaterialCell.self, forCellReuseIdentifier: "SelectedMaterialCell")
    selectedMaterialsTableView.dataSource = self
    selectedMaterialsTableView.delegate = self
    materialsView.exitButton.addTarget(self, action: #selector(closeSelectionView), for: .touchUpInside)
    materialsView.creationView.unitButton.addTarget(self, action: #selector(showUnits), for: .touchUpInside)
    materialsView.addInterventionViewController = self
  }

  // MARK: - Selection

  func selectMaterial(_ material: Materials) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionMaterial = InterventionMaterials(context: managedContext)

    interventionMaterial.unit = material.unit
    selectedMaterials[0].append(material)
    selectedMaterials[1].append(interventionMaterial)
    closeSelectionView()
    updateView()
  }

  private func updateView() {
    let shouldExpand = selectedMaterials[0].count > 0
    let tableViewHeight = (selectedMaterials[0].count > 4) ? 4 * 80 : selectedMaterials[0].count * 80

    materialsExpandImage.isHidden = !shouldExpand
    materialsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    materialsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
    selectedMaterialsTableView.reloadData()
  }


  // MARK: - Actions

  @IBAction private func tapMaterialsView() {
    let shouldExpand = (materialsHeightConstraint.constant == 70)
    let tableViewHeight = (selectedMaterials[0].count > 4) ? 4 * 80 : selectedMaterials[0].count * 80

    if selectedMaterials[0].count == 0 {
      return
    }

    updateCountLabel()
    materialsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    materialsAddButton.isHidden = !shouldExpand
    materialsCountLabel.isHidden = shouldExpand
    materialsExpandImage.transform = materialsExpandImage.transform.rotated(by: CGFloat.pi)
  }

  private func updateCountLabel() {
    if selectedMaterials.count == 1 {
      materialsCountLabel.text = "material".localized
    } else {
      materialsCountLabel.text = String(format: "materials".localized, selectedMaterials.count)
    }
  }

  @objc private func closeSelectionView() {
    materialsView.isHidden = true
    dimView.isHidden = true
  }

  @objc func updateMaterialQuantity(sender: UITextField) {
    let cell = sender.superview?.superview as! SelectedMaterialCell
    let indexPath = selectedMaterialsTableView.indexPath(for: cell)

    selectedMaterials[1][indexPath!.row].setValue(sender.text?.floatValue, forKey: "quantity")
  }

  @objc private func showUnits() {
    self.performSegue(withIdentifier: "showMaterialUnits", sender: self)
  }

  @objc func tapDeleteButton(sender: UIButton) {
    let cell = sender.superview?.superview as! SelectedMaterialCell
    let indexPath = selectedMaterialsTableView.indexPath(for: cell)!
    let alert = UIAlertController(title: nil, message: "delete_material_prompt".localized, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { action in
      self.deleteMaterial(indexPath.row)
    }))
    self.present(alert, animated: true)
  }

  private func deleteMaterial(_ index: Int)  {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionMaterial = selectedMaterials[1][index] as! InterventionMaterials

    do {
      managedContext.delete(interventionMaterial)
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }

    selectedMaterials[0].remove(at: index)
    selectedMaterials[1].remove(at: index)
    updateView()
    materialsView.tableView.reloadData()
  }
}
