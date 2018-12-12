//
//  AddInterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 30/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class AddInterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,
UIGestureRecognizerDelegate, WriteValueBackDelegate, XMLParserDelegate, UITextViewDelegate {

  // MARK: - Outlets

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var saveInterventionButton: UIButton!
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
  @IBOutlet var inputsTapGesture: UITapGestureRecognizer!
  @IBOutlet weak var inputsView: UIView!
  @IBOutlet weak var inputsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputsAddButton: UIButton!
  @IBOutlet weak var inputsCountLabel: UILabel!
  @IBOutlet weak var inputsExpandImageView: UIImageView!
  @IBOutlet weak var selectedInputsTableView: UITableView!
  @IBOutlet weak var inputsTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputsSeparatorView: UIView!
  @IBOutlet weak var inputsUnauthorizedMixImage: UIImageView!
  @IBOutlet weak var inputsUnauthorizedMixLabel: UILabel!

  // Harvest
  @IBOutlet var harvestTapGesture: UITapGestureRecognizer!
  @IBOutlet weak var harvestView: UIView!
  @IBOutlet weak var harvestViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var harvestAddButton: UIButton!
  @IBOutlet weak var harvestCountLabel: UILabel!
  @IBOutlet weak var harvestExpandImageView: UIImageView!
  @IBOutlet weak var harvestNature: UILabel!
  @IBOutlet weak var harvestType: UIButton!
  @IBOutlet weak var harvestTableView: UITableView!
  @IBOutlet weak var harvestTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var harvestSeparatorView: UIView!

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
  @IBOutlet weak var weatherExpandImageView: UIImageView!
  @IBOutlet weak var temperatureSign: UIButton!
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
  @IBOutlet weak var notesTextView: UITextView!
  @IBOutlet weak var notesViewHeightConstraint: NSLayoutConstraint!

  // Scroll view
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!

  // Bottom views
  @IBOutlet weak var bottomBarView: UIView!
  @IBOutlet weak var bottomView: UIView!

  // MARK: - Properties

  var interventionState: InterventionState.RawValue!
  var currentIntervention: Intervention!
  var interventionType: InterventionType!
  var dimView = UIView(frame: CGRect.zero)
  var cellIndexPath: IndexPath!
  var selectedRow: Int!
  var selectedValue: String!
  var customPickerView: CustomPickerView!
  var cropsView: CropsView!
  var selectDateView: SelectDateView!
  var inputsSelectionView: InputsView!
  var materialsSelectionView: MaterialsView!
  var equipmentsSelectionView: EquipmentsView!
  var personsSelectionView: PersonsView!
  var selectedMaterials = [[NSManagedObject]]()
  var interventionEquipments = [NSManagedObject]()
  var selectedEquipments = [Equipment]()
  var selectedPersons = [[NSManagedObject]]()
  var equipmentTypes: [String]!
  var species: [String]!
  var createdSeed = [NSManagedObject]()
  var selectedInputs = [NSManagedObject]()
  var selectedHarvests = [Harvest]()
  var storages = [Storage]()
  var harvestSelectedType: String!
  var storageCreationView: StorageCreationView!
  var weather: Weather!
  var weatherIsSelected: Bool = false
  var weatherButtons = [UIButton]()
  let weatherDescriptions = ["BROKEN_CLOUDS", "CLEAR_SKY", "FEW_CLOUDS", "LIGHT_RAIN",
                             "MIST", "SHOWER_RAIN", "SNOW", "THUNDERSTORM"]

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    setupNavigationBar()
    setupDimView()
    saveInterventionButton.layer.cornerRadius = 3
    setupWorkingPeriodView()
    setupIrrigationView()
    setupInputsView()
    setupHarvestView()
    setupMaterialsView()
    setupEquipmentsView()
    setupPersonsView()
    setupWeatherView()
    customPickerView = CustomPickerView(superview: view)

    notesTextView.delegate = self
    setTextViewPlaceholder()

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

    setupViewsAccordingInterventionType()
    updateAllQuantityLabels()
  }

  private func setupNavigationBar() {
    var barButtonItems = [UIBarButtonItem]()
    let navigationItem = UINavigationItem(title: "")
    let typeLabel = UILabel()

    if interventionType != nil {
      typeLabel.text = interventionType.rawValue.localized
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

  private func setupDimView() {
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    dimView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(dimView)

    NSLayoutConstraint.activate([
      dimView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      dimView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      dimView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
  }

  func setupViewsAccordingInterventionType() {
    switch interventionType! {
    case .Care:
      materialsView.isHidden = false
      materialsSeparatorView.isHidden = false
    case .CropProtection:
      inputsSelectionView.segmentedControl.selectedSegmentIndex = 1
      inputsSelectionView.createButton.setTitle("create_new_phyto".localized.uppercased(), for: .normal)
    case .Fertilization:
      inputsSelectionView.segmentedControl.selectedSegmentIndex = 2
      inputsSelectionView.createButton.setTitle("create_new_ferti".localized.uppercased(), for: .normal)
    case .GroundWork:
      inputsView.isHidden = true
      inputsSeparatorView.isHidden = true
    case .Harvest:
      harvestView.isHidden = false
      harvestSeparatorView.isHidden = false
      inputsView.isHidden = true
      inputsSeparatorView.isHidden = true
    case .Irrigation:
      irrigationView.isHidden = false
      irrigationSeparatorView.isHidden = false
      inputsSelectionView.segmentedControl.selectedSegmentIndex = 2
      inputsSelectionView.createButton.setTitle("create_new_ferti".localized.uppercased(), for: .normal)
    default:
      return
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    // Changes inputsSelectionView frame and position
    let guide = view.safeAreaLayoutGuide
    let height = guide.layoutFrame.size.height

    cropsView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 30, height: height - 30)
    cropsView.center.x = view.center.x
    cropsView.frame.origin.y = navigationBar.frame.origin.y + 15
  }

  // MARK: - Table view data source

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
      return selectedHarvests.count
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case selectedInputsTableView:
      return selectedInputsTableViewCellForRowAt(tableView, indexPath)
    case selectedMaterialsTableView:
      return selectedMaterialsTableViewCellForRowAt(tableView, indexPath)
    case selectedEquipmentsTableView:
      return selectedEquipmentsTableViewCellForRowAt(tableView, indexPath)
    case selectedPersonsTableView:
      return selectedPersonsTableViewCellForRowAt(tableView, indexPath)
    case harvestTableView:
      return harvestTableViewCellForRowAt(tableView, indexPath)
    default:
      fatalError("Unknown tableView: \(tableView)")
    }
  }

  func defineTableViewsHeightForRow(_ tableView: UITableView) -> CGFloat {
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
    return defineTableViewsHeightForRow(tableView)
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return defineTableViewsHeightForRow(tableView)
  }

  // MARK: - Core Data

  private func createIntervention() {
    if !checkErrorsAccordingInterventionType() {
      return
    }
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let workingPeriod = WorkingPeriod(context: managedContext)
    let duration = workingPeriodDurationTextField.text!.floatValue
    let notes = (notesTextView.text != "notes".localized)

    currentIntervention = Intervention(context: managedContext)
    currentIntervention.type = interventionType.rawValue
    currentIntervention.status = InterventionState.Created.rawValue
    notes ? currentIntervention.infos = notesTextView.text : nil
    changeWaterUnit()
    workingPeriod.intervention = currentIntervention
    workingPeriod.executionDate = selectDateView.datePicker.date
    workingPeriod.hourDuration = duration
    createTargets(currentIntervention)
    createMaterials(currentIntervention)
    createEquipments(currentIntervention)
    createPersons(currentIntervention)
    saveHarvest(currentIntervention)
    saveInterventionInputs(currentIntervention)
    saveWeather(currentIntervention)
    saveInfos()
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

  private func updateIntervention() {
    if !checkErrorsAccordingInterventionType() {
      return
    }
    let duration = workingPeriodDurationTextField.text!.floatValue
    let notes = (notesTextView.text != "notes".localized)

    currentIntervention?.workingPeriods?.setValue(selectDateView.datePicker.date, forKey: "executionDate")
    currentIntervention?.workingPeriods?.setValue(duration, forKey: "hourDuration")
    notes ? currentIntervention.infos = notesTextView.text : nil
    changeWaterUnit()
    updateTargets(currentIntervention)
    updateEquipments(currentIntervention)
    updatePersons(currentIntervention)
    updateInputs(currentIntervention)
    updateHarvest(currentIntervention)
    currentIntervention?.status = InterventionState.Created.rawValue
    performSegue(withIdentifier: "unwindToInterventionVC", sender: self)
  }

  private func changeWaterUnit() {
    if interventionType == .Irrigation {
      let waterVolume = irrigationVolumeTextField.text!.floatValue

      currentIntervention?.waterQuantity = waterVolume
      switch irrigationUnitButton.titleLabel?.text {
      case "m³":
        currentIntervention?.waterUnit = "CUBIC_METER"
      case "hl":
        currentIntervention?.waterUnit = "HECTOLITER"
      case "l":
        currentIntervention?.waterUnit = "LITER"
      default:
        currentIntervention?.waterUnit = ""
      }
    }
  }

  private func updateEquipments(_ intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsFetchRequest: NSFetchRequest<InterventionEquipment> = InterventionEquipment.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", intervention)

    equipmentsFetchRequest.predicate = predicate
    do {
      let interventionEquipments = try managedContext.fetch(equipmentsFetchRequest)

      for interventionEquipment in interventionEquipments {
        managedContext.delete(interventionEquipment)
      }
      for selectedEquipment in selectedEquipments {
        let interventionEquipment = InterventionEquipment(context: managedContext)

        interventionEquipment.intervention = intervention
        interventionEquipment.equipment = selectedEquipment
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not fetch or save. \(error), \(error.userInfo)")
    }
  }

  private func updateTargets(_ intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let targetsFetchRequest: NSFetchRequest<Target> = Target.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", intervention)

    targetsFetchRequest.predicate = predicate
    do {
      let targets = try managedContext.fetch(targetsFetchRequest)

      for target in targets {
        managedContext.delete(target)
      }
      createTargets(intervention)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func updatePersons(_ intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionPersonsFetchRequest: NSFetchRequest<InterventionPerson> = InterventionPerson.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", intervention)


    interventionPersonsFetchRequest.predicate = predicate
    do {
      let interventionPersons = try managedContext.fetch(interventionPersonsFetchRequest)

      for interventionPerson in interventionPersons {
        managedContext.delete(interventionPerson)
      }
      for selectedPerson in selectedPersons[1] {
        let person = InterventionPerson(context: managedContext)

        person.intervention = intervention
        person.isDriver = (selectedPerson as! InterventionPerson).isDriver
        person.person = (selectedPerson as! InterventionPerson).person
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not fetch or save. \(error), \(error.userInfo)")
    }
  }

  private func updateHarvest(_ intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let harvestsFetchRequest: NSFetchRequest<Harvest> = Harvest.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", intervention)

    harvestsFetchRequest.predicate = predicate

    do {
      let fetchedHarvests = try managedContext.fetch(harvestsFetchRequest)

      for harvest in fetchedHarvests {
        managedContext.delete(harvest)
      }
      for harvestEntity in selectedHarvests {
        let harvest = Harvest(context: managedContext)
        let type = harvestType.titleLabel?.text

        harvest.intervention = intervention
        harvest.type = type
        harvest.number = harvestEntity.number
        harvest.quantity = harvestEntity.quantity
        harvest.unit = harvestEntity.unit
        harvest.storage = harvestEntity.storage
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func deleteInput(_ intervention: Intervention, _ inputName: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let inputsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: inputName)
    let predicate = NSPredicate(format: "intervention == %@", intervention)

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

  private func updateInputs(_ intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    deleteInput(intervention, "InterventionSeed")
    deleteInput(intervention, "InterventionPhytosanitary")
    deleteInput(intervention, "InterventionFertilizer")

    do {
      for selectedInput in selectedInputs {
        switch selectedInput {
        case is InterventionSeed:
          let selectedSeed = selectedInput as! InterventionSeed
          let interventionSeed = InterventionSeed(context: managedContext)

          interventionSeed.intervention = intervention
          interventionSeed.seed = selectedSeed.seed
          interventionSeed.quantity = selectedSeed.quantity
          interventionSeed.unit = selectedSeed.unit
        case is InterventionPhytosanitary:
          let selectedPhyto = selectedInput as! InterventionPhytosanitary
          let interventionPhyto = InterventionPhytosanitary(context: managedContext)

          interventionPhyto.intervention = intervention
          interventionPhyto.phyto = selectedPhyto.phyto
          interventionPhyto.quantity = selectedPhyto.quantity
          interventionPhyto.unit = selectedPhyto.unit
        case is InterventionFertilizer:
          let selectedFertilizer = selectedInput as! InterventionFertilizer
          let interventionFertilizer = InterventionFertilizer(context: managedContext)

          interventionFertilizer.intervention = intervention
          interventionFertilizer.fertilizer = selectedFertilizer.fertilizer
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

  private func resetInputsAttributes(entity: String) {
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

  private func saveInterventionInputs(_ intervention: Intervention) {
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

  private func createTargets(_ intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for selectedCrop in cropsView.selectedCrops {
      let target = Target(context: managedContext)

      target.intervention = intervention
      target.crop = selectedCrop
      target.workAreaPercentage = 100
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func saveHarvest(_ intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for harvestEntity in selectedHarvests {
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

  private func createMaterials(_ intervention: Intervention) {
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

  private func createEquipments(_ intervention: Intervention) {
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

  private func createPersons(_ intervention: Intervention) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for case let interventionPerson as InterventionPerson in selectedPersons[1] {
      let index = selectedPersons[1].firstIndex(of: interventionPerson)!

      interventionPerson.intervention = intervention
      interventionPerson.person = selectedPersons[0][index] as? Person
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func fetchEntity(entityName: String, searchedEntity: inout [NSManagedObject],
                           entity: inout [NSManagedObject]) {
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

  private func saveWeather(_ intervention: Intervention) {
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

  private func saveInfos() {
    let infos = getInfos()

    if infos.isEmpty && notesTextView.text != "Notes" {
      currentIntervention.infos = notesTextView.text
    } else {
      currentIntervention.infos = infos
    }
  }

  private func getInfos() -> String {
    var infos = ""

    switch interventionType! {
    case .Care:
      for case let interventionMaterial as InterventionMaterial in currentIntervention!.interventionMaterials! {
        guard let material = interventionMaterial.material else { return infos }
        guard let unit = interventionMaterial.unit?.localized else { return infos }
        let materialInfos = String(format: "%@ • %g %@", material.name!, interventionMaterial.quantity, unit)

        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(materialInfos)
      }
    case .CropProtection:
      for case let interventionPhyto as InterventionPhytosanitary in currentIntervention!.interventionPhytosanitaries! {
        guard let phyto = interventionPhyto.phyto else { return infos }
        guard let unit = interventionPhyto.unit?.localized else { return infos }
        let phytoInfos = String(format: "%@ • %g %@", phyto.name!, interventionPhyto.quantity, unit)

        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(phytoInfos)
      }
    case .Fertilization:
      for case let interventionFertilizer as InterventionFertilizer in currentIntervention!.interventionFertilizers! {
        guard let fertilizer = interventionFertilizer.fertilizer else { return infos }
        guard let unit = interventionFertilizer.unit?.localized else { return infos }
        let fertilizerInfos = String(format: "%@ • %g %@", fertilizer.name!, interventionFertilizer.quantity, unit)

        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(fertilizerInfos)
      }
    case .GroundWork:
      for case let interventionEquipment as InterventionEquipment in currentIntervention!.interventionEquipments! {
        guard let equipment = interventionEquipment.equipment else { return infos }
        var equipmentInfos = equipment.name!

        if let number = equipment.number {
          equipmentInfos.append(String(format: " #%@", number))
        }
        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(equipmentInfos)
      }
    case .Implantation:
      for case let interventionSeed as InterventionSeed in currentIntervention!.interventionSeeds! {
        guard let seed = interventionSeed.seed else { return infos }
        guard let unit = interventionSeed.unit?.localized else { return infos }
        let seedInfos = String(format: "%@ • %g %@", seed.variety!, interventionSeed.quantity, unit)

        if !infos.isEmpty {
          infos.append("\n")
        }
        infos.append(seedInfos)
      }
    case .Irrigation:
      guard let unit = currentIntervention.waterUnit?.localized else { return infos }

      infos = String(format: "%@ • %g %@", "volume".localized, currentIntervention.waterQuantity, unit)
    default:
      return infos
    }
    return infos
  }

  // MARK: - Navigation

  @IBAction private func saveOrUpdateIntervention() {
    if interventionState == nil {
      createIntervention()
    } else if interventionState == InterventionState.Created.rawValue ||
      interventionState == InterventionState.Synced.rawValue {
      updateIntervention()
    }
  }

  // INFO: Needed to perform the unwind segue
  @IBAction private func unwindToInterventionVCWithSegue(_ segue: UIStoryboardSegue) { }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    switch segue.identifier {
    case "showSpecies":
      let destVC = segue.destination as! ListTableViewController
      destVC.delegate = self
      destVC.lastSelectedValue = inputsSelectionView.seedView.specieButton.titleLabel?.text
      destVC.rawStrings = species
      destVC.tag = 0
    case "showEquipmentTypes":
      let destVC = segue.destination as! ListTableViewController
      destVC.delegate = self
      destVC.lastSelectedValue = equipmentsSelectionView.creationView.typeButton.titleLabel?.text
      destVC.rawStrings = equipmentTypes
      destVC.tag = 1
    default:
      return
    }
  }

  @objc private func goBackToInterventionViewController() {
    dismiss(animated: true, completion: nil)
  }

  func defineInputsUnitButtonTitle(value: String) {
    switch inputsSelectionView.segmentedControl.selectedSegmentIndex {
    case 0:
      inputsSelectionView.seedView.unitButton.setTitle(value.localized, for: .normal)
      inputsSelectionView.seedView.rawUnit = value
    case 1:
      inputsSelectionView.phytoView.unitButton.setTitle(value.localized, for: .normal)
      inputsSelectionView.phytoView.rawUnit = value
    case 2:
      inputsSelectionView.fertilizerView.unitButton.setTitle(value.localized, for: .normal)
      inputsSelectionView.fertilizerView.rawUnit = value
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
    guard let oldText = textField.text, let r = Range(range, in: oldText) else {
      return true
    }

    let newText = oldText.replacingCharacters(in: r, with: string)
    var numberOfDecimalDigits = 0

    if newText.components(separatedBy: ".").count > 2 || newText.components(separatedBy: ",").count > 2 {
      return false
    } else if let dotIndex = (newText.contains(",") ? newText.index(of: ",") : newText.index(of: ".")) {
      numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
    }
    return numberOfDecimalDigits <= 2 && newText.count <= 16
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  // MARK: - Text View Delegate

  private func setTextViewPlaceholder() {
    notesTextView.text = "notes".localized
    notesTextView.textColor = .lightGray
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      setTextViewPlaceholder()
    }
  }

  func textViewDidChange(_ textView: UITextView) {
    notesViewHeightConstraint.constant = textView.frame.height + 40
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

  @IBAction private func selectCrops(_ sender: Any) {
    view.endEditing(true)
    dimView.isHidden = false
    cropsView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  private func checkCropsProduction() -> Bool {
    if interventionType == .Harvest || interventionType == .Implantation {
      let selectedCrops = cropsView.selectedCrops
      let firstCrop = selectedCrops.first?.species

      for selectedCrop in selectedCrops {
        if selectedCrop.species != firstCrop {
          let alert = UIAlertController(title: "implantation_on_different_varieties".localized,
                                        message: nil, preferredStyle: .alert)

          alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .default, handler: nil))
          present(alert, animated: true)
          return false
        }
      }
    }
    return true
  }

  @objc private func validateCrops(_ sender: Any) {
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

    updateAllQuantityLabels()
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
  }

  @IBAction private func cancelAdding(_ sender: Any) {
    resetInputsAttributes(entity: "Seed")
    resetInputsAttributes(entity: "Phyto")
    resetInputsAttributes(entity: "Fertilizer")
    dismiss(animated: true, completion: nil)
  }
}
