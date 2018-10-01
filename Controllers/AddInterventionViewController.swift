//
//  AddInterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 30/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class AddInterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, WriteValueBackDelegate, XMLParserDelegate {

  // MARK: - Outlets

  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var equipmentsTableView: UITableView!
  @IBOutlet weak var workingPeriodHeight: NSLayoutConstraint!
  @IBOutlet weak var selectedWorkingPeriodLabel: UILabel!
  @IBOutlet weak var collapseWorkingPeriodImage: UIImageView!
  @IBOutlet weak var selectDateButton: UIButton!
  @IBOutlet weak var durationTextField: UITextField!
  @IBOutlet weak var irrigationView: UIView!
  @IBOutlet weak var irrigationHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var irrigationExpandCollapseImage: UIImageView!
  @IBOutlet weak var irrigationLabel: UILabel!
  @IBOutlet weak var irrigationValueTextField: UITextField!
  @IBOutlet weak var irrigationUnitButton: UIButton!
  @IBOutlet weak var irrigationInfoLabel: UILabel!
  @IBOutlet weak var irrigationSeparatorView: UIView!
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var collapseButton: UIButton!
  @IBOutlet weak var saveInterventionButton: UIButton!
  @IBOutlet weak var selectEquipmentsView: UIView!
  @IBOutlet weak var createEquipmentsView: UIView!
  @IBOutlet weak var equipmentDarkLayer: UIView!
  @IBOutlet weak var equipmentName: UITextField!
  @IBOutlet weak var equipmentNumber: UITextField!
  @IBOutlet weak var equipmentType: UILabel!
  @IBOutlet weak var selectedEquipmentsTableView: UITableView!
  @IBOutlet weak var addEquipmentButton: UIButton!
  @IBOutlet weak var equipmentNumberLabel: UILabel!
  @IBOutlet weak var searchEquipment: UISearchBar!
  @IBOutlet weak var equipmentTypeTableView: UITableView!
  @IBOutlet weak var equipmentTypeButton: UIButton!
  @IBOutlet weak var createEquipment: UIView!
  @IBOutlet weak var createEntity: UIView!
  @IBOutlet weak var entityFirstName: UITextField!
  @IBOutlet weak var entityLastName: UITextField!
  @IBOutlet weak var selectEntitiesView: UIView!
  @IBOutlet weak var createEntitiesView: UIView!
  @IBOutlet weak var entitiesTableView: UITableView!
  @IBOutlet weak var entityRole: UITextField!
  @IBOutlet weak var entityDarkLayer: UIView!
  @IBOutlet weak var doersTableView: UITableView!
  @IBOutlet weak var doersHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var doersTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var doersCollapsedButton: UIButton!
  @IBOutlet weak var doersNumber: UILabel!
  @IBOutlet weak var addEntitiesButton: UIButton!
  @IBOutlet weak var searchEntity: UISearchBar!
  @IBOutlet weak var inputsSelectionView: UIView!
  @IBOutlet weak var inputsCollapseButton: UIButton!
  @IBOutlet weak var inputsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var addInputsButton: UIButton!
  @IBOutlet weak var inputsNumber: UILabel!
  @IBOutlet weak var selectedInputsTableView: UITableView!
  @IBOutlet weak var selectedInputsTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputsSeparatorView: UIView!
  @IBOutlet weak var equipmentHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var equipmentTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var weatherViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var currentWeatherLabel: UILabel!
  @IBOutlet weak var weatherCollapseButton: UIButton!
  @IBOutlet weak var temperatureTextField: UITextField!
  @IBOutlet weak var windSpeedTextField: UITextField!
  @IBOutlet weak var brokenClouds: UIButton!
  @IBOutlet weak var clearSky: UIButton!
  @IBOutlet weak var fewClouds: UIButton!
  @IBOutlet weak var lightRain: UIButton!
  @IBOutlet weak var mist: UIButton!
  @IBOutlet weak var showerRain: UIButton!
  @IBOutlet weak var snow: UIButton!
  @IBOutlet weak var thunderstorm: UIButton!

  // MARK: - Properties

  var newIntervention: Interventions!
  var interventionType: String!
  var equipments = [Equipments]()
  var selectDateView: SelectDateView!
  var irrigationPickerView: CustomPickerView!
  var cropsView: CropsView!
  var inputsView: InputsView!
  var interventionEquipments = [NSManagedObject]()
  var equipmentsTableViewTopAnchor: NSLayoutConstraint!
  var selectedEquipments = [Equipments]()
  var searchedEquipments = [Equipments]()
  var equipmentTypes: [String]!
  var sortedEquipmentTypes: [String]!
  var selectedEquipmentType: String!
  var entities = [Entities]()
  var entitiesTableViewTopAnchor: NSLayoutConstraint!
  var searchedEntities = [NSManagedObject]()
  var doers = [Entities]()
  var createdSeed = [NSManagedObject]()
  var selectedInputs = [NSManagedObject]()
  var solidUnitPicker = UIPickerView()
  var liquidUnitPicker = UIPickerView()
  var pickerValue: String?
  var cellIndexPath: IndexPath!
  var weatherIsSelected: Bool = false
  var weatherButtons = [UIButton]()
  var weather = Weather()
  var apolloQuery = ApolloQuery()
  let solidUnitMeasure = [
    "gram",
    "gram_per_hectare",
    "gram_per_square_meter",
    "kilogram",
    "kilogram_per_hectare",
    "kilogram_per_square_meter",
    "quintal",
    "quintal_per_hectare",
    "quintal_per_square_meter",
    "ton",
    "ton_per_hectare",
    "ton_per_square_meter"]
  let liquidUnitMeasure = [
    "liter",
    "liter_per_hectare",
    "liter_per_square_meter",
    "hectoliter",
    "hectoliter_per_hectare",
    "hectoliter_per_square_meter",
    "cubic_meter",
    "cubic_meter_per_hectare",
    "cubic_meter_per_square_meter"]

  override func viewDidLoad() {
    super.viewDidLoad()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

    // Working period
    selectDateView = SelectDateView(frame: CGRect(x: 0, y: 0, width: 350, height: 250))
    selectDateView.center.x = self.view.center.x
    selectDateView.center.y = self.view.center.y
    view.addSubview(selectDateView)

    let dateFormatter = DateFormatter()

    dateFormatter.locale = Locale(identifier: "fr_FR")
    dateFormatter.dateFormat = "d MMMM"
    let currentDateString = dateFormatter.string(from: Date())
    let validateButton = selectDateView.subviews.last as! UIButton

    validateButton.addTarget(self, action: #selector(validateDate), for: .touchUpInside)

    selectDateButton.setTitle(currentDateString, for: .normal)
    selectDateButton.layer.borderWidth = 0.5
    selectDateButton.layer.borderColor = UIColor.lightGray.cgColor
    selectDateButton.layer.cornerRadius = 5
    selectDateButton.clipsToBounds = true

    durationTextField.layer.cornerRadius = 5
    durationTextField.layer.borderWidth = 0.5
    durationTextField.layer.borderColor = UIColor.lightGray.cgColor
    durationTextField.clipsToBounds = true

    // Adds type label on the navigation bar
    let navigationItem = UINavigationItem(title: "")
    let typeLabel = UILabel()

    if interventionType != nil {
      typeLabel.text = interventionType.localized
    }
    typeLabel.font = UIFont.boldSystemFont(ofSize: 21.0)
    typeLabel.textColor = UIColor.white

    let leftItem = UIBarButtonItem.init(customView: typeLabel)

    navigationItem.leftBarButtonItem = leftItem
    navigationBar.setItems([navigationItem], animated: false)

    equipmentTypes = defineEquipmentTypes()
    sortedEquipmentTypes = equipmentTypes.sorted()
    selectedEquipmentType = sortedEquipmentTypes[0]
    equipmentTypeButton.setTitle(selectedEquipmentType, for: .normal)

    fetchEquipments()
    fetchEntities()

    initUnitMeasurePickerView()

    selectedEquipmentsTableView.layer.borderWidth  = 0.5
    selectedEquipmentsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedEquipmentsTableView.backgroundColor = AppColor.ThemeColors.DarkWhite
    selectedEquipmentsTableView.layer.cornerRadius = 4
    selectedEquipmentsTableView.dataSource = self
    selectedEquipmentsTableView.delegate = self
    selectedEquipmentsTableView.bounces = false

    saveInterventionButton.layer.cornerRadius = 3

    selectedInputsTableView.register(SelectedInputCell.self, forCellReuseIdentifier: "SelectedInputCell")
    selectedInputsTableView.delegate = self
    selectedInputsTableView.dataSource = self
    selectedInputsTableView.bounces = false
    selectedInputsTableView.layer.borderWidth  = 0.5
    selectedInputsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedInputsTableView.backgroundColor = AppColor.ThemeColors.DarkWhite
    selectedInputsTableView.layer.cornerRadius = 4

    equipmentsTableView.dataSource = self
    equipmentsTableView.delegate = self
    equipmentsTableView.bounces = false

    searchEquipment.delegate = self
    searchEquipment.autocapitalizationType = .none

    searchEntity.delegate = self
    searchEntity.autocapitalizationType = .none

    equipmentTypeTableView.dataSource = self
    equipmentTypeTableView.delegate = self
    equipmentTypeTableView.bounces = false

    equipmentsTableViewTopAnchor = equipmentsTableView.topAnchor.constraint(equalTo: searchEquipment.bottomAnchor, constant: 40.5)
    NSLayoutConstraint.activate([equipmentsTableViewTopAnchor])

    entitiesTableView.dataSource = self
    entitiesTableView.delegate = self
    entitiesTableView.bounces = false

    entitiesTableViewTopAnchor = entitiesTableView.topAnchor.constraint(equalTo: searchEntity.bottomAnchor, constant: 40.5)
    NSLayoutConstraint.activate([entitiesTableViewTopAnchor])

    doersTableView.dataSource = self
    doersTableView.delegate = self
    doersTableView.bounces = false
    doersTableView.layer.borderWidth  = 0.5
    doersTableView.layer.borderColor = UIColor.lightGray.cgColor
    doersTableView.backgroundColor = AppColor.ThemeColors.DarkWhite
    doersTableView.layer.cornerRadius = 4

    inputsView = InputsView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    inputsView.addInterventionViewController = self
    view.addSubview(inputsView)

    cropsView = CropsView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
    view.addSubview(cropsView)
    cropsView.validateButton.addTarget(self, action: #selector(validateCrops), for: .touchUpInside)

    initializeWeatherButtons()
    initWeather()
    temperatureTextField.delegate = self
    temperatureTextField.keyboardType = .decimalPad

    windSpeedTextField.delegate = self
    windSpeedTextField.keyboardType = .decimalPad
    setupIrrigation()

    setupViewsAccordingInterventionType()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  private func setupViewsAccordingInterventionType() {
    switch interventionType {
    case Intervention.InterventionType.Care.rawValue:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
    case Intervention.InterventionType.CropProtection.rawValue:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsView.segmentedControl.selectedSegmentIndex = 1
      inputsView.createButton.setTitle("+ CRÉER UN NOUVEAU PHYTO", for: .normal)
    case Intervention.InterventionType.Fertilization.rawValue:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsView.segmentedControl.selectedSegmentIndex = 2
      inputsView.createButton.setTitle("+ CRÉER UN NOUVEAU FERTILISANT", for: .normal)
    case Intervention.InterventionType.GroundWork.rawValue:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsSelectionView.isHidden = true
      inputsSeparatorView.isHidden = true
    case Intervention.InterventionType.Harvest.rawValue:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsSelectionView.isHidden = true
      inputsSeparatorView.isHidden = true
    case Intervention.InterventionType.Implantation.rawValue:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
    default:
      return
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    // Changes inputsView frame and position
    let guide = self.view.safeAreaLayoutGuide
    let height = guide.layoutFrame.size.height
    inputsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: height - 30)
    inputsView.center.x = self.view.center.x
    inputsView.frame.origin.y = navigationBar.frame.origin.y + 15
    inputsView.seedView.specieButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
    inputsView.fertilizerView.natureButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)

    cropsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: height - 30)
    cropsView.center.x = self.view.center.x
    cropsView.frame.origin.y = navigationBar.frame.origin.y + 15
  }

  @objc func showList() {
    self.performSegue(withIdentifier: "showSpecieList", sender: self)
  }

  @objc func showAlert() {
    self.present(inputsView.fertilizerView.natureAlertController, animated: true, completion: nil)
  }

  // MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    switch tableView {
    case equipmentsTableView:
      return searchedEquipments.count
    case selectedEquipmentsTableView:
      return selectedEquipments.count
    case equipmentTypeTableView:
      return equipmentTypes.count
    case entitiesTableView:
      return searchedEntities.count
    case doersTableView:
      return doers.count
    case selectedInputsTableView:
      return selectedInputs.count
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var equipment: NSManagedObject?
    var selectedEquipment: NSManagedObject?
    var equipmentType: String?
    var entity: NSManagedObject?
    var doer: NSManagedObject?

    switch tableView {
    case selectedInputsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedInputCell", for: indexPath) as! SelectedInputCell

      if selectedInputs.count > indexPath.row {
        let selectedInput = selectedInputs[indexPath.row]
        cell.cellDelegate = self
        cell.addInterventionViewController = self
        cell.indexPath = indexPath
        let unit = selectedInput.value(forKey: "unit") as? String
        cell.unitMeasureButton.setTitle(unit?.localized, for: .normal)
        cell.backgroundColor = AppColor.ThemeColors.DarkWhite

        switch selectedInput {
        case is InterventionSeeds:
          let seed = selectedInput.value(forKey: "seeds") as! Seeds
          cell.inputName.text = seed.specie
          cell.inputLabel.text = seed.variety
          cell.inputImage.image = #imageLiteral(resourceName: "seed")
        case is InterventionPhytosanitaries:
          let phyto = selectedInput.value(forKey: "phytos") as! Phytos
          cell.inputName.text = phyto.name
          cell.inputLabel.text = phyto.firmName
          cell.inputImage.image = #imageLiteral(resourceName: "phytosanitary")
        case is InterventionFertilizers:
          let fertilizer = selectedInput.value(forKey: "fertilizers") as! Fertilizers
          cell.inputName.text = fertilizer.name
          cell.inputLabel.text = fertilizer.nature
          cell.inputImage.image = #imageLiteral(resourceName: "fertilizer")
        default:
          fatalError("Unknown input type for: \(String(describing: selectedInput))")
        }
      }
      return cell
    case equipmentsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentCell", for: indexPath) as! EquipmentCell

      equipment = searchedEquipments[indexPath.row]
      cell.nameLabel.text = equipment?.value(forKey: "name") as? String
      cell.typeLabel.text = equipment?.value(forKey: "type") as? String
      cell.typeImageView.image = defineEquipmentImage(equipmentName: cell.typeLabel.text!)
      return cell
    case selectedEquipmentsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedEquipmentCell", for: indexPath) as! SelectedEquipmentCell

      selectedEquipment = selectedEquipments[indexPath.row]
      cell.cellDelegate = self
      cell.indexPath = indexPath
      cell.backgroundColor = AppColor.ThemeColors.DarkWhite
      cell.nameLabel.text = selectedEquipment?.value(forKey: "name") as? String
      cell.typeLabel.text = selectedEquipment?.value(forKey: "type") as? String
      cell.typeImageView.image = defineEquipmentImage(equipmentName: cell.typeLabel.text!)
      return cell
    case equipmentTypeTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTypesCell", for: indexPath) as! EquipmentTypesCell

      equipmentType = sortedEquipmentTypes[indexPath.row]
      cell.nameLabel.text = equipmentType
      return cell
    case entitiesTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "EntityCell", for: indexPath) as! EntityCell

      entity = searchedEntities[indexPath.row]
      cell.firstName.text = entity?.value(forKey: "firstName") as? String
      cell.lastName.text = entity?.value(forKey: "lastName") as? String
      cell.logo.image = #imageLiteral(resourceName: "entity-logo")
      return cell
    case doersTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DoerCell", for: indexPath) as! DoerCell

      doer = doers[indexPath.row]
      cell.driver.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      cell.cellDelegate = self
      cell.indexPath = indexPath
      cell.backgroundColor = AppColor.ThemeColors.DarkWhite
      cell.driver.isOn = (doer?.value(forKey: "isDriver") as? Bool)!
      cell.firstName.text = doer?.value(forKey: "firstName") as? String
      cell.lastName.text = doer?.value(forKey: "lastName") as? String
      cell.logo.image = #imageLiteral(resourceName: "entity-logo")
      return cell
    default:
      fatalError("Switch error")
    }
  }

  // Expand/collapse cell when tapped
  var selectedIndexPath: IndexPath?
  var indexPaths: [IndexPath] = []

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndexPath = indexPath

    switch tableView {
    case equipmentsTableView:
      let cell = equipmentsTableView.cellForRow(at: selectedIndexPath!) as! EquipmentCell

      if cell.isAvaible {
        selectedEquipments.append(searchedEquipments[indexPath.row])
        selectedEquipments[selectedEquipments.count - 1].setValue(indexPath.row, forKey: "row")
        selectedEquipmentsTableView.reloadData()
        cell.isAvaible = false
        cell.backgroundColor = AppColor.CellColors.LightGray
      }
      closeEquipmentsSelectionView()
    case equipmentTypeTableView:
      selectedEquipmentType = sortedEquipmentTypes[indexPath.row]
      equipmentTypeTableView.reloadData()
      equipmentTypeButton.setTitle(selectedEquipmentType, for: .normal)
      equipmentTypeTableView.isHidden = true
    case entitiesTableView:
      let cell = entitiesTableView.cellForRow(at: selectedIndexPath!) as! EntityCell

      if cell.isAvaible {
        doers.append(entities[indexPath.row])
        doers[doers.count - 1].setValue(indexPath.row, forKey: "row")
        doersTableView.reloadData()
        cell.isAvaible = false
        cell.backgroundColor = AppColor.CellColors.LightGray
      }
      closeEntitiesSelectionView()
    default:
      print("Nothing to do")
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch tableView {
    case doersTableView:
      return 75
    case selectedInputsTableView:
      return 110
    default:
      return 60
    }
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch tableView {
    case doersTableView:
      return 75
    case selectedInputsTableView:
      return 110
    default:
      return 60
    }
  }

  func resizeViewAndTableView(viewHeightConstraint: NSLayoutConstraint, tableViewHeightConstraint: NSLayoutConstraint,
                              tableView: UITableView) {
    tableViewHeightConstraint.constant = tableView.contentSize.height
    viewHeightConstraint.constant = tableViewHeightConstraint.constant + 100
  }

  @IBAction func equipmentTypeSelection(_ sender: UIButton) {
    equipmentTypeTableView.isHidden = false
    equipmentTypeTableView.layer.shadowColor = UIColor.black.cgColor
    equipmentTypeTableView.layer.shadowOpacity = 1
    equipmentTypeTableView.layer.shadowOffset = CGSize(width: -1, height: 1)
    equipmentTypeTableView.layer.shadowRadius = 10
  }

  // MARK: - Core Data

  func createSampleHarvestForMutation(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvest = Harvests(context: managedContext)
    let storage = Storages(context: managedContext)

    harvest.number = "1"
    harvest.unit = "TON"
    harvest.quantity = 2
    harvest.type = "SILAGE"
    harvest.interventions = intervention
    harvest.storages = storage
    storage.name = "Storage test n°1"
    storage.type = "BUILDING"
    storage.addToHarvests(harvest)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createIntervention() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    newIntervention = Interventions(context: managedContext)
    let workingPeriod = WorkingPeriods(context: managedContext)

    newIntervention.type = interventionType
    newIntervention.status = Intervention.Status.OutOfSync.rawValue
    newIntervention.infos = "Infos"
    newIntervention.farmID = appDelegate.farmID
    if interventionType == "irrigation" {
      let waterQuantityString = irrigationValueTextField.text!.replacingOccurrences(of: ",", with: ".")
      let waterQuantity = Float(waterQuantityString) ?? 0
      newIntervention.waterQuantity = waterQuantity
      switch irrigationUnitButton.titleLabel?.text {
      case "m³":
        newIntervention.waterUnit = "CUBIC_METER"
      case "l":
        newIntervention.waterUnit = "LITER"
      case "hl":
        newIntervention.waterUnit = "HECTOLITER"
      default:
        newIntervention.waterUnit = ""
      }
    }
    workingPeriod.interventions = newIntervention
    workingPeriod.executionDate = selectDateView.datePicker.date
    let durationString = durationTextField.text!.replacingOccurrences(of: ",", with: ".")
    let hourDuration = Float(durationString) ?? 0
    workingPeriod.hourDuration = hourDuration
    createTargets(intervention: newIntervention)
    createEquipments(intervention: newIntervention)
    createDoers(intervention: newIntervention)
    saveInterventionInputs(intervention: newIntervention)
    if newIntervention.type == "harvest" {
      createSampleHarvestForMutation(intervention: newIntervention)
    }
    saveWeather(intervention: newIntervention)
    resetInputsAttributes(entity: "Seeds")
    resetInputsAttributes(entity: "Phytos")
    resetInputsAttributes(entity: "Fertilizers")
    let id = apolloQuery.pushIntervention(intervention: newIntervention)
    newIntervention.ekyID = id

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func resetInputsAttributes(entity: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
    let predicate = NSPredicate(format: "used == true")

    entitiesFetchRequest.predicate = predicate

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        entity.setValue(false, forKey: "used")
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save or fetch. \(error), \(error.userInfo)")
    }
  }

  func saveInterventionInputs(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for selectedInput in selectedInputs {
      selectedInput.setValue(intervention, forKey: "interventions")
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func fetchSelectedCrops() -> [Crops] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return [Crops]()
    }

    var crops: [Crops]!
    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crops> = Crops.fetchRequest()
    let predicate = NSPredicate(format: "isSelected == true")
    cropsFetchRequest.predicate = predicate

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return crops
  }

  func createTargets(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let selectedCrops = fetchSelectedCrops()

    for crop in selectedCrops {
      let target = Targets(context: managedContext)

      target.interventions = intervention
      target.crops = crop
      target.workAreaPercentage = 100
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createEquipments(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for selectedEquipment in selectedEquipments {
      let equipment = InterventionEquipments(context: managedContext)

      equipment.equipments = selectedEquipment
      equipment.interventions = intervention
      equipment.name = equipment.equipments?.name
      equipment.type = equipment.equipments?.type
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createDoers(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for entity in doers {
      let doer = Doers(context: managedContext)
      let isDriver = entity.value(forKey: "isDriver")

      doer.interventions = intervention
      doer.isDriver = isDriver as! Bool
      doer.entities = entity
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func fetchEntity(entityName: String, searchedEntity: inout [NSManagedObject], entity: inout [NSManagedObject]) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

    do {
      entity = try managedContext.fetch(entitiesFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    searchedEntity = entity
  }

  func saveWeather(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    var currentWeather = Weather(context: managedContext)

    currentWeather = weather
    currentWeather.interventions = intervention

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //super.prepare(for: segue, sender: sender)
    switch segue.identifier {
    case "showSpecieList":
      let destVC = segue.destination as! ListTableViewController
      destVC.delegate = self
      destVC.cellsStrings = loadSpecies()
    default:
      guard let button = sender as? UIButton, button == saveInterventionButton else {
        return
      }

      createIntervention()
    }
  }

  private func loadSpecies() -> [String] {
    var species = [String]()

    if let asset = NSDataAsset(name: "species") {
      do {
        let jsonResult = try JSONSerialization.jsonObject(with: asset.data)
        let registeredSpecies = jsonResult as? [[String: Any]]

        for registeredSpecie in registeredSpecies! {
          let specie = registeredSpecie["name"] as! String
          species.append(specie.localized)
        }
      } catch {
        print("Lexicon error")
      }
    } else {
      print("species.json not found")
    }

    return species.sorted()
  }

  func writeValueBack(value: String) {
    inputsView.seedView.specieButton.setTitle(value, for: .normal)
  }

  // MARK: - Search Bar Delegate

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchedEntities = searchText.isEmpty ? entities : entities.filter({(filterEntity: NSManagedObject) -> Bool in
      let entityName: String = filterEntity.value(forKey: "firstName") as! String
      return entityName.range(of: searchText) != nil
    })
    searchedEquipments = searchText.isEmpty ? equipments : equipments.filter({(filterEquipment: NSManagedObject) -> Bool in
      let equipmentName: String = filterEquipment.value(forKey: "name") as! String
      return equipmentName.range(of: searchText) != nil
    })
    entitiesTableView.reloadData()
    equipmentsTableView.reloadData()
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    switch searchBar {
    case searchEntity:
      entitiesTableViewTopAnchor.constant = 15
      createEntity.isHidden = true
    case searchEquipment:
      equipmentsTableViewTopAnchor.constant = 15
      createEquipment.isHidden = true
    default:
      return
    }
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    switch searchBar {
    case searchEntity:
      searchBar.endEditing(true)
      entitiesTableViewTopAnchor.constant = 40.5
      createEntity.isHidden = false
    case searchEquipment:
      searchBar.endEditing(true)
      equipmentsTableViewTopAnchor.constant = 40.5
      createEquipment.isHidden = false
    default:
      return
    }
  }

  // MARK: - Actions

  @IBAction func selectCrops(_ sender: Any) {
    dimView.isHidden = false
    cropsView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  func checkCropsProduction() -> Bool {
    let selectedCrops = fetchSelectedCrops()
    let firstCrop = selectedCrops.first?.species

    for selectedCrop in selectedCrops {
      if selectedCrop.species != firstCrop {
        let alert = UIAlertController(
          title: "",
          message: "impossible_to_carry_out_implantation_on_crops_different_varieties".localized,
          preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
        return false
      }
    }
    return true
  }

  @objc func validateCrops(_ sender: Any) {
    if checkCropsProduction() {
      if cropsView.selectedCropsLabel.text == "Aucune sélection" {
        totalLabel.text = "+ SÉLECTIONNER"
        totalLabel.textColor = AppColor.TextColors.Green
      } else {
        totalLabel.text = cropsView.selectedCropsLabel.text
        totalLabel.textColor = AppColor.TextColors.DarkGray
      }
      totalLabel.sizeToFit()
      updateIrrigation(self)

      cropsView.isHidden = true
      dimView.isHidden = true

      updateAllInputQuantity()
      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
      })
    }
  }

  @IBAction func selectWorkingPeriod(_ sender: Any) {
    if workingPeriodHeight.constant == 70 {
      workingPeriodHeight.constant = 155
      selectedWorkingPeriodLabel.isHidden = true
      selectDateButton.isHidden = false
    } else {
      workingPeriodHeight.constant = 70
      selectedWorkingPeriodLabel.isHidden = false
      selectDateButton.isHidden = true
      selectedWorkingPeriodLabel.text = getSelectedWorkingPeriod()
    }
    collapseWorkingPeriodImage.transform = collapseWorkingPeriodImage.transform.rotated(by: CGFloat.pi)
  }

  func getSelectedWorkingPeriod() -> String {
    let dateString = selectDateButton.titleLabel!.text!
    let durationString = durationTextField.text!.replacingOccurrences(of: ",", with: ".")
    let duration = Float(durationString) ?? 0

    return String(format: "%@ • %g h", dateString, duration)
  }

  @IBAction func selectDate(_ sender: Any) {
    dimView.isHidden = false
    selectDateView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  func checkIfSelectedDateMatchProductionPeriod(selectedDate: Date) -> Bool {
    let selectedCrops = fetchSelectedCrops()

    if selectedCrops.count > 0 {
      var startDate = selectedCrops.first?.startDate
      var stopDate = selectedCrops.first?.stopDate

      for selectedCrop in selectedCrops {
        startDate = (selectedCrop.startDate! > startDate! ? selectedCrop.startDate! : startDate)
        stopDate = (selectedCrop.stopDate! > stopDate! ? selectedCrop.stopDate! : stopDate)
      }
      if selectedDate < startDate! || selectedDate > stopDate! {
        let message = (selectedDate < startDate! ? String(format: "started_must_be_on_or_after".localized, startDate! as CVarArg) :
          String(format: "started_must_be_on_or_before".localized, stopDate! as CVarArg))
        let alert = UIAlertController(
          title: "working_periods_is_invalid".localized,
          message: message,
          preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
        return false
      }
    }
    return true
  }

  @objc func validateDate() {
    if checkIfSelectedDateMatchProductionPeriod(selectedDate: selectDateView.datePicker.date) {
      let dateFormatter = DateFormatter()

      dateFormatter.locale = Locale(identifier: "fr_FR")
      dateFormatter.dateFormat = "d MMMM"
      let selectedDate = dateFormatter.string(from: selectDateView.datePicker.date)

      selectDateButton.setTitle(selectedDate, for: .normal)
      selectDateView.isHidden = true
      dimView.isHidden = true

      UIView.animate(withDuration: 0.5, animations: {
        UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
      })
    }
  }

  @IBAction func selectInput(_ sender: Any) {
    dimView.isHidden = false
    inputsView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @IBAction func cancelAdding(_ sender: Any) {
    resetInputsAttributes(entity: "Seeds")
    resetInputsAttributes(entity: "Phytos")
    resetInputsAttributes(entity: "Fertilizers")
    dismiss(animated: true, completion: nil)
  }

  func showEntitiesNumber(entities: [NSManagedObject], constraint: NSLayoutConstraint,
                          numberLabel: UILabel, addEntityButton: UIButton) {
    if entities.count > 0 && constraint.constant == 70 {
      addEntityButton.isHidden = true
      numberLabel.isHidden = false
      switch entities {
      case selectedEquipments:
        numberLabel.text = (entities.count == 1 ? "1 equipement" : "\(entities.count) equipements")
      case doers:
        numberLabel.text = (entities.count == 1 ? "1 personne" : "\(entities.count) personnes")
      case selectedInputs:
        numberLabel.text = (entities.count == 1 ? "1 intrant": "\(entities.count) intrants")
      default:
        return
      }
    } else {
      numberLabel.isHidden = true
      addEntityButton.isHidden = false
    }
  }
}

