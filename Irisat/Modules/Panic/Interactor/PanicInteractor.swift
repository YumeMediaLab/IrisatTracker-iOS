//
//  PanicInteractor.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/2/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation

class PanicInteractor: PanicInteractorInputProtocol {

  weak var presenter: PanicInteractorOutputProtocol?
  var APIDataManager: PanicAPIDataManagerInputProtocol?
  var localDatamanager: PanicLocalDataManagerInputProtocol?

  init() {}
}
