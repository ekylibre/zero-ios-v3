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
  @IBOutlet weak var equipmentHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var equipmentTableViewHeightConstraint: NSLayoutConstraint!

  // MARK: - Properties

  var newIntervention: NSManagedObject!
  var interventionType: String!
  var equipments = [NSManagedObject]()
  var selectDateView: SelectDateView!
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
  let solidUnitMeasure = ["g", "g/ha", "g/m2", "kg", "kg/ha", "kg/m3", "q", "q/ha", "q/m2", "t", "t/ha", "t/m2"]
  let liquidUnitMeasure = ["l", "l/ha", "l/m2", "hl", "hl/ha", "hl/m2", "m3","m3/ha", "m3/m2"]

  override func viewDidLoad() {
    super.viewDidLoad()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

    // Working period
    selectDateView = SelectDateView(frame: CGRect(x: 0, y: 0, width: 350, height: 250))
    selectDateView.center.x = self.view.center.x
    selectDateView.center.y = self.view.center.y
    self.view.addSubview(selectDateView)

    let dateFormatter = DateFormatter()

    dateFormatter.locale = Locale(identifier: "fr_FR")
    dateFormatter.dateFormat = "d MMMM"
    let currentDateString = dateFormatter.string(from: Date())
    let validateButton = selectDateView.subviews.last as! UIButton

    validateButton.addTarget(self, action: #selector(validateDate), for: .touchUpInside)

    selectDateButton.setTitle(currentDateString, for: .normal)
    selectDateButton.layer.cornerRadius = 5
    selectDateButton.layer.borderWidth = 0.5
    selectDateButton.layer.borderColor = UIColor.lightGray.cgColor
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
    self.view.addSubview(inputsView)

    cropsView = CropsView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
    self.view.addSubview(cropsView)
    cropsView.validateButton.addTarget(self, action: #selector(validateCrops), for: .touchUpInside)
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
    var input: NSManagedObject?

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
          cell.inputName.text = input?.value(forKey: "specie") as? String
          cell.inputLabel.text = input?.value(forKey: "variety") as? String
          cell.inputImage.image = #imageLiteral(resourceName: "seed")
        case "Phyto":
          cell.inputName.text = input?.value(forKey: "name") as? String
          cell.inputLabel.text = input?.value(forKey: "firmName") as? String
          cell.inputImage.image = #imageLiteral(resourceName: "phytosanitary")
        case "Fertilizer":
          cell.inputName.text = input?.value(forKey: "name") as? String
          cell.inputLabel.text = input?.value(forKey: "nature") as? String
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

  func createIntervention() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsEntity = NSEntityDescription.entity(forEntityName: "Interventions", in: managedContext)!
    newIntervention = NSManagedObject(entity: interventionsEntity, insertInto: managedContext)
    let workingPeriodsEntity = NSEntityDescription.entity(forEntityName: "WorkingPeriods", in: managedContext)!
    let workingPeriod = NSManagedObject(entity: workingPeriodsEntity, insertInto: managedContext)

    newIntervention.setValue(interventionType, forKey: "type")
    newIntervention.setValue(Intervention.Status.OutOfSync.rawValue, forKey: "status")
    newIntervention.setValue("Infos", forKey: "infos")
    workingPeriod.setValue(newIntervention, forKey: "interventions")
    let datePicker = selectDateView.subviews.first as! UIDatePicker
    workingPeriod.setValue(datePicker.date, forKey: "executionDate")
    let hourDuration = Int(durationTextField.text!)
    workingPeriod.setValue(hourDuration, forKey: "hourDuration")
    createTargets(intervention: newIntervention)
    createEquipments(intervention: newIntervention)
    createDoers(intervention: newIntervention)

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
    let selectedCrops = fetchSelectedCrops()

    for crop in selectedCrops {
      let target = NSManagedObject(entity: targetsEntity, insertInto: managedContext)

      target.setValue(intervention, forKey: "interventions")
      target.setValue(crop, forKey: "crops")
      target.setValue(100, forKey: "workAreaPercentage")
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
    let predicate = NSPredicate(format: "isSelected == %@", NSNumber(value: true))
    cropsFetchRequest.predicate = predicate

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return crops
  }

  func createEquipments(intervention: NSManagedObject) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let equipmentsEntity = NSEntityDescription.entity(forEntityName: "InterventionEquipments", in: managedContext)!

    for selectedEquipment in selectedEquipments {
      let equipment = NSManagedObject(entity: equipmentsEntity, insertInto: managedContext)
      let name = selectedEquipment.value(forKeyPath: "name") as! String
      let type = selectedEquipment.value(forKey: "type") as! String
      let equipmentUuid = selectedEquipment.value(forKey: "uuid") as! UUID

      equipment.setValue(intervention, forKey: "interventions")
      equipment.setValue(name, forKey: "name")
      equipment.setValue(type, forKey: "type")
      equipment.setValue(equipmentUuid, forKey: "equipment")
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
          species.append(registeredSpecie["fra"] as! String)
        }
      } catch {
        print("Lexicon error")
      }
    } else {
      print("species.json not found")
    }

    return species
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

  @objc func validateCrops(_ sender: Any) {
    if cropsView.selectedCropsLabel.text == "Aucune sélection" {
      totalLabel.text = "+ SÉLECTIONNER"
      totalLabel.textColor = AppColor.TextColors.Green
    } else {
      totalLabel.text = cropsView.selectedCropsLabel.text
      totalLabel.textColor = AppColor.TextColors.DarkGray
    }
    totalLabel.sizeToFit()

    cropsView.isHidden = true
    dimView.isHidden = true

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
    var dateString: String!
    var hoursNumber: String!

    dateString = selectDateButton.titleLabel?.text

    if durationTextField.text?.isEmpty == true {
      hoursNumber = "0 h"
    } else {
      hoursNumber = durationTextField.text! + " h"
    }

    return dateString + " • " + hoursNumber
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
