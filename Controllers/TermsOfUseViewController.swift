//
//  TermsOfUseViewController.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 04/12/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import WebKit

class TermsOfUseViewController: UIViewController, WKNavigationDelegate {

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var webView: WKWebView!

  // MARK: - Initialization

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "terms_of_use".localized
    navigationController?.navigationBar.isHidden = false
    activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
    startLoadingView()
    activityIndicator.startAnimating()
  }

  private func startLoadingView() {
    let url = URL(string: "https://ekylibre.com/terms-of-use")
    let request = URLRequest(url: url!)

    webView.navigationDelegate = self
    webView.load(request)
  }

  override func viewWillDisappear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
  }

  // MARK: - Navigation delegate

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    activityIndicator.stopAnimating()
    webView.isHidden = false
  }

  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    activityIndicator.stopAnimating()
    presentFailAlert()
  }

  private func presentFailAlert() {
    let alert = UIAlertController(title: "unable_load_terms".localized, message: "try_again_later".localized,
                                  preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "ok".localized.uppercased(), style: .cancel, handler: nil))
    present(alert, animated: true)
  }
}
