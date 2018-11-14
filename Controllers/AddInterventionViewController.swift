//
//  AddInterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 30/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class AddInterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate, WriteValueBackDelegate, XMLParserDelegate {

  // MARK: - Outlets

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var saveInterventionButton: UIButton!
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var totalLabel: UILabel!

  // Working period
  @IBOutlet weak var workingPeriodHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var selectedWorkingPeriodLabel: UILabel!
  @IBOutlet weak var workingPeriodExpandImageView: UIImageView!
  @IBOutlet weak var workingPeriodDateButton: UIButton!
  @IBOutlet weak var workingPeriodDurationTextField: UITextField!
  @IBOutlet weak var workingPeriodUnitLabel: UILabel!

  // Irrigation
  @IBOutlet weak var irrigationView: UIView!
  @IBOutlet weak var irrigationHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var selectedIrrigationLabel: UILabel!
  @IBOutlet weak var irrigationExpandImageView: UIImageView!
  @IBOutlet weak var irrigationVolumeTextField: UITextField!
  @IBOutlet weak var irrigationUnitButton: UIButton!
  @IBOutlet weak var irrigationErrorLabel: UILabel!
  @IBOutlet weak var irrigationSeparatorView: UIView!

  // Inputs
  @IBOutlet var inputsTapGesture: UITapGestureRecognizer!
  @IBOutlet weak var inputsView: UIView!
  @IBOutlet weak var inputsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputsAddButton: UIButton!
  @IBOutlet weak var inputsCountLabel: UILabel!
  @IBOutlet weak var inputsExpandImageView: UIImageView!
  @IBOutlet weak var selectedInputsTableView: UITableView!
  @IBOutlet weak var inputsTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputsSeparatorView: UIView!

  // Materials
  @IBOutlet var materialsTapGesture: UITapGestureRecognizer!
  @IBOutlet weak var materialsView: UIView!
  @IBOutlet weak var materialsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var materialsAddButton: UIButton!
  @IBOutlet weak var materialsCountLabel: UILabel!
  @IBOutlet weak var materialsExpandImageView: UIImageView!
  @IBOutlet weak var selectedMaterialsTableView: UITableView!
  @IBOutlet weak var materialsTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var materialsSeparatorView: UIView!

  // Equipments
  @IBOutlet var equipmentsTapGesture: UITapGestureRecognizer!
  @IBOutlet weak var equipmentsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var equipmentsAddButton: UIButton!
  @IBOutlet weak var equipmentsCountLabel: UILabel!
  @IBOutlet weak var equipmentsExpandImageView: UIImageView!
  @IBOutlet weak var selectedEquipmentsTableView: UITableView!
  @IBOutlet weak var equipmentsTableViewHeightConstraint: NSLayoutConstraint!

  // Persons
  @IBOutlet var personsTapGesture: UITapGestureRecognizer!
  @IBOutlet weak var personsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var personsAddButton: UIButton!
  @IBOutlet weak var personsCountLabel: UILabel!
  @IBOutlet weak var personsExpandImageView: UIImageView!
  @IBOutlet weak var selectedPersonsTableView: UITableView!
  @IBOutlet weak var personsTableViewHeightConstraint: NSLayoutConstraint!

  @IBOutlet weak var weatherViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var currentWeatherLabel: UILabel!
  @IBOutlet weak var weatherExpandImageView: UIImageView!
  @IBOutlet weak var negativeTemperature: UIButton!
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

  // Harvest
  @IBOutlet weak var harvestView: UIView!
  @IBOutlet weak var harvestTableView: UITableView!
  @IBOutlet weak var harvestViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var harvestTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var harvestNature: UILabel!
  @IBOutlet weak var harvestType: UIButton!
  @IBOutlet weak var harvestSeparatorView: UIView!

  // MARK: - Properties

  var newIntervention: Intervention!
  var interventionType: String!
  var selectedRow: Int!
  var selectedValue: String!
  var selectDateView: SelectDateView!
  var irrigationPickerView: CustomPickerView!
  var cropsView: CropsView!
  var species: [String]!
  var inputsSelectionView: InputsView!
  var materialsSelectionView: MaterialsView!
  var equipmentsSelectionView: EquipmentsView!
  var personsSelectionView: PersonsView!
  var selectedMaterials = [[NSManagedObject]]()
  var interventionEquipments = [NSManagedObject]()
  var selectedEquipments = [Equipment]()
  var selectedPersons = [[NSManagedObject]]()
  var equipmentTypes: [String]!
  var createdSeed = [NSManagedObject]()
  var selectedInputs = [NSManagedObject]()
  var massUnitPicker = UIPickerView()
  var volumeUnitPicker = UIPickerView()
  var pickerValue: String?
  var cellIndexPath: IndexPath!
  var weather: Weather!
  var weatherIsSelected: Bool = false
  var harvests = [Harvest]()
  var harvestNaturePickerView: CustomPickerView!
  var harvestUnitPickerView: CustomPickerView!
  var harvestSelectedType: String!
  var storageCreationView: StorageCreationView!
  var storagesPickerView: CustomPickerView!
  var storagesTypes: CustomPickerView!
  var storages = [Storage]()
  var weatherButtons = [UIButton]()
  let massUnitMeasure = [
    "GRAM",
    "GRAM_PER_HECTARE",
    "GRAM_PER_SQUARE_METER",
    "KILOGRAM",
    "KILOGRAM_PER_HECTARE",
    "KILOGRAM_PER_SQUARE_METER",
    "QUINTAL",
    "QUINTAL_PER_HECTARE",
    "QUINTAL_PER_SQUARE_METER",
    "TON",
    "TON_PER_HECTARE",
    "TON_PER_SQUARE_METER"]
  let volumeUnitMeasure = [
    "LITER",
    "LITER_PER_HECTARE",
    "LITER_PER_SQUARE_METER",
    "HECTOLITER",
    "HECTOLITER_PER_HECTARE",
    "HECTOLITER_PER_SQUARE_METER",
    "CUBIC_METER",
    "CUBIC_METER_PER_HECTARE",
    "CUBIC_METER_PER_SQUARE_METER"]

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black

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

    initUnitMeasurePickerView()

    saveInterventionButton.layer.cornerRadius = 3

    cropsView = CropsView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
    view.addSubview(cropsView)
    cropsView.validateButton.addTarget(self, action: #selector(validateCrops), for: .touchUpInside)

    setupWorkingPeriodView()
    setupIrrigationView()
    setupInputsView()
    setupMaterialsView()
    setupEquipmentsView()
    setupPersonsView()

    initializeWeatherButtons()
    initWeather()
    setupWeatherActions()
    temperatureTextField.delegate = self
    temperatureTextField.keyboardType = .decimalPad
    windSpeedTextField.delegate = self
    windSpeedTextField.keyboardType = .decimalPad

    initHarvestView()

    setupViewsAccordingInterventionType()
  }

  private func setupViewsAccordingInterventionType() {
    switch interventionType {
    case InterventionType.Care.rawValue:
      materialsView.isHidden = false
      materialsSeparatorView.isHidden = false
    case InterventionType.CropProtection.rawValue:
      inputsSelectionView.segmentedControl.selectedSegmentIndex = 1
      inputsSelectionView.createButton.setTitle("create_new_phyto".localized.uppercased(), for: .normal)
    case InterventionType.Fertilization.rawValue:
      inputsSelectionView.segmentedControl.selectedSegmentIndex = 2
      inputsSelectionView.createButton.setTitle("create_new_ferti".localized.uppercased(), for: .normal)
    case InterventionType.GroundWork.rawValue:
      inputsView.isHidden = true
      inputsSeparatorView.isHidden = true
    case InterventionType.Harvest.rawValue:
      harvestView.isHidden = false
      harvestSeparatorView.isHidden = false
      inputsView.isHidden = true
      inputsSeparatorView.isHidden = true
    case InterventionType.Irrigation.rawValue:
      irrigationView.isHidden = false
      irrigationSeparatorView.isHidden = false
    default:
      return
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    // Changes inputsSelectionView frame and position
    let guide = self.view.safeAreaLayoutGuide
    let height = guide.layoutFrame.size.height

    cropsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: height - 30)
    cropsView.center.x = self.view.center.x
    cropsView.frame.origin.y = navigationBar.frame.origin.y + 15
  }

  @objc func showList() {
    self.performSegue(withIdentifier: "showSpecies", sender: self)
  }

  @objc func showAlert() {
    self.present(inputsSelectionView.fertilizerView.natureAlertController, animated: true, completion: nil)
  }

  // MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case selectedInputsTableView:
      return selectedInputs.count
    case selectedMaterialsTableView:
      return selectedMaterials[0].count
    case selectedEquipmentsTableView:
      return selectedEquipments.count
    case selectedPersonsTableView:
      return selectedPersons[0].count
    case harvestTableView:
      return harvests.count
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case selectedInputsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedInputCell", for: indexPath) as! SelectedInputCell

      if selectedInputs.count > indexPath.row {
        let selectedInput = selectedInputs[indexPath.row]
        let unit = selectedInput.value(forKey: "unit") as? String

        cell.cellDelegate = self
        cell.addInterventionViewController = self
        cell.indexPath = indexPath
        cell.unitButton.setTitle(unit?.localized, for: .normal)

        switch selectedInput {
        case is InterventionSeed:
          let seed = selectedInput.value(forKey: "seed") as! Seed

          cell.type = "Seed"
          cell.nameLabel.text = seed.specie?.localized
          cell.infoLabel.text = seed.variety
          cell.inputImageView.image = UIImage(named: "seed")
        case is InterventionPhytosanitary:
          let phyto = selectedInput.value(forKey: "phyto") as! Phyto

          cell.type = "Phyto"
          cell.nameLabel.text = phyto.name
          cell.infoLabel.text = phyto.firmName
          cell.inputImageView.image = UIImage(named: "phytosanitary")
        case is InterventionFertilizer:
          let fertilizer = selectedInput.value(forKey: "fertilizer") as! Fertilizer

          cell.type = "Fertilizer"
          cell.nameLabel.text = fertilizer.name?.localized
          cell.infoLabel.text = nil
          cell.inputImageView.image = UIImage(named: "fertilizer")
        default:
          fatalError("Unknown input type for: \(String(describing: selectedInput))")
        }
      }
      return cell
    case selectedMaterialsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedMaterialCell", for: indexPath) as! SelectedMaterialCell
      let name = selectedMaterials[0][indexPath.row].value(forKey: "name") as? String
      let quantity = selectedMaterials[1][indexPath.row].value(forKey: "quantity") as! Float
      let unit = selectedMaterials[1][indexPath.row].value(forKey: "unit") as? String

      cell.nameLabel.text = name
      cell.deleteButton.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
      cell.quantityTextField.text = (quantity == 0) ? "" : String(format: "%g", quantity)
      cell.quantityTextField.addTarget(self, action: #selector(updateMaterialQuantity), for: .editingChanged)
      cell.unitButton.setTitle(unit?.localized.lowercased(), for: .normal)
      cell.unitButton.addTarget(self, action: #selector(showSelectedMaterialUnits), for: .touchUpInside)
      return cell
    case selectedEquipmentsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedEquipmentCell", for: indexPath) as! SelectedEquipmentCell
      let selectedEquipment = selectedEquipments[indexPath.row]
      let imageName = selectedEquipment.type!.lowercased().replacingOccurrences(of: "_", with: "-")

      cell.typeImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
      cell.nameLabel.text = selectedEquipment.name
      cell.deleteButton.addTarget(self, action: #selector(tapEquipmentsDeleteButton), for: .touchUpInside)
      cell.infosLabel.text = getSelectedEquipmentInfos(selectedEquipment)
      return cell
    case selectedPersonsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedPersonCell", for: indexPath) as! SelectedPersonCell
      let selectedPerson = selectedPersons[0][indexPath.row]

      cell.firstNameLabel.text = selectedPerson.value(forKey: "firstName") as? String
      cell.lastNameLabel.text = selectedPerson.value(forKey: "lastName") as? String
      cell.deleteButton.addTarget(self, action: #selector(tapPersonsDeleteButton), for: .touchUpInside)
      cell.driverSwitch.isOn = selectedPersons[1][indexPath.row].value(forKey: "isDriver") as! Bool
      cell.driverSwitch.addTarget(self, action: #selector(updateIsDriver), for: .valueChanged)
      return cell
    case harvestTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "HarvestCell", for: indexPath) as! HarvestCell
      let harvest = harvests[indexPath.row]
      let unit = harvest.unit

      cell.addInterventionController = self
      cell.cellDelegate = self
      cell.indexPath = indexPath
      cell.unit.layer.borderColor = AppColor.CellColors.LightGray.cgColor
      cell.unit.layer.borderWidth = 1
      cell.unit.layer.cornerRadius = 5
      cell.unit.setTitle(unit?.localized, for: .normal)
      cell.storage.backgroundColor = AppColor.ThemeColors.White
      cell.storage.layer.borderColor = AppColor.CellColors.LightGray.cgColor
      cell.storage.layer.borderWidth = 1
      cell.storage.layer.cornerRadius = 5
      cell.storage.setTitle(harvests[indexPath.row].storage?.name ?? "---", for: .normal)
      cell.quantity.keyboardType = .decimalPad
      cell.quantity.layer.borderColor = AppColor.CellColors.LightGray.cgColor
      cell.quantity.layer.borderWidth = 1
      cell.quantity.layer.cornerRadius = 5
      cell.quantity.text = String(harvest.quantity)
      cell.quantity.delegate = cell
      cell.number.layer.borderColor =  AppColor.CellColors.LightGray.cgColor
      cell.number.layer.borderWidth = 1
      cell.number.layer.cornerRadius = 5
      cell.number.text = harvest.number
      cell.number.delegate = cell
      cell.selectionStyle = .none
      return cell
    default:
      fatalError("Unknown tableView: \(tableView)")
    }
  }

  private func getSelectedEquipmentInfos(_ equipment: Equipment) -> String {
    let type = equipment.type!.localized
    guard let number = equipment.number else {
      return type
    }

    return String(format: "%@ #%@", type, number)
  }

  // Expand/collapse cell when tapped
  var selectedIndexPath: IndexPath?
  var indexPaths: [IndexPath] = []

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch tableView {
    case harvestTableView:
      return 150
    case selectedInputsTableView:
      return 110
    case selectedMaterialsTableView:
      return 80
    case selectedEquipmentsTableView:
      return 55
    case selectedPersonsTableView:
      return 65
    default:
      return 60
    }
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    switch tableView {
    case harvestTableView:
      return 150
    case selectedInputsTableView:
      return 110
    case selectedMaterialsTableView:
      return 80
    case selectedEquipmentsTableView:
      return 55
    case selectedPersonsTableView:
      return 65
    default:
      return 60
    }
  }

  // MARK: - Core Data

  @IBAction func createIntervention() {
    if !checkErrorsAccordingInterventionType() {
      return
    }
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let workingPeriod = WorkingPeriod(context: managedContext)
    let duration = workingPeriodDurationTextField.text!.floatValue

    newIntervention = Intervention(context: managedContext)
    newIntervention.type = interventionType
    newIntervention.status = InterventionState.Created.rawValue
    newIntervention.infos = "Infos"
    newIntervention.farmID = appDelegate.farmID
    if interventionType == "IRRIGATION" {
      let waterVolume = irrigationVolumeTextField.text!.floatValue

      newIntervention.waterQuantity = waterVolume
      switch irrigationUnitButton.titleLabel?.text {
      case "m³":
        newIntervention.waterUnit = "CUBIC_METER"
      case "hl":
        newIntervention.waterUnit = "HECTOLITER"
      case "l":
        newIntervention.waterUnit = "LITER"
      default:
        newIntervention.waterUnit = ""
      }
    }
    workingPeriod.intervention = newIntervention
    workingPeriod.executionDate = selectDateView.datePicker.date
    workingPeriod.hourDuration = duration
    createTargets(intervention: newIntervention)
    createMaterials(intervention: newIntervention)
    createEquipments(intervention: newIntervention)
    saveHarvest(intervention: newIntervention)
    saveInterventionInputs(intervention: newIntervention)
    saveWeather(intervention: newIntervention)
    resetInputsAttributes(entity: "Seed")
    resetInputsAttributes(entity: "Phyto")
    resetInputsAttributes(entity: "Fertilizer")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    performSegue(withIdentifier: "unwindToInterventionVC", sender: self)
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

  func saveInterventionInputs(intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for selectedInput in selectedInputs {
      selectedInput.setValue(intervention, forKey: "intervention")
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func fetchSelectedCrops() -> [Crop] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return [Crop]()
    }

    var crops: [Crop]!
    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crop> = Crop.fetchRequest()
    let predicate = NSPredicate(format: "isSelected == true")

    cropsFetchRequest.predicate = predicate
    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return crops
  }

  func createTargets(intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let selectedCrops = fetchSelectedCrops()

    for crop in selectedCrops {
      let target = Target(context: managedContext)

      target.intervention = intervention
      target.crop = crop
      target.workAreaPercentage = 100
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func saveHarvest(intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for harvestEntity in harvests {
      let harvest = Harvest(context: managedContext)

      harvest.type = harvestSelectedType
      harvest.intervention = intervention
      harvest.number = harvestEntity.number
      harvest.quantity = harvestEntity.quantity
      harvest.unit = harvestEntity.unit
      harvest.storage = harvestEntity.storage
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createMaterials(intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for case let interventionMaterial as InterventionMaterial in selectedMaterials[1] {
      let index = selectedMaterials[1].firstIndex(of: interventionMaterial)!

      interventionMaterial.intervention = intervention
      interventionMaterial.material = selectedMaterials[0][index] as? Material
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createEquipments(intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    for selectedEquipment in selectedEquipments {
      let interventionEquipment = InterventionEquipment(context: managedContext)

      interventionEquipment.intervention = intervention
      interventionEquipment.equipment = selectedEquipment
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

  func saveWeather(intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    var currentWeather = Weather(context: managedContext)

    currentWeather = weather
    currentWeather.intervention = intervention

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Navigation

  // INFO: Needed to perform the unwind segue
  @IBAction func unwindToInterventionVCWithSegue(_ segue: UIStoryboardSegue) { }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //super.prepare(for: segue, sender: sender)
    switch segue.identifier {
    case "showSpecies":
      let destVC = segue.destination as! ListTableViewController
      destVC.delegate = self
      destVC.rawStrings = species
      destVC.tag = 0
    case "showMaterialUnits":
      let destVC = segue.destination as! ListTableViewController
      destVC.delegate = self
      destVC.rawStrings = ["METER", "UNITY", "THOUSAND", "LITER", "HECTOLITER",
                           "CUBIC_METER", "GRAM", "KILOGRAM", "QUINTAL", "TON"]
      destVC.tag = 1
    case "showSelectedMaterialUnits":
      let destVC = segue.destination as! ListTableViewController
      destVC.delegate = self
      destVC.rawStrings = ["METER", "UNITY", "THOUSAND", "LITER", "HECTOLITER",
                           "CUBIC_METER", "GRAM", "KILOGRAM", "QUINTAL", "TON"]
      destVC.tag = 2
    case "showEquipmentTypes":
      let destVC = segue.destination as! ListTableViewController
      destVC.delegate = self
      destVC.rawStrings = equipmentTypes
      destVC.tag = 3
    default:
      return
    }
  }

  func writeValueBack(tag: Int, value: String) {
    selectedValue = value

    switch tag {
    case 0:
      inputsSelectionView.seedView.rawSpecie = value
      inputsSelectionView.seedView.specieButton.setTitle(value.localized, for: .normal)
    case 1:
      materialsSelectionView.creationView.unitButton.setTitle(value.localized.lowercased(), for: .normal)
    case 2:
      selectedMaterials[1][selectedRow].setValue(value, forKey: "unit")
      selectedMaterialsTableView.reloadData()
    case 3:
      let imageName = value.lowercased().replacingOccurrences(of: "_", with: "-")

      equipmentsSelectionView.creationView.typeImageView.image = UIImage(named: imageName)
      equipmentsSelectionView.creationView.typeButton.setTitle(value.localized, for: .normal)
      equipmentsSelectionView.defineIndicatorsIfNeeded(value.lowercased())
    default:
      fatalError("writeValueBack: Unknown value for tag")
    }
  }

  // MARK: - Text Field Delegate

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let containsADot = ((textField.text?.contains("."))! || (textField.text?.contains(","))!)
    var invalidCharacters: CharacterSet!

    if containsADot || textField.text?.count == 0 {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789").inverted
    } else {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789.,").inverted
    }

    switch textField {
    case temperatureTextField:
      return string.rangeOfCharacter(
        from: invalidCharacters,
        options: [],
        range: string.startIndex ..< string.endIndex
        ) == nil
    case windSpeedTextField:
      return string.rangeOfCharacter(
        from: invalidCharacters,
        options: [],
        range: string.startIndex ..< string.endIndex
        ) == nil
    default:
      return true
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    switch textField {
    case temperatureTextField:
      weather.temperature = (temperatureTextField.text! as NSString).doubleValue as NSNumber
      if temperatureTextField.text == "" && windSpeedTextField.text == "" {
        currentWeatherLabel.text = "not_filled_in".localized
      } else {
        let temperature = (temperatureTextField.text != "" ? temperatureTextField.text : "--")
        let wind = (windSpeedTextField.text != "" ? windSpeedTextField.text : "--")
        let currentTemp = String(format: "temp".localized, temperature!)
        let currentWind = String(format: "wind".localized, wind!)

        currentWeatherLabel.text = currentTemp + currentWind
      }
    case windSpeedTextField:
      weather.windSpeed = (windSpeedTextField.text! as NSString).doubleValue as NSNumber
      if temperatureTextField.text == "" && windSpeedTextField.text == "" {
        currentWeatherLabel.text = "not_filled_in".localized
      } else {
        let temperature = (temperatureTextField.text != "" ? temperatureTextField.text : "--")
        let wind = (windSpeedTextField.text != "" ? windSpeedTextField.text : "--")
        let currentTemp = String(format: "temp".localized, temperature!)
        let currentWind = String(format: "wind".localized, wind!)

        currentWeatherLabel.text = currentTemp + currentWind
      }
    default:
      return false
    }
    return false
  }

  // MARK: - Gesture recognizer

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    switch gestureRecognizer {
    case inputsTapGesture:
      return !selectedInputsTableView.bounds.contains(touch.location(in: selectedInputsTableView))
    case materialsTapGesture:
      return !selectedMaterialsTableView.bounds.contains(touch.location(in: selectedMaterialsTableView))
    case equipmentsTapGesture:
      return !selectedEquipmentsTableView.bounds.contains(touch.location(in: selectedEquipmentsTableView))
    case personsTapGesture:
      return !selectedPersonsTableView.bounds.contains(touch.location(in: selectedPersonsTableView))
    default:
      fatalError("gestureRecognizer switch error: case not found")
    }
  }

  // MARK: - Actions

  @IBAction func selectCrops(_ sender: Any) {
    dimView.isHidden = false
    cropsView.isHidden = false

    updateAllInputQuantity()
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  func checkCropsProduction() -> Bool {
    if interventionType == "harvest" || interventionType == "implantation" {
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
    }
    return true
  }

  @objc func validateCrops(_ sender: Any) {
    if !checkCropsProduction() {
      return
    } else if cropsView.selectedCropsLabel.text == "no_crop_selected".localized {
      totalLabel.text = "select_crops".localized.uppercased()
      totalLabel.textColor = AppColor.TextColors.Green
    } else {
      totalLabel.text = cropsView.selectedCropsLabel.text
      totalLabel.textColor = AppColor.TextColors.DarkGray
    }
    totalLabel.sizeToFit()
    irrigationVolumeTextField.sendActions(for: .editingChanged)

    cropsView.isHidden = true
    dimView.isHidden = true

    updateAllInputQuantity()
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
  }

  @IBAction func cancelAdding(_ sender: Any) {
    resetInputsAttributes(entity: "Seed")
    resetInputsAttributes(entity: "Phyto")
    resetInputsAttributes(entity: "Fertilizer")
    dismiss(animated: true, completion: nil)
  }

  func showEntitiesNumber(entities: [NSManagedObject], constraint: NSLayoutConstraint,
                          numberLabel: UILabel, addEntityButton: UIButton) {
    if entities.count > 0 && constraint.constant == 70 {
      addEntityButton.isHidden = true
      numberLabel.isHidden = false
      switch entities {
      case selectedInputs:
        numberLabel.text = (entities.count == 1 ? "input".localized : String(format: "inputs".localized, entities.count))
      default:
        return
      }
    } else {
      numberLabel.isHidden = true
      addEntityButton.isHidden = false
    }
  }
}
