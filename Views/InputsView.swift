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

  // MARK: - Properties

  lazy var segmentedControl: UISegmentedControl = {
    let segmentedControl = UISegmentedControl(items: ["seeds".localized, "phytos".localized, "fertilizers".localized])
    segmentedControl.selectedSegmentIndex = 0
    let font = UIFont.systemFont(ofSize: 16)
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    return segmentedControl
  }()

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
    createButton.setTitle("create_new_seed".localized.uppercased(), for: .normal)
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

  lazy var seedView: SeedCreationView = {
    let seedView = SeedCreationView(firstSpecie: firstSpecie, frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    seedView.translatesAutoresizingMaskIntoConstraints = false
    return seedView
  }()

  lazy var phytoView: PhytoCreationView = {
    let phytoView = PhytoCreationView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    phytoView.translatesAutoresizingMaskIntoConstraints = false
    return phytoView
  }()

  lazy var fertilizerView: FertilizerCreationView = {
    let fertilizerView = FertilizerCreationView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fertilizerView.translatesAutoresizingMaskIntoConstraints = false
    return fertilizerView
  }()

  var addInterventionViewController: AddInterventionViewController?
  var seeds = [Seeds]()
  var phytos = [Phytos]()
  var fertilizers = [Fertilizers]()
  var isSearching: Bool = false
  var filteredInputs = [NSManagedObject]()
  var firstSpecie: String

  // MARK: - Initialization

  init(firstSpecie: String, frame: CGRect) {
    self.firstSpecie = firstSpecie
    super.init(frame: frame)
    setupView()
    fetchInputs()
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
      tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
      tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
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
    segmentedControl.addTarget(self, action: #selector(changeSegment), for: UIControl.Event.valueChanged)
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

  // MARK: - Table view

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
      let used = fromSeeds[indexPath.row].value(forKey: "used") as! Bool
      let specie = fromSeeds[indexPath.row].value(forKey: "specie") as? String
      let isRegistered = fromSeeds[indexPath.row].value(forKey: "registered") as! Bool

      cell.isUserInteractionEnabled = !used
      cell.backgroundColor = (used ? AppColor.CellColors.LightGray : AppColor.CellColors.White)
      cell.varietyLabel.text = fromSeeds[indexPath.row].value(forKey: "variety") as? String
      cell.specieLabel.text = specie?.localized
      cell.starImageView.isHidden = isRegistered
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhytoCell", for: indexPath) as! PhytoCell
      let fromPhytos = isSearching ? filteredInputs : phytos
      let used = fromPhytos[indexPath.row].value(forKey: "used") as! Bool
      let inFieldReentryDelay = fromPhytos[indexPath.row].value(forKey: "inFieldReentryDelay") as! Int
      let unit: String = inFieldReentryDelay > 1 ? "hours".localized : "hour".localized
      let isRegistered = fromPhytos[indexPath.row].value(forKey: "registered") as! Bool

      cell.isUserInteractionEnabled = !used
      cell.backgroundColor = (used ? AppColor.CellColors.LightGray : AppColor.CellColors.White)
      cell.nameLabel.text = fromPhytos[indexPath.row].value(forKey: "name") as? String
      cell.firmNameLabel.text = fromPhytos[indexPath.row].value(forKey: "firmName") as? String
      cell.maaIDLabel.text = fromPhytos[indexPath.row].value(forKey: "maaID") as? String
      cell.inFieldReentryDelayLabel.text = "\(inFieldReentryDelay) " + unit
      cell.starImageView.isHidden = isRegistered
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "FertilizerCell", for: indexPath) as! FertilizerCell
      let fromFertilizers = isSearching ? filteredInputs : fertilizers
      let used = fromFertilizers[indexPath.row].value(forKey: "used") as! Bool
      let name = fromFertilizers[indexPath.row].value(forKey: "name") as? String
      let nature = fromFertilizers[indexPath.row].value(forKey: "nature") as? String
      let isRegistered = fromFertilizers[indexPath.row].value(forKey: "registered") as! Bool

      cell.isUserInteractionEnabled = !used
      cell.backgroundColor = (used ? AppColor.CellColors.LightGray : AppColor.CellColors.White)
      cell.nameLabel.text = name?.localized
      cell.natureLabel.text = nature?.localized
      cell.starImageView.isHidden = isRegistered
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
    let inputs: [Int: [NSManagedObject]] = [0: seeds, 1: phytos, 2: fertilizers]
    let fromInputs = isSearching ? filteredInputs : inputs[segmentedControl.selectedSegmentIndex]!

    fromInputs[indexPath.row].setValue(true, forKey: "used")
    tableView.reloadData()
    addInterventionViewController?.selectInput(fromInputs[indexPath.row])
  }

  // MARK: - Search bar

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearching = false
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let inputs:[Int: [NSManagedObject]] = [0: seeds, 1: phytos, 2: fertilizers]
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
    DispatchQueue.main.async {
      if self.tableView.numberOfRows(inSection: 0) > 0 {
        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
      }
    }
  }

  // MARK: - Core Data

  private func fetchInputs() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let seedsFetchRequest: NSFetchRequest<Seeds> = Seeds.fetchRequest()
    let phytosFetchRequest: NSFetchRequest<Phytos> = Phytos.fetchRequest()
    let fertilizersFetchRequest: NSFetchRequest<Fertilizers> = Fertilizers.fetchRequest()

    do {
      seeds = try managedContext.fetch(seedsFetchRequest)
      phytos = try managedContext.fetch(phytosFetchRequest)
      fertilizers = try managedContext.fetch(fertilizersFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    sortInputs()
  }

  private func sortInputs() {
    seeds.sort {
      if $0.registered != $1.registered {
        return !$0.registered && $1.registered
      } else {
        return $0.variety! < $1.variety!
      }
    }
    phytos.sort {
      if $0.registered != $1.registered {
        return !$0.registered && $1.registered
      } else {
        return $0.name! < $1.name!
      }
    }
    fertilizers.sort {
      if $0.registered != $1.registered {
        return !$0.registered && $1.registered
      } else {
        return $0.name!.localized < $1.name!.localized
      }
    }
  }

  private func loadRegisteredInputs() {
    let assets = openAssets()
    let decoder = JSONDecoder()

    do {
      let registeredSeeds = try decoder.decode([RegisteredSeed].self, from: assets[0].data)
      let registeredPhytos = try decoder.decode([RegisteredPhyto].self, from: assets[1].data)
      let registeredFertilizers = try decoder.decode([RegisteredFertilizer].self, from: assets[2].data)

      saveSeeds(registeredSeeds)
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

  func saveSeeds(_ registeredSeeds: [RegisteredSeed]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for registeredSeed in registeredSeeds {
      let seed = Seeds(context: managedContext)

      seed.registered = true
      seed.referenceID = Int32(registeredSeed.id)
      seed.specie = registeredSeed.specie.uppercased()
      seed.variety = registeredSeed.variety
      seed.unit = "KILOGRAM_PER_HECTARE"
      seed.used = false
      seeds.append(seed)
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func savePhytos(_ registeredPhytos: [RegisteredPhyto]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for registeredPhyto in registeredPhytos {
      let phyto = Phytos(context: managedContext)

      phyto.registered = true
      phyto.referenceID = Int32(registeredPhyto.id)
      phyto.name = registeredPhyto.name
      phyto.nature = registeredPhyto.nature
      phyto.maaID = registeredPhyto.maaid
      phyto.mixCategoryCode = registeredPhyto.mixCategoryCode
      phyto.inFieldReentryDelay = Int32(registeredPhyto.inFieldReentryDelay)
      phyto.firmName = registeredPhyto.firmName
      phyto.unit = "LITER_PER_HECTARE"
      phyto.used = false
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

    for registeredFertilizer in registeredFertilizers {
      let fertilizer = Fertilizers(context: managedContext)

      fertilizer.registered = true
      fertilizer.referenceID = Int32(registeredFertilizer.id)
      fertilizer.name = registeredFertilizer.name.uppercased()
      fertilizer.variant = registeredFertilizer.variant
      fertilizer.variety = registeredFertilizer.variety
      fertilizer.derivativeOf = registeredFertilizer.derivativeOf
      fertilizer.nature = registeredFertilizer.nature
      fertilizer.nitrogenConcentration = registeredFertilizer.nitrogenConcentration
      fertilizer.phosphorusConcentration = registeredFertilizer.phosphorusConcentration as NSNumber?
      fertilizer.potassiumConcentration = registeredFertilizer.potassiumConcentration as NSNumber?
      fertilizer.sulfurTrioxydeConcentration = registeredFertilizer.sulfurTrioxydeConcentration as NSNumber?
      fertilizer.unit = "KILOGRAM_PER_HECTARE"
      fertilizer.used = false
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
    let seed = Seeds(context: managedContext)

    seed.registered = false
    seed.specie = specie
    seed.variety = variety
    seed.unit = "KILOGRAM_PER_HECTARE"
    seed.used = false
    seeds.append(seed)

    do {
      seed.ekyID = pushSeed(unit: ArticleUnitEnum.kilogram, variety: SpecieEnum.alliumAscalonicum.rawValue, specie: specie, type: ArticleTypeEnum.seed); #warning("wrong specie passed")
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func createPhyto(name: String, firmName: String, _ maaID: String, _ inFieldReentryDelay: Int) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let phyto = Phytos(context: managedContext)

    phyto.registered = false
    phyto.name = name
    phyto.firmName = firmName
    phyto.maaID = maaID
    phyto.inFieldReentryDelay = Int32(inFieldReentryDelay)
    phyto.unit = "LITER_PER_HECTARE"
    phyto.used = false
    phytos.append(phyto)

    do {
      phyto.ekyID = pushInput(unit: ArticleUnitEnum.liter, name: name, type: ArticleTypeEnum.chemical)
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
    let fertilizer = Fertilizers(context: managedContext)

    fertilizer.registered = false
    fertilizer.name = name
    fertilizer.nature = nature
    fertilizer.unit = "KILOGRAM_PER_HECTARE"
    fertilizer.used = false
    fertilizers.append(fertilizer)

    do {
      fertilizer.ekyID = pushInput(unit: ArticleUnitEnum.kilogram, name: name, type: ArticleTypeEnum.fertilizer)
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - GraphQL

  private func pushInput(unit: ArticleUnitEnum, name: String, type: ArticleTypeEnum) -> Int32{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let group = DispatchGroup()
    let mutation = PushArticleMutation(farmId: farmID, unit: unit, name: name, type: type)
    let _ = apollo.clearCache()

    group.enter()
    apollo.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print(error)
      } else if let resultError = result!.data!.createArticle!.errors {
        print(resultError)
      } else {
        id = Int32(result!.data!.createArticle!.article!.id)!
      }
      group.leave()
    })
    group.wait()
    return id
  }

  private func pushSeed(unit: ArticleUnitEnum, variety: String, specie: String, type: ArticleTypeEnum) -> Int32{
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return 0
    }

    var id: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let group = DispatchGroup()
    let mutation = PushArticleMutation(farmId: farmID, unit: unit, name: variety, type: ArticleTypeEnum.seed,
                                       specie: SpecieEnum(rawValue: specie), variety: variety)
    let _ = apollo.clearCache()

    group.enter()
    apollo.perform(mutation: mutation, queue: DispatchQueue.global(), resultHandler: { (result, error) in
      if let error = error {
        print(error)
      } else if let resultError = result!.data!.createArticle!.errors {
        print(resultError)
      } else {
        id = Int32(result!.data!.createArticle!.article!.id)!
      }
      group.leave()
    })
    group.wait()
    return id
  }

  // MARK: - Actions

  @objc func changeSegment() {
    let searchText = searchBar.text!
    let createButtonTitles = [
      0: "create_new_seed".localized.uppercased(),
      1: "create_new_phyto".localized.uppercased(),
      2: "create_new_ferti".localized.uppercased()
    ]

    createButton.setTitle(createButtonTitles[segmentedControl.selectedSegmentIndex], for: .normal)
    let inputs:[Int: [NSManagedObject]] = [0: seeds, 1: phytos, 2: fertilizers]
    let inputsToUse = inputs[segmentedControl.selectedSegmentIndex]!
    filteredInputs = searchText.isEmpty ? inputsToUse : inputsToUse.filter({(input: NSManagedObject) -> Bool in
      let key: String = segmentedControl.selectedSegmentIndex == 0 ? "variety" : "name"
      let name: String = input.value(forKey: key) as! String
      return name.range(of: searchText, options: .caseInsensitive) != nil
    })
    tableView.reloadData()
    DispatchQueue.main.async {
      if self.tableView.numberOfRows(inSection: 0) > 0 {
        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
      }
    }
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
      seedView.specieButton.setTitle(firstSpecie.localized, for: .normal)
      seedView.varietyTextField.text = ""
    case 1:
      let maaID = phytoView.maaTextField.text!.isEmpty ? "0" : phytoView.maaTextField.text!
      let inFieldReentryDelay = phytoView.reentryDelayTextField.text!.isEmpty ? 0 : Int(phytoView.reentryDelayTextField.text!)
      createPhyto(name: phytoView.nameTextField.text!, firmName: phytoView.firmNameTextField.text!, maaID, inFieldReentryDelay!)
      for subview in phytoView.subviews {
        if subview is UITextField {
          let textField = subview as! UITextField
          textField.text = ""
        }
      }
    case 2:
      createFertilizer(name: fertilizerView.nameTextField.text!, nature: fertilizerView.natureButton.titleLabel!.text!)
      fertilizerView.nameTextField.text = ""
      fertilizerView.natureButton.setTitle("organic".localized, for: .normal)
    default:
      return
    }
    sortInputs()
    dimView.isHidden = true
  }

  private func pushInput(unit: ArticleUnitEnum, name: String, type: ArticleTypeEnum, managedContext: NSManagedObjectContext, input: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    var ekyID: Int32 = 0
    let apollo = appDelegate.apollo!
    let farmID = appDelegate.farmID!
    let mutation = PushArticleMutation(farmId: farmID, unit: unit, name: name, type: type)

    apollo.perform(mutation: mutation) { (result, error) in
      if error != nil {
        print(error!)
      } else {
        ekyID = Int32(result!.data!.createArticle!.article!.id)!
        input.setValue(ekyID, forKey: "ekyID")

        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
      }
    }
  }

  @objc func hideDimView() {
    dimView.isHidden = true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.endEditing(true)
  }
}
