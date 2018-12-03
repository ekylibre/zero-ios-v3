//
//  MenuViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 03/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UITableViewController {

  var commands: [Command]!

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    initializeCommands()
    setupTableView()
  }

  private func initializeCommands() {
    let termsCommand = Command(name: "privacy_policy", assetName: "doc", closure: test)
    let logoutCommand = Command(name: "logout", assetName: "logout", closure: presentLogoutAlert)

    commands = [termsCommand, logoutCommand]
  }

  private func setupTableView() {
    tableView.register(CommandCell.self, forCellReuseIdentifier: "CommandCell")
    tableView.rowHeight = 50
    tableView.tableFooterView = UIView()
    tableView.delegate = self
    tableView.dataSource = self
  }

  // MARK: - Table view

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commands.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CommandCell", for: indexPath) as! CommandCell
    let command = commands[indexPath.row]

    cell.commandImageView.image = UIImage(named: command.assetName)?.withRenderingMode(.alwaysTemplate)
    cell.commandLabel.text = command.name.localized
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let command = commands[indexPath.row]

    command.closure()
  }

  // MARK: - Actions

  private func test() {
    print("cgu")
  }

  // MARK: - Logout

  private func presentLogoutAlert() {
    let alert = UIAlertController(title: "disconnect_prompt".localized, message: nil, preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
    let logoutAction = UIAlertAction(title: "logout".localized, style: .destructive, handler: { action in
      self.logoutUser()
    })

    alert.addAction(cancelAction)
    alert.addAction(logoutAction)
    present(alert, animated: true)
  }

  private func logoutUser() {
    let authentificationService = AuthentificationService(username: "", password: "")

    authentificationService.logout()
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
    emptyAllCoreData()
    navigationController?.popViewController(animated: true)
  }

  private func emptyAllCoreData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let entityNames = appDelegate.persistentContainer.managedObjectModel.entities.map({ (entity) -> String in
      return entity.name!
    })

    for entityName in entityNames {
      batchDeleteEntity(name: entityName)
    }
  }

  private func batchDeleteEntity(name: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
    let request = NSBatchDeleteRequest(fetchRequest: fetch)

    do {
      try managedContext.execute(request)
    } catch let error as NSError {
      print("Could not remove data. \(error), \(error.userInfo)")
    }
  }
}
