//
//  LocationAPIDataManager.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/3/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation
import Alamofire

class LocationAPIDataManager: LocationAPIDataManagerInputProtocol {

  func validateResponse(statusCode: Int) {
    switch statusCode {
    case 200:
     ()
    default:
     ()
    }
  }

  func jsonToData(json: Any) -> Data? {
    do {
      return try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) }
  }

  func postLocation(locationData: LocationInformation) {
    let url = "http://gateway4.redgps.com:11526/"
    let headers = ["cache-control": "no-cache",
                   "Content-Type": "application/json"]
    let parameters: [String : Any] = [
      "id": locationData.id,
      "lat": locationData.latitude,
      "lng": locationData.longitude,
      "time": locationData.time,
      "spd": locationData.speed,
      "ori": locationData.origin,
      "sig": locationData.signal,
      "sat": locationData.sat,
      "odm": locationData.odm,
      "bat": locationData.bat,
      "bato": locationData.bato,
      "acc": locationData.acc,
      "evnt": locationData.event
    ]

    Alamofire.request(url,
                      method: .post,
                      parameters: parameters,
                      encoding: JSONEncoding.default,
                      headers: headers
    ).responseJSON { [weak self] response in
      guard response.result.isSuccess else {
        print("Error while fetching tags: \(String(describing: response.result.error))")
        return
      }
      if let status = response.response?.statusCode {
        self?.validateResponse(statusCode: status)
      }
      if let result = response.result.value {
        print(result)
      }
    }
  }
}

extension LocationViewController {
}
