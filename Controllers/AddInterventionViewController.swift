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
  var selectedRow: Int!
  var selectedValue: String!
  var selectDateView: SelectDateView!
  var irrigationPickerView: CustomPickerView!
  var cropsView: CropsView!
  var inputsSelectionView: InputsView!
  var materialsSelectionView: MaterialsView!
  var equipmentsSelectionView: EquipmentsView!
  var personsSelectionView: PersonsView!
  var selectedMaterials = [[NSManagedObject]]()
  var interventionEquipments = [NSManagedObject]()
  var selectedEquipments = [Equipments]()
  var selectedPersons = [[NSManagedObject]]()
  var equipmentTypes: [String]!
  var createdSeed = [NSManagedObject]()
  var selectedInputs = [NSManagedObject]()
  var solidUnitPicker = UIPickerView()
  var liquidUnitPicker = UIPickerView()
  var pickerValue: String?
  var cellIndexPath: IndexPath!
  var weatherIsSelected: Bool = false
  var weatherButtons = [UIButton]()
  var weather: Weather!
  let solidUnitMeasure = ["g", "g/ha", "g/m2", "kg", "kg/ha", "kg/m2", "q", "q/ha", "q/m2", "t", "t/ha", "t/m2"]
  let liquidUnitMeasure = ["l", "l/ha", "l/m2", "hl", "hl/ha", "hl/m2", "m3","m3/ha", "m3/m2"]

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()
    super.moveViewWhenKeyboardAppears()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

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

    initUnitMeasurePickerView()

    saveInterventionButton.layer.cornerRadius = 3

    selectedInputsTableView.register(SelectedInputCell.self, forCellReuseIdentifier: "SelectedInputCell")
    selectedInputsTableView.delegate = self
    selectedInputsTableView.dataSource = self
    selectedInputsTableView.bounces = false
    selectedInputsTableView.layer.borderWidth  = 0.5
    selectedInputsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedInputsTableView.backgroundColor = AppColor.ThemeColors.DarkWhite
    selectedInputsTableView.layer.cornerRadius = 4

    inputsSelectionView = InputsView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    inputsSelectionView.addInterventionViewController = self
    view.addSubview(inputsSelectionView)

    cropsView = CropsView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
    view.addSubview(cropsView)
    cropsView.validateButton.addTarget(self, action: #selector(validateCrops), for: .touchUpInside)

    selectedMaterials.append([Materials]())
    selectedMaterials.append([InterventionMaterials]())
    setupWorkingPeriodView()
    setupIrrigationView()
    setupMaterialsView()
    equipmentTypes = loadEquipmentTypes()
    setupEquipmentsView()
    selectedPersons.append([Persons]())
    selectedPersons.append([InterventionPersons]())
    setupPersonsView()

    initializeWeatherButtons()
    initWeather()
    temperatureTextField.delegate = self
    temperatureTextField.keyboardType = .decimalPad
    windSpeedTextField.delegate = self
    windSpeedTextField.keyboardType = .decimalPad

    setupViewsAccordingInterventionType()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }

  private func setupViewsAccordingInterventionType() {
    switch interventionType {
    case Intervention.InterventionType.Care.rawValue:
      materialsView.isHidden = false
      materialsSeparatorView.isHidden = false
    case Intervention.InterventionType.CropProtection.rawValue:
      inputsSelectionView.segmentedControl.selectedSegmentIndex = 1
      inputsSelectionView.createButton.setTitle("create_new_phyto".localized.uppercased(), for: .normal)
    case Intervention.InterventionType.Fertilization.rawValue:
      inputsSelectionView.segmentedControl.selectedSegmentIndex = 2
      inputsSelectionView.createButton.setTitle("create_new_ferti".localized.uppercased(), for: .normal)
    case Intervention.InterventionType.GroundWork.rawValue:
      inputsView.isHidden = true
      inputsView.isHidden = true
    case Intervention.InterventionType.Harvest.rawValue:
      inputsSelectionView.isHidden = true
      inputsSeparatorView.isHidden = true
    case Intervention.InterventionType.Irrigation.rawValue:
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
    inputsSelectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: height - 30)
    inputsSelectionView.center.x = self.view.center.x
    inputsSelectionView.frame.origin.y = navigationBar.frame.origin.y + 15
    inputsSelectionView.seedView.specieButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
    inputsSelectionView.fertilizerView.natureButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)

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
          cell.inputImageView.image = UIImage(named: "seed")
        case is InterventionPhytosanitaries:
          let phyto = selectedInput.value(forKey: "phytos") as! Phytos
          cell.inputName.text = phyto.name
          cell.inputLabel.text = phyto.firmName
          cell.inputImageView.image = UIImage(named: "phytosanitary")
        case is InterventionFertilizers:
          let fertilizer = selectedInput.value(forKey: "fertilizers") as! Fertilizers
          cell.inputName.text = fertilizer.name
          cell.inputLabel.text = fertilizer.nature
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
    default:
      fatalError("Switch error")
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

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch tableView {
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
    if interventionType == "IRRIGATION".localized {
      let waterVolume = irrigationVolumeTextField.text!.floatValue
      newIntervention.waterQuantity = waterVolume
      newIntervention.waterUnit = irrigationUnitButton.titleLabel!.text
    }
    workingPeriod.interventions = newIntervention
    workingPeriod.executionDate = selectDateView.datePicker.date
    let duration = workingPeriodDurationTextField.text!.floatValue
    workingPeriod.hourDuration = duration
    createTargets(intervention: newIntervention)
    createMaterials(intervention: newIntervention)
    createEquipments(intervention: newIntervention)
    saveInterventionInputs(intervention: newIntervention)
    resetInputsAttributes(entity: "Seeds")
    resetInputsAttributes(entity: "Phytos")
    resetInputsAttributes(entity: "Fertilizers")
    saveWeather(intervention: newIntervention)

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
    case "showSpecies":
      let destVC = segue.destination as! ListTableViewController
      destVC.delegate = self
      destVC.rawStrings = loadSpecies()
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
          species.append(specie.uppercased())
        }
      } catch {
        print("Lexicon error")
      }
    } else {
      print("species.json not found")
    }

    return species.sorted()
  }

  func writeValueBack(tag: Int, value: String) {
    selectedValue = value

    switch tag {
    case 0:
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
    default:
      fatalError("writeValueBack: Unknown value for tag")
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
      default:
        return
      }
    } else {
      numberLabel.isHidden = true
      addEntityButton.isHidden = false
    }
  }
}
