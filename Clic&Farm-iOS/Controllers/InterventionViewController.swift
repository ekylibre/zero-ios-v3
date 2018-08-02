//
//  InterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import os.log
import CoreData

class InterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  //MARK: Properties

  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var synchroLabel: UILabel!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var leftInterventionButton: UIButton!
  @IBOutlet weak var rightInterventionButton: UIButton!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomBottom: NSLayoutConstraint!
  @IBOutlet weak var addInterventionLabel: UILabel!

  var interventions = [NSManagedObject]() {
    didSet {
      tableView.reloadData()
    }
  }
  var workingPeriods = [NSManagedObject]()

  var interventionButtons: [UIButton] = []

  let dimView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Change status bar appearance
    UIApplication.shared.statusBarStyle = .lightContent
    UIApplication.shared.statusBarView?.backgroundColor = UIColor(rgb: 0x175FC8)

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
    let leadingConstraint = NSLayoutConstraint(item: dimView, attribute: NSLayoutAttribute.leading, relatedBy: .equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
    let trailingConstraint = NSLayoutConstraint(item: dimView, attribute: NSLayoutAttribute.trailing, relatedBy: .equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
    let topConstraint = NSLayoutConstraint(item: dimView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: navigationBar, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    let bottomConstraint = NSLayoutConstraint(item: dimView, attribute: NSLayoutAttribute.bottom, relatedBy: .equal, toItem: bottomView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
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
      dateFormatter.dateFormat = "MMMM"

      let hour = calendar.component(.hour, from: date)
      let minute = calendar.component(.minute, from: date)
      let day = calendar.component(.day, from: date)
      let month = dateFormatter.string(from: date)

      if calendar.isDateInToday(date) {
        synchroLabel.text = String(format: "Dernière synchronisation %02d:%02d", hour, minute)
      } else {
        synchroLabel.text = "Dernière synchronisation \(day) " + month
      }
    } else {
      synchroLabel.text = "Aucune synchronisation répertoriée"
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
  }

  func initialiseInterventionButtons() {

    let interventionNames: [String] = ["Semis", "Travail du sol", "Irrigation", "Récolte", "Entretien", "Fertilisation", "Pulvérisation"]
    let interventionImages: [UIImage] =  [#imageLiteral(resourceName: "implantation"), #imageLiteral(resourceName: "groundWork"), #imageLiteral(resourceName: "irrigation"), #imageLiteral(resourceName: "harvest"), #imageLiteral(resourceName: "care"), #imageLiteral(resourceName: "fertilization"), #imageLiteral(resourceName: "cropProtection")]

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

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let interventionsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Interventions")
    let workingPeriodsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WorkingPeriods")

    do {
      interventions = try managedContext.fetch(interventionsFetchRequest)
      workingPeriods = try managedContext.fetch(workingPeriodsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    if interventions.count == 0 {
      loadSampleInterventions()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return interventions.count
  }

  func transformDate(date: Date) -> String {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "fr_FR")
    dateFormatter.dateFormat = "dd MMMM"

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

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    // Table view cells are reused and should be dequeued using a cell identifier.
    let cellIdentifier = "InterventionTableViewCell"

    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InterventionTableViewCell else {
      fatalError("The dequeued cell is not an instance of InterventionTableViewCell")
    }

    if indexPath.row % 2 == 0 {
      cell.backgroundColor = UIColor.white
    } else {
      cell.backgroundColor = UIColor(rgb: 0xECEBEB)
    }

    // Fetches the appropriate intervention for the data source layout
    let intervention = interventions[indexPath.row]
    let workingPeriod = workingPeriods[indexPath.row]

    switch intervention.value(forKeyPath: "type") as! Int16 {
    case Intervention.InterventionType.Care.rawValue:
      cell.typeLabel.text = "Entretien"
      cell.typeImageView.image = UIImage(named: "care")!
    case Intervention.InterventionType.CropProtection.rawValue:
      cell.typeLabel.text = "Pulvérisation"
      cell.typeImageView.image = UIImage(named: "cropProtection")!
    case Intervention.InterventionType.Fertilization.rawValue:
      cell.typeLabel.text = "Fertilisation"
      cell.typeImageView.image = UIImage(named: "fertilization")!
    case Intervention.InterventionType.GroundWork.rawValue:
      cell.typeLabel.text = "Travail du sol"
      cell.typeImageView.image = UIImage(named: "groundWork")!
    case Intervention.InterventionType.Harvest.rawValue:
      cell.typeLabel.text = "Récolte"
      cell.typeImageView.image = UIImage(named: "harvest")!
    case Intervention.InterventionType.Implantation.rawValue:
      cell.typeLabel.text = "Semis"
      cell.typeImageView.image = UIImage(named: "implantation")!
    case Intervention.InterventionType.Irrigation.rawValue:
      cell.typeLabel.text = "Irrigation"
      cell.typeImageView.image = UIImage(named: "irrigation")!
    default:
      cell.typeLabel.text = "Erreur"
    }

    switch intervention.value(forKeyPath: "status") as! Int16 {
    case Intervention.Status.OutOfSync.rawValue:
      cell.syncImage.backgroundColor = UIColor.orange
    case Intervention.Status.Synchronised.rawValue:
      cell.syncImage.backgroundColor = UIColor.yellow
    case Intervention.Status.Validated.rawValue:
      cell.syncImage.backgroundColor = UIColor.green
    default:
      cell.syncImage.backgroundColor = UIColor.purple
    }

    //cell.cropsLabel.text = intervention.value(forKeyPath: "crops") as? String
    cell.infosLabel.text = intervention.value(forKeyPath: "infos") as? String
    cell.dateLabel.text = transformDate(date: workingPeriod.value(forKeyPath: "executionDate") as! Date)

    // Resize labels according to their text
    cell.typeLabel.sizeToFit()
    cell.cropsLabel.sizeToFit()
    cell.infosLabel.sizeToFit()

    return cell
  }

  func createIntervention(type: Int16, infos: String, status: Int16, executionDate: Date) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let interventionsEntity = NSEntityDescription.entity(forEntityName: "Interventions", in: managedContext)!
    let workingPeriodsEntity = NSEntityDescription.entity(forEntityName: "WorkingPeriods", in: managedContext)!

    let intervention = NSManagedObject(entity: interventionsEntity, insertInto: managedContext)
    let workingPeriod = NSManagedObject(entity: workingPeriodsEntity, insertInto: managedContext)

    intervention.setValue(type, forKeyPath: "type")
    intervention.setValue(infos, forKeyPath: "infos")
    intervention.setValue(status, forKeyPath: "status")
    workingPeriod.setValue(executionDate, forKeyPath: "executionDate")

    do {
      try managedContext.save()
      interventions.append(intervention)
      workingPeriods.append(workingPeriod)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }


  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destViewController = segue.destination as! AddInterventionViewController

    if let type = (sender as? UIButton)?.titleLabel?.text {
      destViewController.interventionType = type
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
    let date4 = makeDate(year: 2017, month: 7, day: 22, hour: 9, minute: 5, second: 0)
    //let inter4 = Intervention(type: .Entretien, crops: "4 cultures", infos: "oui", date: date4, status: .OutOfSync)

    createIntervention(type: 0, infos: "Volume 50mL", status: 0, executionDate: date1)
    createIntervention(type: 1, infos: "Kuhn Prolander", status: 0, executionDate: date2)
    createIntervention(type: 2, infos: "PRIORI GOLD", status: 1, executionDate: date3)
    createIntervention(type: 3, infos: "oui", status: 2, executionDate: date4)
  }

  //MARK: Actions

  @IBAction func synchronise(_ sender: Any) {

    let date = Date()
    let calendar = Calendar.current

    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)

    synchroLabel.text = String(format: "Dernière synchronisation %02d:%02d", hour, minute)
    UserDefaults.standard.set(date, forKey: "lastSyncDate")
    UserDefaults.standard.synchronize()

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    for intervention in interventions {
      if intervention.value(forKeyPath: "status") as? Int16 == Intervention.Status.OutOfSync.rawValue {
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

    var type: Int16 = 0

    switch sender.titleLabel?.text {
    case "Entretien":
      type = 0
    case "Pulvérisation":
      type = 1
    case "Fertilisation":
      type = 2
    case "Travail du sol":
      type = 3
    case "Récolte":
      type = 4
    case "Semis":
      type = 5
    case "Irrigation":
      type = 6
    default:
      type = -1
    }
    createIntervention(type: type, infos: UUID().uuidString, status: 0, executionDate: Date())
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
