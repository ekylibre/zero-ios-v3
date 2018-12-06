//
//  DetailedInterventionViewController+Equipments.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController {

  // MARK: - Initialization

  func setupEquipmentsView() {
    equipmentTypes = loadEquipmentTypes()
    equipmentsSelectionView = EquipmentsView(firstType: getFirstEquipmentType(), frame: CGRect.zero)
    equipmentsSelectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(equipmentsSelectionView)

    NSLayoutConstraint.activate([
      equipmentsSelectionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      equipmentsSelectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -30),
      equipmentsSelectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      equipmentsSelectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -30)
      ])

    equipmentsTapGesture.delegate = self
    selectedEquipmentsTableView.layer.borderWidth  = 0.5
    selectedEquipmentsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedEquipmentsTableView.layer.cornerRadius = 5
    selectedEquipmentsTableView.register(SelectedEquipmentCell.self, forCellReuseIdentifier: "SelectedEquipmentCell")
    selectedEquipmentsTableView.bounces = false
    selectedEquipmentsTableView.dataSource = self
    selectedEquipmentsTableView.delegate = self
    equipmentsSelectionView.addInterventionViewController = self
    equipmentsSelectionView.creationView.typeButton.addTarget(self, action: #selector(showEquipmentTypes),
                                                              for: .touchUpInside)
  }

  private func loadEquipmentTypes() -> [String] {
    var equipmentTypes = [String]()

    if let asset = NSDataAsset(name: "equipment-types") {
      do {
        let jsonResult = try JSONSerialization.jsonObject(with: asset.data)
        let registeredEquipments = jsonResult as? [[String: Any]]

        for registeredEquipment in registeredEquipments! {
          let type = registeredEquipment["nature"] as! String
          equipmentTypes.append(type.uppercased())
        }
      } catch {
        print("Lexicon error")
      }
    } else {
      print("equipment-types.json not found")
    }
    return equipmentTypes
  }

  private func getFirstEquipmentType() -> String {
    let sortedEquipmentTypes = equipmentTypes.sorted(by: {
      $0.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        <
        $1.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
    })

    return sortedEquipmentTypes.first!
  }

  // MARK: - Selection

  func selectEquipment(_ equipment: Equipment, calledFromCreatedIntervention: Bool) {
    selectedEquipments.append(equipment)
    equipmentsSelectionView.cancelButton.sendActions(for: .touchUpInside)
    updateSelectedEquipmentsView(calledFromCreatedIntervention: calledFromCreatedIntervention)
  }

  private func checkButtonDisplayStatus(shouldExpand: Bool) {
    if interventionState == InterventionState.Validated.rawValue {
      equipmentsAddButton.isHidden = true
      equipmentsCountLabel.isHidden = false
    } else if interventionState != nil {
      equipmentsCountLabel.isHidden = !shouldExpand
      equipmentsAddButton.isHidden = !equipmentsCountLabel.isHidden
    }
  }

  func updateSelectedEquipmentsView(calledFromCreatedIntervention: Bool) {
    let isCollapsed = equipmentsHeightConstraint.constant == 70
    let shouldExpand = selectedEquipments.count > 0
    let tableViewHeight = (selectedEquipments.count > 10) ? 10 * 55 : selectedEquipments.count * 55

    if !calledFromCreatedIntervention {
      isCollapsed ? equipmentsExpandImageView.transform =
        equipmentsExpandImageView.transform.rotated(by: CGFloat.pi) : nil
      equipmentsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
      equipmentsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
    }
    equipmentsExpandImageView.isHidden = !shouldExpand
    checkButtonDisplayStatus(shouldExpand: shouldExpand)
    updateEquipmentsCountLabel()
    selectedEquipmentsTableView.reloadData()
  }

  // MARK: - Actions

  @IBAction private func openEquipmentsSelectionView(_ sender: Any) {
    selectedValue = getFirstEquipmentType()
    dimView.isHidden = false
    equipmentsSelectionView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @IBAction private func tapEquipmentsView() {
    let shouldExpand = (equipmentsHeightConstraint.constant == 70)
    let tableViewHeight = (selectedEquipments.count > 10) ? 10 * 55 : selectedEquipments.count * 55

    if selectedEquipments.count == 0 {
      return
    }

    view.endEditing(true)
    updateEquipmentsCountLabel()
    equipmentsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
    equipmentsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    if interventionState != InterventionState.Validated.rawValue {
      equipmentsAddButton.isHidden = !shouldExpand
    }
    equipmentsCountLabel.isHidden = shouldExpand
    selectedEquipmentsTableView.isHidden = !shouldExpand
    equipmentsExpandImageView.transform = equipmentsExpandImageView.transform.rotated(by: CGFloat.pi)
    selectedEquipmentsTableView.reloadData()
  }

  func updateEquipmentsCountLabel() {
    if selectedEquipments.count == 1 {
      equipmentsCountLabel.text = "equipment".localized
    } else if selectedEquipments.count == 0 {
      equipmentsCountLabel.text = "none".localized
    } else {
      equipmentsCountLabel.text = String(format: "equipments".localized, selectedEquipments.count)
    }
  }

  @objc private func showEquipmentTypes() {
    performSegue(withIdentifier: "showEquipmentTypes", sender: self)
  }

  @objc private func tapEquipmentsDeleteButton(sender: UIButton) {
    let cell = sender.superview?.superview as! SelectedEquipmentCell
    let indexPath = selectedEquipmentsTableView.indexPath(for: cell)!
    let alert = UIAlertController(title: "delete_equipment_prompt".localized, message: nil, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { action in
      self.deleteEquipment(indexPath.row)
    }))
    present(alert, animated: true)
  }

  private func deleteEquipment(_ index: Int)  {
    selectedEquipments.remove(at: index)
    updateSelectedEquipmentsView(calledFromCreatedIntervention: false)
    equipmentsSelectionView.tableView.reloadData()
  }

  private func getSelectedEquipmentInfos(_ equipment: Equipment) -> String {
    let type = equipment.type!.localized
    guard let number = equipment.number else {
      return type
    }

    return String(format: "%@ #%@", type, number)
  }

  func selectedEquipmentsTableViewCellForRowAt(_ tableView: UITableView, _ indexPath: IndexPath)
    -> SelectedEquipmentCell {
      let selectedEquipment = selectedEquipments[indexPath.row]
      let imageName = selectedEquipment.type!.lowercased().replacingOccurrences(of: "_", with: "-")
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedEquipmentCell", for: indexPath)
        as! SelectedEquipmentCell


      cell.typeImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
      cell.nameLabel.text = selectedEquipment.name
      cell.deleteButton.addTarget(self, action: #selector(tapEquipmentsDeleteButton), for: .touchUpInside)
      cell.infosLabel.text = getSelectedEquipmentInfos(selectedEquipment)
      return cell
  }
}
