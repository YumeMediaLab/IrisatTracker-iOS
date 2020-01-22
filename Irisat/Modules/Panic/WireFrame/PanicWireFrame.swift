//
//  PanicWireFrame.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/2/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation
import UIKit

class PanicWireFrame: PanicWireFrameProtocol {

  class func createPanicViewController() -> PanicViewController {
    return PanicViewController.instantiate()
  }

  class func presentPanic(from viewController: UIViewController) {
    // Generating module components
    let view = createPanicViewController()
    let presenter: PanicPresenterProtocol & PanicInteractorOutputProtocol = PanicPresenter()
    let interactor: PanicInteractorInputProtocol = PanicInteractor()
    let APIDataManager: PanicAPIDataManagerInputProtocol = PanicAPIDataManager()
    let localDataManager: PanicLocalDataManagerInputProtocol = PanicLocalDataManager()
    let wireFrame: PanicWireFrameProtocol = PanicWireFrame()

    // Connecting
    view.presenter = presenter
    presenter.view = view
    presenter.wireFrame = wireFrame
    presenter.interactor = interactor
    interactor.presenter = presenter
    interactor.APIDataManager = APIDataManager
    interactor.localDatamanager = localDataManager

    let panicViewController = PanicViewController.instantiate()
    let navigationController = UINavigationController(rootViewController: panicViewController)
    viewController.present(navigationController, animated: true, completion: nil)
  }

}
