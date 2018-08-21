//
//  InputsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 20/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class InputsView: UIView {
  var segmentedControl: UISegmentedControl!
  //var searchTextField: UITextField!
  var searchBar: UISearchBar!
  var createButton: UIButton!
  var label: UILabel!
  var tableView: UITableView!

  override init(frame: CGRect) {
    super.init(frame: frame)

    segmentedControl = UISegmentedControl(items: ["Semences", "Phyto.", "Fertilisants"])
    segmentedControl.selectedSegmentIndex = 0
    let font = UIFont.systemFont(ofSize: 16)
    segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
    segmentedControl.addTarget(self, action: #selector(reloadTable), for: UIControlEvents.valueChanged)
    self.addSubview(segmentedControl)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: segmentedControl, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: segmentedControl, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: segmentedControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

    searchBar = UISearchBar(frame: CGRect.zero)
    self.addSubview(searchBar)
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: segmentedControl, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: searchBar, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: searchBar, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    //NSLayoutConstraint(item: searchTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true

    /*createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("+ CRÉER UN NOUVEAU PHYTO", for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    self.addSubview(createButton)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: createButton, attribute: .top, relatedBy: .equal, toItem: searchTextField attribute: .bottom, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: createButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15).isActive = true
    NSLayoutConstraint(item: createButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
    NSLayoutConstraint(item: createButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true*/

    tableView = UITableView(frame: CGRect.zero)
    tableView.separatorInset = UIEdgeInsets.zero
    let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale)
    let line = UIView(frame: frame)
    line.backgroundColor = tableView.separatorColor
    tableView.tableHeaderView = line
    tableView.tableFooterView = UIView()
    self.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom, multiplier: 1, constant: 60).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true

    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
  }

  @objc func reloadTable() {
    tableView.reloadData()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
