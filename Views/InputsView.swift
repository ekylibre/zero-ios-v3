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
  var searchTextField: UITextField!
  var createButton: UIButton!
  var tableView: UITableView!
  var dimView: UIView!
  var seedView: createSeedView!

  override init(frame: CGRect) {
    super.init(frame: frame)

    segmentedControl = UISegmentedControl(items: ["Semences", "Phyto.", "Fertilisants"])
    segmentedControl.selectedSegmentIndex = 0
    let font = UIFont.systemFont(ofSize: 16)
    segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
    segmentedControl.addTarget(self, action: #selector(changeSegment), for: UIControlEvents.valueChanged)
    self.addSubview(segmentedControl)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false

    searchTextField = UITextField(frame: CGRect.zero)
    searchTextField.layer.cornerRadius = 13
    searchTextField.layer.borderWidth = 0.5
    searchTextField.layer.borderColor = UIColor.lightGray.cgColor
    searchTextField.clearButtonMode = .whileEditing
    self.addSubview(searchTextField)
    searchTextField.translatesAutoresizingMaskIntoConstraints = false

    createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("+ CRÉER UNE NOUVELLE SEMENCE", for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
    self.addSubview(createButton)
    createButton.translatesAutoresizingMaskIntoConstraints = false

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
    self.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false

    let viewsDict = [
      "segmented" : segmentedControl,
      "textfield" : searchTextField,
      "button" : createButton,
      "table" : tableView,
      ] as [String : Any]

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[segmented]-15-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[textfield]-20-|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[button]", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[table]|", options: [], metrics: nil, views: viewsDict))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[segmented]-15-[textfield(40)]-15-[button]-15-[table]|", options: [], metrics: nil, views: viewsDict))

    dimView = UIView(frame: CGRect.zero)
    dimView.backgroundColor = UIColor.black
    dimView.alpha = 0.6
    dimView.isHidden = true
    self.addSubview(dimView)
    dimView.translatesAutoresizingMaskIntoConstraints = false
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimview]|", options: [], metrics: nil, views: ["dimview" : dimView]))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimview]|", options: [], metrics: nil, views: ["dimview" : dimView]))

    seedView = createSeedView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    self.addSubview(seedView)
    seedView.isHidden = true
    seedView.translatesAutoresizingMaskIntoConstraints = false
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[seedview]|", options: [], metrics: nil, views: ["seedview" : seedView]))
    NSLayoutConstraint(item: seedView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
    NSLayoutConstraint(item: seedView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true


    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.isHidden = true
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
      return
    } else {
      return
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoder has not been implemented.")
  }
}
