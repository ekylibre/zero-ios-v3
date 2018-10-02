//
//  SpinnerView.swift
//  Clic&Farm-iOS
//
//  Created by Jonathan DE HAAY on 02/10/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit

class SpinerViewController: UIViewController {
  var spinner = UIActivityIndicatorView(style: .whiteLarge)

  override func loadView() {
    view = UIView()
    view.backgroundColor = UIColor(white: 0, alpha: 0.7)

    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.startAnimating()
    view.addSubview(spinner)

    spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}
