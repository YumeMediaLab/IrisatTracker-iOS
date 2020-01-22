//
//  LocationProtocols.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/3/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import UIKit

protocol LocationViewProtocol: LoadableViewController {
  var presenter: LocationPresenterProtocol? { get set }
  /**
   * Add here your methods for communication PRESENTER -> VIEW
   */
}

protocol LocationWireFrameProtocol: class {
  static func presentLocation(from viewController: UIViewController)
  /**
   * Add here your methods for communication PRESENTER -> WIREFRAME
   */
}

protocol LocationPresenterProtocol: class {
  var view: LocationViewProtocol? { get set }
  var interactor: LocationInteractorInputProtocol? { get set }
  var wireFrame: LocationWireFrameProtocol? { get set }
  /**
   * Add here your methods for communication VIEW -> PRESENTER
   */
  func postLocation(locationData: LocationInformation)
  func getRequestComplementaryData() -> RequestComplementaryData
}

protocol LocationInteractorOutputProtocol: class {
  /**
   * Add here your methods for communication INTERACTOR -> PRESENTER
   */
}

protocol LocationInteractorInputProtocol: class {
  var presenter: LocationInteractorOutputProtocol? { get set }
  var APIDataManager: LocationAPIDataManagerInputProtocol? { get set }
  var localDatamanager: LocationLocalDataManagerInputProtocol? { get set }
  /**
   * Add here your methods for communication PRESENTER -> INTERACTOR
   */
  func postLocation(locationData: LocationInformation)
}

protocol LocationAPIDataManagerInputProtocol: class {
  /**
   * Add here your methods for communication INTERACTOR -> APIDATAMANAGER
   */
  func postLocation(locationData: LocationInformation)
}

protocol LocationLocalDataManagerInputProtocol: class {
  /**
   * Add here your methods for communication INTERACTOR -> LOCALDATAMANAGER
   */
}
