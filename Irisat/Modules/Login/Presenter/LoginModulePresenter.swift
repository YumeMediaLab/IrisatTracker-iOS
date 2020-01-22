//
//  LoginModulePresenter.swift
//
//  Created by Rodrigo Nájera on 04/10/2019.
//

import Foundation

class LoginModulePresenter: LoginModulePresenterProtocol, LoginModuleInteractorOutputProtocol {
  var view: LoginModuleViewProtocol?
  var interactor: LoginModuleInteractorInputProtocol?
  var wireFrame: LoginModuleWireFrameProtocol?

  init() {}
}
