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
    organizeProductionsByDistance()
    cropsTableView.reloadData()
  }

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status.rawValue > 2 {
      locationManager.startUpdatingLocation()
      locationSwitch.setOn(true, animated: true)
    } else {
      locationSwitch.setOn(false, animated: true)
    }
  }

  // MARK: - Actions

  @objc func updateLocationParameter(sender: UISwitch) {
    if !sender.isOn {
      sortProductionsByName()
      locationManager.stopUpdatingLocation()
      cropsTableView.reloadData()
      return
    } else if !checkLocationState() {
      locationSwitch.setOn(false, animated: true)
      return
    }

    if locationManager.delegate == nil {
      setupLocationManager()
    }
    locationManager.startUpdatingLocation()
  }

  private func checkLocationState() -> Bool {
    if !CLLocationManager.locationServicesEnabled() {
      requestLocationServices()
      return false
    } else if CLLocationManager.authorizationStatus().rawValue < 3 {
      if CLLocationManager.authorizationStatus() == .notDetermined {
        setupLocationManager()
        return false
      }
      requestAuthorization()
      return false
    }
    return true
  }

  private func requestLocationServices() {
    let alert = UIAlertController(title: "location_request_title".localized, message:
      "location_request_message".localized, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "ok".localized.uppercased(), style: .cancel, handler: { _ in
      self.locationSwitch.setOn(false, animated: true)
    })

    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
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
    present(alert, animated: true, completion: nil)
  }
}
