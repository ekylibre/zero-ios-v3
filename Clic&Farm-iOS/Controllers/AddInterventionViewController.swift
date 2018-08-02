//
//  AddInterventionViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 30/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import CoreData

class AddInterventionViewController: UIViewController {
    
    //MARK : Properties
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var selectCropsView: UIView!
    @IBOutlet weak var interventionToolsTableView: UITableView!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var collapseButton: UIButton!
    
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
        
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(rgb: 0x175FC8)
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interventionTools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch tableView {
        case interventionToolsTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "InterventionToolsTableViewCell", for: indexPath)
        default:
            return cell
        }
        
        //cell.layoutMargins = UIEdgeInsets.zero
        
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
