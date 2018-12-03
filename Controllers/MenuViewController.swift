//
//  MenuViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 03/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

  var commands: [Command]!

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    initializeCommands()
    tableView.register(CommandCell.self, forCellReuseIdentifier: "CommandCell")
    tableView.rowHeight = 50
    tableView.delegate = self
    tableView.dataSource = self
  }

  private func initializeCommands() {
    let termsCommand = Command(name: "privacy_policy", assetName: "doc", closure: test)
    let logoutCommand = Command(name: "logout", assetName: "logout", closure: logout)

    commands = [termsCommand, logoutCommand]
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

    cell.commandImageView.image = UIImage(named: command.assetName)
    cell.commandLabel.text = command.name.localized
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let command = commands[indexPath.row]

    command.closure()
  }

  // MARK: - Actions

  private func test() -> Void {
    print("cgu")
  }

  private func logout() -> Void {
    print("logout")
  }
}
