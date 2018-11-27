//
//  DetailedInterventionViewController+Materials.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 01/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

extension AddInterventionViewController {

  // MARK: - Initialization

  func setupMaterialsView() {
    selectedMaterials.append([Material]())
    selectedMaterials.append([InterventionMaterial]())
    materialsSelectionView = MaterialsView(frame: CGRect.zero)
    materialsSelectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(materialsSelectionView)

    NSLayoutConstraint.activate([
      materialsSelectionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      materialsSelectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -30),
      materialsSelectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      materialsSelectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -30)
      ])

    materialsTapGesture.delegate = self
    selectedMaterialsTableView.layer.borderWidth  = 0.5
    selectedMaterialsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedMaterialsTableView.layer.cornerRadius = 5
    selectedMaterialsTableView.register(SelectedMaterialCell.self, forCellReuseIdentifier: "SelectedMaterialCell")
    selectedMaterialsTableView.bounces = false
    selectedMaterialsTableView.dataSource = self
    selectedMaterialsTableView.delegate = self
    materialsSelectionView.addInterventionViewController = self
    materialsSelectionView.creationView.unitButton.addTarget(self, action: #selector(showMaterialUnits),
                                                             for: .touchUpInside)
  }

  // MARK: - Selection

  func selectMaterial(_ material: Material, quantity: Float?, unit: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionMaterial = InterventionMaterial(context: managedContext)

    interventionMaterial.material = material
    quantity != nil ? interventionMaterial.quantity = quantity! : nil
    interventionMaterial.unit = unit
    selectedMaterials[0].append(material)
    selectedMaterials[1].append(interventionMaterial)
    materialsSelectionView.cancelButton.sendActions(for: .touchUpInside)
    updateView()
  }

  private func updateView() {
    let shouldExpand = selectedMaterials[0].count > 0
    let tableViewHeight = (selectedMaterials[0].count > 10) ? 10 * 80 : selectedMaterials[0].count * 80

    materialsExpandImageView.isHidden = !shouldExpand
    materialsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    materialsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
    selectedMaterialsTableView.reloadData()
  }

  // MARK: - Actions

  func refreshSelectedMaterials() {
    tapMaterialsView()
    if selectedMaterials[1].count > 0 {
      selectedMaterialsTableView.reloadData()
      materialsExpandImageView.isHidden = false
    }
    showEntitiesNumber(
      entities: selectedMaterials[1],
      constraint: materialsHeightConstraint,
      numberLabel: materialsCountLabel,
      addEntityButton: materialsAddButton)
  }

  @IBAction private func openMaterialsSelectionView(_ sender: Any) {
    selectedValue = "METER"
    dimView.isHidden = false
    materialsSelectionView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @IBAction func tapMaterialsView() {
    let shouldExpand = (materialsHeightConstraint.constant == 70)
    let tableViewHeight = (selectedMaterials[0].count > 10) ? 10 * 80 : selectedMaterials[0].count * 80

    if selectedMaterials[0].count == 0 {
      return
    }

    view.endEditing(true)
    updateMaterialsCountLabel()
    materialsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    if interventionState != InterventionState.Validated.rawValue {
      materialsAddButton.isHidden = !shouldExpand
    }
    materialsCountLabel.isHidden = shouldExpand
    selectedMaterialsTableView.isHidden = !shouldExpand
    materialsExpandImageView.transform = materialsExpandImageView.transform.rotated(by: CGFloat.pi)
  }

  func updateMaterialsCountLabel() {
    if selectedMaterials[0].count == 1 {
      materialsCountLabel.text = "material".localized
    } else if selectedMaterials[0].count == 0 {
      materialsCountLabel.text = "none".localized
    } else {
      materialsCountLabel.text = String(format: "materials".localized, selectedMaterials[0].count)
    }
  }

  @objc func updateMaterialQuantity(sender: UITextField) {
    let cell = sender.superview?.superview as! SelectedMaterialCell
    let indexPath = selectedMaterialsTableView.indexPath(for: cell)

    selectedMaterials[1][indexPath!.row].setValue(sender.text?.floatValue, forKey: "quantity")
  }

  @objc func showSelectedMaterialUnits(sender: UIButton) {
    let cell = sender.superview?.superview as! SelectedMaterialCell

    selectedRow = selectedMaterialsTableView.indexPath(for: cell)!.row
    performSegue(withIdentifier: "showSelectedMaterialUnits", sender: self)
  }

  @objc private func showMaterialUnits() {
    performSegue(withIdentifier: "showMaterialUnits", sender: self)
  }

  @objc func tapDeleteButton(sender: UIButton) {
    let cell = sender.superview?.superview as! SelectedMaterialCell
    let indexPath = selectedMaterialsTableView.indexPath(for: cell)!
    let alert = UIAlertController(title: "delete_material_prompt".localized, message: nil, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { action in
      self.deleteMaterial(indexPath.row)
    }))
    present(alert, animated: true)
  }

  private func deleteMaterial(_ index: Int)  {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionMaterial = selectedMaterials[1][index] as! InterventionMaterial

    do {
      managedContext.delete(interventionMaterial)
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }

    selectedMaterials[0].remove(at: index)
    selectedMaterials[1].remove(at: index)
    updateView()
    materialsSelectionView.tableView.reloadData()
  }

  func selectedMaterialsTableViewCellForRowAt(_ tableView: UITableView, _ indexPath: IndexPath)
    -> SelectedMaterialCell {
      let name = selectedMaterials[0][indexPath.row].value(forKey: "name") as? String
      let quantity = selectedMaterials[1][indexPath.row].value(forKey: "quantity") as! Float
      let unit = selectedMaterials[1][indexPath.row].value(forKey: "unit") as? String
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedMaterialCell", for: indexPath)
        as! SelectedMaterialCell

      if interventionState == InterventionState.Validated.rawValue {
        cell.quantityTextField.placeholder = String(format: "%g", quantity)
        cell.unitButton.setTitle(unit?.localized, for: .normal)
        cell.unitButton.setTitleColor(.lightGray, for: .normal)
      } else if quantity == 0 {
        cell.quantityTextField.placeholder = "0"
        cell.quantityTextField.text = ""
        cell.unitButton.setTitle(unit?.localized, for: .normal)
      } else {
        cell.quantityTextField.text = String(format: "%g", quantity)
        cell.unitButton.setTitle(unit?.localized, for: .normal)
      }
      cell.nameLabel.text = name
      cell.deleteButton.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
      cell.quantityTextField.text = (quantity == 0) ? "" : String(format: "%g", quantity)
      cell.quantityTextField.addTarget(self, action: #selector(updateMaterialQuantity), for: .editingChanged)
      cell.unitButton.setTitle(unit?.localized.lowercased(), for: .normal)
      return cell
  }
}
