//
//  InterventionsByCropViewController+GPS.swift
//  Clic&Farm-iOS
//
//  Created by Guillaume Roux on 05/11/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import MapKit
import CoreLocation

extension InterventionsByCropViewController: CLLocationManagerDelegate {

  // MARK: - Initialization

  func setupLocationManager() {
    locationManager.requestAlwaysAuthorization()

    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
  }

  // MARK: - Location Manager delegate

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

    print("locations = \(locValue.latitude) \(locValue.longitude)")
    cropsTableView.reloadData()
  }

  // MARK: - Actions

  @objc func updateLocationParameter(sender: UISwitch) {
    if !sender.isOn {
      locationManager.stopUpdatingLocation()
      return
    }

    if !CLLocationManager.locationServicesEnabled() {
      return
    } else if CLLocationManager.authorizationStatus().rawValue < 3 {
      requestAuthorization()
    }
    locationManager.startUpdatingLocation()
  }

  private func requestAuthorization() {
    let alert = UIAlertController(title: "authorization_request_title".localized, message:
                                  "authorization_request_message".localized, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
    let settingsAction = UIAlertAction(title: "settings".localized, style: .default, handler: { _ in
      let url = URL(string: UIApplication.openSettingsURLString)!
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    })

    alert.addAction(cancelAction)
    alert.addAction(settingsAction)
    self.present(alert, animated: true, completion: nil)
  }
}
