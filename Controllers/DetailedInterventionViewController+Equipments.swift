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
    equipmentsSelectionView = EquipmentsView(firstType: getFirstEquipmentType(),frame: CGRect.zero)
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
    selectedEquipmentsTableView.bounces = false
    selectedEquipmentsTableView.register(SelectedEquipmentCell.self, forCellReuseIdentifier: "SelectedEquipmentCell")
    selectedEquipmentsTableView.dataSource = self
    selectedEquipmentsTableView.delegate = self
    equipmentsSelectionView.exitButton.addTarget(self, action: #selector(closeEquipmentsSelectionView), for: .touchUpInside)
    equipmentsSelectionView.creationView.typeButton.addTarget(self, action: #selector(showEquipmentTypes), for: .touchUpInside)
    equipmentsSelectionView.addInterventionViewController = self
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

  func selectEquipment(_ equipment: Equipment) {
    selectedEquipments.append(equipment)
    closeEquipmentsSelectionView()
    updateView()
  }

  private func updateView() {
    let shouldExpand = selectedEquipments.count > 0
    let tableViewHeight = (selectedEquipments.count > 10) ? 10 * 55 : selectedEquipments.count * 55

    equipmentsExpandImageView.isHidden = !shouldExpand
    equipmentsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    equipmentsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
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

    updateCountLabel()
    equipmentsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    equipmentsAddButton.isHidden = !shouldExpand
    equipmentsCountLabel.isHidden = shouldExpand
    equipmentsExpandImageView.transform = equipmentsExpandImageView.transform.rotated(by: CGFloat.pi)
  }

  private func updateCountLabel() {
    if selectedEquipments.count == 1 {
      equipmentsCountLabel.text = "equipment".localized
    } else {
      equipmentsCountLabel.text = String(format: "equipments".localized, selectedEquipments.count)
    }
  }

  @objc private func closeEquipmentsSelectionView() {
    equipmentsSelectionView.isHidden = true
    dimView.isHidden = true

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })

    equipmentsSelectionView.searchBar.text = nil
    equipmentsSelectionView.searchBar.endEditing(true)
    equipmentsSelectionView.isSearching = false
    equipmentsSelectionView.tableView.reloadData()
  }

  @objc private func showEquipmentTypes() {
    self.performSegue(withIdentifier: "showEquipmentTypes", sender: self)
  }

  @objc func tapEquipmentsDeleteButton(sender: UIButton) {
    let cell = sender.superview?.superview as! SelectedEquipmentCell
    let indexPath = selectedEquipmentsTableView.indexPath(for: cell)!
    let alert = UIAlertController(title: nil, message: "delete_equipment_prompt".localized, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { action in
      self.deleteEquipment(indexPath.row)
    }))
    present(alert, animated: true)
  }

  private func deleteEquipment(_ index: Int)  {
    selectedEquipments.remove(at: index)
    updateView()
    equipmentsSelectionView.tableView.reloadData()
  }
}
