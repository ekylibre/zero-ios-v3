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
    inputsSelectionView = InputsView(firstSpecie: getFirstSpecie(),frame: CGRect.zero)
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
    inputsSelectionView.seedView.specieButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
    inputsSelectionView.fertilizerView.natureButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    inputsSelectionView.addInterventionViewController = self
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

  @IBAction func openInputsSelectionView(_ sender: Any) {
    dimView.isHidden = false
    inputsSelectionView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @IBAction private func tapInputsView() {
    let shouldExpand = (inputsHeightConstraint.constant == 70)
    let tableViewHeight = (selectedInputs.count > 10) ? 10 * 110 : selectedInputs.count * 110

    if selectedInputs.count == 0 {
      return
    }

    updateCountLabel()
    inputsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 100) : 70
    inputsAddButton.isHidden = !shouldExpand
    inputsCountLabel.isHidden = shouldExpand
    inputsExpandImageView.transform = inputsExpandImageView.transform.rotated(by: CGFloat.pi)
    selectedInputsTableView.isHidden = !shouldExpand
    inputsUnauthorizedMixLabel.isHidden = !shouldExpand
    inputsUnauthorizedMixImage.isHidden = !shouldExpand
    shouldExpand ? checkAllMixCategoryCode() : nil
  }

  private func updateCountLabel() {
    if selectedInputs.count == 1 {
      inputsCountLabel.text = "input".localized
    } else {
      inputsCountLabel.text = String(format: "inputs".localized, selectedInputs.count)
    }
  }

  // MARK: -
  func saveSelectedRow(_ indexPath: IndexPath) {
    cellIndexPath = indexPath
  }

  func closeInputsSelectionView() {
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
      inputsExpandImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      view.layoutIfNeeded()
    }
    selectedInputsTableView.reloadData()
  }

  func checkAllMixCategoryCode() {
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
    var selectedPhytos = [InterventionPhytosanitary]()

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

    if !autorizedMix[firstMixCode]!.contains(secondMixCode) {
      return false
    }
    return true
  }

  func selectInput(_ input: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    switch input {
    case let seed as Seed:
      let selectedSeed = InterventionSeed(context: managedContext)
      selectedSeed.unit = seed.unit
      selectedSeed.seed = seed
      selectedInputs.append(selectedSeed)
    case let phyto as Phyto:
      let selectedPhyto = InterventionPhytosanitary(context: managedContext)
      selectedPhyto.unit = phyto.unit
      selectedPhyto.phyto = phyto
      selectedInputs.append(selectedPhyto)
      checkAllMixCategoryCode()
    case let fertilizer as Fertilizer:
      let selectedFertilizer = InterventionFertilizer(context: managedContext)
      selectedFertilizer.unit = fertilizer.unit
      selectedFertilizer.fertilizer = fertilizer
      selectedInputs.append(selectedFertilizer)
    default:
      fatalError("Input type not found")
    }

    selectedInputsTableView.reloadData()
    closeInputsSelectionView()
  }

  func resetInputsUsedAttribute(index: Int) {
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

  func removeInputCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(
      title: "",
      message: "delete_input_prompt".localized,
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { (action: UIAlertAction!) in
      self.resetInputsUsedAttribute(index: indexPath.row)
      self.selectedInputs.remove(at: indexPath.row)
      self.checkAllMixCategoryCode()
      self.selectedInputsTableView.reloadData()
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

  func defineQuantityInFunctionOfSurface(unit: String, quantity: Float, indexPath: IndexPath) {
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
      cell.surfaceQuantity.text = String(format: "input_quantity".localized, efficiency, (unit.components(separatedBy: "/")[0]))
    } else {
      efficiency = quantity / surfaceArea
      cell.surfaceQuantity.text = String(format: "input_quantity_per_surface".localized, efficiency, unit)
    }
    cell.surfaceQuantity.textColor = AppColor.TextColors.DarkGray
  }

  func updateInputQuantity(indexPath: IndexPath) {
    let cell = selectedInputsTableView.cellForRow(at: indexPath) as! SelectedInputCell
    let quantity = cell.quantityTextField.text?.floatValue
    let unit = cell.unitButton.titleLabel?.text

    cell.surfaceQuantity.isHidden = false
    if quantity == 0 || quantity == nil {
      let error = (cell.type == "Phyto") ? "volume_cannot_be_null".localized : "quantity_cannot_be_null".localized
      cell.surfaceQuantity.text = error
      cell.surfaceQuantity.textColor = AppColor.TextColors.Red
    } else if totalLabel.text == "select_crops".localized.uppercased() {
      cell.surfaceQuantity.text = "no_crop_selected".localized
      cell.surfaceQuantity.textColor = AppColor.TextColors.Red
    } else {
      defineQuantityInFunctionOfSurface(unit: unit!.localized, quantity: quantity!, indexPath: indexPath)
    }
  }

  func updateAllInputQuantity() {
    let totalCellNumber = selectedInputs.count
    var indexPath: IndexPath!

    if totalCellNumber > 0 {
      for currentCell in 0..<(totalCellNumber) {
        indexPath = NSIndexPath(row: currentCell, section: 0) as IndexPath?
        updateInputQuantity(indexPath: indexPath)
      }
    }
  }
}
