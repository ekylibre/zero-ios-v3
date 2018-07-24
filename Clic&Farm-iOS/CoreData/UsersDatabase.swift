//
//  AuthentificationDatabase.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 23/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class UsersDatabase: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

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

    func addNewUser(userName: String) {
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context) as! Users

        newUser.userName = userName
        appDelegate.saveContext()
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
