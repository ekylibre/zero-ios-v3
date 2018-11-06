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

  func setupLocationManager(_ locationManager: CLLocationManager) {
    locationManager.requestAlwaysAuthorization()

    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      locationManager.startUpdatingLocation()
    }
  }

  // MARK: - Location Manager delegate

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

    print("locations = \(locValue.latitude) \(locValue.longitude)")
  }
}
