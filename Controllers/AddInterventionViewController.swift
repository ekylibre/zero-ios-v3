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

  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var selectCropsView: UIView!
  @IBOutlet weak var cropsTableView: UITableView!
  @IBOutlet weak var selectedCropsLabel: UILabel!
  @IBOutlet weak var validateButton: UIButton!
  @IBOutlet weak var interventionToolsTableView: UITableView!
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  @IBOutlet weak var firstView: UIView!
  @IBOutlet weak var collapseButton: UIButton!

  var crops = [NSManagedObject]()
  var plots = [NSManagedObject]()
  var cropPlots = [[NSManagedObject]]()

  var viewsArray = [[UIView]]()

  var interventionTools = [NSManagedObject]() {
    didSet {
      if interventionTools.count > 0 {
        interventionToolsTableView.reloadData()
      } else {
        interventionToolsTableView.isHidden = true
      }
    }
  }
  var interventionType: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue

    // Adds type label on the navigation bar
    let navigationItem = UINavigationItem(title: "")
    let typeLabel = UILabel()
    if interventionType != nil {
      typeLabel.text = interventionType
    }
    typeLabel.textColor = UIColor.white
    typeLabel.sizeToFit()

    let leftItem = UIBarButtonItem.init(customView: typeLabel)
    navigationItem.leftBarButtonItem = leftItem
    navigationBar.setItems([navigationItem], animated: false)

    selectCropsView.clipsToBounds = true
    selectCropsView.layer.cornerRadius = 3

    interventionToolsTableView.layer.borderWidth  = 0.5
    interventionToolsTableView.layer.borderColor = UIColor.lightGray.cgColor
    interventionToolsTableView.layer.cornerRadius = 4

    // Crops select
    validateButton.layer.cornerRadius = 3

    self.cropsTableView.dataSource = self
    self.cropsTableView.delegate = self

    cropsTableView.tableFooterView = UIView()
    cropsTableView.bounces = false
    cropsTableView.alwaysBounceVertical = false
  }

  func fetchPlots(cropId: Int) {

    var plots = [NSManagedObject]()

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let plotsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Plots")
    let predicate = NSPredicate(format: "cropId == \(cropId)")
    plotsFetchRequest.predicate = predicate

    do {
      plots = try managedContext.fetch(plotsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    cropPlots.append(plots)
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

    for crop in crops {
      let cropId = crop.value(forKey: "id") as! Int
      fetchPlots(cropId: cropId)
    }

    cropsTableView.reloadData()
  }

  //MARK: Table view

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    switch tableView {
    case  cropsTableView:
      return crops.count
    case interventionToolsTableView:
      return interventionTools.count
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let crop = crops[indexPath.row]

    switch tableView {
    case cropsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cropTableViewCell", for: indexPath) as! CropTableViewCell
      cell.nameLabel.text = crop.value(forKey: "name") as? String
      cell.nameLabel.sizeToFit()
      cell.surfaceAreaLabel.text = String(format: "%.1f ha",crop.value(forKey: "surfaceArea") as! Double)
      cell.surfaceAreaLabel.sizeToFit()

      var views = [UIView]()

      for (index, plot) in cropPlots[indexPath.row].enumerated() {
        let view = UIView(frame: CGRect(x: 15, y: 60 + index * 60, width: Int(cell.frame.size.width - 30), height: 60))
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        let plotImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        plotImageView.backgroundColor = UIColor.lightGray
        view.addSubview(plotImageView)
        let checkboxImage = UIImageView(frame: CGRect(x: 7, y: 7, width: 16, height: 16))
        checkboxImage.image = #imageLiteral(resourceName: "uncheckedCheckbox")
        view.addSubview(checkboxImage)
        let nameLabel = UILabel(frame: CGRect(x: 70, y: 7, width: 200, height: 20))
        nameLabel.textColor = UIColor.black
        let name = plot.value(forKey: "name") as! String
        let calendar = Calendar.current
        let date = plot.value(forKey: "startDate") as! Date
        let year = calendar.component(.year, from: date)
        nameLabel.text = name + " | \(year)"
        nameLabel.font = UIFont.systemFont(ofSize: 13.0)
        view.addSubview(nameLabel)
        let surfaceAreaLabel = UILabel(frame: CGRect(x: 70, y: 33, width: 200, height: 20))
        surfaceAreaLabel.textColor = UIColor.darkGray
        let surfaceArea = plot.value(forKey: "surfaceArea") as! Double
        surfaceAreaLabel.text = String(format: "%.1f ha travaillés", surfaceArea)
        surfaceAreaLabel.font = UIFont.systemFont(ofSize: 13.0)
        view.addSubview(surfaceAreaLabel)
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectPlot))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
        cell.addSubview(view)
        views.append(view)
      }
      viewsArray.append(views)

      return cell
    default:
      fatalError("Swith error")
    }
  }

  // Expand/collapse cell when tapped
  var selectedIndexPath: IndexPath?
  var indexPaths: [IndexPath] = []

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    selectedIndexPath = indexPath

    let cell = cropsTableView.cellForRow(at: selectedIndexPath!) as! CropTableViewCell
    if !indexPaths.contains(selectedIndexPath!) {
      indexPaths += [selectedIndexPath!]
      cell.expandCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    } else {
      let index = indexPaths.index(of: selectedIndexPath!)
      indexPaths.remove(at: index!)
      cell.expandCollapseButton.imageView!.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
    }
    cropsTableView.beginUpdates()
    cropsTableView.endUpdates()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    if indexPaths.count > 0 {
      if indexPaths.contains(indexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
          return 0
        }
        let count = cell.subviews.count - 2
        return CGFloat(count * 60 + 15)
      } else {
        return 60
      }
    }
    return 60
  }

  // Select crop

  var plotsCount = 0
  var totalSurfaceArea: Double = 0

  @IBAction func tapCheckbox(_ sender: UIButton) {

    guard let cell = sender.superview?.superview as? CropTableViewCell else {
      return
    }

    let indexPath = cropsTableView.indexPath(for: cell)!

    let cropSurfaceArea = crops[indexPath.row].value(forKey: "surfaceArea") as! Double

    if !sender.isSelected {
      sender.isSelected = true
      plotsCount += cropPlots[indexPath.row].count
      totalSurfaceArea += cropSurfaceArea
      for view in cell.subviews[2...cropPlots[indexPath.row].count + 1] {
        let checkboxImage = view.subviews[1] as! UIImageView
        checkboxImage.image = #imageLiteral(resourceName: "checkedCheckbox")
      }
    } else {
      sender.isSelected = false
      for (index, view) in cell.subviews[2...cropPlots[indexPath.row].count + 1].enumerated() {
        let checkboxImage = view.subviews[1] as! UIImageView
        if checkboxImage.image == #imageLiteral(resourceName: "checkedCheckbox") {
          checkboxImage.image = #imageLiteral(resourceName: "uncheckedCheckbox")
          plotsCount -= 1
          totalSurfaceArea -= cropPlots[indexPath.row][index].value(forKey: "surfaceArea") as! Double
        }
      }
    }

    if plotsCount == 0 {
      selectedCropsLabel.text = "Aucune sélection"
    } else if plotsCount == 1 {
      selectedCropsLabel.text = String(format: "1 culture • %.1f ha", totalSurfaceArea)
    } else {
      selectedCropsLabel.text = String(format: "%d cultures • %.1f ha", plotsCount, totalSurfaceArea)
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

  @IBAction func collapseExpand(_ sender: Any) {
    if animationRunning {
      return
    }

    let shouldCollapse = firstView.frame.height != 50

    animateView(isCollapse: shouldCollapse, angle: shouldCollapse ? CGFloat.pi : CGFloat.pi - 3.14159)
  }

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

  // Create crops data

  func createCrop(id: Int16, name: String, surfaceArea: Double, uuid: UUID) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let cropsEntity = NSEntityDescription.entity(forEntityName: "Crops", in: managedContext)!

    let crop = NSManagedObject(entity: cropsEntity, insertInto: managedContext)

    crop.setValue(id, forKey: "id")
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

  func createPlot(cropId: Int16, name: String, surfaceArea: Double, startDate: Date, uuid: UUID) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext

    let plotsEntity = NSEntityDescription.entity(forEntityName: "Plots", in: managedContext)!

    let plot = NSManagedObject(entity: plotsEntity, insertInto: managedContext)

    plot.setValue(cropId, forKey: "cropId")
    plot.setValue(name, forKeyPath: "name")
    plot.setValue(surfaceArea, forKeyPath: "surfaceArea")
    plot.setValue(startDate, forKey: "startDate")
    plot.setValue(uuid, forKeyPath: "uuid")

    do {
      try managedContext.save()
      plots.append(plot)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  private func loadSampleCrops() {

    createCrop(id: 1, name: "Crop 1", surfaceArea: 7.5, uuid: UUID())
    createPlot(cropId: 1, name: "Blé tendre", surfaceArea: 3, startDate: Date(), uuid: UUID())
    createPlot(cropId: 1, name: "Maïs", surfaceArea: 4.5, startDate: Date(), uuid: UUID())

    createCrop(id: 2, name: "Epoisses", surfaceArea: 0.651, uuid: UUID())
    createPlot(cropId: 2, name: "Artichaut", surfaceArea: 0.651, startDate: Date(), uuid: UUID())

    createCrop(id: 3, name: "Cabécou", surfaceArea: 12.06, uuid: UUID())
    createPlot(cropId: 3, name: "Avoine", surfaceArea: 6.3, startDate: Date(), uuid: UUID())
    createPlot(cropId: 3, name: "Ciboulette", surfaceArea: 0.92, startDate: Date(), uuid: UUID())
    createPlot(cropId: 3, name: "Cornichon", surfaceArea: 4.84, startDate: Date(), uuid: UUID())
  }

  //MARK: - Actions

  @IBAction func selectCrops(_ sender: Any) {
    dimView.isHidden = false
    selectCropsView.isHidden = false
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @objc func selectPlot(sender: UIGestureRecognizer) {
    let cell = sender.view?.superview as! CropTableViewCell
    let view = sender.view!

    var cropIndex: Int = 0
    var plotIndex: Int = 0

    for views in viewsArray {
      if let indexView = views.index(of: view) {
        cropIndex = viewsArray.index(of: views)!
        plotIndex = indexView
        break
      }
    }

    let checkboxImage = view.subviews[1] as! UIImageView

    if checkboxImage.image == #imageLiteral(resourceName: "uncheckedCheckbox") {
      checkboxImage.image = #imageLiteral(resourceName: "checkedCheckbox")
      plotsCount += 1
      totalSurfaceArea += cropPlots[cropIndex][plotIndex].value(forKey: "surfaceArea") as! Double
      if !cell.checkboxButton.isSelected {
        cell.checkboxButton.isSelected = true
      }
    } else if checkboxImage.image == #imageLiteral(resourceName: "checkedCheckbox") {
      checkboxImage.image = #imageLiteral(resourceName: "uncheckedCheckbox")
      plotsCount -= 1
      totalSurfaceArea -= cropPlots[cropIndex][plotIndex].value(forKey: "surfaceArea") as! Double
      for (index, view) in cell.subviews[2...cropPlots[cropIndex].count + 1].enumerated() {
        let checkboxImage = view.subviews[1] as! UIImageView
        if checkboxImage.image == #imageLiteral(resourceName: "checkedCheckbox") {
          break
        } else if checkboxImage.image == #imageLiteral(resourceName: "uncheckedCheckbox") && index == cropPlots[cropIndex].count - 1 {
          cell.checkboxButton.isSelected = false
        }
      }
    }

    if plotsCount == 0 {
      selectedCropsLabel.text = "Aucune sélection"
    } else if plotsCount == 1 {
      selectedCropsLabel.text = String(format: "1 culture • %.1f ha", totalSurfaceArea)
    } else {
      selectedCropsLabel.text = String(format: "%d cultures • %.1f ha", plotsCount, totalSurfaceArea)
    }
  }

  @IBAction func validateCrops(_ sender: Any) {

    if selectedCropsLabel.text == "Aucune sélection" {
      totalLabel.text = "+ SÉLECTIONNER"
      totalLabel.textColor = AppColor.TextColors.Green
    } else {
      totalLabel.text = selectedCropsLabel.text
      totalLabel.textColor = AppColor.TextColors.DarkGray
    }

    totalLabel.sizeToFit()
    dimView.isHidden = true
    selectCropsView.isHidden = true
    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
  }

  @IBAction func cancelAdding(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
