//
//  InterventionViewController.swift
//  ClickAndFarm-IOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import os.log

class InterventionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var synchroLabel: UILabel!
    
    var interventions = [Intervention]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedInterventions = loadInterventions() {
            interventions += savedInterventions
        } else {
            loadSampleInterventions()
        }
        
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
        }
        
        // Top label : name
        //toolbar.frame = CGRect(x: 0, y: 623, width: 375, height: 100)
        let firstFrame = CGRect(x: 10, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
        let secondFrame = CGRect(x: navigationBar.frame.width - 100, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
        
        let firstLabel = UILabel(frame: firstFrame)
        firstLabel.text = "GAEC du Bois Joli"
        firstLabel.textColor = UIColor.white
        navigationBar.addSubview(firstLabel)
        let firstButton = UIButton(frame: secondFrame)
        firstButton.setTitle("test", for: .normal)
        navigationBar.addSubview(firstButton)

        /*
        let saveText = UIBarButtonItem(title: "ENREGISTRER UNE INTERVENTION", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        saveText.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17.0), NSAttributedStringKey.foregroundColor : UIColor.white], for: UIControlState.normal)
        
        toolbar.items = [saveText]*/

        // Load table view
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
            cell.backgroundColor = UIColor(red: 0.9255, green: 0.9216, blue: 0.9216, alpha: 1)
        }
        
        // Fetches the appropriate intervention for the data source layout
        let intervention = interventions[indexPath.row]
        
        
        switch intervention.type {
        case .Semis:
            cell.typeLabel.text = "Semis"
            cell.typeImageView.image = UIImage(named: "semis")!
        case .TravailSol:
            cell.typeLabel.text = "Travail du sol"
            cell.typeImageView.image = UIImage(named: "travailSol")!
        case .Irrigation:
            cell.typeLabel.text = "Irrigation"
            cell.typeImageView.image = UIImage(named: "irrigation")!
        case .Recolte:
            cell.typeLabel.text = "Récolte"
            cell.typeImageView.image = UIImage(named: "recolte")!
        case .Entretien:
            cell.typeLabel.text = "Entretien"
            cell.typeImageView.image = UIImage(named: "entretien")!
        case .Fertilisation:
            cell.typeLabel.text = "Fertilisation"
            cell.typeImageView.image = UIImage(named: "fertilisation")!
        case .Pulverisation:
            cell.typeLabel.text = "Pulvérisation"
            cell.typeImageView.image = UIImage(named: "pulverisation")!
        }
        
        cell.cropsLabel.text = intervention.crops
        cell.infosLabel.text = intervention.infos
        cell.dateLabel.text = transformDate(date: intervention.date)
        
        if intervention.status == .OutOfSync {
            cell.syncImage.backgroundColor = UIColor.red
        } else if intervention.status == .Synchronised {
            cell.syncImage.backgroundColor = UIColor.yellow
        } else {
            cell.syncImage.backgroundColor = UIColor.green
        }
        
        return cell
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
        let date1 = makeDate(year: 2018, month: 7, day: 19, hour: 9, minute: 5, second: 0)
        let inter1 = Intervention(type: .Irrigation, crops: "2 cultures", infos: "Volume 50", date: date1, status: .OutOfSync)
        let date2 = makeDate(year: 2018, month: 7, day: 18, hour: 9, minute: 5, second: 0)
        let inter2 = Intervention(type: .TravailSol, crops: "1 culture", infos: "Kuhn Prolander", date: date2, status: .OutOfSync)
        let date3 = makeDate(year: 2018, month: 7, day: 17, hour: 9, minute: 5, second: 0)
        let inter3 = Intervention(type: .Pulverisation, crops: "2 cultures", infos: "PRIORI GOLD", date: date3, status: .OutOfSync)
        let date4 = makeDate(year: 2017, month: 7, day: 16, hour: 9, minute: 5, second: 0)
        let inter4 = Intervention(type: .Entretien, crops: "4 cultures", infos: "oui", date: date4, status: .OutOfSync)
        
        interventions += [inter1, inter2, inter3, inter4]
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
            if intervention.status == .OutOfSync {
                intervention.status = .Synchronised
            }
        }
    }
    
    //MARK: Private Methods
    
    private func saveInterventions() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(interventions, toFile: Intervention.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Interventions successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save interventions...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadInterventions() -> [Intervention]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Intervention.ArchiveURL.path) as? [Intervention]
    }
}
