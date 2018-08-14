//
//  UseToolsInIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController: SelectedToolsTableViewCellDelegate {
  func removeCellButton(_ indexPath: Int) {
    let alert = UIAlertController(title: "", message: "Êtes-vous sûr de vouloir supprimer l'outil ?", preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
      self.selectedTools.remove(at: indexPath)
      self.selectedToolsTableView.reloadData()
    }))
    present(alert, animated: true)
    if selectedTools.count == 0 && firstView.frame.height != 50 {
      collapseExpand(self)
      collapseButton.isHidden = true
    }
  }

  func defineToolTypes() {
    toolTypes = ["Semoir monograines", "Presse enrubanneuse", "Castreuse", "Presse balle cubique",
                 "Déchaumeur à disques", "Plateau", "Ensileuse", "Broyeur", "Herse", "Arracheuse",
                 "Andaineur", "Butteuse", "Bineuse", "Désherbineuse", "Planteuse", "Tonne à lisier",
                 "Faucheuse", "Faucheuse conditioneuse", "Charrue", "Moissonneuse-batteuse", "Rouleau",
                 "Houe rotative", "Presse balle ronde", "Outil de préparation du lit de semences",
                 "Décompacteur", "Semoir", "Pulvérisateur", "Épandeur à engrais", "Épandeur à fumier",
                 "Sous soleuse", "Déchaumeur", "Faneuse", "Effaneuse", "Tracteur", "Remorque", "Écimeuse",
                 "Vibroculteur", "Désherbeur", "Enrubanneuse"]
  }

  func showToolsNumber() {
    if selectedTools.count > 0 && firstView.frame.height == 50 {
      addToolButton.isHidden = true
      toolNumberLabel.isHidden = false
      toolNumberLabel.text = (selectedTools.count == 1 ? "1 outil" : "\(selectedTools.count) outils")
    } else {
      addToolButton.isHidden = false
      toolNumberLabel.isHidden = true
    }
  }

  @IBAction func openSelectToolsView(_ sender: Any) {
    dimView.isHidden = false
    selectToolsView.isHidden = false
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = .black
    })
  }

  func showToolType(indexPath: IndexPath) {
    print("Tool type: \(toolTypes[indexPath.row])")
  }

  func closeSelectToolsView() {
    dimView.isHidden = true
    selectToolsView.isHidden = true
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = .black
    })
    if selectedTools.count > 0 && firstView.frame.height == 50 {
      collapseExpand(self)
    }
    selectedToolsTableView.reloadData()
  }

  @IBAction func openCreateToolsView(_ sender: Any) {
    darkLayerView.isHidden = false
    createToolsView.isHidden = false
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = .black
    })
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchedTools = searchText.isEmpty ? interventionTools : interventionTools.filter({(filterTool: NSManagedObject) -> Bool in
      let toolName: String = filterTool.value(forKey: "name") as! String
      return toolName.range(of: searchText) != nil
    })
    interventionToolsTableView.reloadData()
  }

  func fetchTools() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let toolsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tools")

    do {
      interventionTools = try managedContext.fetch(toolsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    searchedTools = interventionTools
    interventionToolsTableView.reloadData()
  }

  @IBAction func closeToolsCreationView(_ sender: Any) {
    toolName.text = nil
    toolNumber.text = nil
    darkLayerView.isHidden = true
    createToolsView.isHidden = true
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = .black
    })
    fetchTools()
  }

  @IBAction func createNewTool(_ sender: Any) {
    if (toolType.text?.count)! > 0 {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      let managedContext = appDelegate.persistentContainer.viewContext
      let toolsEntity = NSEntityDescription.entity(forEntityName: "Tools", in: managedContext)!
      let tools = NSManagedObject(entity: toolsEntity, insertInto: managedContext)

      tools.setValue(toolName.text, forKeyPath: "name")
      tools.setValue(toolNumber.text, forKeyPath: "number")
      tools.setValue(toolType.text, forKeyPath: "type")
      do {
        try managedContext.save()
        interventionTools.append(tools)
        closeToolsCreationView(self)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    } else {
      print("Choose a type")
    }
  }
}
