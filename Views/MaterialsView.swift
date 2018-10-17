//
//  MaterialsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 26/09/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class MaterialsView: SelectionView, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

  // MARK: - Properties

  lazy var creationView: MaterialCreationView = {
    let creationView = MaterialCreationView(frame: CGRect.zero)
    creationView.translatesAutoresizingMaskIntoConstraints = false
    return creationView
  }()

  var materials = [Materials]()
  var filteredMaterials = [Materials]()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    fetchMaterials()
    tableView.reloadData()
  }

  private func setupView() {
    titleLabel.text = "selecting_materials".localized
    createButton.setTitle("create_new_material".localized.uppercased(), for: .normal)
    searchBar.delegate = self
    tableView.register(MaterialCell.self, forCellReuseIdentifier: "MaterialCell")
    tableView.rowHeight = 50
    tableView.delegate = self
    tableView.dataSource = self
    setupCreationView()
    setupActions()
  }

  private func setupCreationView() {
    self.addSubview(creationView)

    NSLayoutConstraint.activate([
      creationView.heightAnchor.constraint(equalToConstant: 250),
      creationView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      creationView.leftAnchor.constraint(equalTo: self.leftAnchor),
      creationView.rightAnchor.constraint(equalTo: self.rightAnchor),
      ])
  }

  private func setupActions() {
    createButton.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
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
    filteredMaterials = searchText.isEmpty ? materials : materials.filter({(material: Materials) -> Bool in
      let name = material.name!
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
    return isSearching ? filteredMaterials.count : materials.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialCell", for: indexPath) as! MaterialCell
    let fromMaterials = isSearching ? filteredMaterials : materials
    let isSelected = addInterventionViewController!.selectedMaterials[0].contains(fromMaterials[indexPath.row])

    cell.nameLabel.text = fromMaterials[indexPath.row].name
    cell.isUserInteractionEnabled = !isSelected
    cell.backgroundColor = isSelected ? AppColor.CellColors.LightGray : AppColor.CellColors.White
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let fromMaterials = isSearching ? filteredMaterials : materials

    addInterventionViewController?.selectMaterial(fromMaterials[indexPath.row])
    searchBar.text = nil
    searchBar.endEditing(true)
    isSearching = false
    tableView.reloadData()
  }

  // MARK: - Core Data

  private func fetchMaterials() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let materialsFetchRequest: NSFetchRequest<Materials> = Materials.fetchRequest()

    do {
      materials = try managedContext.fetch(materialsFetchRequest)
      materials = materials.sorted(by: { $0.name!.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        < $1.name!.lowercased().folding(options: .diacriticInsensitive, locale: .current) })
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func createMaterial(name: String, unit: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let material = Materials(context: managedContext)

    material.name = name
    material.unit = unit
    materials.append(material)

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
    creationView.nameTextField.resignFirstResponder()
    creationView.isHidden = true
    dimView.isHidden = true
    creationView.nameTextField.text = ""
    creationView.errorLabel.isHidden = true
    creationView.unitButton.setTitle("METER".localized.lowercased(), for: .normal)
  }

  @objc private func validateCreation() {
    if !checkMaterialName() {
      return
    }

    creationView.nameTextField.resignFirstResponder()
    createMaterial(name: creationView.nameTextField.text!, unit: addInterventionViewController!.selectedValue)
    materials = materials.sorted(by: { $0.name!.lowercased().folding(options: .diacriticInsensitive, locale: .current)
      < $1.name!.lowercased().folding(options: .diacriticInsensitive, locale: .current) })
    tableView.reloadData()
    creationView.isHidden = true
    dimView.isHidden = true
    addInterventionViewController!.selectedValue = "METER"
    creationView.nameTextField.text = ""
    creationView.errorLabel.isHidden = true
    creationView.unitButton.setTitle("METER".localized.lowercased(), for: .normal)
  }

  private func checkMaterialName() -> Bool {
    let materialsWithSameName = materials.filter({(material: Materials) -> Bool in
      let name = material.name!
      return name.range(of: creationView.nameTextField.text!, options: .caseInsensitive) != nil
    })

    if creationView.nameTextField.text!.isEmpty {
      creationView.errorLabel.text = "material_name_is_empty".localized
      creationView.errorLabel.isHidden = false
      return false
    } else if materialsWithSameName.count > 0 {
      creationView.errorLabel.text = "material_name_not_available".localized
      creationView.errorLabel.isHidden = false
      return false
    }
    return true
  }

  @objc private func nameDidChange() {
    if !creationView.errorLabel.isHidden {
      creationView.errorLabel.isHidden = true
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.endEditing(true)
  }
}
