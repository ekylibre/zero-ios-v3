//
//  Users+CoreDataProperties.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 23/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//
//

import Foundation
import CoreData

extension Users {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
    return NSFetchRequest<Users>(entityName: "Users")
  }
  
  @NSManaged public var userName: String?
  @NSManaged public var loggedStatus: Bool
}
