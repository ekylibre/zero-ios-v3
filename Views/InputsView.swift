//
//  InputsView.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 20/08/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class InputsView: UIView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

  //MARK: - Properties

  var addInterventionViewController: AddInterventionViewController?

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

  var tableViewTopAnchor: NSLayoutConstraint!

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

  var seeds = [NSManagedObject]()
  var phytos = [NSManagedObject]()
  var fertilizers = [NSManagedObject]()
  var filteredInputs = [NSManagedObject]()

  //MARK: - Initialization

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    if !fetchInputs() {
      loadRegisteredInputs()
      tableView.reloadData()
    }
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
    tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 60)

    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      segmentedControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      segmentedControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
      searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15),
      searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
      searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
      createButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15),
      createButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      tableViewTopAnchor,
      tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      tableView.widthAnchor.constraint(equalTo: self.widthAnchor),
      tableView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
      ])

    bindFrameToSuperViewBounds(dimView, height: 0)
    bindFrameToSuperViewBounds(seedView, height: 250)
    bindFrameToSuperViewBounds(phytoView, height: 340)
    bindFrameToSuperViewBounds(fertilizerView, height: 230)
  }

  private func bindFrameToSuperViewBounds(_ view: UIView, height: CGFloat) {
    let customHeightAnchor: NSLayoutConstraint
    if height > 0 {
      customHeightAnchor = view.heightAnchor.constraint(equalToConstant: height)
    } else {
      customHeightAnchor = view.heightAnchor.constraint(equalTo: view.superview!.heightAnchor)
    }

    NSLayoutConstraint.activate([
      customHeightAnchor,
      view.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      view.widthAnchor.constraint(equalTo: self.widthAnchor),
      view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      ])
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

    var countToUse = [0: seeds.count, 1: phytos.count, 2: fertilizers.count]
    return countToUse[segmentedControl.selectedSegmentIndex] ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SeedCell", for: indexPath) as! SeedCell
      let fromSeeds = isSearching ? filteredInputs : seeds

      cell.varietyLabel.text = fromSeeds[indexPath.row].value(forKey: "variety") as? String
      cell.specieLabel.text = fromSeeds[indexPath.row].value(forKey: "specie") as? String
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhytoCell", for: indexPath) as! PhytoCell
      let fromPhytos = isSearching ? filteredInputs : phytos

      cell.nameLabel.text = fromPhytos[indexPath.row].value(forKey: "name") as? String
      cell.firmNameLabel.text = fromPhytos[indexPath.row].value(forKey: "firmName") as? String
      cell.maaIDLabel.text = fromPhytos[indexPath.row].value(forKey: "maaID") as? String
      let reentryDelay = fromPhytos[indexPath.row].value(forKey: "reentryDelay") as! Int
      let unit: String = reentryDelay > 1 ? "heures" : "heure"
      cell.inFieldReentryDelayLabel.text = "\(reentryDelay) " + unit
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "FertilizerCell", for: indexPath) as! FertilizerCell
      let fromFertilizers = isSearching ? filteredInputs : fertilizers

      cell.nameLabel.text = fromFertilizers[indexPath.row].value(forKey: "name") as? String
      cell.natureLabel.text = fromFertilizers[indexPath.row].value(forKey: "nature") as? String
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

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      let cell = tableView.cellForRow(at: indexPath) as! SeedCell

      if cell.isAvaible {
        cell.isAvaible = false
        cell.backgroundColor = AppColor.CellColors.lightGray
        addInterventionViewController?.selectedInputs.append(seeds[indexPath.row])
        addInterventionViewController?.selectedInputs[(addInterventionViewController?.selectedInputs.count)! - 1].setValue(indexPath.row, forKey: "row")
      }
    case 1:
      let cell = tableView.cellForRow(at: indexPath) as! PhytoCell

      if cell.isAvaible {
        cell.isAvaible = false
        cell.backgroundColor = AppColor.CellColors.lightGray
        addInterventionViewController?.selectedInputs.append(phytos[indexPath.row])
        addInterventionViewController?.selectedInputs[(addInterventionViewController?.selectedInputs.count)! - 1].setValue(indexPath.row, forKey: "row")
      }
    case 2:
      let cell = tableView.cellForRow(at: indexPath) as! FertilizerCell

      if cell.isAvaible {
        cell.isAvaible = false
        cell.backgroundColor = AppColor.CellColors.lightGray
        addInterventionViewController?.selectedInputs.append(fertilizers[indexPath.row])
        addInterventionViewController?.selectedInputs[(addInterventionViewController?.selectedInputs.count)! - 1].setValue(indexPath.row, forKey: "row")
      }
    default:
      print("Error")
    }
    addInterventionViewController?.selectedInputsTableView.reloadData()
    addInterventionViewController?.closeSelectInputsView()
  }

  //MARK: - Search bar

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    isSearching = true
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let inputs = [0: seeds, 1: phytos, 2: fertilizers]
    let inputsToUse = inputs[segmentedControl.selectedSegmentIndex]!
    filteredInputs = searchText.isEmpty ? inputsToUse : inputsToUse.filter({(input: NSManagedObject) -> Bool in
      let key: String = segmentedControl.selectedSegmentIndex == 0 ? "variety" : "name"
      let name: String = input.value(forKey: key) as! String
      return name.range(of: searchText, options: .caseInsensitive) != nil
    })
    isSearching = !searchText.isEmpty
    createButton.isHidden = isSearching
    tableViewTopAnchor.constant = isSearching ? 15 : 60
    tableView.reloadData()
    tableView.layoutIfNeeded()
    tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
  }

  //MARK: - Core Data

  private func fetchInputs() -> Bool {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return false
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let seedsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Seeds")
    let phytosFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Phytos")
    let fertilizersFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fertilizers")

    do {
      seeds = try managedContext.fetch(seedsFetchRequest)
      phytos = try managedContext.fetch(phytosFetchRequest)
      fertilizers = try managedContext.fetch(fertilizersFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    if seeds.count < 1 || phytos.count < 1 || fertilizers.count < 1 {
      return false
    }
    return true
  }

  private func loadRegisteredInputs() {
    createSeed(variety: "Variété 1", specie: "Espèce 1")
    createSeed(variety: "Variété 2", specie: "Espèce 2")

    let assets = openAssets()
    let decoder = JSONDecoder()

    do {
      //let registeredSeeds = try decoder.decode([RegisteredSeed].self, from: assets[0].data)
      let registeredPhytos = try decoder.decode([RegisteredPhyto].self, from: assets[1].data)
      let registeredFertilizers = try decoder.decode([RegisteredFertilizer].self, from: assets[2].data)
      //saveSeeds(registeredSeeds)
      savePhytos(registeredPhytos)
      saveFertilizers(registeredFertilizers)
    } catch let jsonError {
      print(jsonError)
    }
  }

  private func openAssets() -> [NSDataAsset] {
    var assets = [NSDataAsset]()
    let assetNames = ["seeds", "phytosanitary-products", "fertilizers"]

    for assetName in assetNames {
      if let asset = NSDataAsset(name: assetName) {
        assets.append(asset)
      } else {
        fatalError(assetName + " not found")
      }
    }
    return assets
  }

  private func savePhytos(_ registeredPhytos: [RegisteredPhyto]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let phytosEntity = NSEntityDescription.entity(forEntityName: "Phytos", in: managedContext)!

    for registeredPhyto in registeredPhytos {
      let phyto = NSManagedObject(entity: phytosEntity, insertInto: managedContext)

      phyto.setValue(true, forKey: "registered")
      phyto.setValue(registeredPhyto.id, forKey: "phytoIDEky")
      phyto.setValue(registeredPhyto.name, forKey: "name")
      phyto.setValue(registeredPhyto.nature, forKey: "nature")
      phyto.setValue(registeredPhyto.maaid, forKey: "maaID")
      phyto.setValue(registeredPhyto.mixCategoryCode, forKey: "mixCategoryCode")
      phyto.setValue(registeredPhyto.inFieldReentryDelay, forKey: "reentryDelay")
      phyto.setValue(registeredPhyto.firmName, forKey: "firmName")

      phyto.setValue("Phyto", forKey: "type")
      phyto.setValue("l/ha", forKey: "unit")
      phyto.setValue(0.0, forKey: "quantity")
      phyto.setValue(0, forKey: "row")
      phytos.append(phyto)
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func saveFertilizers(_ registeredFertilizers: [RegisteredFertilizer]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let fertilizersEntity = NSEntityDescription.entity(forEntityName: "Fertilizers", in: managedContext)!

    for registeredFertilizer in registeredFertilizers {
      let fertilizer = NSManagedObject(entity: fertilizersEntity, insertInto: managedContext)

      fertilizer.setValue(true, forKey: "registered")
      fertilizer.setValue(registeredFertilizer.id, forKey: "fertilizerIDEky")
      fertilizer.setValue(registeredFertilizer.name, forKey: "name")
      fertilizer.setValue(registeredFertilizer.variant, forKey: "variant")
      fertilizer.setValue(registeredFertilizer.variety, forKey: "variety")
      fertilizer.setValue(registeredFertilizer.derivativeOf, forKey: "derivativeOf")
      fertilizer.setValue(registeredFertilizer.nature, forKey: "nature")
      fertilizer.setValue(registeredFertilizer.nitrogenConcentration, forKey: "nitrogenConcentration")
      fertilizer.setValue(registeredFertilizer.phosphorusConcentration, forKey: "phosphorusConcentration")
      fertilizer.setValue(registeredFertilizer.potassiumConcentration, forKey: "potassiumConcentration")
      fertilizer.setValue(registeredFertilizer.sulfurTrioxydeConcentration, forKey: "sulfurTrioxydeConcentration")

      fertilizer.setValue("Fertilizer", forKey: "type")
      fertilizer.setValue("l/ha", forKey: "unit")
      fertilizer.setValue(0.0, forKey: "quantity")
      fertilizer.setValue(0, forKey: "row")
      fertilizers.append(fertilizer)
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func createSeed(variety: String, specie: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let seedsEntity = NSEntityDescription.entity(forEntityName: "Seeds", in: managedContext)!
    let seed = NSManagedObject(entity: seedsEntity, insertInto: managedContext)

    seed.setValue("Seed", forKey: "type")
    seed.setValue(false, forKey: "registered")
    seed.setValue(variety, forKey: "variety")
    seed.setValue(specie, forKey: "specie")
    seed.setValue("kg/ha", forKey: "unit")
    seed.setValue(0.0, forKey: "quantity")
    seed.setValue(0, forKey: "row")
    seeds.append(seed)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func createPhyto(name: String, firmName: String, maaID: Int, reentryDelay: Int) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let phytosEntity = NSEntityDescription.entity(forEntityName: "Phytos", in: managedContext)!
    let phyto = NSManagedObject(entity: phytosEntity, insertInto: managedContext)

    phyto.setValue(false, forKey: "registered")
    phyto.setValue(name, forKey: "name")
    phyto.setValue(firmName, forKey: "firmName")
    phyto.setValue(maaID, forKey: "maaID")
    phyto.setValue("Phyto", forKey: "type")
    phyto.setValue(reentryDelay, forKey: "reentryDelay")
    phyto.setValue("l/ha", forKey: "unit")
    phyto.setValue(0.0, forKey: "quantity")
    phyto.setValue(0, forKey: "row")
    phytos.append(phyto)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func createFertilizer(name: String, nature: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let fertilizersEntity = NSEntityDescription.entity(forEntityName: "Fertilizers", in: managedContext)!
    let fertilizer = NSManagedObject(entity: fertilizersEntity, insertInto: managedContext)

    fertilizer.setValue("Fertilizer", forKey: "type")
    fertilizer.setValue(false, forKey: "registered")
    fertilizer.setValue(name, forKey: "name")
    fertilizer.setValue(nature, forKey: "nature")
    fertilizer.setValue("kg/ha", forKey: "unit")
    fertilizer.setValue(0.0, forKey: "quantity")
    fertilizer.setValue(0, forKey: "row")
    fertilizers.append(fertilizer)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  //MARK: - Actions

  @objc func changeSegment() {
    let searchText = searchBar.text!

    let createButtonTitles = [0: "+ CRÉER UNE NOUVELLE SEMENCE", 1: "+ CRÉER UN NOUVEAU PHYTO", 2: "+ CRÉER UN NOUVEAU FERTILISANT"]
    createButton.setTitle(createButtonTitles[segmentedControl.selectedSegmentIndex], for: .normal)
    let inputs = [0: seeds, 1: phytos, 2: fertilizers]
    let inputsToUse = inputs[segmentedControl.selectedSegmentIndex]!
    filteredInputs = searchText.isEmpty ? inputsToUse : inputsToUse.filter({(input: NSManagedObject) -> Bool in
      let key: String = segmentedControl.selectedSegmentIndex == 0 ? "variety" : "name"
      let name: String = input.value(forKey: key) as! String
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
      createSeed(variety: seedView.varietyTextField.text!, specie: seedView.specieButton.titleLabel!.text!)
      seedView.specieButton.setTitle("Abricotier", for: .normal)
      seedView.varietyTextField.text = ""
    case 1:
      let maaID = phytoView.maaTextField.text!.isEmpty ? 0 : Int(phytoView.maaTextField.text!)
      let reentryDelay = phytoView.reentryDelayTextField.text!.isEmpty ? 0 : Int(phytoView.reentryDelayTextField.text!)
      createPhyto(name: phytoView.nameTextField.text!, firmName: phytoView.firmNameTextField.text!, maaID: maaID!, reentryDelay: reentryDelay!)
      for subview in phytoView.subviews {
        if subview is UITextField {
          let textField = subview as! UITextField
          textField.text = ""
        }
      }
    case 2:
      createFertilizer(name: fertilizerView.nameTextField.text!, nature: fertilizerView.natureButton.titleLabel!.text!)
      fertilizerView.nameTextField.text = ""
      fertilizerView.natureButton.setTitle("Organique", for: .normal)
    default:
      return
    }
    tableView.reloadData()
    dimView.isHidden = true
  }

  @objc func hideDimView() {
    dimView.isHidden = true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.endEditing(true)
  }
}
