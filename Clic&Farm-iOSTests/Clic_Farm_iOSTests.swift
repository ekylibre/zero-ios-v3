//
//  Clic_Farm_iOSTests.swift
//  Clic&Farm-iOSTests
//
//  Created by Guillaume Roux on 23/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import XCTest
import CoreData
@testable import Clic_Farm_iOS

class CoreDataManager {

  let persistentContainer: NSPersistentContainer!
  let backgroundContext: NSManagedObjectContext!

  init(container: NSPersistentContainer) {
    self.persistentContainer = container
    self.backgroundContext = self.persistentContainer.newBackgroundContext()
    self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
  }

  convenience init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Can not get shared app delegate")
    }
    self.init(container: appDelegate.persistentContainer)
  }

  // MARK: - CRUD

  func insertPerson(firstName: String, lastName: String) -> Person? {
    let person = Person(context: backgroundContext)
    person.firstName = firstName
    person.lastName = lastName

    do {
      try backgroundContext.save()
    } catch {
      print("Could not save \(error)")
    }
    return person
  }

  func fetchAll() -> [Person] {
    let request: NSFetchRequest<Person> = Person.fetchRequest()
    let results = try? persistentContainer.viewContext.fetch(request)
    return results ?? [Person]()
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

class Clic_Farm_iOSTests: XCTestCase {

  var sut: CoreDataManager!
  lazy var managedObjectModel: NSManagedObjectModel = {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
    return managedObjectModel
  }()

  lazy var mockPersistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MockedContainer", managedObjectModel: self.managedObjectModel)
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { (description, error) in
      precondition(description.type == NSInMemoryStoreType)

      if let error = error {
        fatalError("Create an in-mem coordinator failed \(error)")
      }
    }
    return container
  }()

  // MARK: - Stubs

  func initStubs() {

    func insertPerson(firstName: String, lastName: String) {
      let person = Person(context: mockPersistentContainer.viewContext)
      person.firstName = firstName
      person.lastName = lastName

      do {
        try mockPersistentContainer.viewContext.save()
      } catch {
        print("Could not save \(error)")
      }
    }

    insertPerson(firstName: "A", lastName: "1")
    insertPerson(firstName: "B", lastName: "2")
    insertPerson(firstName: "C", lastName: "3")
    insertPerson(firstName: "D", lastName: "4")
    insertPerson(firstName: "E", lastName: "5")

    do {
      try mockPersistentContainer.viewContext.save()
    } catch {
      print("Could not save \(error)")
    }
  }

  func flushData() {
    let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
    let objects = try! mockPersistentContainer.viewContext.fetch(fetchRequest)

    for object in objects {
      mockPersistentContainer.viewContext.delete(object)
    }
    try! mockPersistentContainer.viewContext.save()
  }

  // MARK: - Setup

  override func setUp() {
    super.setUp()
    initStubs()
    sut = CoreDataManager(container: mockPersistentContainer)
  }

  override func tearDown() {
    sut = nil
    flushData()
    super.tearDown()
  }

  // MARK: - Tests

  func testCreatePerson() {
    //Given the firstName & lastName
    let firstName = "Z"
    let lastName = "26"

    //When add person
    let person = sut.insertPerson(firstName: firstName, lastName: lastName)

    //Assert: return person
    XCTAssertNotNil(person)

  }

  func testFetchAllPersons() {

    //Given a storage with two todo
    //When fetch
    let results = sut.fetchAll()

    //Assert return five todo items
    XCTAssertEqual(results.count, 5)

  }

  func testRemovePerson() {

    //Given a item in persistent store
    let items = sut.fetchAll()
    let item = items[0]

    let numberOfItems = items.count

    //When remove a item
    sut.remove(objectID: item.objectID)
    sut.save()

    //Assert number of item - 1
    XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfItems - 1)

  }

  //Convenient method for getting the number of data in store now
  func numberOfItemsInPersistentStore() -> Int {
    let request: NSFetchRequest<Person> = Person.fetchRequest()
    let results = try! mockPersistentContainer.viewContext.fetch(request)
    return results.count
  }
}
