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
  var lastSelectedValue: String?
  var rawStrings: [String]!
  var tag: Int!

  override func viewDidLoad() {
    super.viewDidLoad()

    sortByLocales()
    tableView.separatorInset = UIEdgeInsets.zero
    tableView.tableFooterView = UIView()
    scrollToLastSelectedValue()
  }

  private func sortByLocales() {
    rawStrings = rawStrings.sorted(by: {
      $0.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        <
        $1.localized.lowercased().folding(options: .diacriticInsensitive, locale: .current)
    })
  }

  private func scrollToLastSelectedValue() {
    var indexPath: IndexPath!

    for index in 0..<rawStrings.count {
      if lastSelectedValue == rawStrings[index].localized {
        indexPath = IndexPath(row: index, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
        break
      }
    }
  }

  // MARK: - Table view

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rawStrings.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
    let rawString = rawStrings[indexPath.row]

    cell.label.text = rawString.localized
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.writeValueBack(tag: tag, value: rawStrings[indexPath.row])
    dismiss(animated: true, completion: nil)
  }
}
