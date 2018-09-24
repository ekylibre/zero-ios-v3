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
  @IBOutlet weak var equipmentNameWarning: UILabel!
  @IBOutlet weak var selectedEquipmentsTableView: UITableView!
  @IBOutlet weak var addEquipmentButton: UIButton!
  @IBOutlet weak var equipmentNumberLabel: UILabel!
  @IBOutlet weak var searchEquipment: UISearchBar!
  @IBOutlet weak var equipmentTypeTableView: UITableView!
  @IBOutlet weak var equipmentTypeButton: UIButton!
  @IBOutlet weak var equipmentTypeImage: UIImageView!
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
  @IBOutlet weak var cloudyButton: UIButton!
  @IBOutlet weak var sunnyButton: UIButton!
  @IBOutlet weak var cloudyPassageButton: UIButton!
  @IBOutlet weak var rainFallButton: UIButton!
  @IBOutlet weak var fogyButton: UIButton!
  @IBOutlet weak var rainButton: UIButton!
  @IBOutlet weak var snowButton: UIButton!
  @IBOutlet weak var stormButton: UIButton!
  @IBOutlet weak var harvestView: UIView!
  @IBOutlet weak var harvestTableView: UITableView!
  @IBOutlet weak var harvestViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var harvestTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var harvestNature: UILabel!
  @IBOutlet weak var harvestType: UIButton!

  // MARK: - Properties

  var newIntervention: Interventions!
  var interventionType: String!
  var equipments = [NSManagedObject]()
  var selectDateView: SelectDateView!
  var irrigationPickerView: CustomPickerView!
  var cropsView: CropsView!
  var inputsView: InputsView!
  var interventionEquipments = [NSManagedObject]()
  var equipmentsTableViewTopAnchor: NSLayoutConstraint!
  var selectedEquipments = [NSManagedObject]()
  var searchedEquipments = [NSManagedObject]()
  var equipmentTypes: [String]!
  var sortedEquipmentTypes: [String]!
  var selectedEquipmentType: String!
  var entities = [NSManagedObject]()
  var entitiesTableViewTopAnchor: NSLayoutConstraint!
  var searchedEntities = [NSManagedObject]()
  var doers = [NSManagedObject]()
  var createdSeed = [NSManagedObject]()
  var selectedInputs = [NSManagedObject]()
  var solidUnitPicker = UIPickerView()
  var liquidUnitPicker = UIPickerView()
  var pickerValue: String?
  var cellIndexPath: IndexPath!
  var weatherIsSelected: Bool = false
  var weathers = [UIButton]()
  var weather = NSManagedObject()
  var weatherTypes = [
    "cloudy".localized,
    "sunny".localized,
    "cloudy_passage".localized,
    "rain_fall".localized,
    "fogy".localized,
    "rain".localized,
    "snow".localized,
    "storm".localized]
  var harvests = [Harvests]()
  var harvestNaturePickerView: CustomPickerView!
  var harvestUnitPickerView: CustomPickerView!
  var storagesPickerView: CustomPickerView!
  var storages = [Storages]()
  let solidUnitMeasure = ["g", "g/ha", "g/m2", "kg", "kg/ha", "kg/m3", "q", "q/ha", "q/m2", "t", "t/ha", "t/m2"]
  let liquidUnitMeasure = ["l", "l/ha", "l/m2", "hl", "hl/ha", "hl/m2", "m3","m3/ha", "m3/m2"]

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
    equipmentTypeImage.image = defineEquipmentImage(equipmentName: selectedEquipmentType)

    fetchEntity(entityName: "Equipments", searchedEntity: &searchedEquipments, entity: &equipments)
    fetchEntity(entityName: "Entities", searchedEntity: &searchedEntities, entity: &entities)

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

    initializeWeatherView()
    weathers = defineWeathers()
    createWeather(windSpeed: 0, temperature: 0, weatherDescription: "cloudy")
    temperatureTextField.delegate = self
    temperatureTextField.keyboardType = .decimalPad

    windSpeedTextField.delegate = self
    windSpeedTextField.keyboardType = .decimalPad

    harvestType.layer.borderColor = AppColor.cgColor.LightGray
    harvestType.layer.borderWidth = 1
    harvestType.layer.cornerRadius = 5
    initHarvestView()

    setupViewsAccordingInterventionType()
  }

  private func setupViewsAccordingInterventionType() {
    switch interventionType {
    case Intervention.InterventionType.Care.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      harvestView.isHidden = true
    case Intervention.InterventionType.CropProtection.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      harvestView.isHidden = true
      inputsView.segmentedControl.selectedSegmentIndex = 1
      inputsView.createButton.setTitle("+ CRÉER UN NOUVEAU PHYTO", for: .normal)
    case Intervention.InterventionType.Fertilization.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      harvestView.isHidden = true
      inputsView.segmentedControl.selectedSegmentIndex = 2
      inputsView.createButton.setTitle("+ CRÉER UN NOUVEAU FERTILISANT", for: .normal)
    case Intervention.InterventionType.GroundWork.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsSelectionView.isHidden = true
      inputsSeparatorView.isHidden = true
      harvestView.isHidden = true
    case Intervention.InterventionType.Harvest.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      inputsSelectionView.isHidden = true
      inputsSeparatorView.isHidden = true
    case Intervention.InterventionType.Implantation.rawValue.localized:
      irrigationView.isHidden = true
      irrigationSeparatorView.isHidden = true
      harvestView.isHidden = true
    case Intervention.InterventionType.Irrigation.rawValue.localized:
      harvestView.isHidden = true
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
    case harvestTableView:
      return harvests.count
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
    var input: NSManagedObject?
    var harvest: NSManagedObject?

    switch tableView {
    case selectedInputsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedInputCell", for: indexPath) as! SelectedInputCell

      if selectedInputs.count > indexPath.row {
        input = selectedInputs[indexPath.row]
        let quantity = String(input?.value(forKey: "quantity") as! Double)
        cell.cellDelegate = self
        cell.addInterventionViewController = self
        cell.indexPath = indexPath
        cell.type = input?.value(forKey: "type") as! String
        cell.inputQuantity.text = quantity
        cell.unitMeasureButton.setTitle(input?.value(forKey: "unit") as? String, for: .normal)
        cell.backgroundColor = AppColor.ThemeColors.DarkWhite

        switch cell.type {
        case "Seed":
          let specie = input?.value(forKey: "specie") as? String

          cell.inputName.text = specie?.localized
          cell.inputLabel.text = input?.value(forKey: "variety") as? String
          cell.inputImage.image = #imageLiteral(resourceName: "seed")
        case "Phyto":
          cell.inputName.text = input?.value(forKey: "name") as? String
          cell.inputLabel.text = input?.value(forKey: "firmName") as? String
          cell.inputImage.image = #imageLiteral(resourceName: "phytosanitary")
        case "Fertilizer":
          let name = input?.value(forKey: "name") as? String

          cell.inputName.text = name?.localized
          cell.inputImage.image = #imageLiteral(resourceName: "fertilizer")
        default:
          print("No type")
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
    case harvestTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "HarvestCell", for: indexPath) as! HarvestCell

      harvest = harvests[indexPath.row]
      cell.addInterventionController = self
      cell.cellDelegate = self
      cell.indexPath = indexPath
      cell.unit.layer.borderColor = AppColor.cgColor.LightGray
      cell.unit.layer.borderWidth = 1
      cell.unit.layer.cornerRadius = 5
      cell.unit.setTitle(harvest?.value(forKey: "unit") as? String, for: .normal)
      cell.storage.backgroundColor = AppColor.ThemeColors.White
      cell.storage.layer.borderColor = AppColor.cgColor.LightGray
      cell.storage.layer.borderWidth = 1
      cell.storage.layer.cornerRadius = 5
      cell.storage.setTitle(harvests[indexPath.row].storages?.name ?? "---", for: .normal)
      cell.quantity.keyboardType = .decimalPad
      cell.quantity.layer.borderColor = AppColor.cgColor.LightGray
      cell.quantity.layer.borderWidth = 1
      cell.quantity.layer.cornerRadius = 5
      cell.quantity.text = String(harvest?.value(forKey: "quantity") as! Double)
      cell.quantity.delegate = cell
      cell.number.layer.borderColor =  AppColor.cgColor.LightGray
      cell.number.layer.borderWidth = 1
      cell.number.layer.cornerRadius = 5
      cell.number.text = harvest?.value(forKey: "number") as? String
      cell.number.delegate = cell
      return cell
    default:
      fatalError("Unknown tableView: \(tableView)")
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
      equipmentTypeImage.image = defineEquipmentImage(equipmentName: selectedEquipmentType)
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
    case harvestTableView:
      return 150
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
    case harvestTableView:
      return 150
    default:
      return 60
    }
  }

  func resizeViewAndTableView(viewHeightConstraint: NSLayoutConstraint, tableViewHeightConstraint: NSLayoutConstraint,
                              tableView: UITableView) {
    tableViewHeightConstraint.constant = tableView.contentSize.height
    viewHeightConstraint.constant = tableViewHeightConstraint.constant + 100
  }

  // MARK: - Core Data

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
    if interventionType == "irrigation".localized {
      let waterQuantityString = irrigationValueTextField.text!.replacingOccurrences(of: ",", with: ".")
      let waterQuantity = Float(waterQuantityString) ?? 0
      newIntervention.waterQuantity = waterQuantity
      newIntervention.waterUnit = irrigationUnitButton.titleLabel!.text
    }
    workingPeriod.interventions = newIntervention
    workingPeriod.executionDate = selectDateView.datePicker.date
    let durationString = durationTextField.text!.replacingOccurrences(of: ",", with: ".")
    let hourDuration = Float(durationString) ?? 0
    workingPeriod.hourDuration = hourDuration
    createTargets(intervention: newIntervention)
    createEquipments(intervention: newIntervention)
    createDoers(intervention: newIntervention)
    saveHarvest(intervention: newIntervention)
    saveWeather(intervention: newIntervention)

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

  func saveHarvest(intervention: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvestEntity = NSEntityDescription.entity(forEntityName: "Harvests", in: managedContext)!

    for harvest in harvests {
      let harvestManagedObject = NSManagedObject(entity: harvestEntity, insertInto: managedContext)
      let type = harvestType.titleLabel?.text

      harvestManagedObject.setValue(intervention, forKey: "interventions")
      harvestManagedObject.setValue(type, forKey: "type")
      harvestManagedObject.setValue(harvest.value(forKey: "number"), forKey: "number")
      harvestManagedObject.setValue(harvest.value(forKey: "quantity"), forKey: "quantity")
      harvestManagedObject.setValue(harvest.value(forKey: "unit"), forKey: "unit")
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func createEquipments(intervention: NSManagedObject) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsEntity = NSEntityDescription.entity(forEntityName: "InterventionEquipments", in: managedContext)!

    for selectedEquipment in selectedEquipments {
      let equipment = NSManagedObject(entity: equipmentsEntity, insertInto: managedContext)

      equipment.setValue(intervention, forKey: "interventions")
      equipment.setValue(selectedEquipment, forKey: "equipments")
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
      doer.setValue(entity, forKey: "entities")
      doer.setValue(isDriver, forKey: "isDriver")
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func saveWeather(intervention: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let weatherEntity = NSEntityDescription.entity(forEntityName: "Weather", in: managedContext)!
    let currentWeather = NSManagedObject(entity: weatherEntity, insertInto: managedContext)

    currentWeather.setValue(intervention, forKey: "interventions")
    currentWeather.setValue(weather.value(forKey: "temperature"), forKey: "temperature")
    currentWeather.setValue(weather.value(forKey: "weatherDescription"), forKey: "weatherDescription")
    currentWeather.setValue(weather.value(forKey: "windSpeed"), forKey: "windSpeed")

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
      if temperatureTextField.text == "" && windSpeedTextField.text == "" {
        currentWeatherLabel.text = "not_filled_in".localized
      } else {
        let temperature = (temperatureTextField.text != "" ? temperatureTextField.text : "--")
        let wind = (windSpeedTextField.text != "" ? windSpeedTextField.text : "--")
        let currentTemperature = String(format: "temp".localized, temperature!)
        let currentWind = String(format: "wind".localized, wind!)

        currentWeatherLabel.text = currentTemperature + currentWind
      }
      weather.setValue((temperatureTextField.text! as NSString).doubleValue, forKey: "temperature")
    case windSpeedTextField:
      if temperatureTextField.text == "" && windSpeedTextField.text == "" {
        currentWeatherLabel.text = "not_filled_in".localized
      } else {
        let temperature = (temperatureTextField.text != "" ? temperatureTextField.text : "--")
        let wind = (windSpeedTextField.text != "" ? windSpeedTextField.text : "--")
        let currentTemperature = String(format: "temp".localized, temperature!)
        let currentWind = String(format: "wind".localized, wind!)

        currentWeatherLabel.text = currentTemperature + currentWind
      }
      weather.setValue((windSpeedTextField.text! as NSString).doubleValue, forKey: "windSpeed")
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
    if cropsView.selectedCropsLabel.text == "no_selection".localized {
      totalLabel.text = "select".localized
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
    /*dimView.isHidden = false
     workingPeriodView.isHidden = false

     UIView.animate(withDuration: 0.5, animations: {
     UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
     })*/
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

  @objc func validateDate() {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "local_code".localized)
    dateFormatter.dateFormat = "d MMMM"
    let selectedDate = dateFormatter.string(from: selectDateView.datePicker.date)
    selectDateButton.setTitle(selectedDate, for: .normal)

    selectDateView.isHidden = true
    dimView.isHidden = true

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
  }

  @IBAction func selectInput(_ sender: Any) {
    dimView.isHidden = false
    inputsView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @IBAction func cancelAdding(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  func showEntitiesNumber(entities: [NSManagedObject], constraint: NSLayoutConstraint,
                          numberLabel: UILabel, addEntityButton: UIButton) {

    if entities.count > 0 && constraint.constant == 70 {
      addEntityButton.isHidden = true
      numberLabel.isHidden = false
      switch entities {
      case selectedEquipments:
        numberLabel.text = (entities.count == 1 ? "one_equipment".localized : String(format: "equipments".localized, entities.count))
      case doers:
        numberLabel.text = (entities.count == 1 ? "one_person".localized : String(format: "people".localized, entities.count))
      case selectedInputs:
        numberLabel.text = (entities.count == 1 ? "one_input".localized : String(format: "inputs".localized, entities.count))
      default:
        return
      }
    } else {
      numberLabel.isHidden = true
      addEntityButton.isHidden = false
    }
  }
}
