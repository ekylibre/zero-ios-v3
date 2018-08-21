//
//  InputSelection.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 21/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class InputsSelection: UIView {
  var tableView: UITableView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    tableView = UITableView(frame: CGRect.zero)
    tableView.separatorInset = UIEdgeInsets.zero
    let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale)
    let line = UIView(frame: frame)
    line.backgroundColor = tableView.separatorColor
    tableView.tableHeaderView = line
    tableView.tableFooterView = UIView()
    self.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 20).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 20).isActive = true
  }

  @objc func reloadTable() {
    tableView.reloadData()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
