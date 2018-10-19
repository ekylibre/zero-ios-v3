//
//  AddEntitiesToIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 17/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: DoerCellDelegate {

  // MARK: - Actions

  func updateDriverStatus(_ indexPath: IndexPath, driver: UISwitch) {
  }

  @IBAction func collapseDoersView(_ sender: Any) {
    if doersHeightConstraint.constant != 70 {
      UIView.animate(withDuration: 0.5, animations: {
        self.doersTableView.isHidden = true
        self.doersHeightConstraint.constant = 70
        self.doersCollapsedButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.view.layoutIfNeeded()
      })
    } else {
      UIView.animate(withDuration: 0.5, animations: {
        self.doersTableView.isHidden = false
        self.resizeViewAndTableView(
          viewHeightConstraint: self.doersHeightConstraint,
          tableViewHeightConstraint: self.doersTableViewHeightConstraint,
          tableView: self.doersTableView)
        self.doersCollapsedButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
        self.view.layoutIfNeeded()
      })
    }
    showEntitiesNumber(
      entities: doers,
      constraint: doersHeightConstraint,
      numberLabel: doersNumber,
      addEntityButton: addEntitiesButton)
  }

  @IBAction func openEntitiesSelectionView(_ sender: Any) {
    dimView.isHidden = false
    selectEntitiesView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
      self.view.layoutIfNeeded()
    })
  }

  func closeEntitiesSelectionView() {
    dimView.isHidden = true
    selectEntitiesView.isHidden = true

    if doers.count > 0 {
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
        self.doersCollapsedButton.isHidden = false
        self.doersTableView.isHidden = false
        self.resizeViewAndTableView(
          viewHeightConstraint: self.doersHeightConstraint,
          tableViewHeightConstraint: self.doersTableViewHeightConstraint,
          tableView: self.doersTableView)
        self.doersCollapsedButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
        self.view.layoutIfNeeded()
      })
    }
    searchedEntities = entities
    doersTableView.reloadData()
  }

  @IBAction func openEntitiesCreationView(_ sender: Any) {
    entityDarkLayer.isHidden = false
    createEntitiesView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
      self.view.layoutIfNeeded()
    })
  }

  func fetchEntities() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest: NSFetchRequest<Entities> = Entities.fetchRequest()

    do {
      entities = try managedContext.fetch(entitiesFetchRequest)

      searchedEntities = entities
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  @IBAction func closeEntitiesCreationView(_ sender: Any) {
    entityFirstName.text = nil
    entityLastName.text = nil
    entityRole.text = nil
    entityDarkLayer.isHidden = true
    createEntitiesView.isHidden = true
    fetchEntities()
    entitiesTableView.reloadData()
  }

  @IBAction func createNewEntity(_ sender: Any) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = Entities(context: managedContext)

    entity.firstName = entityFirstName.text
    entity.lastName = entityLastName.text
    entity.role = entityRole.text

    do {
      entity.ekyID = pushPerson(first: entityFirstName.text ?? "", last: entityLastName.text ?? "")
      try managedContext.save()
      entities.append(entity)
      closeEntitiesCreationView(self)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func pushPerson(first: String, last: String) -> Int32 {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let group = DispatchGroup()
    let mutation = PushPersonMutation(farmId: farmID, firstName: first, lastName: last)
    let _ = apollo.clearCache()

    group.enter()
    apollo.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print(error)
      } else if let resultError = result!.data!.createPerson!.errors {
        print(resultError)
      } else {
        id = Int32(result!.data!.createPerson!.person!.id)!
      }
      group.leave()
    })
    group.wait()
    return id
  }

  func removeDoerCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(
      title: "",
      message: "delete_person_prompt".localized,
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { (action: UIAlertAction!) in
      self.doers.remove(at: indexPath.row)
      self.doersTableView.reloadData()

      if self.doers.count == 0 {
        self.doersTableView.isHidden = true
        self.doersCollapsedButton.isHidden = true
        self.doersHeightConstraint.constant = 70
      } else {
        UIView.animate(withDuration: 0.5, animations: {
          self.resizeViewAndTableView(
            viewHeightConstraint: self.doersHeightConstraint,
            tableViewHeightConstraint: self.doersTableViewHeightConstraint,
            tableView: self.doersTableView)
          self.view.layoutIfNeeded()
        })
      }
    }))
    self.present(alert, animated: true)
  }
}
