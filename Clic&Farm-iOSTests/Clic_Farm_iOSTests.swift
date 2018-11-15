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

class Clic_Farm_iOSTests: XCTestCase {

  var sut: StorageManager!
  lazy var managedObjectModel: NSManagedObjectModel = {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
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

  override func setUp() {
    super.setUp()
    initStubs()
    sut = StorageManager(container: mockPersistentContainer)
    NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)),
                                           name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
  }

  override func tearDown() {
    flushData()
    sut = nil
    super.tearDown()
  }

  func test_insertPerson() {
    //Given
    let firstName = "Z"
    let lastName = "26"

    //When
    let person = sut.insertObject(entityName: "Person") as! Person
    person.firstName = firstName
    person.lastName = lastName

    //Then
    XCTAssertNotNil(person)
  }

  func test_fetchAllPersons() {
    //When
    let results = sut.fetchAllObjects(entityName: "Person")

    //Then
    XCTAssertEqual(results.count, 5)
  }

  func test_removePerson() {
    //Given
    let persons = sut.fetchAllObjects(entityName: "Person")
    let person = persons[0]
    let numberOfPersons = persons.count

    //When
    sut.remove(objectID: person.objectID)
    sut.save()

    //Then
    XCTAssertEqual(numberOfItemsInPersistentStore(), numberOfPersons - 1)
  }

  func test_save() {
    //Given
    let firstName = "Y"
    let lastName = "25"

    let expect = expectation(description: "Context Saved")

    waitForSavedNotification { (notification) in
      expect.fulfill()
    }

    //When
    let person = sut.insertObject(entityName: "Person") as! Person
    person.firstName = firstName
    person.lastName = lastName
    XCTAssertNotNil(person, "person must not be nil")
    sut.save()

    //Assert
    waitForExpectations(timeout: 1, handler: nil)
  }

  //Convenient method for getting the number of data in store now
  func numberOfItemsInPersistentStore() -> Int {
    let request: NSFetchRequest<Person> = Person.fetchRequest()
    let results = try! mockPersistentContainer.viewContext.fetch(request)
    return results.count
  }

  var saveNotificationCompleteHandler: ((Notification) -> ())?

  func waitForSavedNotification(completeHandler: @escaping ((Notification) -> ())) {
    saveNotificationCompleteHandler = completeHandler
  }

  func contextSaved(notification: Notification) {
    saveNotificationCompleteHandler?(notification)
  }
}
