//
//  ListTableViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 27/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

  // MARK: - Properties

  var delegate: WriteValueBackDelegate?
  var cellsStrings: [String]!
  var tag: Int!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.bounces = false
    tableView.separatorInset = UIEdgeInsets.zero
    tableView.tableFooterView = UIView()
  }

  // MARK: - Table view

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellsStrings.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
    let string = cellsStrings[indexPath.row]

    cell.label.text = string.localized
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.writeValueBack(tag: tag, value: cellsStrings[indexPath.row])
    self.dismiss(animated: true, completion: nil)
  }
}
