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
  var interventions = [Intervention]() {
    didSet {
      tableView.reloadData()
    }
  }

  let dimView = UIView()
  let refreshControl = UIRefreshControl()
  var interventionButtons = [UIButton]()
  var interventionButtonsLabels = [UILabel]()
  let interventionTypes = ["IMPLANTATION", "GROUND_WORK", "IRRIGATION", "HARVEST",
                           "CARE", "FERTILIZATION", "CROP_PROTECTION"]

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()

    // Hide navigation bar
    navigationController?.navigationBar.isHidden = true

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

    checkLocalData()
    if Connectivity.isConnectedToInternet() {
      fetchInterventions()
      synchronise(self)
    } else {
      fetchInterventions()
    }

    initializeLogoutItem()
  }

  func initialiseInterventionButtons() {
    for buttonCount in 0...6 {
      let interventionButton = UIButton(frame: CGRect(x: 30, y: 600, width: bottomView.bounds.width, height: bottomView.bounds.height))
      let image = UIImage(named: interventionTypes[buttonCount].lowercased().replacingOccurrences(of: "_", with: "-"))
      let interventionLabel = UILabel()

      interventionButton.tag = buttonCount
      interventionButton.backgroundColor = UIColor.white
      interventionButton.setBackgroundImage(image, for: .normal)
      interventionButton.layer.cornerRadius = 3
      interventionButton.isHidden = false
      interventionLabel.text = interventionTypes[buttonCount].localized
      interventionLabel.textColor = .white
      interventionLabel.font = UIFont.systemFont(ofSize: 15)
      interventionLabel.translatesAutoresizingMaskIntoConstraints = false
      interventionLabel.isHidden = true
      interventionButtons.append(interventionButton)
      interventionButtonsLabels.append(interventionLabel)
      bottomView.addSubview(interventionButton)
      bottomView.addSubview(interventionButtonsLabels[interventionButton.tag])
    }
  }

  private func fetchInterventions() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsFetchRequest: NSFetchRequest<Intervention> = Intervention.fetchRequest()

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

      if ($0.workingPeriods?.anyObject() as? WorkingPeriod)?.executionDate != nil && ($1.workingPeriods?.anyObject() as? WorkingPeriod)?.executionDate != nil {
        result = ($0.workingPeriods?.anyObject() as! WorkingPeriod).executionDate! >
          ($1.workingPeriods?.anyObject() as! WorkingPeriod).executionDate!
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
    let entitiesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Farm")

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      return entities.first?.value(forKey: "name") as? String
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
    let image = UIImage(named: "logout")?.withRenderingMode(.alwaysTemplate)

    logoutButton.addTarget(self, action: #selector(logoutFromFarm), for: .touchUpInside)
    logoutButton.setImage(image, for: .normal)
    logoutButton.imageView?.tintColor = .white
    let rightItem = UIBarButtonItem.init(customView: logoutButton)

    navigationItem.rightBarButtonItem = rightItem
    navigationBar.setItems([navigationItem], animated: true)
  }

  func emptyCoreData(entityName: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let request = NSBatchDeleteRequest(fetchRequest: fetch)

    do {
      try managedContext.execute(request)
    } catch let error as NSError {
      print("Could not remove data. \(error), \(error.userInfo)")
    }
  }

  func emptyAllCoreData() {
    let entitiesNames = [
      "Crop",
      "Equipment",
      "Farm",
      "Fertilizer",
      "Harvest",
      "InterventionEquipment",
      "InterventionFertilizer",
      "InterventionMaterial",
      "InterventionPerson",
      "InterventionPhytosanitary",
      "Intervention",
      "InterventionSeed",
      "Material",
      "Person",
      "Phyto",
      "Seed",
      "Storage",
      "User",
      "Weather",
      "WorkingPeriod"]

    for entityName in entitiesNames {
      emptyCoreData(entityName: entityName)
    }
  }

  @objc func logoutFromFarm(_ sender: Any) {
    let alert = UIAlertController(title: "", message: "disconnect_prompt".localized, preferredStyle: .actionSheet)

    alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "menu_logout".localized, style: .destructive, handler: { action in
      let authentificationService = AuthentificationService(username: "", password: "")

      authentificationService.logout()
      UserDefaults.standard.set(false, forKey: "hasBeenLaunchedBefore")
      UserDefaults.standard.set(0, forKey: "lastSyncDate")
      UserDefaults.standard.synchronize()
      self.emptyAllCoreData()
      self.navigationController?.popViewController(animated: true)
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

    cell.selectionStyle = .none
    cell.typeLabel.text = intervention.type?.localized
    cell.typeImageView.image = UIImage(named: assetName)
    cell.syncImage.image = stateImages[intervention.status]?.withRenderingMode(.alwaysTemplate)
    cell.syncImage.tintColor = stateTintColors[intervention.status]
    cell.cropsLabel.text = updateCropsLabel(targets!)
    cell.infosLabel.text = intervention.infos
    cell.backgroundColor = (indexPath.row % 2 == 0) ? AppColor.CellColors.White : AppColor.CellColors.LightGray
    if workingPeriod?.executionDate != nil {
      cell.dateLabel.text = transformDate(date: workingPeriod!.executionDate!)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "updateIntervention", sender: self)
  }

  func fetchTargets(_ intervention: Intervention) -> [Target]? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let targetsFetchRequest: NSFetchRequest<Target> = Target.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", intervention)
    targetsFetchRequest.predicate = predicate

    do {
      let targets = try managedContext.fetch(targetsFetchRequest)
      return targets
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  func fetchWorkingPeriod(_ intervention: Intervention) -> WorkingPeriod? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let workingPeriodsFetchRequest: NSFetchRequest<WorkingPeriod> = WorkingPeriod.fetchRequest()
    let predicate = NSPredicate(format: "intervention == %@", intervention)
    workingPeriodsFetchRequest.predicate = predicate

    do {
      let workingPeriods = try managedContext.fetch(workingPeriodsFetchRequest)
      return workingPeriods.first
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  func updateCropsLabel(_ targets: [Target]?) -> String? {
    var totalSurfaceArea: Float = 0

    if targets != nil {
      for target in targets! {
        let crop = target.crop
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
    let intervention = Intervention(context: managedContext)
    let workingPeriod = WorkingPeriod(context: managedContext)

    intervention.type = type
    intervention.infos = infos
    intervention.status = status
    workingPeriod.intervention = intervention
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
      let type = interventionTypes[((sender as? UIButton)?.tag)!]

      destVC.interventionType = type
      destVC.interventionState = nil
      destVC.currentIntervention = nil
    case "updateIntervention":
      let destVC = segue.destination as! AddInterventionViewController
      let indexPath = tableView.indexPathForSelectedRow

      if indexPath != nil {
        let intervention = interventions[(indexPath?.row)!]

        destVC.currentIntervention = intervention
        destVC.interventionState = intervention.status
      }
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

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < -75 && !refreshControl.isRefreshing {
      refreshControl.beginRefreshing()
      synchronise(self)
    }
  }

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
        if self.navigationBar.items?.count == 1 {
          self.displayFarmName()
        }
        self.pushEntities()
        self.pushInterventionIfNeeded()
        self.updateInterventionIfNeeded()
        self.updateInterventionIfChangedOnApi()
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
    let interventionsFetchRequest: NSFetchRequest<Intervention> = Intervention.fetchRequest()
    let predicate = NSPredicate(format: "ekyID == %d", 0)

    interventionsFetchRequest.predicate = predicate

    do {
      let interventions = try managedContext.fetch(interventionsFetchRequest)

      for intervention in interventions {
        intervention.ekyID = pushIntervention(intervention: intervention)
        if intervention.ekyID != 0 {
          intervention.status = Int16(InterventionState.Synced.rawValue)
        }
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not fetch: \(error), \(error.userInfo)")
    }
  }

  func updateInterventionIfNeeded() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsFetchRequest: NSFetchRequest<Intervention> = Intervention.fetchRequest()
    let ekyIDPredicate = NSPredicate(format: "ekyID != %d", 0)
    let statusPredicate = NSPredicate(format: "status == %d", InterventionState.Created.rawValue)
    let predicates = NSCompoundPredicate(type: .and, subpredicates: [ekyIDPredicate, statusPredicate])

    interventionsFetchRequest.predicate = predicates

    do {
      let interventions = try managedContext.fetch(interventionsFetchRequest)

      for intervention in interventions {
        pushUpdatedIntervention(intervention: intervention)
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not fetch: \(error), \(error.userInfo)")
    }
  }


  func fetchCrops() -> [Crop] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return [Crop]()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crop> = Crop.fetchRequest()

    do {
      let crops = try managedContext.fetch(cropsFetchRequest)

      return crops
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return [Crop]()
  }

  @objc func action(sender: UIButton) {
    hideInterventionAdd()
    performSegue(withIdentifier: "showAddInterventionVC", sender: sender)
  }

  @objc func hideInterventionAdd() {
    for interventionButton in interventionButtons {
      interventionButton.isHidden = true
      interventionButtonsLabels[interventionButton.tag].isHidden = true
    }

    createInterventionButton.isHidden = false
    heightConstraint.constant = 60
    dimView.isHidden = true
  }

  @IBAction func addIntervention(_ sender: Any) {
    let crops = fetchCrops()

    if crops.count ==  0 {
      let alert = UIAlertController(title: "", message: "start_online_with_crops".localized, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
      present(alert, animated: true)
    } else {
      self.heightConstraint.constant = 220
      createInterventionButton.isHidden = true
      bottomView.layoutIfNeeded()
      var index: CGFloat = 1
      var column: CGFloat = 1
      var line: CGFloat = 0
      let width = bottomView.frame.size.width

      for interventionButton in interventionButtons {
        interventionButton.isHidden = false
        interventionButton.frame = CGRect(x: column * width/5.357 + (column + 1) * width/19.737, y: 20 + line * 100, width: 70, height: 70)
        interventionButton.titleEdgeInsets = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        interventionButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)

        interventionButtonsLabels[interventionButton.tag].isHidden = false
        NSLayoutConstraint.activate([
          interventionButtonsLabels[interventionButton.tag].topAnchor.constraint(equalTo: interventionButton.bottomAnchor, constant: 5),
          interventionButtonsLabels[interventionButton.tag].centerXAnchor.constraint(equalTo: interventionButton.centerXAnchor)
          ])

        bottomView.layoutIfNeeded()

        index += 1
        column = index.truncatingRemainder(dividingBy: 4)
        line = floor(index / 4)
      }
      dimView.isHidden = false
    }
  }
}
