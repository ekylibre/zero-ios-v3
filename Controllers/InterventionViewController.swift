//
//  InterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import Apollo
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

  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var interventions = [Interventions]() {
    didSet {
      tableView.reloadData()
    }
  }

  let dimView = UIView()
  let refreshControl = UIRefreshControl()
  var interventionButtons = [UIButton]()
  let interventionTypes = ["IMPLANTATION", "GROUND_WORK", "IRRIGATION", "HARVEST",
                           "CARE", "FERTILIZATION", "CROP_PROTECTION"]

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()

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
        synchroLabel.text = String(format: "today_last_synchronization".localized, hour, minute)
      } else {
        synchroLabel.text = "last_synchronization".localized + dateString
      }
    } else {
      synchroLabel.text = "no_synchronization_listed".localized
    }

    initialiseInterventionButtons()

    // Load table view
    tableView.dataSource = self
    tableView.delegate = self
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(synchronise(_:)), for: .valueChanged)

    checkLocalData()
    if Connectivity.isConnectedToInternet() {
      fetchInterventions()
      synchronise(self)
    } else {
      fetchInterventions()
    }

    displayFarmName()

    initializeLogoutItem()
  }

  func initialiseInterventionButtons() {
    for buttonCount in 0...6 {
      let interventionButton = UIButton(frame: CGRect(x: 30, y: 600, width: bottomView.bounds.width, height: bottomView.bounds.height))
      let image = UIImage(named: interventionTypes[buttonCount].lowercased().replacingOccurrences(of: "_", with: "-"))

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
  }

  private func fetchInterventions() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsFetchRequest: NSFetchRequest<Interventions> = Interventions.fetchRequest()

    do {
      interventions = try managedContext.fetch(interventionsFetchRequest)
      sortInterventionByDate()
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  func sortInterventionByDate() {
    interventions = interventions.sorted(by: {
      let result: Bool!

      if ($0.workingPeriods?.anyObject() as? WorkingPeriods)?.executionDate != nil && ($1.workingPeriods?.anyObject() as? WorkingPeriods)?.executionDate != nil {
        result = ($0.workingPeriods?.anyObject() as! WorkingPeriods).executionDate! >
          ($1.workingPeriods?.anyObject() as! WorkingPeriods).executionDate!
        return result
      }
      return true
    })
  }

  // MARK: - Apollo

  func fetchFarmNameAndId() -> String? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Farms")

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      if entities.count > 0 {
        return entities[0].value(forKey: "name") as? String
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  func displayFarmName() {
    let firstFrame = CGRect(x: 10, y: 0, width: navigationBar.frame.width / 2, height: navigationBar.frame.height)
    let farmLabel = UILabel(frame: firstFrame)

    farmLabel.text = fetchFarmNameAndId()
    farmLabel.textColor = UIColor.white
    farmLabel.font = UIFont.boldSystemFont(ofSize: 18)
    navigationBar.addSubview(farmLabel)
  }

  // MARK: - Logout

  func initializeLogoutItem() {
    let navigationItem = UINavigationItem(title: "")
    let logoutButton = UIButton()

    logoutButton.addTarget(self, action: #selector(logoutFromFarm), for: .touchUpInside)
    logoutButton.setImage(UIImage(named: "logout"), for: .normal)
    let rightItem = UIBarButtonItem.init(customView: logoutButton)

    navigationItem.rightBarButtonItem = rightItem
    navigationBar.setItems([navigationItem], animated: true)
  }

  @objc func logoutFromFarm(_ sender: Any) {
    let alert = UIAlertController(title: "", message: "disconnect_prompt".localized, preferredStyle: .actionSheet)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "menu_logout".localized, style: .destructive, handler: { action in
      let authentificationService = AuthentificationService(username: "", password: "")

      authentificationService.logout()
      appDelegate.
      self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }))
    present(alert, animated: true)
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

    let intervention = interventions[indexPath.row]
    let targets = fetchTargets(intervention)
    let workingPeriod = fetchWorkingPeriod(intervention)
    let assetName = intervention.type!.lowercased().replacingOccurrences(of: "_", with: "-")
    let stateImages: [Int16: UIImage] = [0: UIImage(named: "out-of-sync")!, 1: UIImage(named: "synchronised")!, 2: UIImage(named: "validated")!]
    let stateTintColors: [Int16: UIColor] = [0: UIColor.orange, 1: UIColor.green, 2: UIColor.green]

    cell.typeLabel.text = intervention.type?.localized
    cell.typeImageView.image = UIImage(named: assetName)
    cell.syncImage.image = stateImages[intervention.status]?.withRenderingMode(.alwaysTemplate)
    cell.syncImage.tintColor = stateTintColors[intervention.status]
    cell.cropsLabel.text = updateCropsLabel(targets!)
    cell.infosLabel.text = intervention.infos
    cell.backgroundColor = (indexPath.row % 2 == 0) ? AppColor.CellColors.White : AppColor.CellColors.LightGray
    if workingPeriod?.executionDate != nil {
      cell.dateLabel.text = transformDate(date: (workingPeriod?.executionDate)!)
    }

    // Resize labels according to their text
    cell.typeLabel.sizeToFit()
    cell.cropsLabel.sizeToFit()
    cell.infosLabel.sizeToFit()
    cell.selectionStyle = .none

    return cell
  }

  func fetchTargets(_ intervention: Interventions) -> [Targets]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let targetsFetchRequest: NSFetchRequest<Targets> = Targets.fetchRequest()
    let predicate = NSPredicate(format: "interventions == %@", intervention)
    targetsFetchRequest.predicate = predicate

    do {
      let targets = try managedContext.fetch(targetsFetchRequest)
      return targets
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  func fetchWorkingPeriod(_ intervention: Interventions) -> WorkingPeriods? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let workingPeriodsFetchRequest: NSFetchRequest<WorkingPeriods> = WorkingPeriods.fetchRequest()
    let predicate = NSPredicate(format: "interventions == %@", intervention)
    workingPeriodsFetchRequest.predicate = predicate

    do {
      let workingPeriods = try managedContext.fetch(workingPeriodsFetchRequest)
      return workingPeriods.first
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  func updateCropsLabel(_ targets: [Targets]?) -> String? {
    var totalSurfaceArea: Float = 0

    if targets != nil {
      for target in targets! {
        let crop = target.crops
        totalSurfaceArea += crop?.surfaceArea ?? 0
      }
      let cropString = targets!.count < 2 ? "crop".localized : "crops".localized
      return String(format: cropString, targets!.count) + String(format: " • %.1f ha", totalSurfaceArea)
    }
    return nil
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
    let intervention = Interventions(context: managedContext)
    let workingPeriod = WorkingPeriods(context: managedContext)

    intervention.type = type
    intervention.infos = infos
    intervention.status = status
    workingPeriod.interventions = intervention
    workingPeriod.executionDate = executionDate

    do {
      try managedContext.save()
      interventions.append(intervention)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "showAddInterventionVC":
      let destVC = segue.destination as! AddInterventionViewController
      let index = interventionButtons.firstIndex(of: (sender as! UIButton))!

      destVC.interventionType = interventionTypes[index]
    default:
      return
    }
  }

  @IBAction func unwindToInterventionVCWithSegue(_ segue: UIStoryboardSegue) {
    if segue.source is AddInterventionViewController {
      fetchInterventions()
    }
  }

  func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    return calendar.date(from: components)!
  }

  // MARK: - Actions

  @IBAction func synchronise(_ sender: Any) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let date = Date()
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)

    queryFarms { (success) in
      if success {
        self.pushInterventionIfNeeded()
        self.fetchInterventions()

        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        self.synchroLabel.text = String(format: "today_last_synchronization".localized, hour, minute)
        UserDefaults.standard.set(date, forKey: "lastSyncDate")
        UserDefaults.standard.synchronize()
      } else {
        self.synchroLabel.text = "sync_failure".localized
      }
      self.refreshControl.endRefreshing()
      self.tableView.reloadData()
    }
  }

  func pushInterventionIfNeeded() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsFetchRequest: NSFetchRequest<Interventions> = Interventions.fetchRequest()
    let predicate = NSPredicate(format: "ekyID == %d", 0)

    interventionsFetchRequest.predicate = predicate

    do {
      let interventions = try managedContext.fetch(interventionsFetchRequest)

      for intervention in interventions {
        intervention.ekyID = pushIntervention(intervention: intervention)
        if intervention.ekyID != 0 {
          intervention.status = Int16(InterventionState.Synced.rawValue)
        }
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Could not fetch: \(error), \(error.userInfo)")
    }
  }

  @objc func action(sender: UIButton) {
    hideInterventionAdd()
    performSegue(withIdentifier: "showAddInterventionVC", sender: sender)
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
