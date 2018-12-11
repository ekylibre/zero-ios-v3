//
//  EquipmentsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 11/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class EquipmentsView: SelectionView, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

  // MARK: - Properties

  lazy var creationView = EquipmentCreationView(firstType: firstEquipmentType)
  lazy var editionView = EquipmentEditionView(firstType: firstEquipmentType)
  var equipments = [Equipment]()
  var filteredEquipments = [Equipment]()
  var firstEquipmentType: String

  func loadEquipmentIndicators(_ equipmentNature: String) -> [String] {
    if let asset = NSDataAsset(name: "equipment-types") {
      do {
        let jsonResult = try JSONSerialization.jsonObject(with: asset.data)
        let registeredEquipments = jsonResult as? [[String: Any]]

        for registeredEquipment in registeredEquipments! {
          if equipmentNature == registeredEquipment["nature"] as! String {
            var indicators = [String]()

            !(registeredEquipment["main_frozen_indicator_name"] is NSNull)
              ? indicators.append(registeredEquipment["main_frozen_indicator_name"] as! String) : nil
            !(registeredEquipment["other_frozen_indicator_name"] is NSNull)
              ? indicators.append(registeredEquipment["other_frozen_indicator_name"] as! String) : nil
            return indicators
          }
        }
      } catch {
        print("Lexicon error")
      }
    } else {
      print("equipment-types.json not found")
    }
    return [String]()
  }

  func defineIndicatorUnit(_ key: String, textField: UITextField) -> String? {
    let units = [
      "plowshare_count": "UNITY",
      "motor_power": "FRENCH_HORSEPOWER",
      "application_width": "METER",
      "rows_count": "UNITY",
      "nominal_storable_net_volume": "CUBIC_METER",
      "nominal_storable_net_mass": "KILOGRAM",
      "diameter": "METER",
      "width": "METER",
      "length": "METER"]

    if units[key] == "UNITY" {
      textField.keyboardType = .numberPad
    } else {
      textField.keyboardType = .decimalPad
    }
    return units[key]
  }

  func defineIndicatorsIfNeeded(_ equipmentNature: String) {
    let indicators = loadEquipmentIndicators(equipmentNature)

    if indicators.count > 1 {
      let firstUnit = defineIndicatorUnit(indicators[0], textField: creationView.firstEquipmentParameter)
      let secondUnit = defineIndicatorUnit(indicators[1], textField: creationView.secondEquipmentParameter)

      creationView.firstEquipmentParameter.placeholder = indicators[0].localized
      creationView.secondEquipmentParameter.placeholder = indicators[1].localized
      creationView.firstParameterUnit.text = firstUnit?.localized
      creationView.secondParameterUnit.text = secondUnit?.localized
    } else if indicators.count > 0 {
      let unit = defineIndicatorUnit(indicators[0], textField: creationView.firstEquipmentParameter)

      creationView.firstEquipmentParameter.placeholder = indicators[0].localized
      creationView.firstParameterUnit.text = unit?.localized
    }

    creationView.heightConstraint.constant = 350 + (CGFloat(indicators.count) * 50)
    creationView.firstEquipmentParameter.isHidden = (indicators.count < 1)
    creationView.firstParameterUnit.isHidden = (indicators.count < 1)
    creationView.secondEquipmentParameter.isHidden = (indicators.count < 2)
    creationView.secondParameterUnit.isHidden = (indicators.count < 2)
  }

  // MARK: - Initialization

  init(firstType: String, frame: CGRect) {
    firstEquipmentType = firstType
    super.init(frame: frame)
    setupView()
    fetchEquipments()
    tableView.reloadData()
    defineIndicatorsIfNeeded(firstEquipmentType.lowercased())
  }

  private func setupView() {
    titleLabel.text = "selecting_equipments".localized
    createButton.setTitle("create_new_equipment".localized.uppercased(), for: .normal)
    searchBar.delegate = self
    tableView.register(EquipmentCell.self, forCellReuseIdentifier: "EquipmentCell")
    tableView.rowHeight = 65
    tableView.delegate = self
    tableView.dataSource = self
    setupCreationAndEditionViews()
    setupActions()
  }

  private func setupCreationAndEditionViews() {
    addSubview(creationView)
    addSubview(editionView)

    NSLayoutConstraint.activate([
      creationView.leftAnchor.constraint(equalTo: leftAnchor),
      creationView.rightAnchor.constraint(equalTo: rightAnchor),
      creationView.centerYAnchor.constraint(equalTo: centerYAnchor),
      editionView.leftAnchor.constraint(equalTo: leftAnchor),
      editionView.rightAnchor.constraint(equalTo: rightAnchor),
      editionView.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
  }

  private func setupActions() {
    createButton.addTarget(self, action: #selector(openCreationView), for: .touchUpInside)
    creationView.nameTextField.addTarget(self, action: #selector(nameDidChange), for: .editingChanged)
    creationView.cancelButton.addTarget(self, action: #selector(cancelCreation), for: .touchUpInside)
    creationView.createButton.addTarget(self, action: #selector(validateCreation), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Search bar

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredEquipments = searchText.isEmpty ? equipments : equipments.filter({(equipment: Equipment) -> Bool in
      let name = equipment.name!
      return name.range(of: searchText, options: .caseInsensitive) != nil
    })
    isSearching = !searchText.isEmpty
    createButton.isHidden = isSearching
    tableViewTopAnchor.constant = isSearching ? 10 : 40
    tableView.reloadData()
    DispatchQueue.main.async {
      if self.tableView.numberOfRows(inSection: 0) > 0 {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
      }
    }
  }

  // MARK: - Table view

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isSearching ? filteredEquipments.count : equipments.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentCell", for: indexPath) as! EquipmentCell
    let equipment = isSearching ? filteredEquipments[indexPath.row] : equipments[indexPath.row]
    let isSelected = addInterventionViewController!.selectedEquipments.contains(equipment)
    let imageName = equipment.type!.lowercased().replacingOccurrences(of: "_", with: "-")

    cell.typeImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
    cell.nameLabel.text = equipment.name
    cell.infosLabel.text = getEquipmentInfos(equipment)
    cell.isUserInteractionEnabled = !isSelected
    cell.backgroundColor = isSelected ? AppColor.CellColors.LightGray : AppColor.CellColors.White
    return cell
  }

  private func getEquipmentInfos(_ equipment: Equipment) -> String {
    let type = equipment.type!.localized
    guard let number = equipment.number else {
      return type
    }

    return String(format: "%@ #%@", type, number)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let fromEquipments = isSearching ? filteredEquipments : equipments

    addInterventionViewController?.selectEquipment(fromEquipments[indexPath.row], calledFromCreatedIntervention: false)
    searchBar.text = nil
    searchBar.endEditing(true)
    isSearching = false
    tableView.reloadData()
  }

  // MARK: - Core Data

  private func fetchEquipments() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsFetchRequest: NSFetchRequest<Equipment> = Equipment.fetchRequest()

    do {
      equipments = try managedContext.fetch(equipmentsFetchRequest)
      equipments = equipments.sorted(by: {
        let firstName = $0.name?.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        let secondName = $1.name?.lowercased().folding(options: .diacriticInsensitive, locale: .current)

        if firstName != nil && secondName != nil {
          return firstName! < secondName!
        }
        return true
      })
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func createEquipment(name: String, number: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipment = Equipment(context: managedContext)

    equipment.type = addInterventionViewController!.selectedValue
    equipment.name = name
    equipment.number = number.isEmpty ? nil : number
    equipment.indicatorOne = (creationView.firstEquipmentParameter.text != "" ?
      creationView.firstEquipmentParameter.text : nil)
    equipment.indicatorTwo = (creationView.secondEquipmentParameter.text != "" ?
      creationView.secondEquipmentParameter.text : nil)
    equipments.append(equipment)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Actions

  @objc private func openCreationView() {
    dimView.isHidden = false
    creationView.isHidden = false
  }

  @objc private func nameDidChange() {
    if !creationView.nameErrorLabel.isHidden {
      creationView.nameErrorLabel.isHidden = true
    }
  }

  @objc private func cancelCreation() {
    let imageName = firstEquipmentType.lowercased().replacingOccurrences(of: "_", with: "-")

    creationView.nameTextField.resignFirstResponder()
    creationView.isHidden = true
    dimView.isHidden = true
    creationView.typeImageView.image = UIImage(named: imageName)
    creationView.typeButton.setTitle(firstEquipmentType.localized, for: .normal)
    creationView.nameTextField.text = ""
    creationView.nameErrorLabel.isHidden = true
    creationView.numberTextField.text = ""
    creationView.numberErrorLabel.isHidden = true
    creationView.firstEquipmentParameter.text = nil
    creationView.secondEquipmentParameter.text = nil
  }

  @objc private func validateCreation() {
    let imageName = firstEquipmentType.lowercased().replacingOccurrences(of: "_", with: "-")

    if !checkEquipmentName() || !checkEquipmentNumber() {
      return
    }

    creationView.nameTextField.resignFirstResponder()
    createEquipment(name: creationView.nameTextField.text!, number: creationView.numberTextField.text!)
    equipments = equipments.sorted(by: {
      let firstName = $0.name?.lowercased().folding(options: .diacriticInsensitive, locale: .current)
      let secondName = $1.name?.lowercased().folding(options: .diacriticInsensitive, locale: .current)

      if firstName != nil && secondName != nil {
        return firstName! < secondName!
      }
      return true
    })
    tableView.reloadData()
    creationView.isHidden = true
    dimView.isHidden = true
    addInterventionViewController!.selectedValue = firstEquipmentType
    creationView.typeImageView.image = UIImage(named: imageName)
    creationView.typeButton.setTitle(firstEquipmentType.localized, for: .normal)
    creationView.nameTextField.text = ""
    creationView.nameErrorLabel.isHidden = true
    creationView.numberTextField.text = ""
    creationView.numberErrorLabel.isHidden = true
    creationView.firstEquipmentParameter.text = nil
    creationView.secondEquipmentParameter.text = nil
  }

  func checkEquipmentName() -> Bool {
    if creationView.nameTextField.text!.isEmpty {
      creationView.nameErrorLabel.text = "equipment_name_is_empty".localized
      creationView.nameErrorLabel.isHidden = false
      return false
    } else if equipments.contains(where: { $0.name?.lowercased() == creationView.nameTextField.text?.lowercased() }) {
      creationView.nameErrorLabel.text = "equipment_name_not_available".localized
      creationView.nameErrorLabel.isHidden = false
      return false
    }
    return true
  }

  private func checkEquipmentNumber() -> Bool {
    if equipments.contains(where: { $0.number == creationView.numberTextField.text }) {
      creationView.numberErrorLabel.isHidden = false
      return false
    }
    return true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    endEditing(true)
  }
}
