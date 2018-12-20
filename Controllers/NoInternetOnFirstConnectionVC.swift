//
//  NoInternetOnFirstConnectionVC.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 20/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class NoInternetOnFirstConnectionVC: UIViewController {

  @IBOutlet weak var noInternetTextView: UITextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    noInternetTextView.text = "no_internet_on_first_connection".localized
  }
}
