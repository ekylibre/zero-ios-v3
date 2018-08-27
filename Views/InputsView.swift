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
  var searchBar: UISearchBar!
  var createButton: UIButton!
  var tableView: UITableView!
  var dimView: UIView!
  var seedView: CreateSeedView!
  var phytoView: CreatePhytoView!
  var fertilizerView: CreateFertilizerView!

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.isHidden = true
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true

    segmentedControl = UISegmentedControl(items: ["Semences", "Phyto.", "Fertilisants"])
    segmentedControl.selectedSegmentIndex = 0
    let font = UIFont.systemFont(ofSize: 16)
    segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
    segmentedControl.addTarget(self, action: #selector(changeSegment), for: UIControlEvents.valueChanged)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false

    self.addSubview(segmentedControl)

    searchBar = UISearchBar(frame: CGRect.zero)
    searchBar.searchBarStyle = .minimal
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(searchBar)

    createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("+ CRÉER UNE NOUVELLE SEMENCE", for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(createButton)

    tableView = UITableView(frame: CGRect.zero)
    tableView.separatorInset = UIEdgeInsets.zero
    let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale)
    let line = UIView(frame: frame)
    line.backgroundColor = tableView.separatorColor
    tableView.tableHeaderView = line
    tableView.tableFooterView = UIView()
    tableView.bounces = false
    tableView.register(SeedsTableViewCell.self, forCellReuseIdentifier: "SeedsCell")
    tableView.register(PhytosTableViewCell.self, forCellReuseIdentifier: "PhytosCell")
    tableView.register(FertilizersTableViewCell.self, forCellReuseIdentifier: "FertilizersCell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(tableView)

    let viewsDict = [
      "segmented" : segmentedControl,
      "searchbar" : searchBar,
      "button" : createButton,
      "table" : tableView,
      ] as [String : Any]

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[segmented]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[searchbar]-20-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[button]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[segmented]-15-[searchbar]-15-[button]-15-[table]|", options: [], metrics: nil, views: viewsDict))

    dimView = UIView(frame: CGRect.zero)
    dimView.backgroundColor = UIColor.black
    dimView.alpha = 0.6
    dimView.isHidden = true
    dimView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(dimView)
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimview]|", options: [], metrics: nil, views: ["dimview" : dimView]))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimview]|", options: [], metrics: nil, views: ["dimview" : dimView]))

    seedView = CreateSeedView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    seedView.cancelButton.addTarget(self, action: #selector(hideDimView), for: .touchUpInside)
    seedView.createButton.addTarget(self, action: #selector(hideDimView), for: .touchUpInside)
    seedView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(seedView)
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[seedview]|", options: [], metrics: nil, views: ["seedview" : seedView]))
    NSLayoutConstraint(item: seedView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250).isActive = true
    NSLayoutConstraint(item: seedView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    phytoView = CreatePhytoView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    phytoView.cancelButton.addTarget(self, action: #selector(hideDimView), for: .touchUpInside)
    phytoView.createButton.addTarget(self, action: #selector(hideDimView), for: .touchUpInside)
    phytoView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(phytoView)
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[phytoview]|", options: [], metrics: nil, views: ["phytoview" : phytoView]))
    NSLayoutConstraint(item: phytoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 340).isActive = true
    NSLayoutConstraint(item: phytoView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    fertilizerView = CreateFertilizerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fertilizerView.cancelButton.addTarget(self, action: #selector(hideDimView), for: .touchUpInside)
    fertilizerView.createButton.addTarget(self, action: #selector(hideDimView), for: .touchUpInside)
    fertilizerView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(fertilizerView)
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[fertilizerview]|", options: [], metrics: nil, views: ["fertilizerview" : fertilizerView]))
    NSLayoutConstraint(item: fertilizerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 230).isActive = true
    NSLayoutConstraint(item: fertilizerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.endEditing(true)
  }

  @objc func changeSegment() {
    if segmentedControl.selectedSegmentIndex == 0 {
      createButton.setTitle("+ CRÉER UNE NOUVELLE SEMENCE", for: .normal)
    } else if segmentedControl.selectedSegmentIndex == 1 {
      createButton.setTitle("+ CRÉER UN NOUVEAU PHYTO", for: .normal)
    } else {
      createButton.setTitle("+ CRÉER UN NOUVEAU FERTILISANT", for: .normal)
    }
    tableView.reloadData()
  }

  @objc func tapCreateButton() {
    dimView.isHidden = false
    if segmentedControl.selectedSegmentIndex == 0 {
      seedView.isHidden = false
    } else if segmentedControl.selectedSegmentIndex == 1 {
      phytoView.isHidden = false
    } else {
      fertilizerView.isHidden = false
    }
  }

  @objc func hideDimView() {
    dimView.isHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
