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
    
    var interventionType: String?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func cancelAdding(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
