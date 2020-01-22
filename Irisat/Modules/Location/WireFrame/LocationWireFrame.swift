//
//  LocationWireFrame.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/3/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation
import UIKit

class LocationWireFrame: LocationWireFrameProtocol {

  class func createLocationViewController() -> LocationViewController {
    return LocationViewController.instantiate()
  }

  class func presentLocation(from viewController: UIViewController) {
    // Generating module components
    let view = createLocationViewController()
    let presenter: LocationPresenterProtocol & LocationInteractorOutputProtocol = LocationPresenter()
    let interactor: LocationInteractorInputProtocol = LocationInteractor()
    let APIDataManager: LocationAPIDataManagerInputProtocol = LocationAPIDataManager()
    let localDataManager: LocationLocalDataManagerInputProtocol = LocationLocalDataManager()
    let wireFrame: LocationWireFrameProtocol = LocationWireFrame()

    // Connecting
    view.presenter = presenter
    presenter.view = view
    presenter.wireFrame = wireFrame
    presenter.interactor = interactor
    interactor.presenter = presenter
    interactor.APIDataManager = APIDataManager
    interactor.localDatamanager = localDataManager

    let navigationController = UINavigationController(rootViewController: view)
    viewController.present(navigationController, animated: true, completion: nil)
  }

}
