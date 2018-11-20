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
  @IBOutlet weak var syncView: UIView!
  @IBOutlet weak var syncLabel: UILabel!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var createInterventionButton: UIButton!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!

  // MARK: - Properties

  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var interventions = [Intervention]() {
    didSet {
      tableView.reloadData()
    }
  }

  let navItem = UINavigationItem()
  let dimView = UIView(frame: CGRect.zero)
  let refreshControl = UIRefreshControl()
  var interventionTypeButtons = [UIButton]()
  var interventionTypeLabels = [UILabel]()
  let interventionTypes = ["IMPLANTATION", "GROUND_WORK", "IRRIGATION", "HARVEST",
                           "CARE", "FERTILIZATION", "CROP_PROTECTION"]

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()
    super.hideKeyboardWhenTappedAround()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    setupNavigationBar()
    setupTableView()
    setupBottomView()
    updateSyncLabel()
    setupDimView()

    checkLocalData()
    fetchInterventions()
    if Connectivity.isConnectedToInternet() {
      synchronise(self)
    }
  }

  private func setupNavigationBar() {
    let farmNameLabel = UILabel()
    let cropsButton = UIButton()
    let logoutButton = UIButton()

    navigationController?.navigationBar.isHidden = true
    farmNameLabel.text = fetchFarmName()
    farmNameLabel.textColor = UIColor.white
    farmNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
    cropsButton.setImage(UIImage(named: "plots")?.withRenderingMode(.alwaysTemplate), for: .normal)
    cropsButton.tintColor = .white
    cropsButton.addTarget(self, action: #selector(presentInterventionsByCrop), for: .touchUpInside)
    logoutButton.setImage(UIImage(named: "logout")?.withRenderingMode(.alwaysTemplate), for: .normal)
    logoutButton.tintColor = .white
    logoutButton.addTarget(self, action: #selector(presentLogoutAlert), for: .touchUpInside)

    NSLayoutConstraint.activate([
      cropsButton.widthAnchor.constraint(equalToConstant: 32.0),
      cropsButton.heightAnchor.constraint(equalToConstant: 32.0),
      logoutButton.widthAnchor.constraint(equalToConstant: 32.0),
      logoutButton.heightAnchor.constraint(equalToConstant: 32.0)
      ])

    navItem.leftBarButtonItem = UIBarButtonItem(customView: farmNameLabel)
    navItem.rightBarButtonItems = [UIBarButtonItem(customView: logoutButton), UIBarButtonItem(customView: cropsButton)]
    navigationBar.setItems([navItem], animated: true)
  }

  private func setupTableView() {
    tableView.bringSubviewToFront(syncView)
    tableView.register(InterventionCell.self, forCellReuseIdentifier: "InterventionCell")
    tableView.rowHeight = 80
    tableView.delegate = self
    tableView.dataSource = self
    tableView.refreshControl = refreshControl
  }

  private func setupBottomView() {
    createInterventionButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
    createInterventionButton.layer.shadowOffset = CGSize(width: 0, height: 4)
    createInterventionButton.layer.shadowOpacity = 1
    createInterventionButton.layer.shadowRadius = 0
    createInterventionButton.layer.masksToBounds = false
    createInterventionButton.layer.cornerRadius = 3
    createInterventionButton.addTarget(self, action: #selector(expandBottomView), for: .touchUpInside)

    setupInterventionTypeButtons()
    setupInterventionTypeLabels()
  }

  private func setupInterventionTypeButtons() {
    for index in 0...6 {
      let interventionTypeButton = UIButton(frame: CGRect(x: 30, y: 600, width: bottomView.bounds.width, height: bottomView.bounds.height))
      let assetName = interventionTypes[index].lowercased().replacingOccurrences(of: "_", with: "-")
      let image = UIImage(named: assetName)

      interventionTypeButton.tag = index
      interventionTypeButton.backgroundColor = UIColor.white
      interventionTypeButton.setBackgroundImage(image, for: .normal)
      interventionTypeButton.layer.cornerRadius = 3
      interventionTypeButton.isHidden = true
      interventionTypeButton.addTarget(self, action: #selector(presentAddInterventionVC), for: .touchUpInside)
      interventionTypeButton.translatesAutoresizingMaskIntoConstraints = false
      bottomView.addSubview(interventionTypeButton)
      interventionTypeButtons.append(interventionTypeButton)
      setupButtonLayout(button: interventionTypeButton, index: CGFloat(index + 1))
    }
  }

  private func setupButtonLayout(button: UIButton, index: CGFloat) {
    let column = index.truncatingRemainder(dividingBy: 4)
    let gapWidth = (UIScreen.main.bounds.width - 280) / 5
    let leftConstant = gapWidth + column * (70 + gapWidth)
    let topConstant: CGFloat = index > 3 ? 120 : 20

    NSLayoutConstraint.activate([
      button.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: leftConstant),
      button.widthAnchor.constraint(equalToConstant: 70),
      button.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: topConstant),
      button.heightAnchor.constraint(equalToConstant: 70)
      ])
  }

  private func setupInterventionTypeLabels() {
    for index in 0...6 {
      let interventionTypeLabel = UILabel()

      interventionTypeLabel.text = interventionTypes[index].localized
      interventionTypeLabel.textColor = .white
      interventionTypeLabel.font = UIFont.systemFont(ofSize: 15)
      interventionTypeLabel.isHidden = true
      interventionTypeLabel.translatesAutoresizingMaskIntoConstraints = false
      bottomView.addSubview(interventionTypeLabel)
      interventionTypeLabels.append(interventionTypeLabel)

      NSLayoutConstraint.activate([
        interventionTypeLabel.centerXAnchor.constraint(equalTo: interventionTypeButtons[index].centerXAnchor),
        interventionTypeLabel.topAnchor.constraint(equalTo: interventionTypeButtons[index].bottomAnchor, constant: 5)
        ])
    }
  }

  func updateSyncLabel() {
    guard let date = UserDefaults.standard.value(forKey: "lastSyncDate") as? Date else {
      syncLabel.text = "no_synchronization_listed".localized
      return
    }
    let calendar = Calendar.current

    if calendar.isDateInToday(date) {
      let hour = calendar.component(.hour, from: date)
      let minute = calendar.component(.minute, from: date)

      syncLabel.text = String(format: "today_last_synchronization".localized, hour, minute)
    } else {
      let dateFormatter = DateFormatter()

      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMMM"
      syncLabel.text = "last_synchronization".localized + dateFormatter.string(from: date)
    }
  }

  private func setupDimView() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(collapseBottomView))

    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    dimView.addGestureRecognizer(gesture)
    dimView.isHidden = true
    dimView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(dimView)

    NSLayoutConstraint.activate([
      dimView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
      dimView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
      dimView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      dimView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
      ])
  }

  // MARK: - Core Data

  private func fetchFarmName() -> String? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let farmsFetchRequest: NSFetchRequest<Farm> = Farm.fetchRequest()

    do {
      let entities = try managedContext.fetch(farmsFetchRequest)
      return entities.first?.name
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  private func fetchInterventions() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let interventionsFetchRequest: NSFetchRequest<Intervention> = Intervention.fetchRequest()

    do {
      interventions = try managedContext.fetch(interventionsFetchRequest)
      sortInterventionsByDate()
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }

  private func sortInterventionsByDate() {
    interventions = interventions.sorted(by: {
      let firstWorkingPeriod = $0.workingPeriods?.anyObject() as! WorkingPeriod
      let secondWorkingPeriod = $1.workingPeriods?.anyObject() as! WorkingPeriod

      return firstWorkingPeriod.executionDate! > secondWorkingPeriod.executionDate!
    })
  }

  // MARK: - Table view
  
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
    let assetName = intervention.type!.lowercased().replacingOccurrences(of: "_", with: "-")
    let stateImages: [Int16: UIImage] = [0: UIImage(named: "created")!, 1: UIImage(named: "synced")!, 2: UIImage(named: "validated")!]

    cell.typeImageView.image = UIImage(named: assetName)
    cell.typeLabel.text = intervention.type?.localized
    cell.stateImageView.image = stateImages[intervention.status]?.withRenderingMode(.alwaysTemplate)
    cell.stateImageView.tintColor = (intervention.status == 0) ? UIColor.orange : UIColor.green
    cell.dateLabel.text = updateDateLabel(intervention.workingPeriods!)
    cell.cropsLabel.text = updateCropsLabel(intervention.targets!)
    cell.notesLabel.text = intervention.infos
    cell.backgroundColor = (indexPath.row % 2 == 0) ? AppColor.CellColors.White : AppColor.CellColors.LightGray
    return cell
  }

  private func updateDateLabel(_ workingPeriods: NSSet) -> String {
    let date = (workingPeriods.allObjects as! [WorkingPeriod]).first!.executionDate!
    let calendar = Calendar.current
    let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "locale".localized)
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter
    }()
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

  private func updateCropsLabel(_ targets: NSSet) -> String {
    let cropString = (targets.count < 2) ? "crop".localized : "crops".localized
    var totalSurfaceArea: Float = 0

    for case let target as Target in targets {
      let crop = target.crop!

      totalSurfaceArea += crop.surfaceArea
    }
    return String(format: cropString, targets.count) + String(format: " • %.1f ha", totalSurfaceArea)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y < -75 && !refreshControl.isRefreshing {
      refreshControl.beginRefreshing()
      synchronise(self)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "showAddInterventionVC":
      let destVC = segue.destination as! AddInterventionViewController
      let type = interventionTypes[((sender as? UIButton)?.tag)!]

      destVC.interventionType = type
    default:
      return
    }
  }

  @IBAction private func unwindToInterventionVCWithSegue(_ segue: UIStoryboardSegue) {
    if segue.source is AddInterventionViewController {
      fetchInterventions()
    }
  }

  @objc private func presentAddInterventionVC(sender: UIButton) {
    performSegue(withIdentifier: "showAddInterventionVC", sender: sender)
    collapseBottomView()
  }

  @objc private func presentInterventionsByCrop(_ sender: Any) {
    self.performSegue(withIdentifier: "showInterventionsByCrop", sender: sender)
    collapseBottomView()
  }

  // MARK: - Actions

  @IBAction private func synchronise(_ sender: Any) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let date = Date()
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)
    let farmNameLabel = navItem.leftBarButtonItem?.customView as? UILabel

    queryFarms { (success) in
      if success {
        if farmNameLabel?.text == nil {
          farmNameLabel?.text = self.fetchFarmName()
        }
        self.pushStoragesIfNeeded()
        self.pushInterventionIfNeeded()
        self.fetchInterventions()

        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        self.syncLabel.text = String(format: "today_last_synchronization".localized, hour, minute)
        UserDefaults.standard.set(date, forKey: "lastSyncDate")
        UserDefaults.standard.synchronize()
      } else {
        self.syncLabel.text = "sync_failure".localized
      }
      self.refreshControl.endRefreshing()
      self.tableView.reloadData()
    }
  }

  private func pushInterventionIfNeeded() {
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
        try managedContext.save()
      }
    } catch let error as NSError {
      print("Could not fetch: \(error), \(error.userInfo)")
    }
  }

  @objc private func expandBottomView() {
    if !checkCropsData() {
      return
    }

    createInterventionButton.isHidden = true
    heightConstraint.constant = 220
    dimView.isHidden = false

    for index in 0...6 {
      interventionTypeButtons[index].isHidden = false
      interventionTypeLabels[index].isHidden = false
    }
  }

  private func checkCropsData() -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return false
    }

    var crops: [Crop]!
    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest: NSFetchRequest<Crop> = Crop.fetchRequest()

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    if crops.count == 0 {
      let alert = UIAlertController(title: "", message: "start_online_with_crops".localized, preferredStyle: .alert)
      let action = UIAlertAction(title: "ok".localized, style: .default, handler: nil)

      alert.addAction(action)
      present(alert, animated: true)
      return false
    }
    return true
  }

  @objc func collapseBottomView() {
    for index in 0...6 {
      interventionTypeButtons[index].isHidden = true
      interventionTypeLabels[index].isHidden = true
    }

    dimView.isHidden = true
    heightConstraint.constant = 60
    createInterventionButton.isHidden = false
  }

  // MARK: - Logout

  @objc private func presentLogoutAlert() {
    let alert = UIAlertController(title: "", message: "disconnect_prompt".localized, preferredStyle: .actionSheet)
    let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
    let logoutAction = UIAlertAction(title: "menu_logout".localized, style: .destructive, handler: { action in
      self.logoutUser()
    })

    alert.addAction(cancelAction)
    alert.addAction(logoutAction)
    present(alert, animated: true)
  }

  private func logoutUser() {
    let authentificationService = AuthentificationService(username: "", password: "")

    authentificationService.logout()
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
    emptyAllCoreData()
    navigationController?.popViewController(animated: true)
  }

  private func emptyAllCoreData() {
    let entityNames = appDelegate.persistentContainer.managedObjectModel.entities.map({ (entity) -> String in
      return entity.name!
    })

    for entityName in entityNames {
      batchDeleteEntity(name: entityName)
    }
  }

  private func batchDeleteEntity(name: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
    let request = NSBatchDeleteRequest(fetchRequest: fetch)

    do {
      try managedContext.execute(request)
    } catch let error as NSError {
      print("Could not remove data. \(error), \(error.userInfo)")
    }
  }
}
