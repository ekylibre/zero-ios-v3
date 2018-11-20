//
//  StorageManager.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 15/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class StorageManager {

  let persistentContainer: NSPersistentContainer!
  lazy var backgroundContext = persistentContainer.newBackgroundContext()

  init(container: NSPersistentContainer) {
    self.persistentContainer = container
    self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
  }

  convenience init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Can not get shared app delegate")
    }
    self.init(container: appDelegate.persistentContainer)
  }

  // MARK: - CRUD

  func insertObject(entityName: String) -> NSManagedObject {
    return NSEntityDescription.insertNewObject(forEntityName: entityName, into: backgroundContext)
  }

  func fetchAllObjects(entityName: String) -> [NSManagedObject] {
    let request = NSFetchRequest<NSManagedObject>(entityName: entityName)

    do {
      return try persistentContainer.viewContext.fetch(request)
    } catch {
      print("Could not fetch \(error)")
    }
    return [NSManagedObject]()
  }

  func remove(objectID: NSManagedObjectID) {
    let object = backgroundContext.object(with: objectID)
    backgroundContext.delete(object)
  }

  func save() {
    if backgroundContext.hasChanges {
      do {
        try backgroundContext.save()
      } catch {
        print("Could not save \(error)")
      }
    }
  }
}
