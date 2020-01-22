//
//  LocationPresenter.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/3/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import CoreMotion

class LocationPresenter: LocationPresenterProtocol, LocationInteractorOutputProtocol {

  var view: LocationViewProtocol?
  var interactor: LocationInteractorInputProtocol?
  var wireFrame: LocationWireFrameProtocol?

  var locationManager: CLLocationManager = CLLocationManager()
  let motionManager = CMMotionManager()

  let defaults = UserDefaults.standard

  func postLocation(locationData: LocationInformation) {
    interactor?.postLocation(locationData: locationData)
  }

  func getRequestComplementaryData() -> RequestComplementaryData {
    // Date
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmss"
    let positionDate = formatter.string(from: date)

    // Speed
    var speed: CLLocationSpeed = CLLocationSpeed()
    guard let locationManagerLocation = locationManager.location else { return RequestComplementaryData(speed: 0, battery: 0, date: "") }
    speed = locationManagerLocation.speed
    let locationSpeed = speed * 3.6

    // Battery
    var batteryLevel: Float {
      return UIDevice.current.batteryLevel * 10
    }

    let result = RequestComplementaryData(speed: Int(locationSpeed), battery: Int(batteryLevel), date: positionDate)
    return result
  }
}


struct RequestComplementaryData {
  var speed: Int
  var battery: Int
  var date: String
}
