//
//  InterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData
import Apollo

class InterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  // MARK: - Outlets

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var synchroLabel: UILabel!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var leftInterventionButton: UIButton!
  @IBOutlet weak var rightInterventionButton: UIButton!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomBottom: NSLayoutConstraint!
  @IBOutlet weak var addInterventionLabel: UILabel!

  // MARK: - Properties

  var userDatabase = UsersDatabase()
  var apolloQuery = ApolloQuery()
  var interventions = [NSManagedObject]() {
    didSet {
      tableView.reloadData()
    }
  }

  var interventionButtons: [UIButton] = []
  let dimView = UIView()
  let refreshControl = UIRefreshControl()

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Change status bar appearance
    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

    // Rounded buttons
    leftInterventionButton.layer.cornerRadius = 3
    leftInterventionButton.clipsToBounds = true
    rightInterventionButton.layer.cornerRadius = 3
    rightInterventionButton.clipsToBounds = true

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
      dateFormatter.locale = Locale(identifier: "fr_FR")
      dateFormatter.dateFormat = "d MMMM"

      let hour = calendar.component(.hour, from: date)
      let minute = calendar.component(.minute, from: date)
      let dateString = dateFormatter.string(from: date)

      if calendar.isDateInToday(date) {
        synchroLabel.text = String(format: "Dernière synchronisation %02d:%02d", hour, minute)
      } else {
        synchroLabel.text = "Dernière synchronisation " + dateString
      }
    } else {
      synchroLabel.text = "Aucune synchronisation répertoriée"
    }

    initialiseInterventionButtons()

    // Load table view
    tableView.dataSource = self
    tableView.delegate = self
    tableView.refreshControl = refreshControl

    refreshControl.addTarget(self, action: #selector(synchronise(_:)), for: .valueChanged)
  }

  func initialiseInterventionButtons() {

    let interventionNames: [String] = [
      "implantation".localized,
      "ground_work".localized,
      "irrigation".localized,
      "harvest".localized,
      "care".localized,
      "fertilization".localized,
      "crop_protection".localized
    ]
    let interventionImages: [UIImage] =  [#imageLiteral(resourceName: "implantation"), #imageLiteral(resourceName: "ground-work"), #imageLiteral(resourceName: "irrigation"), #imageLiteral(resourceName: "harvest"), #imageLiteral(resourceName: "care"), #imageLiteral(resourceName: "fertilization"), #imageLiteral(resourceName: "crop-protection")]

    for buttonCount in 0...6 {

      let interventionButton = UIButton(frame: CGRect(x: 30, y: 600, width: bottomView.bounds.width, height: bottomView.bounds.height))

      interventionButton.backgroundColor = UIColor.white
      interventionButton.setBackgroundImage(interventionImages[buttonCount], for: .normal)
      interventionButton.setTitle(interventionNames[buttonCount], for: .normal)
      interventionButton.setTitleColor(UIColor.white, for: .normal)
      interventionButton.layer.cornerRadius = 3
      interventionButton.isHidden = false
      interventionButtons.append(interventionButton)
      bottomView.addSubview(interventionButton)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    initializeApolloClient()
    //apolloQuery.checkLocalData()
    self.fetchInterventions()
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

  // MARK: - Apollo

  func checkIfTokenIsValid(authService: AuthentificationService) -> String {
    if authService.oauth2.hasUnexpiredAccessToken() {
      return authService.oauth2.accessToken!
    } else {
      authService.authorize(presenting: self)
      return authService.oauth2.accessToken!
    }
  }

  func initializeApolloClient() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let url = URL(string: "https://api.ekylibre-test.com/v1/graphql")!
    let configuation = URLSessionConfiguration.default
    let authService = AuthentificationService(username: "", password: "")
    let token = checkIfTokenIsValid(authService: authService)

    configuation.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
    appDelegate.apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuation))
  }

  func fetchFarmNameAndId() -> String? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entitiesFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Farms")

    do {
      let entities = try managedContext.fetch(entitiesFetchRequest)

      for entity in entities {
        return entity.value(forKey: "name") as? String
      }
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
  }

  /*func displayFarmName() {
   let firstFrame = CGRect(x: 10, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
   let farmLabel = UILabel(frame: firstFrame)

   if userDatabase.entityIsEmpty(entity: "Farms") {
   apolloQuery.defineFarmNameAndID { (success) -> Void in
   if success {
   farmLabel.text = self.fetchFarmNameAndId()
   farmLabel.textColor = UIColor.white
   self.navigationBar.addSubview(farmLabel)
   }
   }
   } else {
   farmLabel.text = fetchFarmNameAndId()
   farmLabel.textColor = UIColor.white
   navigationBar.addSubview(farmLabel)
   }
   }*/

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

    cell.typeLabel.text = (intervention.value(forKey: "type") as? String)?.localized
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
      cell.typeLabel.text = "Erreur"
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

  func fetchTargets(of intervention: NSManagedObject) -> [Targets]? {
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

  func updateCropsLabel(_ targets: [Targets]?) -> String {
    var totalSurfaceArea: Float = 0

    if targets != nil {
      for target in targets! {
        let crop = target.crops
        totalSurfaceArea += crop?.surfaceArea ?? 0
      }
    }

    if targets?.count ?? 0 > 1 {
      return String(format: "%d cultures • %.1f ha", targets!.count, totalSurfaceArea)
    } else {
      return String(format: "1 culture • %.1f ha", totalSurfaceArea)
    }
  }

  func transformDate(date: Date) -> String {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "fr_FR")
    dateFormatter.dateFormat = "d MMMM"

    var dateString = dateFormatter.string(from: date)
    let year = calendar.component(.year, from: date)

    if calendar.isDateInToday(date) {
      return "aujourd'hui"
    } else if calendar.isDateInYesterday(date) {
      return "hier"
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

    if var type = (sender as? UIButton)?.titleLabel?.text {
      switch type {
      case Intervention.InterventionType.Care.rawValue.localized:
        type = Intervention.InterventionType.Care.rawValue
      case Intervention.InterventionType.CropProtection.rawValue.localized:
        type = Intervention.InterventionType.CropProtection.rawValue
      case Intervention.InterventionType.Fertilization.rawValue.localized:
        type = Intervention.InterventionType.Fertilization.rawValue
      case Intervention.InterventionType.GroundWork.rawValue.localized:
        type = Intervention.InterventionType.GroundWork.rawValue
      case Intervention.InterventionType.Harvest.rawValue.localized:
        type = Intervention.InterventionType.Harvest.rawValue
      case Intervention.InterventionType.Implantation.rawValue.localized:
        type = Intervention.InterventionType.Implantation.rawValue
      case Intervention.InterventionType.Irrigation.rawValue.localized:
        type = Intervention.InterventionType.Irrigation.rawValue
      default:
        return
      }
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

    apolloQuery.queryFarms { (success) in
      if success {
        self.fetchInterventions()

        for intervention in self.interventions {
          if intervention.value(forKey: "status") as? Int16 == Intervention.Status.OutOfSync.rawValue {
            intervention.setValue(Intervention.Status.Synchronised.rawValue, forKey: "status")
          }
        }

        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        self.synchroLabel.text = String(format: "Dernière synchronisation %02d:%02d", hour, minute)
        UserDefaults.standard.set(date, forKey: "lastSyncDate")
        UserDefaults.standard.synchronize()
      } else {
        self.synchroLabel.text = "sync_failure".localized
      }
      self.refreshControl.endRefreshing()
      self.tableView.reloadData()
    }
  }

  @objc func action(sender: UIButton) {
    hideInterventionAdd()
    performSegue(withIdentifier: "addIntervention", sender: sender)
  }

  @objc func hideInterventionAdd() {
    addInterventionLabel.text = "ENREGISTRER UNE INTERVENTION"
    for interventionButton in interventionButtons {
      interventionButton.isHidden = true
    }
    leftInterventionButton.isHidden = false
    rightInterventionButton.isHidden = false
    heightConstraint.constant = 80
    dimView.isHidden = true
  }

  @IBAction func addIntervention(_ sender: Any) {

    self.heightConstraint.constant = 240
    addInterventionLabel.text = "ENREGISTRER UNE INTERVENTION DE..."
    leftInterventionButton.isHidden = true
    rightInterventionButton.isHidden = true
    bottomView.layoutIfNeeded()
    var index: CGFloat = 1
    var line: CGFloat = 0
    let width = bottomView.frame.size.width

    for interventionButton in interventionButtons {

      interventionButton.isHidden = false
      interventionButton.frame = CGRect(x: index * width/5.357 + (index + 1) * width/19.737, y: 35 + line * 100, width: 70, height: 70)
      interventionButton.titleEdgeInsets = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
      interventionButton.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
      //implantationButton.imageEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: implantationButton.titleLabel!.frame.size.height, right: 0)
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
