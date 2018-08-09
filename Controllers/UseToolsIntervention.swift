//
//  UseToolsInIntervention.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 08/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

extension AddInterventionViewController {

  @IBAction func selectTools(_ sender: Any) {
    dimView.isHidden = false
    selectToolsView.isHidden = false
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = .black
    })
  }

  @IBAction func openCreateToolsView(_ sender: Any) {
    darkLayerView.isHidden = false
    createToolsView.isHidden = false
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = .black
    })
  }

  func fetchTools() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let toolsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tools")

    do {
      interventionTools = try managedContext.fetch(toolsFetchRequest)
      /*for data in fetchTools {
        print("Name: \(String(describing: data.value(forKey: "name")))\n")
        print("Nbr: \(String(describing: data.value(forKey: "number")))\n")
        print("type: \(String(describing: data.value(forKey: "type")))\n")
        print("Data: \(data)")
      }*/
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
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
        print("Stored")
        closeToolsCreationView(self)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    } else {
      print("Choose a type")
    }
  }
}
