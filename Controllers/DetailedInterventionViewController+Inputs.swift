//
//  DetailedInterventionViewController+Inputs.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 23/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: SelectedInputCellDelegate {

  // MARK: - Initialization

  func setupInputsView() {
    species = loadSpecies()
    inputsSelectionView = InputsView(firstSpecie: getFirstSpecie(), frame: CGRect.zero)
    inputsSelectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(inputsSelectionView)

    NSLayoutConstraint.activate([
      inputsSelectionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      inputsSelectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -30),
      inputsSelectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      inputsSelectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -30)
      ])

    inputsUnauthorizedMixImage.tintColor = .red

    inputsTapGesture.delegate = self
    selectedInputsTableView.layer.borderWidth  = 0.5
    selectedInputsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedInputsTableView.layer.cornerRadius = 5
    selectedInputsTableView.register(SelectedInputCell.self, forCellReuseIdentifier: "SelectedInputCell")
    selectedInputsTableView.bounces = false
    selectedInputsTableView.delegate = self
    selectedInputsTableView.dataSource = self
    inputsSelectionView.addInterventionViewController = self
    inputsSelectionView.seedView.specieButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
    inputsSelectionView.fertilizerView.natureButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    inputsSelectionView.seedView.unitButton.addTarget(
      self, action: #selector(showInputsCreationUnits), for: .touchUpInside)
    inputsSelectionView.phytoView.unitButton.addTarget(
      self, action: #selector(showInputsCreationUnits), for: .touchUpInside)
    inputsSelectionView.fertilizerView.unitButton.addTarget(
      self, action: #selector(showInputsCreationUnits), for: .touchUpInside)
  }

  private func loadSpecies() -> [String] {
    var species = [String]()

    if let asset = NSDataAsset(name: "production-natures") {
      do {
        let jsonResult = try JSONSerialization.jsonObject(with: asset.data)
        let productionNatures = jsonResult as? [[String: Any]]

        for productionNature in productionNatures! {
          let specie = productionNature["specie"] as! String
          if !species.contains(specie.uppercased()) &&
            SpecieEnum(rawValue: specie.uppercased()) != SpecieEnum.__unknown(specie.uppercased()) {
            species.append(specie.uppercased())
          }
        }
      } catch let error as NSError {
        print("Lexicon fetch failed. \(error)")
      }
    } else {
      print("production_natures.json not found")
    }
    return species.sorted()
  }

  private func getFirstSpecie() -> String {
    let sortedSpecies = species.sorted(by: {
      $0.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        <
        $1.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
    })

    return sortedSpecies.first!
  }

  // MARK: - Actions

  @objc private func showList() {
    performSegue(withIdentifier: "showSpecies", sender: self)
  }

  @objc private func showAlert() {
    present(inputsSelectionView.fertilizerView.natureAlertController, animated: true, completion: nil)
  }

  private func checkButtonDisplayStatus(shouldExpand: Bool) {
    if interventionState == InterventionState.Validated.rawValue {
      inputsAddButton.isHidden = true
      inputsCountLabel.isHidden = false
    } else if interventionState != nil {
      inputsCountLabel.isHidden = !shouldExpand
      inputsAddButton.isHidden = !inputsCountLabel.isHidden
    }
  }

  func refreshSelectedInputs() {
    let shouldExpand = selectedInputs.count > 0

    checkButtonDisplayStatus(shouldExpand: shouldExpand)
    inputsExpandImageView.isHidden = !shouldExpand
    updateInputsCountLabel()
    selectedInputsTableView.reloadData()
  }

  func saveSelectedRow(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
  }

  @IBAction private func openInputsSelectionView(_ sender: Any) {
    dimView.isHidden = false
    inputsSelectionView.isHidden = false
    inputsSelectionView.tableView.reloadData()
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @IBAction func tapInputsView() {
    let shouldExpand = (inputsHeightConstraint.constant == 70)
    let tableViewHeight = (selectedInputs.count > 10) ? 10 * 110 : selectedInputs.count * 110

    if selectedInputs.count == 0 {
      return
    }

    if interventionState != InterventionState.Validated.rawValue {
      inputsAddButton.isHidden = !shouldExpand
    }
    view.endEditing(true)
    updateInputsCountLabel()
    inputsCountLabel.isHidden = shouldExpand
    inputsExpandImageView.isHidden = (selectedInputs.count == 0)
    inputsExpandImageView.transform = inputsExpandImageView.transform.rotated(by: CGFloat.pi)
    inputsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
    inputsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 100) : 70
    selectedInputsTableView.isHidden = !shouldExpand
    inputsUnauthorizedMixLabel.isHidden = !shouldExpand
    inputsUnauthorizedMixImage.isHidden = !shouldExpand
    shouldExpand ? checkAllMixCategoryCode() : nil
  }

  func updateInputsCountLabel() {
    if selectedInputs.count == 1 {
      inputsCountLabel.text = "input".localized
    } else if selectedInputs.count == 0 {
      inputsCountLabel.text = "none".localized
    } else {
      inputsCountLabel.text = String(format: "inputs".localized, selectedInputs.count)
    }
  }

  @objc private func showInputsCreationUnits() {
    let units = ["METER", "UNITY", "THOUSAND", "LITER", "HECTOLITER",
                 "CUBIC_METER", "GRAM", "KILOGRAM", "QUINTAL", "TON"]

    customPickerView.values = units
    customPickerView.pickerView.reloadComponent(0)
    customPickerView.closure = { (value) in
      self.defineInputsUnitButtonTitle(value: value)
    }
    customPickerView.isHidden = false
  }

  private func closeInputsSelectionView() {
    let isCollapsed = inputsHeightConstraint.constant == 70
    dimView.isHidden = true
    inputsSelectionView.isHidden = true

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })

    if selectedInputs.count > 0 {
      inputsExpandImageView.isHidden = false
      selectedInputsTableView.isHidden = false
      inputsTableViewHeightConstraint.constant = selectedInputsTableView.contentSize.height
      inputsHeightConstraint.constant = inputsTableViewHeightConstraint.constant + 100
      isCollapsed ? inputsExpandImageView.transform = inputsExpandImageView.transform.rotated(by: CGFloat.pi) : nil
      view.layoutIfNeeded()
    }
    selectedInputsTableView.reloadData()
  }

  private func checkAllMixCategoryCode() {
    var selectedPhytos = [InterventionPhytosanitary]()
    var firstMixCategoryCode: String?
    var unauthorized = false

    for case let selectedInput as InterventionPhytosanitary in selectedInputs {
      if selectedInput.phyto?.mixCategoryCode != nil {
        firstMixCategoryCode == nil ? firstMixCategoryCode = selectedInput.phyto?.mixCategoryCode : nil
        if firstMixCategoryCode != nil {
          if !checkMixCategoryCode(selectedInput.phyto!.mixCategoryCode!, firstMixCategoryCode!) {
            unauthorized = true
            break
          }
        }
      }
    }

    for case let selectedPhyto as InterventionPhytosanitary in selectedInputs {
      selectedPhytos.append(selectedPhyto)
    }
    if selectedPhytos.count > 1 && unauthorized {
      inputsUnauthorizedMixImage.isHidden = false
      inputsUnauthorizedMixLabel.isHidden = false
    } else {
      inputsUnauthorizedMixImage.isHidden = true
      inputsUnauthorizedMixLabel.isHidden = true
    }
  }

  func checkMixCategoryCode(_ firstMixCode: String, _ secondMixCode: String) -> Bool {
    let autorizedMix = ["1":"1234", "2":"134", "3":"14", "4":"14", "5":""]

    return autorizedMix[firstMixCode]!.contains(secondMixCode)
  }

  func selectInput(_ input: NSManagedObject, quantity: Float?, unit: String?,
                   calledFromCreatedIntervention: Bool) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    switch input {
    case let seed as Seed:
      let selectedSeed = InterventionSeed(context: managedContext)
      selectedSeed.unit = (unit != nil ? unit : seed.unit)
      selectedSeed.seed = seed
      quantity != nil ? selectedSeed.quantity = quantity! : nil
      selectedInputs.append(selectedSeed)
    case let phyto as Phyto:
      let selectedPhyto = InterventionPhytosanitary(context: managedContext)
      selectedPhyto.unit = (unit != nil ? unit : phyto.unit)
      selectedPhyto.phyto = phyto
      quantity != nil ? selectedPhyto.quantity = quantity! : nil
      selectedInputs.append(selectedPhyto)
      checkAllMixCategoryCode()
    case let fertilizer as Fertilizer:
      let selectedFertilizer = InterventionFertilizer(context: managedContext)
      selectedFertilizer.unit = (unit != nil ? unit : fertilizer.unit)
      selectedFertilizer.fertilizer = fertilizer
      quantity != nil ? selectedFertilizer.quantity = quantity! : nil
      selectedInputs.append(selectedFertilizer)
    default:
      fatalError("Input type not found")
    }

    selectedInputsTableView.reloadData()
    !calledFromCreatedIntervention ? closeInputsSelectionView() : nil
  }

  private func resetInputsUsedAttribute(index: Int) {
    switch selectedInputs[index] {
    case is InterventionSeed:
      (selectedInputs[index] as! InterventionSeed).seed?.used = false
    case is InterventionPhytosanitary:
      (selectedInputs[index] as! InterventionPhytosanitary).phyto?.used = false
    case is InterventionFertilizer:
      (selectedInputs[index] as! InterventionFertilizer).fertilizer?.used = false
    default:
      return
    }
  }

  private func deleteSelectedInput(_ indexPath: IndexPath) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    do {
      let input = selectedInputs[indexPath.row]
      managedContext.delete(input)
      try managedContext.save()
    } catch let error as NSError {
      print("Could not delete: \(error), \(error.userInfo)")
    }
  }

  func removeInputCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(title: "delete_input_prompt".localized, message: nil, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { (action: UIAlertAction!) in
      self.resetInputsUsedAttribute(index: indexPath.row)
      self.deleteSelectedInput(indexPath)
      self.selectedInputs.remove(at: indexPath.row)
      self.selectedInputsTableView.reloadData()
      self.checkAllMixCategoryCode()
      if self.selectedInputs.count == 0 {
        self.selectedInputsTableView.isHidden = true
        self.inputsExpandImageView.isHidden = true
        self.inputsHeightConstraint.constant = 70
      } else {
        self.inputsTableViewHeightConstraint.constant = self.selectedInputsTableView.contentSize.height
        self.inputsHeightConstraint.constant = self.inputsTableViewHeightConstraint.constant + 100
        self.view.layoutIfNeeded()
      }
    }))
    present(alert, animated: true)
  }

  private func defineQuantityInFunctionOfSurface(unit: String, quantity: Float, indexPath: IndexPath) {
    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let surfaceArea = cropsView.selectedSurfaceArea
    var efficiency: Float = 0

    if unit.contains("/") {
      let surfaceUnit = unit.components(separatedBy: "/")[1]
      switch surfaceUnit {
      case "ha":
        efficiency = quantity * surfaceArea
      case "m²":
        efficiency = quantity * (surfaceArea * 10000)
      default:
        return
      }
      cell.surfaceQuantity.text = String(format: "input_quantity".localized, efficiency,
                                         (unit.components(separatedBy: "/")[0]))
    } else {
      efficiency = quantity / surfaceArea
      cell.surfaceQuantity.text = String(format: "input_quantity_per_surface".localized, efficiency, unit)
    }
    cell.surfaceQuantity.textColor = AppColor.TextColors.DarkGray
  }

  func updateQuantityLabel(indexPath: IndexPath) {
    let cell = selectedInputsTableView.cellForRow(at: indexPath) as? SelectedInputCell
    let isValidated = (interventionState == InterventionState.Validated.rawValue)
    let quantity = (isValidated ? cell?.quantityTextField.placeholder?.floatValue : cell?.quantityTextField.text?.floatValue)
    let unit = cell?.unitButton.titleLabel?.text

    cell?.surfaceQuantity.isHidden = false
    if quantity == 0 || quantity == nil {
      let error = (cell?.type == "Phyto") ? "volume_cannot_be_null".localized : "quantity_cannot_be_null".localized
      cell?.surfaceQuantity.text = error
      cell?.surfaceQuantity.textColor = AppColor.AppleColors.Red
    } else if totalLabel.text == "select_crops".localized.uppercased() {
      cell?.surfaceQuantity.text = "no_crop_selected".localized
      cell?.surfaceQuantity.textColor = AppColor.AppleColors.Red
    } else {
      defineQuantityInFunctionOfSurface(unit: unit!.localized, quantity: quantity!, indexPath: indexPath)
    }
  }

  func updateAllQuantityLabels() {
    for (index, _) in selectedInputs.enumerated() {
      updateQuantityLabel(indexPath: IndexPath(row: index, section: 0))
    }
  }

  private func displayInputQuantityInReadOnlyMode(_ interventionInput: NSManagedObject, cell: SelectedInputCell) {
    let unit = interventionInput.value(forKey: "unit") as? String
    let quantity = interventionInput.value(forKey: "quantity") as? Float

    if interventionState == InterventionState.Validated.rawValue {
      cell.quantityTextField.placeholder = (quantity as NSNumber?)?.stringValue
      cell.unitButton.setTitle(unit?.localized, for: .normal)
      cell.unitButton.setTitleColor(.lightGray, for: .normal)
    } else if quantity == 0 || quantity == nil {
      cell.quantityTextField.placeholder = "0"
      cell.quantityTextField.text = nil
    } else {
      cell.quantityTextField.text = (quantity as NSNumber?)?.stringValue
    }
  }

  func selectedInputsTableViewCellForRowAt(_ tableView: UITableView, _ indexPath: IndexPath) -> SelectedInputCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedInputCell", for: indexPath) as! SelectedInputCell

    if selectedInputs.count > indexPath.row {
      let selectedInput = selectedInputs[indexPath.row]
      let unit = selectedInput.value(forKey: "unit") as? String

      cell.warningLabel.isHidden = true
      cell.warningImageView.isHidden = true
      cell.cellDelegate = self
      cell.addInterventionViewController = self
      cell.indexPath = indexPath
      cell.unitButton.setTitle(unit?.localized, for: .normal)
      cell.inputUnit = unit

      switch selectedInput {
      case is InterventionSeed:
        let interventionSeed = selectedInput as! InterventionSeed

        cell.nameLabel.text = interventionSeed.seed?.specie?.localized
        cell.infoLabel.text = interventionSeed.seed?.variety
        cell.type = "Seed"
        cell.inputImageView.image = UIImage(named: "seed")
        displayInputQuantityInReadOnlyMode(selectedInput, cell: cell)
      case is InterventionPhytosanitary:
        let interventionPhyto = selectedInput as! InterventionPhytosanitary

        cell.nameLabel.text = interventionPhyto.phyto?.name
        cell.infoLabel.text = interventionPhyto.phyto?.firmName
        cell.type = "Phyto"
        cell.inputImageView.image = UIImage(named: "phytosanitary")
        cell.displayWaringIfInvalidDoses(interventionPhyto)
        displayInputQuantityInReadOnlyMode(selectedInput, cell: cell)
      case is InterventionFertilizer:
        let interventionFertilizer = selectedInput as! InterventionFertilizer

        cell.nameLabel.text = interventionFertilizer.fertilizer?.name?.localized
        cell.infoLabel.text = interventionFertilizer.fertilizer?.nature?.localized
        cell.type = "Fertilizer"
        cell.inputImageView.image = UIImage(named: "fertilizer")
        displayInputQuantityInReadOnlyMode(selectedInput, cell: cell)
      default:
        fatalError("Unknown input type for: \(String(describing: selectedInput))")
      }
    }
    return cell
  }
}
