//
//  InputsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 20/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class InputsView: UIView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

  //MARK: - Properties

  lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: ["Semences", "Phyto.", "Fertilisants"])
    segmentedControl.selectedSegmentIndex = 0
    let font = UIFont.systemFont(ofSize: 16)
    segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    return segmentedControl
  }()

  var isSearching: Bool = false

  lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar(frame: CGRect.zero)
    searchBar.searchBarStyle = .minimal
    searchBar.autocapitalizationType = .none
    searchBar.delegate = self
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    return searchBar
  }()

  lazy var createButton: UIButton = {
    let createButton = UIButton(frame: CGRect.zero)
    createButton.setTitle("+ CRÉER UNE NOUVELLE SEMENCE", for: .normal)
    createButton.setTitleColor(AppColor.TextColors.Green, for: .normal)
    createButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    createButton.translatesAutoresizingMaskIntoConstraints = false
    return createButton
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.separatorInset = UIEdgeInsets.zero
    let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1 / UIScreen.main.scale)
    let line = UIView(frame: frame)
    line.backgroundColor = tableView.separatorColor
    tableView.tableHeaderView = line
    tableView.tableFooterView = UIView()
    tableView.bounces = false
    tableView.register(SeedCell.self, forCellReuseIdentifier: "SeedCell")
    tableView.register(PhytoCell.self, forCellReuseIdentifier: "PhytoCell")
    tableView.register(FertilizerCell.self, forCellReuseIdentifier: "FertilizerCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  lazy var dimView: UIView = {
    let dimView = UIView(frame: CGRect.zero)
    dimView.backgroundColor = UIColor.black
    dimView.alpha = 0.6
    dimView.isHidden = true
    dimView.translatesAutoresizingMaskIntoConstraints = false
    return dimView
  }()

  lazy var seedView: CreateSeedView = {
    let seedView = CreateSeedView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    seedView.translatesAutoresizingMaskIntoConstraints = false
    return seedView
  }()

  lazy var phytoView: CreatePhytoView = {
    let phytoView = CreatePhytoView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    phytoView.translatesAutoresizingMaskIntoConstraints = false
    return phytoView
  }()

  lazy var fertilizerView: CreateFertilizerView = {
    let fertilizerView = CreateFertilizerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fertilizerView.translatesAutoresizingMaskIntoConstraints = false
    return fertilizerView
  }()

  var sampleSeeds = [["Variété 1", "Espèce 1"], ["Variété 2", "Espèce 2"]]
  var samplePhytos = [["Nom 1", "Marque 1", "1000", "1 heures"], ["Nom 2", "Marque 2", "2000", "2 heures"], ["Nom 3", "Marque 3", "3000", "3 heures"]]
  var sampleFertilizers = [["Nom 1", "Nature 1"], ["Nom 2", "Nature 2"], ["Nom 3", "Nature 3"], ["Nom 4", "Nature 4"]]
  var filteredInputs: [[String]]!

  //MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  private func setupView() {
    self.isHidden = true
    self.backgroundColor = UIColor.white
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.addSubview(segmentedControl)
    self.addSubview(searchBar)
    self.addSubview(createButton)
    self.addSubview(tableView)
    self.addSubview(dimView)
    self.addSubview(seedView)
    self.addSubview(phytoView)
    self.addSubview(fertilizerView)
    setupLayout()
    setupActions()
  }

  private func setupLayout() {
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

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimview]|", options: [], metrics: nil, views: ["dimview" : dimView]))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimview]|", options: [], metrics: nil, views: ["dimview" : dimView]))

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[seedview]|", options: [], metrics: nil, views: ["seedview" : seedView]))
    NSLayoutConstraint(item: seedView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250).isActive = true
    NSLayoutConstraint(item: seedView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[phytoview]|", options: [], metrics: nil, views: ["phytoview" : phytoView]))
    NSLayoutConstraint(item: phytoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 340).isActive = true
    NSLayoutConstraint(item: phytoView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[fertilizerview]|", options: [], metrics: nil, views: ["fertilizerview" : fertilizerView]))
    NSLayoutConstraint(item: fertilizerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 230).isActive = true
    NSLayoutConstraint(item: fertilizerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
  }

  private func setupActions() {
    segmentedControl.addTarget(self, action: #selector(changeSegment), for: UIControlEvents.valueChanged)
    createButton.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
    seedView.cancelButton.addTarget(self, action: #selector(hideDimView), for: .touchUpInside)
    seedView.createButton.addTarget(self, action: #selector(createInput), for: .touchUpInside)
    phytoView.cancelButton.addTarget(self, action: #selector(hideDimView), for: .touchUpInside)
    phytoView.createButton.addTarget(self, action: #selector(createInput), for: .touchUpInside)
    fertilizerView.cancelButton.addTarget(self, action: #selector(hideDimView), for: .touchUpInside)
    fertilizerView.createButton.addTarget(self, action: #selector(createInput), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Table view

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSearching {
      return filteredInputs.count
    }

    var countToUse = [0: sampleSeeds.count, 1: samplePhytos.count, 2: sampleFertilizers.count]
    return countToUse[segmentedControl.selectedSegmentIndex] ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SeedCell", for: indexPath) as! SeedCell
      let fromSeeds = isSearching ? filteredInputs! : sampleSeeds

      cell.varietyLabel.text = fromSeeds[indexPath.row][0]
      cell.specieLabel.text = fromSeeds[indexPath.row][1]
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhytoCell", for: indexPath) as! PhytoCell
      let fromPhytos = isSearching ? filteredInputs! : samplePhytos

      cell.nameLabel.text = fromPhytos[indexPath.row][0]
      cell.firmNameLabel.text = fromPhytos[indexPath.row][1]
      cell.maaIDLabel.text = fromPhytos[indexPath.row][2]
      cell.inFieldReentryDelayLabel.text = fromPhytos[indexPath.row][3]
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "FertilizerCell", for: indexPath) as! FertilizerCell
      let fromFertilizers = isSearching ? filteredInputs! : sampleFertilizers

      cell.nameLabel.text = fromFertilizers[indexPath.row][0]
      cell.natureLabel.text = fromFertilizers[indexPath.row][1]
      return cell
    default:
      fatalError("Switch error")
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if segmentedControl.selectedSegmentIndex == 1 {
      return 100
    }

    return 60
  }

  //MARK: - Search bar

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearching = true
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let inputs = [0: sampleSeeds, 1: samplePhytos, 2: sampleFertilizers]
    let inputsToUse = inputs[segmentedControl.selectedSegmentIndex]!
    filteredInputs = searchText.isEmpty ? inputsToUse : inputsToUse.filter({(input: [String]) -> Bool in
      let name: String = input[0]
      return name.range(of: searchText, options: .caseInsensitive) != nil
    })
    isSearching = (searchText.isEmpty ? false : true)
    createButton.isHidden = isSearching
    tableView.reloadData()
  }

  //MARK: - Actions

  @objc func changeSegment() {
    let searchText = searchBar.text!

    let createButtonTitles = [0: "+ CRÉER UNE NOUVELLE SEMENCE", 1: "+ CRÉER UN NOUVEAU PHYTO", 2: "+ CRÉER UN NOUVEAU FERTILISANT"]
    createButton.setTitle(createButtonTitles[segmentedControl.selectedSegmentIndex], for: .normal)
    let inputs = [0: sampleSeeds, 1: samplePhytos, 2: sampleFertilizers]
    let inputsToUse = inputs[segmentedControl.selectedSegmentIndex]!
    filteredInputs = searchText.isEmpty ? inputsToUse : inputsToUse.filter({(input: [String]) -> Bool in
      let name: String = input[0]
      return name.range(of: searchText, options: .caseInsensitive) != nil
    })
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

  @objc func createInput() {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      sampleSeeds.append([seedView.varietyTextField.text!, seedView.specieButton.titleLabel!.text!])
      seedView.specieButton.setTitle("Avoine", for: .normal)
      seedView.varietyTextField.text = ""
      tableView.reloadData()
    case 1:
      samplePhytos.append([phytoView.nameTextField.text!, phytoView.firmNameTextField.text!, phytoView.maaTextField.text!, phytoView.reentryDelayTextField.text! + " heures"])
      for subview in phytoView.subviews {
        if subview is UITextField {
          let textField = subview as! UITextField
          textField.text = ""
        }
      }
      tableView.reloadData()
    case 2:
      sampleFertilizers.append([fertilizerView.nameTextField.text!, fertilizerView.natureButton.titleLabel!.text!])
      fertilizerView.nameTextField.text = ""
      fertilizerView.natureButton.setTitle("Organique", for: .normal)
      tableView.reloadData()
    default:
      return
    }
    dimView.isHidden = true
  }

  @objc func hideDimView() {
    dimView.isHidden = true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.endEditing(true)
  }
}
