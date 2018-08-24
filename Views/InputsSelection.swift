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
    tableView.backgroundColor = AppColor.ThemeColors.DarkWhite
    tableView.layer.cornerRadius = 5
    tableView.layer.borderWidth  = 0.5
    tableView.layer.borderColor = UIColor.lightGray.cgColor
    tableView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(tableView)

    let viewsDict = [
      "tableView": tableView
      ] as [String: Any]

    self.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|-20-[tableView]-20-|",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )

    self.addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|[tableView]-20-|",
        options: [],
        metrics: nil,
        views: viewsDict
      )
    )
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
