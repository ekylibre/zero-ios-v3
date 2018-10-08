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
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var collapseButton: UIButton!
  @IBOutlet weak var saveInterventionButton: UIButton!

  // Working Period
  @IBOutlet weak var workingPeriodHeight: NSLayoutConstraint!
  @IBOutlet weak var selectedWorkingPeriodLabel: UILabel!
  @IBOutlet weak var collapseWorkingPeriodImage: UIImageView!
  @IBOutlet weak var selectDateButton: UIButton!
  @IBOutlet weak var durationTextField: UITextField!
  @IBOutlet weak var durationUnitLabel: UILabel!

  // Inputs
  @IBOutlet weak var inputsSelectionView: UIView!
  @IBOutlet weak var inputsCollapseButton: UIButton!
  @IBOutlet weak var inputsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var addInputsButton: UIButton!
  @IBOutlet weak var inputsNumber: UILabel!
  @IBOutlet weak var selectedInputsTableView: UITableView!
  @IBOutlet weak var selectedInputsTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputsSeparatorView: UIView!

  // Irrigation
  @IBOutlet weak var irrigationView: UIView!
  @IBOutlet weak var irrigationHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var irrigationExpandCollapseImage: UIImageView!
  @IBOutlet weak var irrigationLabel: UILabel!
  @IBOutlet weak var irrigationValueTextField: UITextField!
  @IBOutlet weak var irrigationUnitButton: UIButton!
  @IBOutlet weak var irrigationInfoLabel: UILabel!
  @IBOutlet weak var irrigationSeparatorView: UIView!

  // Equipments
  @IBOutlet weak var equipmentsTableView: UITableView!
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
  @IBOutlet weak var equipmentHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var equipmentTableViewHeightConstraint: NSLayoutConstraint!

  // Entities
  @IBOutlet weak var createEntity: UIView!
  @IBOutlet weak var entityFirstName: UITextField!
  @IBOutlet weak var entityLastName: UITextField!
  @IBOutlet weak var selectEntitiesView: UIView!
  @IBOutlet weak var createEntitiesView: UIView!
  @IBOutlet weak var entitiesTableView: UITableView!
  @IBOutlet weak var entityRole: UITextField!
  @IBOutlet weak var entityDarkLayer: UIView!
  @IBOutlet weak var addEntitiesButton: UIButton!
  @IBOutlet weak var searchEntity: UISearchBar!
  @IBOutlet weak var doersTableView: UITableView!
  @IBOutlet weak var doersHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var doersTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var doersCollapsedButton: UIButton!
  @IBOutlet weak var doersNumber: UILabel!

  // Weather
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

  var interventionState: Intervention.State.RawValue!
  var currentIntervention: Interventions!
  var interventionType: String!
  var selectDateView: SelectDateView!
  var irrigationPickerView: CustomPickerView!
  var cropsView: CropsView!
  var inputsView: InputsView!
  var selectedInputs = [NSManagedObject]()
  var equipments = [Equipments]()
  var searchedEquipments = [Equipments]()
  var selectedEquipments = [InterventionEquipments]()
  var equipmentsTableViewTopAnchor: NSLayoutConstraint!
  var equipmentTypes: [String]!
  var sortedEquipmentTypes: [String]!
  var selectedEquipmentType: String!
  var entities = [Entities]()
  var searchedEntities = [Entities]()
  var doers = [Doers]()
  var entitiesTableViewTopAnchor: NSLayoutConstraint!
  var solidUnitPicker = UIPickerView()
  var liquidUnitPicker = UIPickerView()
  var pickerValue: String?
  var cellIndexPath: IndexPath!
  var weatherIsSelected: Bool = false
  var weatherButtons = [UIButton]()
  var weather: Weather!
  let solidUnitMeasure = ["g", "g/ha", "g/m2", "kg", "kg/ha", "kg/m2", "q", "q/ha", "q/m2", "t", "t/ha", "t/m2"]
  let liquidUnitMeasure = ["l", "l/ha", "l/m2", "hl", "hl/ha", "hl/m2", "m3","m3/ha", "m3/m2"]

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()
    super.moveViewWhenKeyboardAppears()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

    // Working period
    selectDateView = SelectDateView(frame: CGRect(x: 0, y: 0, width: 350, height: 250))
    selectDateView.center.x = self.view.center.x
    selectDateView.center.y = self.view.center.y
    view.addSubview(selectDateView)

    let dateFormatter = DateFormatter()

    dateFormatter.locale = Locale(identifier: "locale".localized)
    dateFormatter.dateFormat = "d MMM"
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
    durationTextField.addTarget(self, action: #selector(updateDurationUnit), for: .editingChanged)

    // Adds type label on the navigation bar
    let navigationItem = UINavigationItem(title: "")
    let typeLabel = UILabel()

    if interventionType != nil {
      typeLabel.text = interventionType
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

    setupIrrigation()

    initializeWeatherButtons()
    initWeather()
    temperatureTextField.delegate = self
    temperatureTextField.keyboardType = .decimalPad
    windSpeedTextField.delegate = self
    windSpeedTextField.keyboardType = .decimalPad

    loadInterventionData()

    setupViewsAccordingInterventionType()
    refreshSelectedEquipment()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  private func setupViewsAccordingInterventionType() {
    switch interventionType {
    case Intervention.InterventionType.Care.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
    case Intervention.InterventionType.CropProtection.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsView.segmentedControl.selectedSegmentIndex = 1
      inputsView.createButton.setTitle("+ CRÉER UN NOUVEAU PHYTO", for: .normal)
    case Intervention.InterventionType.Fertilization.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsView.segmentedControl.selectedSegmentIndex = 2
      inputsView.createButton.setTitle("+ CRÉER UN NOUVEAU FERTILISANT", for: .normal)
    case Intervention.InterventionType.GroundWork.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsSelectionView.isHidden = true
      inputsSeparatorView.isHidden = true
    case Intervention.InterventionType.Harvest.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsSelectionView.isHidden = true
      inputsSeparatorView.isHidden = true
    case Intervention.InterventionType.Implantation.rawValue.localized:
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
        cell.unitMeasureButton.setTitle(selectedInput.value(forKey: "unit") as? String, for: .normal)
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

      let selectedEquipment = selectedEquipments[indexPath.row]
      cell.cellDelegate = self
      cell.indexPath = indexPath
      cell.backgroundColor = AppColor.ThemeColors.DarkWhite
      cell.nameLabel.text = selectedEquipment.equipments?.name
      cell.typeLabel.text = selectedEquipment.equipments?.type
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

      addSelectedEquipment(equipment: searchedEquipments[indexPath.row])
      selectedEquipmentsTableView.reloadData()
      cell.isAvaible = false
      cell.backgroundColor = AppColor.CellColors.LightGray
      closeEquipmentsSelectionView()
    case equipmentTypeTableView:
      selectedEquipmentType = sortedEquipmentTypes[indexPath.row]
      equipmentTypeTableView.reloadData()
      equipmentTypeButton.setTitle(selectedEquipmentType, for: .normal)
      equipmentTypeTableView.isHidden = true
    case entitiesTableView:
      let cell = entitiesTableView.cellForRow(at: selectedIndexPath!) as! EntityCell

      if cell.isAvaible {
        addSelectedPerson(person: entities[indexPath.row])
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

  func createIntervention() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    currentIntervention = Interventions(context: managedContext)
    let workingPeriod = WorkingPeriods(context: managedContext)

    currentIntervention.type = interventionType
    currentIntervention.status = Intervention.Status.OutOfSync.rawValue
    currentIntervention.infos = "Infos"
    if interventionType == "IRRIGATION".localized {
      let waterVolume = irrigationValueTextField.text!.floatValue
      currentIntervention.waterQuantity = waterVolume
      currentIntervention.waterUnit = irrigationUnitButton.titleLabel!.text
    }
    workingPeriod.interventions = currentIntervention
    workingPeriod.executionDate = selectDateView.datePicker.date
    let duration = durationTextField.text!.floatValue
    workingPeriod.hourDuration = duration
    createTargets(intervention: currentIntervention)
    createEquipments(intervention: currentIntervention)
    createDoers(intervention: currentIntervention)
    saveInterventionInputs(intervention: currentIntervention)
    resetInputsAttributes(entity: "Seeds")
    resetInputsAttributes(entity: "Phytos")
    resetInputsAttributes(entity: "Fertilizers")
    saveWeather(intervention: currentIntervention)

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

  func createTargets(intervention: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let targetsEntity = NSEntityDescription.entity(forEntityName: "Targets", in: managedContext)!

    for selectedCrop in cropsView.selectedCrops {
      let target = NSManagedObject(entity: targetsEntity, insertInto: managedContext)

      target.setValue(intervention, forKey: "interventions")
      target.setValue(selectedCrop, forKey: "crops")
      target.setValue(100, forKey: "workAreaPercentage")
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

      equipment.interventions = intervention
      equipment.equipments = selectedEquipment.equipments
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createDoers(intervention: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let doersEntity = NSEntityDescription.entity(forEntityName: "Doers", in: managedContext)!

    for entity in doers {
      let doer = NSManagedObject(entity: doersEntity, insertInto: managedContext)
      let isDriver = entity.value(forKey: "isDriver")

      doer.setValue(intervention, forKey: "interventions")
      doer.setValue(UUID(), forKey: "uuid")
      doer.setValue(isDriver, forKey: "isDriver")
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
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

      if interventionState == Intervention.State.New.rawValue {
        createIntervention()
      }
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

  // MARK: - Text Field Delegate

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let containsADot = textField.text?.contains(".")
    var invalidCharacters: CharacterSet!

    if containsADot! {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789").inverted
    } else {
      invalidCharacters = NSCharacterSet(charactersIn: "0123456789.").inverted
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
      weather.temperature = (temperatureTextField.text! as NSString).doubleValue
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
      weather.windSpeed = (windSpeedTextField.text! as NSString).doubleValue
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

  // MARK: - Actions

  @IBAction func selectCrops(_ sender: Any) {
    dimView.isHidden = false
    cropsView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @objc func validateCrops(_ sender: Any) {
    if cropsView.selectedCropsLabel.text == "no_crop_selected".localized {
      totalLabel.text = "select_crops".localized.uppercased()
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

  @IBAction func selectWorkingPeriod(_ sender: Any) {
    let shouldExpand = (workingPeriodHeight.constant == 70)

    if shouldExpand {
      let dateString = selectDateButton.titleLabel!.text!
      let duration = durationTextField.text!.floatValue

      selectedWorkingPeriodLabel.text = String(format: "%@ • %g h", dateString, duration)
    }

    workingPeriodHeight.constant = shouldExpand ? 155 : 70
    selectedWorkingPeriodLabel.isHidden = shouldExpand
    selectDateButton.isHidden = !shouldExpand
    collapseWorkingPeriodImage.transform = collapseWorkingPeriodImage.transform.rotated(by: CGFloat.pi)
  }

  @IBAction func selectDate(_ sender: Any) {
    dimView.isHidden = false
    selectDateView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @objc func validateDate() {
    let dateFormatter = DateFormatter()
    let selectedDate: String

    dateFormatter.locale = Locale(identifier: "locale".localized)
    dateFormatter.dateFormat = "d MMM"
    selectedDate = dateFormatter.string(from: selectDateView.datePicker.date)
    selectDateButton.setTitle(selectedDate, for: .normal)
    selectDateView.isHidden = true
    dimView.isHidden = true

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
  }

  @objc func updateDurationUnit() {
    let duration = durationTextField.text!.floatValue

    durationUnitLabel.text = (duration <= 1) ? "hour".localized : "hours".localized
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
        numberLabel.text = (entities.count == 1 ? "equipment".localized : String(format: "equipments".localized, entities.count))
      case doers:
        numberLabel.text = (entities.count == 1 ? "person".localized : String(format: "persons".localized, entities.count))
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

