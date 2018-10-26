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
    selectedPersons.append([Persons]())
    selectedPersons.append([InterventionPersons]())
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
    selectedPersonsTableView.bounces = false
    selectedPersonsTableView.register(SelectedPersonCell.self, forCellReuseIdentifier: "SelectedPersonCell")
    selectedPersonsTableView.dataSource = self
    selectedPersonsTableView.delegate = self
    personsSelectionView.exitButton.addTarget(self, action: #selector(closePersonsSelectionView), for: .touchUpInside)
    personsSelectionView.addInterventionViewController = self
  }

  // MARK: - Selection

  func selectPerson(_ person: Persons, _ isDriver: Bool) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionPerson = InterventionPersons(context: managedContext)

    interventionPerson.isDriver = isDriver
    interventionPerson.persons = person
    selectedPersons[0].append(person)
    selectedPersons[1].append(interventionPerson)
    closePersonsSelectionView()
    updateView()
  }

  private func updateView() {
    let shouldExpand = selectedPersons[0].count > 0
    let tableViewHeight = (selectedPersons[0].count > 10) ? 10 * 65 : selectedPersons[0].count * 65

    personsExpandImageView.isHidden = !shouldExpand
    personsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    personsTableViewHeightConstraint.constant = CGFloat(tableViewHeight)
    selectedPersonsTableView.reloadData()
  }

  // MARK: - Actions

  func refreshSelectedPersons() {
    tapPersonsView()
    if selectedPersons[1].count > 0 {
      selectedPersonsTableView.reloadData()
      personsExpandImageView.isHidden = false
    }
    personsAddButton.isHidden = true
    showEntitiesNumber(
      entities: selectedPersons[1],
      constraint: personsHeightConstraint,
      numberLabel: personsCountLabel,
      addEntityButton: personsAddButton)
  }

  @IBAction private func openPersonsSelectionView(_ sender: Any) {
    dimView.isHidden = false
    personsSelectionView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @IBAction private func tapPersonsView() {
    let shouldExpand = (personsHeightConstraint.constant == 70)
    let tableViewHeight = (selectedPersons[0].count > 10) ? 10 * 65 : selectedPersons[0].count * 65

    if selectedPersons[0].count == 0 {
      return
    }

    updateCountLabel()
    personsHeightConstraint.constant = shouldExpand ? CGFloat(tableViewHeight + 90) : 70
    if interventionState != InterventionState.Validated.rawValue {
      personsAddButton.isHidden = (!shouldExpand)
    }
    personsCountLabel.isHidden = shouldExpand
    selectedPersonsTableView.isHidden = !shouldExpand
    personsExpandImageView.transform = personsExpandImageView.transform.rotated(by: CGFloat.pi)
  }

  private func updateCountLabel() {
    if selectedPersons[0].count == 1 {
      personsCountLabel.text = "person".localized
    } else {
      personsCountLabel.text = String(format: "persons".localized, selectedPersons[0].count)
    }
  }

  @objc private func closePersonsSelectionView() {
    personsSelectionView.isHidden = true
    dimView.isHidden = true

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })

    personsSelectionView.searchBar.text = nil
    personsSelectionView.searchBar.endEditing(true)
    personsSelectionView.isSearching = false
    personsSelectionView.tableView.reloadData()
  }

  @objc func updateIsDriver(sender: UISwitch) {
    let cell = sender.superview?.superview as! SelectedPersonCell
    let indexPath = selectedPersonsTableView.indexPath(for: cell)

    selectedPersons[1][indexPath!.row].setValue(sender.isOn, forKey: "isDriver")
  }

  @objc func tapPersonsDeleteButton(sender: UIButton) {
    let cell = sender.superview?.superview as! SelectedPersonCell
    let indexPath = selectedPersonsTableView.indexPath(for: cell)!
    let alert = UIAlertController(title: nil, message: "delete_person_prompt".localized, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { action in
      self.deletePerson(indexPath.row)
    }))
    self.present(alert, animated: true)
  }

  private func deletePerson(_ index: Int)  {
    selectedPersons[0].remove(at: index)
    selectedPersons[1].remove(at: index)
    updateView()
    personsSelectionView.tableView.reloadData()
  }
}
