//
//  TermsOfUseViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 04/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import WebKit

class TermsOfUseViewController: UIViewController, WKUIDelegate {

  @IBOutlet weak var webView: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()

    let myURL = URL(string: "https://ekylibre.com/terms-of-use")
    let myRequest = URLRequest(url: myURL!)
    webView.load(myRequest)
    title = "terms_of_use".localized
    navigationController?.navigationBar.isHidden = false
  }

  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
  }
}
