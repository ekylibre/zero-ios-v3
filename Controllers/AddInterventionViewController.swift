//
//  AddInterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 30/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class AddInterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, WriteValueBackDelegate {

  //MARK: - Outlets

  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var equipmentsTableView: UITableView!
  @IBOutlet weak var workingPeriodHeight: NSLayoutConstraint!
  @IBOutlet weak var selectedWorkingPeriodLabel: UILabel!
  @IBOutlet weak var collapseWorkingPeriodImage: UIImageView!
  @IBOutlet weak var selectDateButton: UIButton!
  @IBOutlet weak var durationTextField: UITextField!
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var firstView: UIView!
  @IBOutlet weak var collapseButton: UIButton!
  @IBOutlet weak var saveInterventionButton: UIButton!
  @IBOutlet weak var selectToolsView: UIView!
  @IBOutlet weak var createToolsView: UIView!
  @IBOutlet weak var toolsDarkLayer: UIView!
  @IBOutlet weak var toolName: UITextField!
  @IBOutlet weak var toolNumber: UITextField!
  @IBOutlet weak var toolType: UILabel!
  @IBOutlet weak var selectedToolsTableView: UITableView!
  @IBOutlet weak var addToolButton: UIButton!
  @IBOutlet weak var toolNumberLabel: UILabel!
  @IBOutlet weak var searchTool: UISearchBar!
  @IBOutlet weak var toolTypeTableView: UITableView!
  @IBOutlet weak var toolTypeButton: UIButton!
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

  //MARK: - Properties

  var newIntervention: NSManagedObject!
  var interventionType: String!
  var equipments = [NSManagedObject]()
  var selectDateView: SelectDateView!
  var cropsView: CropsView!
  var inputsView: InputsView!
  var interventionTools = [NSManagedObject]()
  var selectedTools = [NSManagedObject]()
  var searchedTools = [NSManagedObject]()
  var toolTypes: [String]!
  var selectedToolType: String!
  var entities = [NSManagedObject]()
  var searchedEntities = [NSManagedObject]()
  var doers = [NSManagedObject]()
  var toolImage: [UIImage] = [#imageLiteral(resourceName: "airplanter"), #imageLiteral(resourceName: "baler_wrapper"), #imageLiteral(resourceName: "corn-topper"), #imageLiteral(resourceName: "cubic_baler"), #imageLiteral(resourceName: "disc_harrow"), #imageLiteral(resourceName: "forage_platform"), #imageLiteral(resourceName: "forager"), #imageLiteral(resourceName: "grinder"), #imageLiteral(resourceName: "harrow"), #imageLiteral(resourceName: "harvester"), #imageLiteral(resourceName: "hay_rake"), #imageLiteral(resourceName: "hiller"), #imageLiteral(resourceName: "hoe"), #imageLiteral(resourceName: "hoe_weeder"), #imageLiteral(resourceName: "implanter"), #imageLiteral(resourceName: "irrigation_pivot"), #imageLiteral(resourceName: "mower"), #imageLiteral(resourceName: "mower_conditioner"), #imageLiteral(resourceName: "plow"), #imageLiteral(resourceName: "reaper"), #imageLiteral(resourceName: "roll"), #imageLiteral(resourceName: "rotary_hoe"), #imageLiteral(resourceName: "round_baler"), #imageLiteral(resourceName: "seedbed_preparator"), #imageLiteral(resourceName: "soil_loosener"), #imageLiteral(resourceName: "sower"), #imageLiteral(resourceName: "sprayer"), #imageLiteral(resourceName: "spreader"), #imageLiteral(resourceName: "liquid_manure_spreader"), #imageLiteral(resourceName: "subsoil_plow"), #imageLiteral(resourceName: "superficial_plow"), #imageLiteral(resourceName: "tedder"), #imageLiteral(resourceName: "topper"), #imageLiteral(resourceName: "tractor"), #imageLiteral(resourceName: "trailer"), #imageLiteral(resourceName: "trimmer"), #imageLiteral(resourceName: "vibrocultivator"), #imageLiteral(resourceName: "weeder"), #imageLiteral(resourceName: "wrapper")]

  override func viewDidLoad() {
    super.viewDidLoad()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

    // Working period
    selectDateView = SelectDateView(frame: CGRect(x: 0, y: 0, width: 350, height: 250))
    self.view.addSubview(selectDateView)
    selectDateView.center.x = self.view.center.x
    selectDateView.center.y = self.view.center.y
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "fr_FR")
    dateFormatter.dateFormat = "d MMMM"
    let currentDateString = dateFormatter.string(from: Date())
    selectDateButton.setTitle(currentDateString, for: .normal)
    let validateButton = selectDateView.subviews.last as! UIButton
    validateButton.addTarget(self, action: #selector(validateDate), for: .touchUpInside)

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
    selectedToolsTableView.layer.borderWidth  = 0.5
    selectedToolsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedToolsTableView.backgroundColor = AppColor.ThemeColors.DarkWhite
    selectedToolsTableView.layer.cornerRadius = 4
    saveInterventionButton.layer.cornerRadius = 3
    equipmentsTableView.dataSource = self
    equipmentsTableView.delegate = self
    selectedToolsTableView.dataSource = self
    selectedToolsTableView.delegate = self
    searchTool.delegate = self
    searchTool.autocapitalizationType = .none
    searchEntity.delegate = self
    searchEntity.autocapitalizationType = .none
    toolTypeTableView.dataSource = self
    toolTypeTableView.delegate = self
    entitiesTableView.dataSource = self
    entitiesTableView.delegate = self
    doersTableView.dataSource = self
    doersTableView.delegate = self
    doersHeightConstraint.constant = 70
    doersTableViewHeightConstraint.constant = doersTableView.contentSize.height
    doersTableView.layer.borderWidth  = 0.5
    doersTableView.layer.borderColor = UIColor.lightGray.cgColor
    doersTableView.backgroundColor = AppColor.ThemeColors.DarkWhite
    doersTableView.layer.cornerRadius = 4
    defineToolTypes()
    fetchTools()
    fetchEntities()
    selectedToolType = toolTypes[0]
    toolTypeButton.setTitle(toolTypes[0], for: .normal)

    inputsView = InputsView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
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

  //MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    switch tableView {
    case equipmentsTableView:
      return searchedTools.count
    case selectedToolsTableView:
      return selectedTools.count
    case toolTypeTableView:
      return toolTypes.count
    case entitiesTableView:
      return searchedEntities.count
    case doersTableView:
      return doers.count
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var tool: NSManagedObject?
    var selectedTool: NSManagedObject?
    var toolType: String?
    var entity: NSManagedObject?
    var doer: NSManagedObject?

    switch tableView {
    case equipmentsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentsTableViewCell", for: indexPath) as! EquipmentsTableViewCell

      tool = searchedTools[indexPath.row]
      cell.nameLabel.text = tool?.value(forKey: "name") as? String
      cell.typeLabel.text = tool?.value(forKey: "type") as? String
      cell.typeImageView.image = toolImage[defineToolImage(toolName: cell.typeLabel.text!)]
      return cell
    case selectedToolsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedToolsTableViewCell", for: indexPath) as! SelectedToolsTableViewCell

      selectedTool = selectedTools[indexPath.row]
      cell.cellDelegate = self
      cell.indexPath = indexPath.row
      cell.backgroundColor = AppColor.ThemeColors.DarkWhite
      cell.nameLabel.text = selectedTool?.value(forKey: "name") as? String
      cell.typeLabel.text = selectedTool?.value(forKey: "type") as? String
      cell.typeImageView.image = toolImage[defineToolImage(toolName: cell.typeLabel.text!)]
      return cell
    case toolTypeTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToolsTypeTableViewCell", for: indexPath) as! ToolsTypeTableViewCell

      toolType = toolTypes[indexPath.row]
      cell.nameLabel.text = toolType
      return cell
    case entitiesTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "EntitiesTableViewCell", for: indexPath) as! EntitiesTableViewCell

      entity = searchedEntities[indexPath.row]
      cell.firstName.text = entity?.value(forKey: "firstName") as? String
      cell.lastName.text = entity?.value(forKey: "lastName") as? String
      cell.logo.image = #imageLiteral(resourceName: "entityLogo")
      return cell
    case doersTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DoersTableViewCell", for: indexPath) as! DoersTableViewCell

      doer = doers[indexPath.row]
      cell.driver.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      cell.cellDelegate = self
      cell.indexPath = indexPath.row
      cell.backgroundColor = AppColor.ThemeColors.DarkWhite
      cell.driver.isOn = (doer?.value(forKey: "isDriver") as? Bool)!
      cell.firstName.text = doer?.value(forKey: "firstName") as? String
      cell.lastName.text = doer?.value(forKey: "lastName") as? String
      cell.logo.image = #imageLiteral(resourceName: "entityLogo")
      return cell
    default:
      fatalError("Switch error")
    }
  }

  @IBAction func toolTypeSelection(_ sender: UIButton) {
    toolTypeTableView.isHidden = false
    toolTypeTableView.layer.shadowColor = UIColor.black.cgColor
    toolTypeTableView.layer.shadowOpacity = 1
    toolTypeTableView.layer.shadowOffset = CGSize(width: -1, height: 1)
    toolTypeTableView.layer.shadowRadius = 10
  }

  // Expand/collapse cell when tapped
  var selectedIndexPath: IndexPath?
  var indexPaths: [IndexPath] = []

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndexPath = indexPath

    switch tableView {
    case equipmentsTableView:
      selectedTools.append(equipments[indexPath.row])
      closeSelectToolsView()
    case toolTypeTableView:
      selectedToolType = toolTypes[indexPath.row]
      toolTypeTableView.reloadData()
      toolTypeButton.setTitle(selectedToolType, for: .normal)
      toolTypeTableView.isHidden = true
    case entitiesTableView:
      doersTableView.isHidden = false
      doers.append(entities[indexPath.row])
      doersTableViewHeightConstraint.constant = doersTableView.contentSize.height
      doersHeightConstraint.constant = doersTableViewHeightConstraint.constant + 70
      doersTableView.reloadData()
      closeSelectEntitiesView()
    default:
      print("Nothing to do")
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch tableView {
    case doersTableView:
      return 75
    default:
      return 60
    }
  }

  //MARK: - Core Data

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
    createTools(intervention: newIntervention)
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

  func createTools(intervention: NSManagedObject) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let toolsEntity = NSEntityDescription.entity(forEntityName: "Tools", in: managedContext)!

    for selectedTool in selectedTools {
      let tool = NSManagedObject(entity: toolsEntity, insertInto: managedContext)
      let name = selectedTool.value(forKey: "name") as! String
      let type = selectedTool.value(forKey: "type") as! String
      let equipment = selectedTool.value(forKey: "uuid") as! UUID

      tool.setValue(intervention, forKey: "interventions")
      tool.setValue(name, forKey: "name")
      tool.setValue(type, forKey: "type")
      tool.setValue(equipment, forKey: "equipment")
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

  //MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //super.prepare(for: segue, sender: sender)
    switch segue.identifier {
    case "showSpecieList":
      let destVC = segue.destination as! ListTableViewController
      destVC.delegate = self
      destVC.cellsStrings = ["Avoine", "Blé dur", "Blé tendre", "Maïs", "Riz", "Triticale", "Soja", "Tournesol annuel", "Fève ou féverole", "Luzerne", "Pois commun", "Sainfoin", "Chanvre"]
    default:
      guard let button = sender as? UIButton, button === saveInterventionButton else {
        return
      }

      createIntervention()
    }
  }

  func writeValueBack(value: String) {
    inputsView.seedView.specieButton.setTitle(value, for: .normal)
  }

  //MARK: - Actions

  var animationRunning: Bool = false

  @IBAction func collapseExpand(_ sender: Any) {

    if animationRunning {
      return
    }

    let shouldCollapse = firstView.frame.height != 70

    animateView(isCollapse: shouldCollapse, angle: shouldCollapse ? CGFloat.pi : CGFloat.pi - 3.14159)
  }

  func animateView(isCollapse: Bool, angle: CGFloat) {

    animationRunning = true

    heightConstraint.constant = isCollapse ? 70 : 300

    UIView.animate(withDuration: 0.5, animations: {
      self.collapseButton.isHidden = false
      self.collapseButton.imageView!.transform = CGAffineTransform(rotationAngle: angle)
      self.view.layoutIfNeeded()
    }, completion: { _ in
      self.animationRunning = false
    })
    showToolsNumber()
  }

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
}
