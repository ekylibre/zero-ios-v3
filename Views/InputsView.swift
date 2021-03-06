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
    createButton.setTitleColor(AppColor.TextColors.LightGreen, for: .highlighted)
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
    tableView.register(SeedCell.self, forCellReuseIdentifier: "SeedCell")
    tableView.register(PhytoCell.self, forCellReuseIdentifier: "PhytoCell")
    tableView.register(FertilizerCell.self, forCellReuseIdentifier: "FertilizerCell")
    tableView.estimatedRowHeight = 60
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
    let seedView = SeedCreationView(firstSpecie: firstSpecie, frame: CGRect.zero)
    seedView.translatesAutoresizingMaskIntoConstraints = false
    return seedView
  }()

  lazy var phytoView: PhytoCreationView = {
    let phytoView = PhytoCreationView(frame: CGRect.zero)
    phytoView.translatesAutoresizingMaskIntoConstraints = false
    return phytoView
  }()

  lazy var fertilizerView: FertilizerCreationView = {
    let fertilizerView = FertilizerCreationView(frame: CGRect.zero)
    fertilizerView.translatesAutoresizingMaskIntoConstraints = false
    return fertilizerView
  }()

  var addInterventionViewController: AddInterventionViewController?
  var seeds = [Seed]()
  var phytos = [Phyto]()
  var fertilizers = [Fertilizer]()
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
    isHidden = true
    backgroundColor = UIColor.white
    layer.cornerRadius = 5
    clipsToBounds = true
    addSubview(segmentedControl)
    addSubview(searchBar)
    addSubview(createButton)
    addSubview(tableView)
    addSubview(dimView)
    addSubview(seedView)
    addSubview(phytoView)
    addSubview(fertilizerView)
    setupLayout()
    setupActions()
  }

  private func setupLayout() {
    tableViewTopAnchor = tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40)

    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 15),
      segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
      searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
      createButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 2.5),
      createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      tableViewTopAnchor,
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.rightAnchor.constraint(equalTo: rightAnchor)
      ])

    bindFrameToSuperViewBounds(dimView, height: 0)
    bindFrameToSuperViewBounds(seedView, height: 290)
    bindFrameToSuperViewBounds(phytoView, height: 400)
    bindFrameToSuperViewBounds(fertilizerView, height: 300)
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
      view.centerYAnchor.constraint(equalTo: centerYAnchor),
      view.widthAnchor.constraint(equalTo: widthAnchor),
      view.centerXAnchor.constraint(equalTo: centerXAnchor),
      ])
  }

  private func setupActions() {
    segmentedControl.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
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

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSearching {
      return filteredInputs.count
    }

    var countToUse = [0: seeds.count, 1: phytos.count, 2: fertilizers.count]
    return countToUse[segmentedControl.selectedSegmentIndex] ?? 0
  }

  private func checkIfInputIsSelected(fromInput: NSManagedObject) -> Bool {
    let selectedInputs = addInterventionViewController!.selectedInputs

    for interventionInput in selectedInputs {
      var input: NSManagedObject?

      switch interventionInput {
      case is InterventionSeed:
        input = interventionInput.value(forKey: "seed") as? NSManagedObject
      case is InterventionPhytosanitary:
        input = interventionInput.value(forKey: "phyto") as? NSManagedObject
      case is InterventionFertilizer:
        input = interventionInput.value(forKey: "fertilizer") as? NSManagedObject
      default:
        return false
      }

      if input == fromInput {
        return true
      }
    }
    return false
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SeedCell", for: indexPath) as! SeedCell
      let fromSeeds = isSearching ? filteredInputs : seeds
      let isSelected = checkIfInputIsSelected(fromInput: fromSeeds[indexPath.row])
      let specie = fromSeeds[indexPath.row].value(forKey: "specie") as? String
      let isRegistered = fromSeeds[indexPath.row].value(forKey: "registered") as! Bool

      cell.isUserInteractionEnabled = !isSelected
      cell.backgroundColor = isSelected ? AppColor.CellColors.LightGray : AppColor.CellColors.White
      cell.varietyLabel.text = fromSeeds[indexPath.row].value(forKey: "variety") as? String
      cell.specieLabel.text = specie?.localized
      cell.starImageView.isHidden = isRegistered
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhytoCell", for: indexPath) as! PhytoCell
      let fromPhytos = isSearching ? filteredInputs : phytos
      let isSelected = checkIfInputIsSelected(fromInput: fromPhytos[indexPath.row])
      let inFieldReentryDelay = fromPhytos[indexPath.row].value(forKey: "inFieldReentryDelay") as! Int
      let unit: String = inFieldReentryDelay > 1 ? "hours".localized : "hour".localized
      let isRegistered = fromPhytos[indexPath.row].value(forKey: "registered") as! Bool
      let authorized = checkPhytoMixCategoryCode((fromPhytos[indexPath.row] as! Phyto))

      cell.unauthorizedMixingLabel.isHidden = authorized
      cell.unauthorizedMixingImage.isHidden = authorized
      cell.isUserInteractionEnabled = !isSelected
      cell.backgroundColor = (isSelected ? AppColor.CellColors.LightGray : AppColor.CellColors.White)
      cell.nameLabel.text = fromPhytos[indexPath.row].value(forKey: "name") as? String
      cell.firmNameLabel.text = fromPhytos[indexPath.row].value(forKey: "firmName") as? String
      cell.maaIDLabel.text = fromPhytos[indexPath.row].value(forKey: "maaID") as? String
      cell.inFieldReentryDelayLabel.text = "\(inFieldReentryDelay) " + unit
      cell.starImageView.isHidden = isRegistered
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "FertilizerCell", for: indexPath) as! FertilizerCell
      let fromFertilizers = isSearching ? filteredInputs : fertilizers
      let isSelected = checkIfInputIsSelected(fromInput: fromFertilizers[indexPath.row])
      let name = fromFertilizers[indexPath.row].value(forKey: "name") as? String
      let nature = fromFertilizers[indexPath.row].value(forKey: "nature") as? String
      let isRegistered = fromFertilizers[indexPath.row].value(forKey: "registered") as! Bool

      cell.isUserInteractionEnabled = !isSelected
      cell.backgroundColor = (isSelected ? AppColor.CellColors.LightGray : AppColor.CellColors.White)
      cell.nameLabel.text = name?.localized
      cell.natureLabel.text = nature?.localized
      cell.starImageView.isHidden = isRegistered
      return cell
    default:
      fatalError("Switch error")
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return segmentedControl.selectedSegmentIndex == 1 ? 100 : UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let inputs: [Int: [NSManagedObject]] = [0: seeds, 1: phytos, 2: fertilizers]
    let fromInputs = isSearching ? filteredInputs : inputs[segmentedControl.selectedSegmentIndex]!

    fromInputs[indexPath.row].setValue(true, forKey: "used")
    tableView.reloadData()
    addInterventionViewController?.selectInput(
      fromInputs[indexPath.row], quantity: nil, unit: nil, calledFromCreatedIntervention: false)
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
    tableViewTopAnchor.constant = isSearching ? 10 : 40
    tableView.reloadData()
    DispatchQueue.main.async {
      if self.tableView.numberOfRows(inSection: 0) > 0 {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
      }
    }
  }

  // MARK: - Core Data

  private func fetchInputs() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let seedsFetchRequest: NSFetchRequest<Seed> = Seed.fetchRequest()
    let phytosFetchRequest: NSFetchRequest<Phyto> = Phyto.fetchRequest()
    let fertilizersFetchRequest: NSFetchRequest<Fertilizer> = Fertilizer.fetchRequest()

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

  private func createSeed(variety: String, specie: String, unit: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let formattedSpecie = specie.uppercased().replacingOccurrences(of: " ", with: "_")
    let managedContext = appDelegate.persistentContainer.viewContext
    let seed = Seed(context: managedContext)

    seed.registered = false
    seed.ekyID = 0
    seed.referenceID = 0
    seed.specie = formattedSpecie
    seed.variety = variety
    seed.unit = unit
    seed.used = false
    seeds.append(seed)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func createPhyto(name: String, firmName: String, _ maaID: String, _ inFieldReentryDelay: Int, unit: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let phyto = Phyto(context: managedContext)

    phyto.registered = false
    phyto.ekyID = 0
    phyto.referenceID = 0
    phyto.name = name
    phyto.firmName = firmName
    phyto.maaID = maaID
    phyto.inFieldReentryDelay = Int32(inFieldReentryDelay)
    phyto.unit = unit
    phyto.used = false
    phytos.append(phyto)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func createFertilizer(name: String, nature: String, unit: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let fertilizer = Fertilizer(context: managedContext)

    fertilizer.registered = false
    fertilizer.ekyID = 0
    fertilizer.referenceID = 0
    fertilizer.name = name
    fertilizer.nature = nature
    fertilizer.unit = unit
    fertilizer.used = false
    fertilizers.append(fertilizer)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Actions

  private func checkPhytoMixCategoryCode(_ phyto: Phyto) -> Bool {
    for case let selectedInput as InterventionPhytosanitary in addInterventionViewController!.selectedInputs {
      if selectedInput.phyto?.mixCategoryCode != nil && phyto.mixCategoryCode != nil {
        if !addInterventionViewController!.checkMixCategoryCode(
          selectedInput.phyto!.mixCategoryCode!, phyto.mixCategoryCode!) {
          return false
        }
      }
    }
    return true
  }

  @objc private func changeSegment() {
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
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
      }
    }
  }

  @objc private func tapCreateButton() {
    dimView.isHidden = false
    if segmentedControl.selectedSegmentIndex == 0 {
      seedView.isHidden = false
    } else if segmentedControl.selectedSegmentIndex == 1 {
      phytoView.isHidden = false
    } else {
      fertilizerView.isHidden = false
    }
  }

  private func checkSeedName() -> Bool {
    if seedView.varietyTextField.text!.isEmpty {
      seedView.errorLabel.text = "seed_variety_is_empty".localized
      seedView.errorLabel.isHidden = false
      return false
    } else if seeds.contains(where: { $0.variety?.lowercased() == seedView.varietyTextField.text?.lowercased() }) {
      seedView.errorLabel.text = "seed_variety_not_available".localized
      seedView.errorLabel.isHidden = false
      return false
    }
    return true
  }

  private func checkPhytoName() -> Bool {
    if phytoView.nameTextField.text!.isEmpty {
      phytoView.errorLabel.text = "phyto_name_is_empty".localized
      phytoView.errorLabel.isHidden = false
      return false
    } else if phytos.contains(where: { $0.name?.lowercased() == phytoView.nameTextField.text?.lowercased() }) {
      phytoView.errorLabel.text = "phyto_name_not_available".localized
      phytoView.errorLabel.isHidden = false
      return false
    }
    return true
  }

  private func checkFertilizerName() -> Bool {
    if fertilizerView.nameTextField.text!.isEmpty {
      fertilizerView.errorLabel.text = "ferti_name_is_empty".localized
      fertilizerView.errorLabel.isHidden = false
      return false
    } else if fertilizers.contains(where: { $0.name?.lowercased() == fertilizerView.nameTextField.text?.lowercased()}) {
      fertilizerView.errorLabel.text = "ferti_name_not_available".localized
      fertilizerView.errorLabel.isHidden = false
      return false
    }
    return true
  }

  @objc private func createInput() {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      if !checkSeedName() {
        return
      }

      createSeed(
        variety: seedView.varietyTextField.text!,
        specie: seedView.rawSpecie,
        unit: seedView.rawUnit)
      seedView.specieButton.setTitle(firstSpecie.localized, for: .normal)
      seedView.varietyTextField.text = ""
      sortInputs()
      dimView.isHidden = true
      seedView.errorLabel.isHidden = true
      seedView.isHidden = true
    case 1:
      if !checkPhytoName() {
        return
      }

      let reentryDelay = Int(phytoView.reentryDelayTextField.text!)
      let maaID = phytoView.maaTextField.text!.isEmpty ? "0" : phytoView.maaTextField.text!
      let inFieldReentryDelay = phytoView.reentryDelayTextField.text!.isEmpty ? 0 : reentryDelay

      createPhyto(
        name: phytoView.nameTextField.text!,
        firmName: phytoView.firmNameTextField.text!,
        maaID,
        inFieldReentryDelay!,
        unit: phytoView.rawUnit)
      for subview in phytoView.subviews {
        if subview is UITextField {
          let textField = subview as! UITextField
          textField.text = ""
        }
      }
      sortInputs()
      dimView.isHidden = true
      phytoView.errorLabel.isHidden = true
      phytoView.isHidden = true
    case 2:
      if !checkFertilizerName() {
        return
      }

      createFertilizer(
        name: fertilizerView.nameTextField.text!,
        nature: fertilizerView.natureButton.titleLabel!.text!,
        unit: fertilizerView.rawUnit)
      fertilizerView.nameTextField.text = ""
      fertilizerView.natureButton.setTitle("organic".localized, for: .normal)
      sortInputs()
      dimView.isHidden = true
      fertilizerView.errorLabel.isHidden = true
      fertilizerView.isHidden = true
    default:
      return
    }
    sortInputs()
    tableView.reloadData()
    dimView.isHidden = true
  }

  @objc private func hideDimView() {
    dimView.isHidden = true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    endEditing(true)
  }
}
