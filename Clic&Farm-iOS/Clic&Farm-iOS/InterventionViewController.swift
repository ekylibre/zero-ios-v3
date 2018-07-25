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
    
    var interventions = [NSManagedObject]()
    
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
        
        let addView = UIView()
        addView.frame = CGRect(x: 0, y: 517, width: 375, height: 150)
        addView.backgroundColor = UIColor.blue
        self.view.addSubview(addView)
        addView.isHidden = false
        
        addView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: addView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: addView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        //let widthConstraint = NSLayoutConstraint(item: addView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        //let heightConstraint = NSLayoutConstraint(item: addView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        view.addConstraints([horizontalConstraint, verticalConstraint/*, widthConstraint, heightConstraint*/])
        
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
        let secondFrame = CGRect(x: navigationBar.frame.width - 150, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
        
        let firstLabel = UILabel(frame: firstFrame)
        firstLabel.text = "GAEC du Bois Joli"
        firstLabel.textColor = UIColor.white
        navigationBar.addSubview(firstLabel)
        let firstButton = UIButton(frame: secondFrame)
        firstButton.setTitle("test", for: .normal)
        navigationBar.addSubview(firstButton)

        // Load table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Interventions")
        
        do {
            interventions = try managedContext.fetch(fetchRequest)
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
        
        //cell.cropsLabel.text = intervention.value(forKeyPath: "crops") as? String
        cell.infosLabel.text = intervention.value(forKeyPath: "infos") as? String
        //cell.dateLabel.text = transformDate(date: intervention.value(forKeyPath: "date") as! Date)
        //cell.dateLabel.text = transformDate(date: intervention.date)
        
        // Resize labels according to their text
        cell.typeLabel.sizeToFit()
        cell.cropsLabel.sizeToFit()
        cell.infosLabel.sizeToFit()
        
        if intervention.value(forKeyPath: "status") as? Int16 == Intervention.Status.OutOfSync.rawValue {
            cell.syncImage.backgroundColor = UIColor.orange
        } else if intervention.value(forKeyPath: "status") as? Int16 == Intervention.Status.Synchronised.rawValue {
            cell.syncImage.backgroundColor = UIColor.yellow
        } else {
            cell.syncImage.backgroundColor = UIColor.green
        }
        
        return cell
    }
    
    func save(type: Int16, crops: String, infos: String, date: Date) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Interventions", in: managedContext)!
        
        let intervention = NSManagedObject(entity: entity, insertInto: managedContext)
        
        intervention.setValue(type, forKeyPath: "type")
        //intervention.setValue(crops, forKeyPath: "crops")
        intervention.setValue(infos, forKeyPath: "infos")
        //intervention.setValue(date, forKeyPath: "date")
        
        do {
            try managedContext.save()
            interventions.append(intervention)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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

    func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        return calendar.date(from: components)!
    }
    
    private func loadSampleInterventions() {
        let date1 = makeDate(year: 2018, month: 7, day: 20, hour: 9, minute: 5, second: 0)
        //let inter1 = Intervention(type: .Irrigation, crops: "2 cultures", infos: "Volume 50", date: date1, status: .OutOfSync)
        let date2 = makeDate(year: 2018, month: 7, day: 19, hour: 9, minute: 5, second: 0)
        //let inter2 = Intervention(type: .TravailSol, crops: "1 culture", infos: "Kuhn Prolander", date: date2, status: .OutOfSync)
        let date3 = makeDate(year: 2018, month: 7, day: 18, hour: 9, minute: 5, second: 0)
        //let inter3 = Intervention(type: .Pulverisation, crops: "2 cultures", infos: "PRIORI GOLD", date: date3, status: .OutOfSync)
        let date4 = makeDate(year: 2017, month: 7, day: 17, hour: 9, minute: 5, second: 0)
        //let inter4 = Intervention(type: .Entretien, crops: "4 cultures", infos: "oui", date: date4, status: .OutOfSync)
        
        save(type: 0, crops: "2 cultures", infos: "Volume 50mL", date: date1)
        save(type: 1, crops: "1 culture", infos: "Kuhn Prolander", date: date2)
        save(type: 2, crops: "2 cultures", infos: "PRIORI GOLD", date: date3)
        save(type: 3, crops: "4 cultures", infos: "oui", date: date4)
        //interventions += [inter1, inter2, inter3, inter4]
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
        
        for intervention in interventions {
            if intervention.value(forKeyPath: "status") as? Int16 == Intervention.Status.OutOfSync.rawValue {
                intervention.setValue(Intervention.Status.Synchronised.rawValue, forKey: "status")
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func addIntervention(_ sender: Any) {
        bottomView.isHidden = true
        
        /*leftInterventionButton.isEnabled = false
        leftInterventionButton.isHidden = true
        rightInterventionButton.isEnabled = false
        rightInterventionButton.isHidden = true*/
        print("oui")
    }
}
