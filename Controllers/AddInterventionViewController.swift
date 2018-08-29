//
//  AddInterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 30/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class AddInterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

  //MARK: - Outlets

  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var selectCropsView: UIView!
  @IBOutlet weak var cropsTableView: UITableView!
  @IBOutlet weak var selectedPlotsLabel: UILabel!
  @IBOutlet weak var equipmentsTableView: UITableView!
  @IBOutlet weak var workingPeriodHeight: NSLayoutConstraint!
  @IBOutlet weak var selectedWorkingPeriodLabel: UILabel!
  @IBOutlet weak var collapseWorkingPeriodImage: UIImageView!
  @IBOutlet weak var selectDateButton: UIButton!
  @IBOutlet weak var durationTextField: UITextField!
  @IBOutlet weak var navigationBar: UINavigationBar!
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
  @IBOutlet weak var inputsSelectionView: UIView!
  @IBOutlet weak var inputsCollapseButton: UIButton!
  @IBOutlet weak var inputsHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var addInputsButton: UIButton!
  @IBOutlet weak var inputsNumber: UILabel!
  @IBOutlet weak var selectedInputsTableView: UITableView!
  @IBOutlet weak var selectedInputsTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var equipmentHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var equipmentTableViewHeightConstraint: NSLayoutConstraint!

  //MARK: - Properties

  var newIntervention: NSManagedObject!
  var interventionType: String!
  var selectedPlots = [NSManagedObject]()
  var crops = [NSManagedObject]()
  var viewsArray = [[UIView]]()
  var equipments = [NSManagedObject]()
  var selectDateView: UIView!
  var inputsView: InputsView!
  var specificInputsTableView: UITableView!
  var interventionTools = [NSManagedObject]()
  var selectedTools = [NSManagedObject]()
  var searchedTools = [NSManagedObject]()
  var plots = [NSManagedObject]()
  var cropPlots = [[NSManagedObject]]()
  var toolTypes: [String]!
  var selectedToolType: String!
  var entities = [NSManagedObject]()
  var searchedEntities = [NSManagedObject]()
  var doers = [NSManagedObject]()
  var toolImage: [UIImage] = [#imageLiteral(resourceName: "airplanter"), #imageLiteral(resourceName: "baler_wrapper"), #imageLiteral(resourceName: "corn-topper"), #imageLiteral(resourceName: "cubic_baler"), #imageLiteral(resourceName: "disc_harrow"), #imageLiteral(resourceName: "forage_platform"), #imageLiteral(resourceName: "forager"), #imageLiteral(resourceName: "grinder"), #imageLiteral(resourceName: "harrow"), #imageLiteral(resourceName: "harvester"), #imageLiteral(resourceName: "hay_rake"), #imageLiteral(resourceName: "hiller"), #imageLiteral(resourceName: "hoe"), #imageLiteral(resourceName: "hoe_weeder"), #imageLiteral(resourceName: "implanter"), #imageLiteral(resourceName: "irrigation_pivot"), #imageLiteral(resourceName: "mower"), #imageLiteral(resourceName: "mower_conditioner"), #imageLiteral(resourceName: "plow"), #imageLiteral(resourceName: "reaper"), #imageLiteral(resourceName: "roll"), #imageLiteral(resourceName: "rotary_hoe"), #imageLiteral(resourceName: "round_baler"), #imageLiteral(resourceName: "seedbed_preparator"), #imageLiteral(resourceName: "soil_loosener"), #imageLiteral(resourceName: "sower"), #imageLiteral(resourceName: "sprayer"), #imageLiteral(resourceName: "spreader"), #imageLiteral(resourceName: "liquid_manure_spreader"), #imageLiteral(resourceName: "subsoil_plow"), #imageLiteral(resourceName: "superficial_plow"), #imageLiteral(resourceName: "tedder"), #imageLiteral(resourceName: "topper"), #imageLiteral(resourceName: "tractor"), #imageLiteral(resourceName: "trailer"), #imageLiteral(resourceName: "trimmer"), #imageLiteral(resourceName: "vibrocultivator"), #imageLiteral(resourceName: "weeder"), #imageLiteral(resourceName: "wrapper")]
  var sampleSeeds = [["Variété 1", "Espèce 1"], ["Variété 2", "Espèce 2"]]
  var samplePhytos = [["Nom 1", "Marque 1", "1000", "1h"], ["Nom 2", "Marque 2", "2000", "2h"], ["Nom 3", "Marque 3", "3000", "3h"]]
  var sampleFertilizers = [["Nom 1", "Nature 1"], ["Nom 2", "Nature 2"], ["Nom 3", "Nature 3"], ["Nom 4", "Nature 4"]]
  var selectedInputs = [[String]]()
  var selectedInputsManagedObject = [NSManagedObject]()
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
    selectCropsView.clipsToBounds = true
    selectCropsView.layer.cornerRadius = 3
    selectedToolsTableView.layer.borderWidth  = 0.5
    selectedToolsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedToolsTableView.backgroundColor = AppColor.ThemeColors.DarkWhite
    selectedToolsTableView.layer.cornerRadius = 4
    saveInterventionButton.layer.cornerRadius = 3
    cropsTableView.dataSource = self
    cropsTableView.delegate = self
    cropsTableView.tableFooterView = UIView()
    cropsTableView.bounces = false
    equipmentsTableView.dataSource = self
    equipmentsTableView.delegate = self
    equipmentsTableView.bounces = false
    selectedToolsTableView.dataSource = self
    selectedToolsTableView.delegate = self
    selectedToolsTableView.bounces = false
    searchTool.delegate = self
    searchTool.autocapitalizationType = .none
    searchEntity.delegate = self
    searchEntity.autocapitalizationType = .none
    toolTypeTableView.dataSource = self
    toolTypeTableView.delegate = self
    toolTypeTableView.bounces = false
    entitiesTableView.dataSource = self
    entitiesTableView.delegate = self
    entitiesTableView.bounces = false
    doersTableView.dataSource = self
    doersTableView.delegate = self
    doersTableView.bounces = false
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
    specificInputsTableView = inputsView.tableView
    inputsView.seedView.createButton.addTarget(self, action: #selector(createInput), for: .touchUpInside)
    inputsView.phytoView.createButton.addTarget(self, action: #selector(createInput), for: .touchUpInside)
    inputsView.fertilizerView.createButton.addTarget(self, action: #selector(createInput), for: .touchUpInside)

    selectedInputsTableView.register(SelectedInputsTableViewCell.self, forCellReuseIdentifier: "SelectedInputsTableViewCell")
    selectedInputsTableView.backgroundColor = AppColor.ThemeColors.DarkWhite
    selectedInputsTableView.layer.cornerRadius = 5
    selectedInputsTableView.layer.borderWidth  = 0.5
    selectedInputsTableView.layer.borderColor = UIColor.lightGray.cgColor
    selectedInputsTableView.delegate = self
    selectedInputsTableView.dataSource = self
    selectedInputsTableView.bounces = false

    initUnitMeasurePickerView()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    // Changes inputsView frame and position
    let guide = self.view.safeAreaLayoutGuide
    let height = guide.layoutFrame.size.height
    inputsView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 30, height: height - 30)
    inputsView.center.x = self.view.center.x
    inputsView.frame.origin.y = navigationBar.frame.origin.y + 15
    specificInputsTableView.delegate = self
    specificInputsTableView.dataSource = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    fetchCrops()

    if crops.count == 0 {
      loadSampleCrops()
    }

    cropsTableView.reloadData()
  }

  //MARK: - Table view data source

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    switch tableView {
    case cropsTableView:
      return crops.count
    case specificInputsTableView:
      return getNumberOfInputs()
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
    case selectedInputsTableView:
      return selectedInputsManagedObject.count
    default:
      return 1
    }
  }

  func getNumberOfInputs() -> Int {

    switch inputsView.segmentedControl.selectedSegmentIndex {
    case 0:
      return sampleSeeds.count
    case 1:
      return samplePhytos.count
    case 2:
      return sampleFertilizers.count
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var crop: NSManagedObject?
    var tool: NSManagedObject?
    var selectedTool: NSManagedObject?
    var toolType: String?
    var entity: NSManagedObject?
    var doer: NSManagedObject?
    var input: NSManagedObject?

    switch tableView {
    case cropsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cropTableViewCell", for: indexPath) as! CropTableViewCell

      crop = crops[indexPath.row]
      cell.nameLabel.text = crop?.value(forKey: "name") as? String
      cell.nameLabel.sizeToFit()
      cell.surfaceAreaLabel.text = String(format: "%.1f ha", crop?.value(forKey: "surfaceArea") as! Double)
      cell.surfaceAreaLabel.sizeToFit()

      let plots = fetchPlots(fromCrop: crop!)

      var views = [UIView]()

      for (index, plot) in plots.enumerated() {
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
        let name = plot.value(forKeyPath: "name") as! String
        let calendar = Calendar.current
        let date = plot.value(forKeyPath: "startDate") as! Date
        let year = calendar.component(.year, from: date)
        nameLabel.text = name + " | \(year)"
        nameLabel.font = UIFont.systemFont(ofSize: 13.0)
        view.addSubview(nameLabel)
        let surfaceAreaLabel = UILabel(frame: CGRect(x: 70, y: 33, width: 200, height: 20))
        surfaceAreaLabel.textColor = UIColor.darkGray
        let surfaceArea = plot.value(forKeyPath: "surfaceArea") as! Double
        surfaceAreaLabel.text = String(format: "%.1f ha travaillés", surfaceArea)
        surfaceAreaLabel.font = UIFont.systemFont(ofSize: 13.0)
        view.addSubview(surfaceAreaLabel)
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPlotView))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
        cell.addSubview(view)
        views.append(view)
      }
      viewsArray.append(views)
      return cell
    case specificInputsTableView:

      if inputsView.segmentedControl.selectedSegmentIndex == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeedsCell", for: indexPath) as! SeedsTableViewCell

        cell.varietyLabel.text = sampleSeeds[indexPath.row][0]
        cell.specieLabel.text = sampleSeeds[indexPath.row][1]
        return cell
      } else if inputsView.segmentedControl.selectedSegmentIndex == 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhytosCell", for: indexPath) as! PhytosTableViewCell

        cell.nameLabel.text = samplePhytos[indexPath.row][0]
        cell.firmNameLabel.text = samplePhytos[indexPath.row][1]
        cell.maaIDLabel.text = samplePhytos[indexPath.row][2]
        cell.inFieldReentryDelayLabel.text = samplePhytos[indexPath.row][3]
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FertilizersCell", for: indexPath) as! FertilizersTableViewCell

        cell.nameLabel.text = sampleFertilizers[indexPath.row][0]
        cell.natureLabel.text = sampleFertilizers[indexPath.row][1]
        return cell
      }
    case selectedInputsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedInputsTableViewCell", for: indexPath) as! SelectedInputsTableViewCell

      if selectedInputsManagedObject.count > indexPath.row {
        input = selectedInputsManagedObject[indexPath.row]

        cell.cellDelegate = self
        cell.addInterventionViewController = self
        cell.indexPath = indexPath
        //cell.type = input?.value(forKey: "type") as! String
        cell.inputName.text = input?.value(forKey: "specie") as? String
        cell.inputSpec.text = input?.value(forKey: "variety") as? String
        cell.backgroundColor = AppColor.ThemeColors.DarkWhite
        //cell.inputQuantity.text = (cell.inputQuantity.text == "" ? input?.value(forKey: "quantity") as? String : "")
        if cell.unitMeasureButton.titleLabel!.text == nil {
          //cell.unitMeasureButton.setTitle(input?.value(forKey: "unit") as? String, for: .normal)
        }
        switch cell.type {
        case "Seed":
          cell.inputImage.image = #imageLiteral(resourceName: "seed")
        case "Phyto":
          cell.inputImage.image = #imageLiteral(resourceName: "phytosanitary")
        case "Fertilizer":
          cell.inputImage.image = #imageLiteral(resourceName: "fertilizer")
        default:
          cell.inputImage.image = #imageLiteral(resourceName: "seed")
        }
      }
      return cell
    case equipmentsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentCell", for: indexPath) as! EquipmentCell

      tool = searchedTools[indexPath.row]
      cell.nameLabel.text = tool?.value(forKey: "name") as? String
      cell.typeLabel.text = tool?.value(forKey: "type") as? String
      cell.typeImageView.image = toolImage[defineToolImage(toolName: cell.typeLabel.text!)]
      return cell
    case selectedToolsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedToolsTableViewCell", for: indexPath) as! SelectedToolsTableViewCell

      selectedTool = selectedTools[indexPath.row]
      cell.cellDelegate = self
      cell.indexPath = indexPath
      cell.backgroundColor = AppColor.ThemeColors.DarkWhite
      cell.nameLabel.text = selectedTool?.value(forKey: "name") as? String
      cell.typeLabel.text = selectedTool?.value(forKey: "type") as? String
      cell.typeImageView.image = toolImage[defineToolImage(toolName: cell.typeLabel.text!)]
      return cell
    case toolTypeTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "EquipmentTypesCell", for: indexPath) as! EquipmentTypesCell

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
      cell.indexPath = indexPath
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
    case cropsTableView:
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
    case equipmentsTableView:
      let cell = equipmentsTableView.cellForRow(at: selectedIndexPath!) as! EquipmentCell

      if !cell.isAlreadySelected {
        selectedTools.append(equipments[indexPath.row])
        selectedTools[selectedTools.count - 1].setValue(indexPath.row, forKey: "row")
        selectedToolsTableView.reloadData()
        cell.isAlreadySelected = true
        cell.backgroundColor = AppColor.CellColors.lightGray
      }
      closeSelectToolsView()
    case toolTypeTableView:
      selectedToolType = toolTypes[indexPath.row]
      toolTypeTableView.reloadData()
      toolTypeButton.setTitle(selectedToolType, for: .normal)
      toolTypeTableView.isHidden = true
    case entitiesTableView:
      let cell = entitiesTableView.cellForRow(at: selectedIndexPath!) as! EntitiesTableViewCell

      if !cell.isAlreadySelected {
        doers.append(entities[indexPath.row])
        doers[doers.count - 1].setValue(indexPath.row, forKey: "row")
        doersTableView.reloadData()
        cell.isAlreadySelected = true
        cell.backgroundColor = AppColor.CellColors.lightGray
      }
      closeSelectEntitiesView()
    case specificInputsTableView:
      switch inputsView.segmentedControl.selectedSegmentIndex {
      case 0:
        let cell = specificInputsTableView.cellForRow(at: selectedIndexPath!) as! SeedsTableViewCell

        if !cell.isAlreadySelected {
          selectedInputs.append(sampleSeeds[indexPath.row])
          cell.isAlreadySelected = true
          cell.backgroundColor = AppColor.CellColors.lightGray
        }
      case 1:
        let cell = specificInputsTableView.cellForRow(at: selectedIndexPath!) as! PhytosTableViewCell

        if !cell.isAlreadySelected {
          selectedInputs.append(samplePhytos[indexPath.row])
          cell.isAlreadySelected = true
          cell.backgroundColor = AppColor.CellColors.lightGray
        }
      case 2:
        let cell = specificInputsTableView.cellForRow(at: selectedIndexPath!) as! FertilizersTableViewCell

        if !cell.isAlreadySelected {
          selectedInputs.append(sampleFertilizers[indexPath.row])
          cell.isAlreadySelected = true
          cell.backgroundColor = AppColor.CellColors.lightGray
        }
      default:
        print("Error")
      }
      storeSampleSeed(indexPath: selectedIndexPath!)
      selectedInputsTableView.reloadData()
      closeSelectInputsView()
    default:
      print("Nothing to do")
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch tableView {
    case cropsTableView:
      if indexPaths.contains(indexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
          return 0
        }
        let count = cell.subviews.count - 2
        return CGFloat(count * 60 + 15)
      } else {
        return 60
      }
    case doersTableView:
      return 75
    case specificInputsTableView:
      if inputsView.segmentedControl.selectedSegmentIndex == 1 {
        return 100
      } else {
        return 60
      }
    case selectedInputsTableView:
      return 100
    default:
      return 60
    }
  }

  //MARK: - Core Data

  private func loadSampleCrops() {

    createCrop(name: "Crop 1", surfaceArea: 7.5, uuid: UUID())
    createPlot(cropName: "Crop 1", name: "Blé tendre", surfaceArea: 3, startDate: Date(), uuid: UUID())
    createPlot(cropName: "Crop 1", name: "Maïs", surfaceArea: 4.5, startDate: Date(), uuid: UUID())

    createCrop(name: "Epoisses", surfaceArea: 0.651, uuid: UUID())
    createPlot(cropName: "Epoisses", name: "Artichaut", surfaceArea: 0.651, startDate: Date(), uuid: UUID())

    createCrop(name: "Cabécou", surfaceArea: 12.06, uuid: UUID())
    createPlot(cropName: "Cabécou", name: "Avoine", surfaceArea: 6.3, startDate: Date(), uuid: UUID())
    createPlot(cropName: "Cabécou", name: "Ciboulette", surfaceArea: 0.92, startDate: Date(), uuid: UUID())
    createPlot(cropName: "Cabécou", name: "Cornichon", surfaceArea: 4.84, startDate: Date(), uuid: UUID())
  }

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

    for selectedPlot in selectedPlots {
      let target = NSManagedObject(entity: targetsEntity, insertInto: managedContext)
      let surfaceArea = selectedPlot.value(forKeyPath: "surfaceArea") as! Double

      target.setValue(intervention, forKey: "interventions")
      target.setValue(surfaceArea, forKey: "surfaceArea")
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
      let name = selectedTool.value(forKeyPath: "name") as! String
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

  func createPlot(cropName: String, name: String, surfaceArea: Double, startDate: Date, uuid: UUID) {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let plotsEntity = NSEntityDescription.entity(forEntityName: "Plots", in: managedContext)!
    let plot = NSManagedObject(entity: plotsEntity, insertInto: managedContext)

    let crop = fetchCrop(withName: cropName)

    plot.setValue(crop, forKeyPath: "crops")
    plot.setValue(name, forKeyPath: "name")
    plot.setValue(surfaceArea, forKeyPath: "surfaceArea")
    plot.setValue(startDate, forKey: "startDate")
    plot.setValue(uuid, forKeyPath: "uuid")

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func fetchCrops() {

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
  }

  func fetchCrop(withName cropName: String) -> NSManagedObject {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return NSManagedObject()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let cropsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Crops")
    let predicate = NSPredicate(format: "name == %@", cropName)
    cropsFetchRequest.predicate = predicate

    var crops: [NSManagedObject]!

    do {
      crops = try managedContext.fetch(cropsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    if crops.count == 1 {
      return crops.first!
    } else {
      return NSManagedObject()
    }
  }

  func fetchPlots(fromCrop crop: NSManagedObject) -> [NSManagedObject] {

    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return [NSManagedObject]()
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let plotsFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Plots")
    let predicate = NSPredicate(format: "crops == %@", crop)
    plotsFetchRequest.predicate = predicate

    var plots: [NSManagedObject]!

    do {
      plots = try managedContext.fetch(plotsFetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }

    return plots
  }

  //MARK: - Plots selecting

  var plotsCount = 0
  var totalSurfaceArea: Double = 0

  @IBAction func tapCheckbox(_ sender: UIButton) {

    guard let cell = sender.superview?.superview as? CropTableViewCell else {
      return
    }

    let indexPath = cropsTableView.indexPath(for: cell)!
    let crop = crops[indexPath.row]
    let cropSurfaceArea = crop.value(forKeyPath: "surfaceArea") as! Double
    let plots = fetchPlots(fromCrop: crop)

    if !sender.isSelected {
      sender.isSelected = true
      plotsCount += plots.count
      totalSurfaceArea += cropSurfaceArea
      for view in cell.subviews[2...plots.count + 1] {
        let checkboxImage = view.subviews[1] as! UIImageView
        checkboxImage.image = #imageLiteral(resourceName: "checkedCheckbox")
      }
      for plot in plots {
        selectedPlots.append(plot)
      }
    } else {
      sender.isSelected = false
      for (index, view) in cell.subviews[2...plots.count + 1].enumerated() {
        let checkboxImage = view.subviews[1] as! UIImageView
        if checkboxImage.image == #imageLiteral(resourceName: "checkedCheckbox") {
          checkboxImage.image = #imageLiteral(resourceName: "uncheckedCheckbox")
          plotsCount -= 1
          totalSurfaceArea -= plots[index].value(forKeyPath: "surfaceArea") as! Double
          if let index = selectedPlots.index(of: plots[index]) {
            selectedPlots.remove(at: index)
          }
        }
      }
    }

    if plotsCount == 0 {
      selectedPlotsLabel.text = "Aucune sélection"
    } else if plotsCount == 1 {
      selectedPlotsLabel.text = String(format: "1 culture • %.1f ha", totalSurfaceArea)
    } else {
      selectedPlotsLabel.text = String(format: "%d cultures • %.1f ha", plotsCount, totalSurfaceArea)
    }
  }

  @objc func tapPlotView(sender: UIGestureRecognizer) {
    let cell = sender.view?.superview as! CropTableViewCell
    let view = sender.view!

    var crop: NSManagedObject!
    var plots: [NSManagedObject]!
    var plot: NSManagedObject!

    for views in viewsArray {
      if let indexView = views.index(of: view) {
        crop = crops[viewsArray.index(of: views)!]
        plots = fetchPlots(fromCrop: crop)
        plot = plots[indexView]
        break
      }
    }

    let checkboxImage = view.subviews[1] as! UIImageView

    if checkboxImage.image == #imageLiteral(resourceName: "uncheckedCheckbox") {
      checkboxImage.image = #imageLiteral(resourceName: "checkedCheckbox")
      plotsCount += 1
      totalSurfaceArea += plot.value(forKeyPath: "surfaceArea") as! Double
      if !cell.checkboxButton.isSelected {
        cell.checkboxButton.isSelected = true
      }
      selectedPlots.append(plot)
    } else if checkboxImage.image == #imageLiteral(resourceName: "checkedCheckbox") {
      checkboxImage.image = #imageLiteral(resourceName: "uncheckedCheckbox")
      plotsCount -= 1
      totalSurfaceArea -= plot.value(forKeyPath: "surfaceArea") as! Double
      for (index, view) in cell.subviews[2...plots.count + 1].enumerated() {
        let checkboxImage = view.subviews[1] as! UIImageView
        if checkboxImage.image == #imageLiteral(resourceName: "checkedCheckbox") {
          break
        } else if checkboxImage.image == #imageLiteral(resourceName: "uncheckedCheckbox") && index == plots.count - 1 {
          cell.checkboxButton.isSelected = false
        }

        if let index = selectedPlots.index(of: plot) {
          selectedPlots.remove(at: index)
        }
      }
    }

    if plotsCount == 0 {
      selectedPlotsLabel.text = "Aucune sélection"
    } else if plotsCount == 1 {
      selectedPlotsLabel.text = String(format: "1 culture • %.1f ha", totalSurfaceArea)
    } else {
      selectedPlotsLabel.text = String(format: "%d cultures • %.1f ha", plotsCount, totalSurfaceArea)
    }
  }

  //MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    guard let button = sender as? UIButton, button === saveInterventionButton else {
      return
    }

    createIntervention()
  }

  //MARK: - Actions

  @IBAction func selectPlots(_ sender: Any) {

    dimView.isHidden = false
    selectCropsView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
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

  @IBAction func validatePlots(_ sender: Any) {

    if selectedPlotsLabel.text == "Aucune sélection" {
      totalLabel.text = "+ SÉLECTIONNER"
      totalLabel.textColor = AppColor.TextColors.Green
    } else {
      totalLabel.text = selectedPlotsLabel.text
      totalLabel.textColor = AppColor.TextColors.DarkGray
    }
    totalLabel.sizeToFit()

    dimView.isHidden = true
    selectCropsView.isHidden = true

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Blue
    })
  }
  
  @IBAction func selectDate(_ sender: Any) {
    dimView.isHidden = false
    selectDateView.isHidden = false
  }

  @objc func validateDate() {
    let datePicker = selectDateView.subviews.first as! UIDatePicker
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "fr_FR")
    dateFormatter.dateFormat = "d MMMM"
    let selectedDate = dateFormatter.string(from: datePicker.date)
    selectDateButton.setTitle(selectedDate, for: .normal)

    dimView.isHidden = true
    selectDateView.isHidden = true
  }

  @IBAction func selectInput(_ sender: Any) {
    dimView.isHidden = false
    inputsView.isHidden = false

    UIView.animate(withDuration: 0.5, animations: {
      UIApplication.shared.statusBarView?.backgroundColor = AppColor.StatusBarColors.Black
    })
  }

  @objc func createInput() {
    switch inputsView.segmentedControl.selectedSegmentIndex {
    case 0:
      sampleSeeds.append([inputsView.seedView.varietyTextField.text!, inputsView.seedView.specieButton.titleLabel!.text!])
      inputsView.seedView.specieButton.setTitle("Avoine", for: .normal)
      inputsView.seedView.varietyTextField.text = ""
      inputsView.tableView.reloadData()
    case 1:
      samplePhytos.append([inputsView.phytoView.nameTextField.text!, inputsView.phytoView.firmNameTextField.text!, inputsView.phytoView.maaTextField.text!, inputsView.phytoView.reentryDelayTextField.text!])
      for subview in inputsView.phytoView.subviews {
        if subview is UITextField {
          let textField = subview as! UITextField
          textField.text = ""
        }
      }
      inputsView.tableView.reloadData()
    case 2:
      sampleFertilizers.append([inputsView.fertilizerView.nameTextField.text!, inputsView.fertilizerView.natureButton.titleLabel!.text!])
      inputsView.fertilizerView.nameTextField.text = ""
      inputsView.fertilizerView.natureButton.setTitle("Organique", for: .normal)
      inputsView.tableView.reloadData()
    default:
      return
    }
  }

  @IBAction func cancelAdding(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
