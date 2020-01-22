//
//  LoginModuleWireFrame.swift
//
//  Created by Rodrigo Nájera on 04/10/2019.
//

import Foundation
import UIKit

class LoginModuleWireFrame: LoginModuleWireFrameProtocol {

  class func createLoginModuleViewController() -> LoginModuleViewController {
    return LoginModuleViewController.instantiate()
  }

  class func presentLoginModuleModule(from viewController: UIViewController) {
    // Generating module components
    let view = createLoginModuleViewController()
    let presenter: LoginModulePresenterProtocol & LoginModuleInteractorOutputProtocol = LoginModulePresenter()
    let interactor: LoginModuleInteractorInputProtocol = LoginModuleInteractor()
    let APIDataManager: LoginModuleAPIDataManagerInputProtocol = LoginModuleAPIDataManager()
    let localDataManager: LoginModuleLocalDataManagerInputProtocol = LoginModuleLocalDataManager()
    let wireFrame: LoginModuleWireFrameProtocol = LoginModuleWireFrame()

    // Connecting
    view.presenter = presenter
    presenter.view = view
    presenter.wireFrame = wireFrame
    presenter.interactor = interactor
    interactor.presenter = presenter
    interactor.APIDataManager = APIDataManager
    interactor.localDatamanager = localDataManager

  }

}
