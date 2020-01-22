//
//  LoginModuleInteractor.swift
//
//  Created by Rodrigo Nájera on 04/10/2019.
//

import Foundation

class LoginModuleInteractor: LoginModuleInteractorInputProtocol {

  weak var presenter: LoginModuleInteractorOutputProtocol?
  var APIDataManager: LoginModuleAPIDataManagerInputProtocol?
  var localDatamanager: LoginModuleLocalDataManagerInputProtocol?

  init() {}
}
