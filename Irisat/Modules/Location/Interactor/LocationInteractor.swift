//
//  LocationInteractor.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/3/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation

class LocationInteractor: LocationInteractorInputProtocol {

  weak var presenter: LocationInteractorOutputProtocol?
  var APIDataManager: LocationAPIDataManagerInputProtocol?
  var localDatamanager: LocationLocalDataManagerInputProtocol?

  func postLocation(locationData: LocationInformation){
    APIDataManager?.postLocation(locationData: locationData)
  }
}
