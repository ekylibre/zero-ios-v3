//
//  AddInterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 30/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class AddInterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  //MARK : Properties

  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var selectCropsView: UIView!
  @IBOutlet weak var cropsTableView: UITableView!
  @IBOutlet weak var interventionToolsTableView: UITableView!
  @IBOutlet weak var validateButton: UIButton!
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var firstView: UIView!
  @IBOutlet weak var collapseButton: UIButton!
  @IBOutlet weak var selectToolsView: UIView!
  @IBOutlet weak var createToolsView: UIView!
  @IBOutlet weak var darkLayerView: UIView!
  @IBOutlet weak var toolName: UITextField!
  @IBOutlet weak var toolNumber: UITextField!
  @IBOutlet weak var toolType: UILabel!
  @IBOutlet weak var selectedToolsTableView: UITableView!

  var crops = [NSManagedObject]()
  var interventionTools = [NSManagedObject]()
  var selectedTools = [NSManagedObject]()
  var interventionType: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    UIApplication.shared.statusBarView?.backgroundColor = Constants.ThemeColors.Blue

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
    selectCropsView.clipsToBounds = true
    selectCropsView.layer.cornerRadius = 3
    selectedToolsTableView.layer.borderWidth  = 0.5
    selectedToolsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedToolsTableView.backgroundColor = Constants.ThemeColors.darkWhite
    selectedToolsTableView.layer.cornerRadius = 4

    // Crops select
    validateButton.layer.cornerRadius = 3

    cropsTableView.dataSource = self
    cropsTableView.delegate = self
    interventionToolsTableView.dataSource = self
    interventionToolsTableView.delegate = self
    selectedToolsTableView.dataSource = self
    selectedToolsTableView.delegate = self
    fetchTools()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Crops")

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    if crops.count == 0 {
      loadSampleCrops()
    }
    cropsTableView.reloadData()
  }

  //MARK: Table view

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    switch tableView {
    case cropsTableView:
      return crops.count
    case interventionToolsTableView:
      return interventionTools.count
    case selectedToolsTableView:
      return selectedTools.count
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var crop: NSManagedObject?
    var tool: NSManagedObject?
    var selectedTool: NSManagedObject?

    if indexPath.row < crops.count {
      crop = crops[indexPath.row]
    }
    if indexPath.row < interventionTools.count {
      tool = interventionTools[indexPath.row]
    }
    if indexPath.row < selectedTools.count {
      selectedTool = selectedTools[indexPath.row]
    }

    switch tableView {
    case cropsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cropsTableViewCell", for: indexPath) as! CropsTableViewCell

      cell.nameLabel.text = crop?.value(forKey: "name") as? String
      cell.nameLabel.sizeToFit()
      cell.surfaceAreaLabel.text = String(format: "%.1f ha", crop?.value(forKey: "surfaceArea") as! Double)
      cell.surfaceAreaLabel.sizeToFit()
      return cell
    case interventionToolsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "InterventionToolsTableViewCell", for: indexPath) as! InterventionToolsTableViewCell

      cell.nameLabel.text = tool?.value(forKey: "name") as? String
      cell.typeLabel.text = tool?.value(forKey: "type") as? String
      cell.typeImageView.image = #imageLiteral(resourceName: "clic&farm-logo")
      return cell
    case selectedToolsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedToolsTableViewCell", for: indexPath) as! SelectedToolsTableViewCell

      cell.backgroundColor = Constants.ThemeColors.darkWhite
      cell.nameLabel.text = selectedTool?.value(forKey: "name") as? String
      cell.typeLabel.text = selectedTool?.value(forKey: "type") as? String
      cell.typeImageView.image = #imageLiteral(resourceName: "clic&farm-logo")
      return cell
    default:
      fatalError("Switch error")
    }
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */

  //MARK: Actions

  var animationRunning: Bool = false

  func animateView(isCollapse: Bool, angle: CGFloat) {
    heightConstraint.constant = isCollapse ? 50 : 300

    animationRunning = true

    UIView.animate(withDuration: 0.5, animations: {
      self.collapseButton.imageView!.transform = CGAffineTransform(rotationAngle: angle)
      self.view.layoutIfNeeded()
    }, completion: { _ in
      self.animationRunning = false
    })
  }

  func createCrop(name: String, surfaceArea: Double, uuid: UUID) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let cropsEntity = NSEntityDescription.entity(forEntityName: "Crops", in: managedContext)!

    let crop = NSManagedObject(entity: cropsEntity, insertInto: managedContext)

    crop.setValue(name, forKeyPath: "name")
    crop.setValue(surfaceArea, forKeyPath: "surfaceArea")
    crop.setValue(uuid, forKeyPath: "uuid")

    do {
      try managedContext.save()
      crops.append(crop)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func loadSampleCrops() {
    createCrop(name: "Crop 1", surfaceArea: 7.5, uuid: UUID())
    createCrop(name: "Epoisses", surfaceArea: 0.651, uuid: UUID())
    createCrop(name: "Cabécou", surfaceArea: 12.06, uuid: UUID())
  }

  //MARK: - Actions

  @IBAction func selectCrops(_ sender: Any) {
    self.dimView.isHidden = false
    self.selectCropsView.isHidden = false
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
    })
  }

  @IBAction func validateCrops(_ sender: Any) {
    self.dimView.isHidden = true
    self.selectCropsView.isHidden = true
    UIView.animate(withDuration: 1, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = UIColor(rgb: 0x175FC8)
    })
  }

  @IBAction func collapseExpand(_ sender: Any) {
    if animationRunning {
      return
    }

    let shouldCollapse = firstView.frame.height != 50

    animateView(isCollapse: shouldCollapse, angle: shouldCollapse ? CGFloat.pi : CGFloat.pi - 3.14159)
  }

  @IBAction func cancelAdding(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
