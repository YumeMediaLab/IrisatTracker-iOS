//
//  PanicPresenter.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/1/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation
import CoreMotion

class PanicPresenter: PanicPresenterProtocol, PanicInteractorOutputProtocol {
  var view: PanicViewProtocol?
  var interactor: PanicInteractorInputProtocol?
  var wireFrame: PanicWireFrameProtocol?

  let motionManager = CMMotionManager()

  func deviceDidFell() -> Bool {
    if let accelerometerData = motionManager.accelerometerData {

      let y = accelerometerData.acceleration.y
      let x = accelerometerData.acceleration.x
      let z = accelerometerData.acceleration.z

      let currentDeviceAcceleration: Float = sqrt(Float(x) * Float(x) + Float(y) * Float(y) + Float(z) * Float(z))
      if (currentDeviceAcceleration > 8.5) {
        //Device felt on ground
        return true
      }
    }
    return false
  }

}
