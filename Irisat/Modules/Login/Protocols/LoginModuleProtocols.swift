//
//  LoginModuleProtocols.swift
//
//  Created by Rodrigo Nájera on 04/10/2019.
//

import Foundation
import UIKit

protocol LoginModuleViewProtocol: LoadableViewController {
  var presenter: LoginModulePresenterProtocol? { get set }
  /**
   * Add here your methods for communication PRESENTER -> VIEW
   */
}

protocol LoginModuleWireFrameProtocol: class {
  static func presentLoginModuleModule(from viewController: UIViewController)
  /**
   * Add here your methods for communication PRESENTER -> WIREFRAME
   */
}

protocol LoginModulePresenterProtocol: class {
  var view: LoginModuleViewProtocol? { get set }
  var interactor: LoginModuleInteractorInputProtocol? { get set }
  var wireFrame: LoginModuleWireFrameProtocol? { get set }
  /**
   * Add here your methods for communication VIEW -> PRESENTER
   */
}

protocol LoginModuleInteractorOutputProtocol: class {
  /**
   * Add here your methods for communication INTERACTOR -> PRESENTER
   */
}

protocol LoginModuleInteractorInputProtocol: class {
  var presenter: LoginModuleInteractorOutputProtocol? { get set }
  var APIDataManager: LoginModuleAPIDataManagerInputProtocol? { get set }
  var localDatamanager: LoginModuleLocalDataManagerInputProtocol? { get set }
  /**
   * Add here your methods for communication PRESENTER -> INTERACTOR
   */
}

protocol LoginModuleAPIDataManagerInputProtocol: class {
  /**
   * Add here your methods for communication INTERACTOR -> APIDATAMANAGER
   */
}

protocol LoginModuleLocalDataManagerInputProtocol: class {
  /**
   * Add here your methods for communication INTERACTOR -> LOCALDATAMANAGER
   */
}
