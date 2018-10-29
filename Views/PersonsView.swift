//
//  PersonsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 15/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class PersonsView: SelectionView, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

  // MARK: - Properties

  lazy var creationView: PersonCreationView = {
    let creationView = PersonCreationView(frame: CGRect.zero)
    creationView.translatesAutoresizingMaskIntoConstraints = false
    return creationView
  }()

  var persons = [Persons]()
  var filteredPersons = [Persons]()

  // MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    fetchPersons()
    tableView.reloadData()
  }

  private func setupView() {
    titleLabel.text = "selecting_persons".localized
    createButton.setTitle("create_new_person".localized.uppercased(), for: .normal)
    searchBar.delegate = self
    tableView.register(PersonCell.self, forCellReuseIdentifier: "PersonCell")
    tableView.rowHeight = 65
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
    createButton.addTarget(self, action: #selector(openCreationView), for: .touchUpInside)
    creationView.firstNameTextField.addTarget(self, action: #selector(firstNameDidChange), for: .editingChanged)
    creationView.lastNameTextField.addTarget(self, action: #selector(lastNameDidChange), for: .editingChanged)
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
    filteredPersons = searchText.isEmpty ? persons : persons.filter({(person: Persons) -> Bool in
      let name = person.firstName!
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
    return isSearching ? filteredPersons.count : persons.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
    let person = isSearching ? filteredPersons[indexPath.row] : persons[indexPath.row]
    let isSelected = addInterventionViewController!.selectedPersons[0].contains(person)

    cell.firstNameLabel.text = person.firstName
    cell.lastNameLabel.text = person.lastName
    cell.isUserInteractionEnabled = !isSelected
    cell.backgroundColor = isSelected ? AppColor.CellColors.LightGray : AppColor.CellColors.White
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let person = isSearching ? filteredPersons[indexPath.row] : persons[indexPath.row]

    addInterventionViewController?.selectPerson(person, false)
    searchBar.text = nil
    searchBar.endEditing(true)
    isSearching = false
    tableView.reloadData()
  }

  // MARK: - Core Data

  private func fetchPersons() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let personsFetchRequest: NSFetchRequest<Persons> = Persons.fetchRequest()

    do {
      persons = try managedContext.fetch(personsFetchRequest)
      persons = persons.sorted(by: {
        let nameOne = $0.firstName?.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        let nameTwo = $1.firstName?.lowercased().folding(options: .diacriticInsensitive, locale: .current)

        if nameOne != nil && nameTwo != nil {
          return nameOne! < nameTwo!
        }
        return true
      })
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func createPerson(firstName: String, lastName: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let person = Persons(context: managedContext)

    person.firstName = firstName
    person.lastName = lastName
    persons.append(person)

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

  @objc private func firstNameDidChange() {
    if !creationView.firstNameErrorLabel.isHidden {
      creationView.firstNameErrorLabel.isHidden = true
    }
  }

  @objc private func lastNameDidChange() {
    if !creationView.lastNameErrorLabel.isHidden {
      creationView.lastNameErrorLabel.isHidden = true
    }
  }

  @objc private func cancelCreation() {
    creationView.firstNameTextField.resignFirstResponder()
    creationView.isHidden = true
    dimView.isHidden = true
    creationView.firstNameTextField.text = ""
    creationView.firstNameErrorLabel.isHidden = true
    creationView.lastNameTextField.text = ""
    creationView.lastNameErrorLabel.isHidden = true
  }

  @objc private func validateCreation() {
    if !checkPersonName() {
      return
    }

    creationView.firstNameTextField.resignFirstResponder()
    createPerson(firstName: creationView.firstNameTextField.text!, lastName: creationView.lastNameTextField.text!)
    persons = persons.sorted(by: { $0.firstName!.lowercased().folding(options: .diacriticInsensitive, locale: .current)
      < $1.firstName!.lowercased().folding(options: .diacriticInsensitive, locale: .current) })
    tableView.reloadData()
    creationView.isHidden = true
    dimView.isHidden = true
    creationView.firstNameTextField.text = ""
    creationView.firstNameErrorLabel.isHidden = true
    creationView.lastNameTextField.text = ""
    creationView.lastNameErrorLabel.isHidden = true
  }

  private func checkPersonName() -> Bool {
    creationView.firstNameErrorLabel.isHidden = !creationView.firstNameTextField.text!.isEmpty
    creationView.lastNameErrorLabel.isHidden = !creationView.lastNameTextField.text!.isEmpty

    if (creationView.firstNameTextField.text!.isEmpty) || (creationView.lastNameTextField.text!.isEmpty) {
      return false
    }
    return true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.endEditing(true)
  }
}
