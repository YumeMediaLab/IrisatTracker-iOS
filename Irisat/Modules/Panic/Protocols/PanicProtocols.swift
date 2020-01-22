//
//  PanicProtocols.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/1/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation
import UIKit

protocol PanicViewProtocol: LoadableViewController {
  var presenter: PanicPresenterProtocol? { get set }
  /**
   * Add here your methods for communication PRESENTER -> VIEW
   */
}

protocol PanicWireFrameProtocol: class {
  static func presentPanic(from viewController: UIViewController)
  /**
   * Add here your methods for communication PRESENTER -> WIREFRAME
   */
}

protocol PanicPresenterProtocol: class {
  var view: PanicViewProtocol? { get set }
  var interactor: PanicInteractorInputProtocol? { get set }
  var wireFrame: PanicWireFrameProtocol? { get set }
  /**
   * Add here your methods for communication VIEW -> PRESENTER
   */
  func deviceDidFell() -> Bool
}

protocol PanicInteractorOutputProtocol: class {
  /**
   * Add here your methods for communication INTERACTOR -> PRESENTER
   */
}

protocol PanicInteractorInputProtocol: class {
  var presenter: PanicInteractorOutputProtocol? { get set }
  var APIDataManager: PanicAPIDataManagerInputProtocol? { get set }
  var localDatamanager: PanicLocalDataManagerInputProtocol? { get set }
  /**
   * Add here your methods for communication PRESENTER -> INTERACTOR
   */
}

protocol PanicAPIDataManagerInputProtocol: class {
  /**
   * Add here your methods for communication INTERACTOR -> APIDATAMANAGER
   */
}

protocol PanicLocalDataManagerInputProtocol: class {
  /**
   * Add here your methods for communication INTERACTOR -> LOCALDATAMANAGER
   */
}
