//
//  InterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class InterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  // MARK: - Outlets

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var synchroLabel: UILabel!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var createInterventionButton: UIButton!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomBottom: NSLayoutConstraint!

  // MARK: - Properties

  var interventions = [NSManagedObject]() {
    didSet {
      tableView.reloadData()
    }
  }

  let interventionTypes = ["IMPLANTATION", "GROUND_WORK", "IRRIGATION", "HARVEST",
                           "CARE", "FERTILIZATION", "CROP_PROTECTION"]
  var interventionButtons: [UIButton] = []
  let dimView = UIView()

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()
    super.moveViewWhenKeyboardAppears()

    // Change status bar appearance
    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

    // Rounded buttons
    createInterventionButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    createInterventionButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    createInterventionButton.layer.shadowOpacity = 1.0
    createInterventionButton.layer.shadowRadius = 0.0
    createInterventionButton.layer.masksToBounds = false
    createInterventionButton.layer.cornerRadius = 3
    //createInterventionButton.clipsToBounds = true

    // Dim view
    self.view.addSubview(dimView)

    dimView.translatesAutoresizingMaskIntoConstraints = false
    dimView.backgroundColor = UIColor.black
    dimView.alpha = 0.6
    let leadingConstraint = NSLayoutConstraint(item: dimView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: .equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
    let trailingConstraint = NSLayoutConstraint(item: dimView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: .equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
    let topConstraint = NSLayoutConstraint(item: dimView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: .equal, toItem: navigationBar, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
    let bottomConstraint = NSLayoutConstraint(item: dimView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: .equal, toItem: bottomView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
    NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    dimView.isUserInteractionEnabled = true
    let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideInterventionAdd))
    gesture.numberOfTapsRequired = 1
    dimView.addGestureRecognizer(gesture)
    dimView.isHidden = true

    // Updates synchronisation label
    if let date = UserDefaults.standard.value(forKey: "lastSyncDate") as? Date {
      let calendar = Calendar.current
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMMM"

      let hour = calendar.component(.hour, from: date)
      let minute = calendar.component(.minute, from: date)
      let dateString = dateFormatter.string(from: date)

      if calendar.isDateInToday(date) {
        synchroLabel.text = String(format: "today_last_synchronization".localized, "\(hour)", "\(minute)")
      } else {
        synchroLabel.text = "last_synchronization".localized + dateString
      }
    } else {
      synchroLabel.text = "no_synchronization_listed".localized
    }

    // Top label : name
    //toolbar.frame = CGRect(x: 0, y: 623, width: 375, height: 100)
    let firstFrame = CGRect(x: 10, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
    let firstLabel = UILabel(frame: firstFrame)
    firstLabel.text = "GAEC du Bois Joli"
    firstLabel.textColor = UIColor.white
    navigationBar.addSubview(firstLabel)

    initialiseInterventionButtons()

    // Load table view
    self.tableView.dataSource = self
    self.tableView.delegate = self

    tableView.bounces = false
  }

  func initialiseInterventionButtons() {
    for buttonCount in 0...6 {
      let interventionButton = UIButton(frame: CGRect(x: 30, y: 600, width: bottomView.bounds.width, height: bottomView.bounds.height))
      let image = UIImage(named: interventionTypes[buttonCount].lowercased())

      interventionButton.backgroundColor = UIColor.white
      interventionButton.setBackgroundImage(image, for: .normal)
      interventionButton.setTitle(interventionTypes[buttonCount].localized, for: .normal)
      interventionButton.setTitleColor(UIColor.white, for: .normal)
      interventionButton.layer.cornerRadius = 3
      interventionButton.isHidden = false
      interventionButtons.append(interventionButton)
      bottomView.addSubview(interventionButton)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    fetchInterventions()
    if interventions.count == 0 {
      loadSampleInterventions()
    }
  }

  private func fetchInterventions() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsFetchRequest: NSFetchRequest<Interventions> = Interventions.fetchRequest()

    do {
      interventions = try managedContext.fetch(interventionsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return interventions.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "InterventionCell", for: indexPath) as? InterventionCell else {
      fatalError("The dequeued cell is not an instance of InterventionCell")
    }

    cell.backgroundColor = (indexPath.row % 2 == 0) ? AppColor.CellColors.White : AppColor.CellColors.LightGray

    let intervention = interventions[indexPath.row]
    let targets = fetchTargets(of: intervention)
    let workingPeriod = fetchWorkingPeriod(of: intervention)

    cell.typeLabel.text = intervention.value(forKey: "type") as? String
    switch intervention.value(forKey: "type") as! String {
    case Intervention.InterventionType.Care.rawValue:
      cell.typeImageView.image = UIImage(named: "care")!
    case Intervention.InterventionType.CropProtection.rawValue:
      cell.typeImageView.image = UIImage(named: "crop-protection")!
    case Intervention.InterventionType.Fertilization.rawValue:
      cell.typeImageView.image = UIImage(named: "fertilization")!
    case Intervention.InterventionType.GroundWork.rawValue:
      cell.typeImageView.image = UIImage(named: "ground-work")!
    case Intervention.InterventionType.Harvest.rawValue:
      cell.typeImageView.image = UIImage(named: "harvest")!
    case Intervention.InterventionType.Implantation.rawValue:
      cell.typeImageView.image = UIImage(named: "implantation")!
    case Intervention.InterventionType.Irrigation.rawValue:
      cell.typeImageView.image = UIImage(named: "irrigation")!
    default:
      cell.typeLabel.text = "error".localized
    }

    switch intervention.value(forKey: "status") as! Int16 {
    case Intervention.Status.OutOfSync.rawValue:
      cell.syncImage.backgroundColor = UIColor.orange
    case Intervention.Status.Synchronised.rawValue:
      cell.syncImage.backgroundColor = UIColor.yellow
    case Intervention.Status.Validated.rawValue:
      cell.syncImage.backgroundColor = UIColor.green
    default:
      cell.syncImage.backgroundColor = UIColor.purple
    }

    cell.cropsLabel.text = updateCropsLabel(targets)
    cell.infosLabel.text = intervention.value(forKey: "infos") as? String
    cell.dateLabel.text = transformDate(date: workingPeriod.value(forKey: "executionDate") as! Date)

    // Resize labels according to their text
    cell.typeLabel.sizeToFit()
    cell.cropsLabel.sizeToFit()
    cell.infosLabel.sizeToFit()

    return cell
  }

  func fetchTargets(of intervention: NSManagedObject) -> [NSManagedObject] {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return [NSManagedObject]()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let targetsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Targets")
    let predicate = NSPredicate(format: "interventions == %@", intervention)
    targetsFetchRequest.predicate = predicate

    var targets: [NSManagedObject]!

    do {
      targets = try managedContext.fetch(targetsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    return targets
  }

  func fetchWorkingPeriod(of intervention: NSManagedObject) -> NSManagedObject {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return NSManagedObject()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let workingPeriodsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WorkingPeriods")
    let predicate = NSPredicate(format: "interventions == %@", intervention)
    workingPeriodsFetchRequest.predicate = predicate

    var workingPeriods: [NSManagedObject]!

    do {
      workingPeriods = try managedContext.fetch(workingPeriodsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    return workingPeriods.first!
  }

  func updateCropsLabel(_ targets: [NSManagedObject]) -> String {
    var totalSurfaceArea: Double = 0

    for target in targets {
      let crop = target.value(forKey: "crops") as! NSManagedObject
      let surfaceArea = crop.value(forKey: "surfaceArea") as! Double
      totalSurfaceArea += surfaceArea 
    }

    let cropString = targets.count < 2 ? "crop".localized : "crops".localized
    return String(format: cropString, targets.count) + String(format: " • %.1f ha", totalSurfaceArea)
  }

  func transformDate(date: Date) -> String {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "fr_FR")
    dateFormatter.dateFormat = "d MMMM"

    var dateString = dateFormatter.string(from: date)
    let year = calendar.component(.year, from: date)

    if calendar.isDateInToday(date) {
      return "today".localized.lowercased()
    } else if calendar.isDateInYesterday(date) {
      return "yesterday".localized.lowercased()
    } else {
      if !calendar.isDate(Date(), equalTo: date, toGranularity: .year) {
        dateString.append(" \(year)")
      }
      return dateString
    }
  }

  func createIntervention(type: String, infos: String, status: Int16, executionDate: Date) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsEntity = NSEntityDescription.entity(forEntityName: "Interventions", in: managedContext)!
    let workingPeriodsEntity = NSEntityDescription.entity(forEntityName: "WorkingPeriods", in: managedContext)!
    let intervention = NSManagedObject(entity: interventionsEntity, insertInto: managedContext)
    let workingPeriod = NSManagedObject(entity: workingPeriodsEntity, insertInto: managedContext)

    intervention.setValue(type, forKey: "type")
    intervention.setValue(infos, forKey: "infos")
    intervention.setValue(status, forKey: "status")
    workingPeriod.setValue(intervention, forKey: "interventions")
    workingPeriod.setValue(executionDate, forKey: "executionDate")

    do {
      try managedContext.save()
      interventions.append(intervention)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destVC = segue.destination as! AddInterventionViewController

    if let type = (sender as? UIButton)?.titleLabel?.text {
      destVC.interventionType = type
    }
  }

  @IBAction func unwindFromAddVC(_ sender: UIStoryboardSegue) {

    if sender.source is AddInterventionViewController {
      if let senderVC = sender.source as? AddInterventionViewController {
        interventions.append(senderVC.newIntervention)
      }
      tableView.reloadData()
    }
  }

  func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    return calendar.date(from: components)!
  }

  private func loadSampleInterventions() {

    let date1 = makeDate(year: 2018, month: 7, day: 25, hour: 9, minute: 5, second: 0)
    //let inter1 = Intervention(type: .Irrigation, crops: "2 cultures", infos: "Volume 50", date: date1, status: .OutOfSync)
    let date2 = makeDate(year: 2018, month: 7, day: 24, hour: 9, minute: 5, second: 0)
    //let inter2 = Intervention(type: .TravailSol, crops: "1 culture", infos: "Kuhn Prolander", date: date2, status: .OutOfSync)
    let date3 = makeDate(year: 2018, month: 7, day: 23, hour: 9, minute: 5, second: 0)
    //let inter3 = Intervention(type: .Pulverisation, crops: "2 cultures", infos: "PRIORI GOLD", date: date3, status: .OutOfSync)
    let date4 = makeDate(year: 2017, month: 7, day: 5, hour: 9, minute: 5, second: 0)
    //let inter4 = Intervention(type: .Entretien, crops: "4 cultures", infos: "oui", date: date4, status: .OutOfSync)

    createIntervention(type: Intervention.InterventionType.Care.rawValue, infos: "Volume 50mL", status: 0, executionDate: date1)
    createIntervention(type: Intervention.InterventionType.CropProtection.rawValue, infos: "Kuhn Prolander", status: 0, executionDate: date2)
    createIntervention(type: Intervention.InterventionType.Fertilization.rawValue, infos: "PRIORI GOLD", status: 1, executionDate: date3)
    createIntervention(type: Intervention.InterventionType.GroundWork.rawValue, infos: "oui", status: 2, executionDate: date4)
  }

  // MARK: - Actions

  @IBAction func synchronise(_ sender: Any) {
    let date = Date()
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)

    synchroLabel.text = String(format: "today_last_synchronization".localized, "\(hour)", "\(minute)")
    UserDefaults.standard.set(date, forKey: "lastSyncDate")
    UserDefaults.standard.synchronize()

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for intervention in interventions {
      if intervention.value(forKey: "status") as? Int16 == Intervention.Status.OutOfSync.rawValue {
        intervention.setValue(Intervention.Status.Synchronised.rawValue, forKey: "status")
      }
    }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }

    tableView.reloadData()
  }

  @objc func action(sender: UIButton) {
    hideInterventionAdd()
    performSegue(withIdentifier: "addIntervention", sender: sender)
  }

  @objc func hideInterventionAdd() {
    for interventionButton in interventionButtons {
      interventionButton.isHidden = true
    }

    createInterventionButton.isHidden = false
    heightConstraint.constant = 60
    dimView.isHidden = true
  }

  @IBAction func addIntervention(_ sender: Any) {
    self.heightConstraint.constant = 220
    createInterventionButton.isHidden = true
    bottomView.layoutIfNeeded()
    var index: CGFloat = 1
    var line: CGFloat = 0
    let width = bottomView.frame.size.width

    for interventionButton in interventionButtons {
      interventionButton.isHidden = false
      interventionButton.frame = CGRect(x: index * width/5.357 + (index + 1) * width/19.737, y: 20 + line * 100, width: 70, height: 70)
      interventionButton.titleEdgeInsets = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
      interventionButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
      bottomView.layoutIfNeeded()

      if index > 2 {
        line += 1
        index = 0
      } else {
        index += 1
      }
    }
    dimView.isHidden = false
  }
}
