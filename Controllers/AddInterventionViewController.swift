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

  // Validated Intervention
  @IBOutlet weak var interventionLogo: UIImageView!
  @IBOutlet weak var warningView: UIView!
  @IBOutlet weak var warningMessage: UILabel!

  // Working period
  @IBOutlet var workingPeriodTapGesture: UITapGestureRecognizer!
  @IBOutlet weak var workingPeriodHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var selectedWorkingPeriodLabel: UILabel!
  @IBOutlet weak var workingPeriodExpandImageView: UIImageView!
  @IBOutlet weak var workingPeriodDateButton: UIButton!
  @IBOutlet weak var workingPeriodDurationTextField: UITextField!
  @IBOutlet weak var workingPeriodUnitLabel: UILabel!

  // Irrigation
  @IBOutlet var irrigationTapGesture: UITapGestureRecognizer!
  @IBOutlet weak var irrigationView: UIView!
  @IBOutlet weak var irrigationHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var selectedIrrigationLabel: UILabel!
  @IBOutlet weak var irrigationExpandImageView: UIImageView!
  @IBOutlet weak var irrigationVolumeTextField: UITextField!
  @IBOutlet weak var irrigationUnitButton: UIButton!
  @IBOutlet weak var irrigationErrorLabel: UILabel!
  @IBOutlet weak var irrigationSeparatorView: UIView!

  // Inputs
  @IBOutlet weak var inputsView: UIView!
  @IBOutlet weak var inputsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var addInputsButton: UIButton!
  @IBOutlet weak var inputsCollapseButton: UIButton!
  @IBOutlet weak var inputsNumber: UILabel!
  @IBOutlet weak var selectedInputsTableView: UITableView!
  @IBOutlet weak var selectedInputsTableViewHeightConstraint: NSLayoutConstraint!
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

  // Weather
  @IBOutlet weak var weatherViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var currentWeatherLabel: UILabel!
  @IBOutlet weak var weatherCollapseButton: UIButton!
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

  // Notes
  @IBOutlet weak var notesTextField: UITextField!

  // Bottom view
  @IBOutlet weak var bottomBarView: UIView!
  @IBOutlet weak var bottomView: UIView!

  // Harvest
  @IBOutlet weak var harvestView: UIView!
  @IBOutlet weak var harvestTableView: UITableView!
  @IBOutlet weak var harvestViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var harvestTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var harvestNature: UILabel!
  @IBOutlet weak var harvestType: UIButton!
  @IBOutlet weak var harvestSeparatorView: UIView!
  @IBOutlet weak var addALoad: UIButton!

  // MARK: - Properties

  var interventionState: InterventionState.RawValue!
  var currentIntervention: Interventions!
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
  var selectedEquipments = [Equipments]()
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
  var harvests = [Harvests]()
  var harvestNaturePickerView: CustomPickerView!
  var harvestUnitPickerView: CustomPickerView!
  var storagesPickerView: CustomPickerView!
  var storages = [Storages]()
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

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

    initUnitMeasurePickerView()

    saveInterventionButton.layer.cornerRadius = 3
    setupWorkingPeriodView()
    setupIrrigationView()
    setupInputsView()
    setupMaterialsView()
    setupEquipmentsView()
    setupPersonsView()
    initHarvestView()
    initWeatherView()
    notesTextField.delegate = self

    cropsView = CropsView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
    cropsView.currentIntervention = currentIntervention
    cropsView.interventionState = interventionState
    loadInterventionInAppropriateMode()
    cropsView.fetchCrops()
    cropsView.validateButton.addTarget(self, action: #selector(validateCrops), for: .touchUpInside)
    view.addSubview(cropsView)

    if interventionState != nil {
      totalLabel.text = cropsView.selectedCropsLabel.text
      totalLabel.textColor = AppColor.TextColors.DarkGray
    }

    initializeBarButtonItems()

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
    performSegue(withIdentifier: "showSpecies", sender: self)
  }

  @objc func showAlert() {
    present(inputsSelectionView.fertilizerView.natureAlertController, animated: true, completion: nil)
  }

  // MARK: Bar button

  func initializeBarButtonItems() {
    var barButtonItems = [UIBarButtonItem]()
    let navigationItem = UINavigationItem(title: "")
    let typeLabel = UILabel()

    if interventionType != nil {
      typeLabel.text = interventionType.localized
    }
    typeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
    typeLabel.textColor = .white
    let typeItem = UIBarButtonItem.init(customView: typeLabel)

    if interventionState == InterventionState.Validated.rawValue {
      let backButton = UIButton()
      let buttonImage = UIImage(named: "exit-arrow")?.withRenderingMode(.alwaysTemplate)

      backButton.setImage(buttonImage, for: .normal)
      backButton.tintColor = .white
      backButton.addTarget(self, action: #selector(goBackToInterventionViewController), for: .touchUpInside)
      let backItem = UIBarButtonItem.init(customView: backButton)

      barButtonItems.append(backItem)
    }
    barButtonItems.append(typeItem)
    navigationItem.leftBarButtonItems = barButtonItems
    navigationBar.setItems([navigationItem], animated: true)
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

  func displayInputQuantityInReadOnlyMode(quantity: String?, unit: String?, cell: SelectedInputCell) {
    if interventionState == InterventionState.Validated.rawValue {
      cell.inputQuantity.placeholder = quantity
      cell.unitMeasureButton.setTitle(unit?.localized, for: .normal)
      cell.unitMeasureButton.setTitleColor(.lightGray, for: .normal)
    } else if quantity == "0" || quantity == nil {
      cell.inputQuantity.placeholder = "0"
    } else {
      cell.inputQuantity.text = quantity
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case selectedInputsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedInputCell", for: indexPath) as! SelectedInputCell

      cell.selectionStyle = .none
      if selectedInputs.count > indexPath.row {
        let selectedInput = selectedInputs[indexPath.row]
        let unit = selectedInput.value(forKey: "unit") as? String

        cell.cellDelegate = self
        cell.addInterventionViewController = self
        cell.indexPath = indexPath
        cell.unitMeasureButton.setTitle(unit?.localized, for: .normal)
        cell.backgroundColor = AppColor.ThemeColors.DarkWhite

        switch selectedInput {
        case is InterventionSeeds:
          let interventionSeed = selectedInput as! InterventionSeeds

          cell.inputName.text = interventionSeed.seeds?.specie?.localized
          cell.inputLabel.text = interventionSeed.seeds?.variety
          cell.type = "Seed"
          cell.inputImageView.image = UIImage(named: "seed")
          displayInputQuantityInReadOnlyMode(quantity: (interventionSeed.quantity as NSNumber?)?.stringValue,
                                             unit: interventionSeed.unit, cell: cell)
        case is InterventionPhytosanitaries:
          let interventionPhyto = selectedInput as! InterventionPhytosanitaries

          cell.inputName.text = interventionPhyto.phytos?.name
          cell.inputLabel.text = interventionPhyto.phytos?.firmName
          cell.type = "Phyto"
          cell.inputImageView.image = UIImage(named: "phytosanitary")
          displayInputQuantityInReadOnlyMode(quantity: (interventionPhyto.quantity as NSNumber?)?.stringValue,
                                             unit: interventionPhyto.unit, cell: cell)
        case is InterventionFertilizers:
          let interventionFertilizer = selectedInput as! InterventionFertilizers

          cell.inputName.text = interventionFertilizer.fertilizers?.name?.localized
          cell.inputLabel.text = interventionFertilizer.fertilizers?.nature?.localized
          cell.type = "Fertilizer"
          cell.inputImageView.image = UIImage(named: "fertilizer")
          displayInputQuantityInReadOnlyMode(quantity: (interventionFertilizer.quantity as NSNumber?)?.stringValue,
                                             unit: interventionFertilizer.unit, cell: cell)
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

      if interventionState != nil {
        cell.driverSwitch.isOn = selectedPersons[1][indexPath.row].value(forKey: "isDriver") as! Bool
      }
      cell.firstNameLabel.text = selectedPerson.value(forKey: "firstName") as? String
      cell.lastNameLabel.text = selectedPerson.value(forKey: "lastName") as? String
      cell.deleteButton.addTarget(self, action: #selector(tapPersonsDeleteButton), for: .touchUpInside)
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
      cell.storage.setTitle(harvests[indexPath.row].storages?.name ?? "---", for: .normal)
      cell.quantity.keyboardType = .decimalPad
      cell.quantity.layer.borderColor = AppColor.CellColors.LightGray.cgColor
      cell.quantity.layer.borderWidth = 1
      cell.quantity.layer.cornerRadius = 5
      if interventionState == InterventionState.Validated.rawValue {
        cell.quantity.placeholder = String(harvest.quantity)
        cell.number.placeholder = harvest.number
      } else if harvest.quantity == 0 {
        cell.quantity.placeholder = "0"
        cell.number.text = harvest.number
      } else {
        cell.quantity.text = String(harvest.quantity)
        cell.number.text = harvest.number
      }
      cell.quantity.delegate = cell
      cell.number.layer.borderColor =  AppColor.CellColors.LightGray.cgColor
      cell.number.layer.borderWidth = 1
      cell.number.layer.cornerRadius = 5
      cell.number.delegate = cell
      cell.selectionStyle = .none
      return cell
    default:
      fatalError("Unknown tableView: \(tableView)")
    }
  }

  private func getSelectedEquipmentInfos(_ equipment: Equipments) -> String {
    let type = equipment.type!.localized
    guard let number = equipment.number else {
      return type
    }

    return String(format: "%@ #%@", type, number)
  }

  // Expand/collapse cell when tapped
  var selectedIndexPath: IndexPath?
  var indexPaths: [IndexPath] = []

  func defineTableViewSize(_ tableView: UITableView) -> CGFloat {
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

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return defineTableViewSize(tableView)
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return defineTableViewSize(tableView)
  }

  func resizeViewAndTableView(viewHeightConstraint: NSLayoutConstraint, tableViewHeightConstraint: NSLayoutConstraint,
                              tableView: UITableView) {
    tableViewHeightConstraint.constant = tableView.contentSize.height
    viewHeightConstraint.constant = tableViewHeightConstraint.constant + 100
  }

  // MARK: - Core Data

  func createIntervention() {
    if !checkErrorsAccordingInterventionType() {
      return
    }
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let workingPeriod = WorkingPeriods(context: managedContext)
    let duration = workingPeriodDurationTextField.text!.floatValue

    currentIntervention = Interventions(context: managedContext)
    currentIntervention.type = interventionType
    currentIntervention.status = InterventionState.Created.rawValue
    currentIntervention.infos = notesTextField.text
    currentIntervention.farmID = appDelegate.farmID
    if interventionType == "IRRIGATION" {
      let waterVolume = irrigationVolumeTextField.text!.floatValue

      currentIntervention.waterQuantity = waterVolume
      switch irrigationUnitButton.titleLabel?.text {
      case "m³":
        currentIntervention.waterUnit = "CUBIC_METER"
      case "hl":
        currentIntervention.waterUnit = "HECTOLITER"
      case "l":
        currentIntervention.waterUnit = "LITER"
      default:
        currentIntervention.waterUnit = ""
      }
    }
    workingPeriod.interventions = currentIntervention
    workingPeriod.executionDate = selectDateView.datePicker.date
    workingPeriod.hourDuration = duration
    createTargets(intervention: currentIntervention)
    createEquipments(intervention: currentIntervention)
    createInterventionPersons(intervention: currentIntervention)
    saveInterventionInputs(intervention: currentIntervention)
    createMaterials(intervention: currentIntervention)
    createHarvest(intervention: currentIntervention)
    resetInputsAttributes(entity: "Seeds")
    resetInputsAttributes(entity: "Phytos")
    resetInputsAttributes(entity: "Fertilizers")
    saveWeather(intervention: currentIntervention)

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    performSegue(withIdentifier: "unwindToInterventionVC", sender: self)
  }

  func updateIntervention() {
    if !checkErrorsAccordingInterventionType() {
      return
    }
    let duration = workingPeriodDurationTextField.text!.floatValue

    currentIntervention.workingPeriods?.executionDate = selectDateView.datePicker.date
    currentIntervention.workingPeriods?.hourDuration = duration
    currentIntervention.infos = notesTextField.text
    if interventionType == "IRRIGATION" {
      let waterVolume = irrigationVolumeTextField.text!.floatValue

      currentIntervention.waterQuantity = waterVolume
      switch irrigationUnitButton.titleLabel?.text {
      case "m³":
        currentIntervention.waterUnit = "CUBIC_METER"
      case "hl":
        currentIntervention.waterUnit = "HECTOLITER"
      case "l":
        currentIntervention.waterUnit = "LITER"
      default:
        currentIntervention.waterUnit = ""
      }
    }
    updateTargets(intervention: currentIntervention)
    updateEquipments(intervention: currentIntervention)
    updatePersons(intervention: currentIntervention)
    updateInputs(intervention: currentIntervention)
    updateHarvest(intervention: currentIntervention)
    currentIntervention.status = InterventionState.Created.rawValue
    performSegue(withIdentifier: "unwindToInterventionVC", sender: self)
  }

  func updateEquipments(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsFetchRequest: NSFetchRequest<InterventionEquipments> = InterventionEquipments.fetchRequest()
    let predicate = NSPredicate(format: "interventions == %@", intervention)

    equipmentsFetchRequest.predicate = predicate
    do {
      let interventionEquipments = try managedContext.fetch(equipmentsFetchRequest)

      for interventionEquipment in interventionEquipments {
        managedContext.delete(interventionEquipment)
      }
      for selectedEquipment in selectedEquipments {
        let interventionEquipment = InterventionEquipments(context: managedContext)

        interventionEquipment.interventions = intervention
        interventionEquipment.equipments = selectedEquipment
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not fetch or save. \(error), \(error.userInfo)")
    }
  }

  func updateTargets(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let targetsFetchRequest: NSFetchRequest<Targets> = Targets.fetchRequest()
    let predicate = NSPredicate(format: "interventions == %@", intervention)

    targetsFetchRequest.predicate = predicate
    do {
      let targets = try managedContext.fetch(targetsFetchRequest)

      for target in targets {
        managedContext.delete(target)
      }
      createTargets(intervention: intervention)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func updatePersons(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionPersonsFetchRequest: NSFetchRequest<InterventionPersons> = InterventionPersons.fetchRequest()
    let predicate = NSPredicate(format: "interventions == %@", intervention)

    interventionPersonsFetchRequest.predicate = predicate
    do {
      let interventionPersons = try managedContext.fetch(interventionPersonsFetchRequest)

      for interventionPerson in interventionPersons {
        managedContext.delete(interventionPerson)
      }
      for selectedPerson in selectedPersons[1] {
        let person = InterventionPersons(context: managedContext)

        person.interventions = intervention
        person.isDriver = (selectedPerson as! InterventionPersons).isDriver
        person.persons = (selectedPerson as! InterventionPersons).persons
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not fetch or save. \(error), \(error.userInfo)")
    }
  }

  func updateHarvest(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvestsFetchRequest: NSFetchRequest<Harvests> = Harvests.fetchRequest()
    let predicate = NSPredicate(format: "interventions == %@", intervention)

    harvestsFetchRequest.predicate = predicate


    do {
      let fetchedHarvests = try managedContext.fetch(harvestsFetchRequest)

      for harvest in fetchedHarvests {
        managedContext.delete(harvest)
      }
      for harvestEntity in harvests {
        let harvest = Harvests(context: managedContext)
        let type = harvestType.titleLabel?.text

        harvest.interventions = intervention
        harvest.type = type
        harvest.number = harvestEntity.number
        harvest.quantity = harvestEntity.quantity
        harvest.unit = harvestEntity.unit
        harvest.storages = harvestEntity.storages
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func deleteInput(intervention: Interventions, inputName: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let inputsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: inputName)
    let predicate = NSPredicate(format: "interventions == %@", intervention)

    inputsFetchRequest.predicate = predicate

    do {
      let inputs = try managedContext.fetch(inputsFetchRequest)

      for input in inputs {
        managedContext.delete(input as! NSManagedObject)
      }
    } catch let error as NSError {
      print("Could not delete. \(error), \(error.userInfo)")
    }
  }

  func updateInputs(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    deleteInput(intervention: intervention, inputName: "InterventionSeeds")
    deleteInput(intervention: intervention, inputName: "InterventionPhytosanitaries")
    deleteInput(intervention: intervention, inputName: "InterventionFertilizers")

    do {
      for selectedInput in selectedInputs {
        switch selectedInput {
        case is InterventionSeeds:
          let selectedSeed = selectedInput as! InterventionSeeds
          let interventionSeed = InterventionSeeds(context: managedContext)

          interventionSeed.interventions = intervention
          interventionSeed.seeds = selectedSeed.seeds
          interventionSeed.quantity = selectedSeed.quantity
          interventionSeed.unit = selectedSeed.unit
        case is InterventionPhytosanitaries:
          let selectedPhyto = selectedInput as! InterventionPhytosanitaries
          let interventionPhyto = InterventionPhytosanitaries(context: managedContext)

          interventionPhyto.interventions = intervention
          interventionPhyto.phytos = selectedPhyto.phytos
          interventionPhyto.quantity = selectedPhyto.quantity
          interventionPhyto.unit = selectedPhyto.unit
        case is InterventionFertilizers:
          let selectedFertilizer = selectedInput as! InterventionFertilizers
          let interventionFertilizer = InterventionFertilizers(context: managedContext)

          interventionFertilizer.interventions = intervention
          interventionFertilizer.fertilizers = selectedFertilizer.fertilizers
          interventionFertilizer.quantity = selectedFertilizer.quantity
          interventionFertilizer.unit = selectedFertilizer.unit
        default:
          return
        }
      }
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

  func createTargets(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for selectedCrop in cropsView.selectedCrops {
      let target = Targets(context: managedContext)

      target.interventions = intervention
      target.crops = selectedCrop
      target.workAreaPercentage = 100
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createInterventionPersons(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for selectedPerson in selectedPersons[1] {
      let interventionPerson = InterventionPersons(context: managedContext)

      interventionPerson.interventions = intervention
      interventionPerson.isDriver = (selectedPerson as! InterventionPersons).isDriver
      interventionPerson.persons = (selectedPerson as! InterventionPersons).persons
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createHarvest(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for harvestEntity in harvests {
      let harvest = Harvests(context: managedContext)
      let type = harvestType.titleLabel?.text

      harvest.interventions = intervention
      harvest.type = type
      harvest.number = harvestEntity.number
      harvest.quantity = harvestEntity.quantity
      harvest.unit = harvestEntity.unit
      harvest.storages = harvestEntity.storages
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }


  func createMaterials(intervention: Interventions) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext


    for case let interventionMaterial as InterventionMaterials in selectedMaterials[1] {
      let index = selectedMaterials[1].firstIndex(of: interventionMaterial)!

      interventionMaterial.interventions = intervention
      interventionMaterial.materials = selectedMaterials[0][index] as? Materials
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
      let interventionEquipment = InterventionEquipments(context: managedContext)

      interventionEquipment.interventions = intervention
      interventionEquipment.equipments = selectedEquipment
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

  @IBAction func saveOrUpdateIntervention() {
    if interventionState == nil {
      createIntervention()
    } else if interventionState == InterventionState.Created.rawValue || interventionState == InterventionState.Synced.rawValue {
      updateIntervention()
    }
  }

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

  @objc func goBackToInterventionViewController() {
    performSegue(withIdentifier: "goBackToInterventionViewController", sender: self)
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
      saveCurrentWeather(self)
    case windSpeedTextField:
      saveCurrentWeather(self)
    default:
      return false
    }
    return false
  }

  // MARK: - Gesture recognizer

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    switch gestureRecognizer {
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
      for selectedCrop in cropsView.selectedCrops {
        if selectedCrop.species != cropsView.selectedCrops.first!.species {
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
    if checkCropsProduction() {
      if cropsView.selectedCropsLabel.text == "no_crop_selected".localized {
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

  @IBAction func selectInput(_ sender: Any) {
    dimView.isHidden = false
    inputsSelectionView.isHidden = false

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
      case selectedInputs:
        numberLabel.text = (entities.count == 1 ? "input".localized : String(format: "inputs".localized, entities.count))
      case selectedMaterials[1]:
        numberLabel.text = (entities.count == 1 ? "material".localized : String(format: "materials".localized, entities.count))
      case selectedEquipments:
        numberLabel.text = (entities.count == 1 ? "equipment".localized : String(format: "equipments".localized, entities.count))
      case selectedPersons[1]:
        numberLabel.text = (entities.count == 1 ? "person".localized : String(format: "persons".localized, entities.count))
      default:
        return
      }
    } else if interventionState == InterventionState.Validated.rawValue {
      addEntityButton.isHidden = true
      numberLabel.isHidden = (constraint.constant != 70)
      numberLabel.text = "none".localized
    } else {
      numberLabel.isHidden = true
      addEntityButton.isHidden = false
    }
  }
}
