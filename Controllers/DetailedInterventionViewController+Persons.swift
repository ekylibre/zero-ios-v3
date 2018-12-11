//
//  DetailedInterventionViewController+Persons.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 15/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController {

  // MARK: - Initialization

  func setupPersonsView() {
    selectedPersons.append([Person]())
    selectedPersons.append([InterventionPerson]())
    personsSelectionView = PersonsView(frame: CGRect.zero)
    personsSelectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(personsSelectionView)

    NSLayoutConstraint.activate([
      personsSelectionView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      personsSelectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: -30),
      personsSelectionView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      personsSelectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -30)
      ])

    personsTapGesture.delegate = self
    selectedPersonsTableView.layer.borderWidth  = 0.5
    selectedPersonsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedPersonsTableView.layer.cornerRadius = 5
    selectedPersonsTableView.register(SelectedPersonCell.self, forCellReuseIdentifier: "SelectedPersonCell")
    selectedPersonsTableView.bounces = false
    selectedPersonsTableView.dataSource = self
    selectedPersonsTableView.delegate = self
    personsSelectionView.addInterventionViewController = self
  }

  // MARK: - Selection

  func selectPerson(_ person: Person, isDriver: Bool, calledFromCreatedIntervention: Bool) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionPerson = InterventionPerson(context: managedContext)

    interventionPerson.isDriver = isDriver
    interventionPerson.person = person
    selectedPersons[0].append(person)
    selectedPersons[1].append(interventionPerson)
    personsSelectionView.cancelButton.sendActions(for: .touchUpInside)
    updateSelectedPersonsView(calledFromCreatedIntervention: calledFromCreatedIntervention)
  }

  private func checkButtonDisplayStatus(shouldExpand: Bool) {
    if interventionState == InterventionState.Validated.rawValue {
      personsAddButton.isHidden = true
      personsCountLabel.isHidden = false
    } else if interventionState != nil {
      personsCountLabel.isHidden = !shouldExpand
      personsAddButton.isHidden = !personsCountLabel.isHidden
    }
  }

  func updateSelectedPersonsView(calledFromCreatedIntervention: Bool) {
    let isCollapsed = personsHeightConstraint.constant == 70
    let shouldExpand = selectedPersons[0].count > 0
    let tableViewHeight = (selectedPersons[0].count > 10) ? 10 * 65 : selectedPersons[0].count * 65

    if !calledFromCreatedIntervention {
      isCollapsed ? personsExpandImageView.transform = personsExpandImageView.transform.rotated(by: CGFloat.pi) : nil
      personsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
      personsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
    }
    personsExpandImageView.isHidden = !shouldExpand
    checkButtonDisplayStatus(shouldExpand: shouldExpand)
    updatePersonsCountLabel()
    selectedPersonsTableView.reloadData()
  }

  // MARK: - Actions

  @IBAction private func openPersonsSelectionView(_ sender: Any) {
    dimView.isHidden = false
    personsSelectionView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @IBAction func tapPersonsView() {
    let shouldExpand = (personsHeightConstraint.constant == 70)
    let tableViewHeight = (selectedPersons[0].count > 10) ? 10 * 65 : selectedPersons[0].count * 65

    if selectedPersons[0].count == 0 {
      return
    }

    view.endEditing(true)
    updatePersonsCountLabel()
    personsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    personsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
    if interventionState != InterventionState.Validated.rawValue {
      personsAddButton.isHidden = (!shouldExpand)
    }
    personsCountLabel.isHidden = shouldExpand
    selectedPersonsTableView.isHidden = !shouldExpand
    personsExpandImageView.transform = personsExpandImageView.transform.rotated(by: CGFloat.pi)
  }

  func updatePersonsCountLabel() {
    if selectedPersons[0].count == 1 {
      personsCountLabel.text = "person".localized
    } else if selectedPersons[0].count == 0 {
      personsCountLabel.text = "none".localized
    } else {
      personsCountLabel.text = String(format: "persons".localized, selectedPersons[0].count)
    }
  }

  @objc private func updateIsDriver(sender: UISwitch) {
    let cell = sender.superview?.superview as! SelectedPersonCell
    let indexPath = selectedPersonsTableView.indexPath(for: cell)

    selectedPersons[1][indexPath!.row].setValue(sender.isOn, forKey: "isDriver")
  }

  @objc private func tapPersonsDeleteButton(sender: UIButton) {
    let cell = sender.superview?.superview as! SelectedPersonCell
    let indexPath = selectedPersonsTableView.indexPath(for: cell)!
    let alert = UIAlertController(title: "delete_person_prompt".localized, message: nil, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { action in
      self.deletePerson(indexPath.row)
    }))
    present(alert, animated: true)
  }

  private func deletePerson(_ index: Int)  {
    selectedPersons[0].remove(at: index)
    selectedPersons[1].remove(at: index)
    updateSelectedPersonsView(calledFromCreatedIntervention: false)
    personsSelectionView.tableView.reloadData()
  }

  func selectedPersonsTableViewCellForRowAt(_ tableView: UITableView, _ indexPath: IndexPath) -> SelectedPersonCell {
    let selectedPerson = selectedPersons[0][indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedPersonCell", for: indexPath)
      as! SelectedPersonCell

    if interventionState != nil {
      cell.driverSwitch.isOn = selectedPersons[1][indexPath.row].value(forKey: "isDriver") as! Bool
    }
    cell.firstNameLabel.text = selectedPerson.value(forKey: "firstName") as? String
    cell.lastNameLabel.text = selectedPerson.value(forKey: "lastName") as? String
    cell.deleteButton.addTarget(self, action: #selector(tapPersonsDeleteButton), for: .touchUpInside)
    cell.driverSwitch.addTarget(self, action: #selector(updateIsDriver), for: .valueChanged)
    return cell
  }
}
