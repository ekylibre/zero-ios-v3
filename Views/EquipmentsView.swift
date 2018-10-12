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

  lazy var creationView: EquipmentCreationView = {
    let creationView = EquipmentCreationView(frame: CGRect.zero)
    creationView.translatesAutoresizingMaskIntoConstraints = false
    return creationView
  }()

  var equipments = [Equipments]()
  var filteredEquipments = [Equipments]()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    fetchEquipments()
    tableView.reloadData()
  }

  private func setupView() {
    titleLabel.text = "selecting_equipments".localized
    createButton.setTitle("create_new_equipment".localized.uppercased(), for: .normal)
    searchBar.delegate = self
    tableView.register(EquipmentCell.self, forCellReuseIdentifier: "EquipmentCell")
    tableView.rowHeight = 50
    tableView.delegate = self
    tableView.dataSource = self
    setupCreationView()
    setupActions()
  }

  private func setupCreationView() {
    self.addSubview(creationView)

    NSLayoutConstraint.activate([
      creationView.heightAnchor.constraint(equalToConstant: 350),
      creationView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      creationView.leftAnchor.constraint(equalTo: self.leftAnchor),
      creationView.rightAnchor.constraint(equalTo: self.rightAnchor),
      ])
  }

  private func setupActions() {
    createButton.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
    creationView.cancelButton.addTarget(self, action: #selector(cancelCreation), for: .touchUpInside)
    creationView.createButton.addTarget(self, action: #selector(validateCreation), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Search bar

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearching = true
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredEquipments = searchText.isEmpty ? equipments : equipments.filter({(equipment: Equipments) -> Bool in
      let name = equipment.name!
      return name.range(of: searchText, options: .caseInsensitive) != nil
    })
    isSearching = !searchText.isEmpty
    createButton.isHidden = isSearching
    tableViewTopAnchor.constant = isSearching ? 15 : 60
    tableView.reloadData()
    DispatchQueue.main.async {
      if self.tableView.numberOfRows(inSection: 0) > 0 {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
      }
    }
  }

  // MARK: - Table view

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isSearching ? filteredEquipments.count : equipments.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentCell", for: indexPath) as! EquipmentCell
    let fromEquipments = isSearching ? filteredEquipments : equipments
    let isSelected = addInterventionViewController!.selectedMaterials[0].contains(fromEquipments[indexPath.row])

    cell.nameLabel.text = fromEquipments[indexPath.row].name
    cell.isUserInteractionEnabled = !isSelected
    cell.backgroundColor = isSelected ? AppColor.CellColors.LightGray : AppColor.CellColors.White
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let fromEquipments = isSearching ? filteredEquipments : equipments

    addInterventionViewController?.selectEquipment(fromEquipments[indexPath.row])
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
    let equipmentsFetchRequest: NSFetchRequest<Equipments> = Equipments.fetchRequest()

    do {
      equipments = try managedContext.fetch(equipmentsFetchRequest)
      equipments = equipments.sorted(by: { $0.name!.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        < $1.name!.lowercased().folding(options: .diacriticInsensitive, locale: .current) })
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func createEquipment(name: String, number: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipment = Equipments(context: managedContext)

    equipment.name = name
    equipment.number = number
    equipments.append(equipment)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Actions

  @objc private func tapCreateButton() {
    dimView.isHidden = false
    creationView.isHidden = false
  }

  @objc private func cancelCreation() {
    dimView.isHidden = true
  }

  @objc private func validateCreation() {
    createEquipment(name: creationView.nameTextField.text!, number: creationView.numberTextField.text!)
    creationView.nameTextField.text = ""
    creationView.typeButton.setTitle("METER".localized.lowercased(), for: .normal)
    equipments = equipments.sorted(by: { $0.name!.lowercased().folding(options: .diacriticInsensitive, locale: .current)
      < $1.name!.lowercased().folding(options: .diacriticInsensitive, locale: .current) })
    tableView.reloadData()
    dimView.isHidden = true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.endEditing(true)
  }
}
