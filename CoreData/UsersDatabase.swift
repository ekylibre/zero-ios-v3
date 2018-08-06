//
//  AuthentificationDatabase.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 23/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class UsersDatabase: UIViewController {

  // MARK: Properties

  let appDelegate = UIApplication.shared.delegate as! AppDelegate

  // MARK: Actions

  func emptyEntity(entity: String) {
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        context.delete(data)
      }
      try context.save()
    } catch {
      print("Remove failed")
    }
  }

  func entityIsEmpty(entity: String) -> Bool {
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      if result.count == 0 {
        return true
      }
    } catch {
      print("Fetch failed")
    }
    return false
  }

  func fetchData(entity: String, dataToFetch: String) {
    let context = appDelegate.persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

    request.returnsObjectsAsFaults = false
    do {
      let result = try context.fetch(request)
      for data in result as! [NSManagedObject] {
        print(data.value(forKey: dataToFetch) as! String)
      }
      appDelegate.saveContext()
    } catch {
      print("Fetch failed")
    }
  }
}
