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

  // MARK: Actions

  func updateDriverStatus(_ indexPath: IndexPath, driver: UISwitch) {
    doers[indexPath.row].setValue(driver.isOn, forKey: "isDriver")
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
    })
  }

  func closeEntitiesSelectionView() {
    dimView.isHidden = true
    selectEntitiesView.isHidden = true

    if doers.count > 0 {
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
        self.view.layoutIfNeeded()
        self.doersCollapsedButton.isHidden = false
        self.doersTableView.isHidden = false
        self.resizeViewAndTableView(
          viewHeightConstraint: self.doersHeightConstraint,
          tableViewHeightConstraint: self.doersTableViewHeightConstraint,
          tableView: self.doersTableView)
        self.doersCollapsedButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
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
    })
  }

  @IBAction func closeEntitiesCreationView(_ sender: Any) {
    entityFirstName.text = nil
    entityLastName.text = nil
    entityRole.text = nil
    entityDarkLayer.isHidden = true
    createEntitiesView.isHidden = true
    fetchEntity(entityName: "Entities", searchedEntity: &searchedEntities, entity: &entities)
    entitiesTableView.reloadData()
  }

  @IBAction func createNewEntity(_ sender: Any) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesTable = NSEntityDescription.entity(forEntityName: "Entities", in: managedContext)!
    let entity = NSManagedObject(entity: entitiesTable, insertInto: managedContext)

    entity.setValue(false, forKey: "isDriver")
    entity.setValue(entityFirstName.text, forKeyPath: "firstName")
    entity.setValue(entityLastName.text, forKeyPath: "lastName")
    entity.setValue(entityRole.text, forKeyPath: "role")
    entity.setValue(0, forKey: "row")

    do {
      try managedContext.save()
      entities.append(entity)
      closeEntitiesCreationView(self)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func removeDoerCell(_ indexPath: IndexPath) {
    let alert = UIAlertController(
      title: "",
      message: "Êtes-vous sûr de vouloir supprimer la personne ?",
      preferredStyle: .alert
    )

    alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
      let row = self.doers[indexPath.row].value(forKey: "row") as! Int
      let indexTab = NSIndexPath(row: row, section: 0)
      let cell = self.entitiesTableView.cellForRow(at: indexTab as IndexPath) as! EntityCell

      cell.isAvaible = true
      cell.backgroundColor = AppColor.CellColors.white

      self.doers.remove(at: indexPath.row)

      if self.doers.count == 0 {
        self.doersTableView.isHidden = true
        self.doersHeightConstraint.constant = 70
        self.doersCollapsedButton.isHidden = true
      } else {
        self.resizeViewAndTableView(
          viewHeightConstraint: self.doersHeightConstraint,
          tableViewHeightConstraint: self.doersTableViewHeightConstraint,
          tableView: self.doersTableView)
        self.showEntitiesNumber(
          entities: self.doers,
          constraint: self.doersHeightConstraint,
          numberLabel: self.doersNumber,
          addEntityButton: self.addEntitiesButton)
      }
      self.doersTableView.reloadData()
    }))
    self.present(alert, animated: true)
  }
}
