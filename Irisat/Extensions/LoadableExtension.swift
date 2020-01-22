//
//  LoadableExtension.swift
//  NavigationBarPOC
//
//  Created by Rodrigo Najera Rivas on 2/23/19.
//  Copyright © 2019 RodrigoNajera. All rights reserved.
//

import Foundation
import UIKit

protocol LoadableViewController: class {
  static var storyboardFileName: String { get }
  static var storyboardID: String { get }
}

extension LoadableViewController {
  static var storyboardID: String {
    return String(describing: self)
  }
}

extension LoadableViewController where Self: UIViewController {
  static func instantiate() -> Self {
    let storyboard = Self.storyboardFileName
    guard let vc = UIStoryboard.instanceofViewController(with: storyboardID, from: storyboardFileName) as? Self else {
      fatalError("The viewController '\(self.storyboardID)' of '\(storyboard)' is not of class '\(self)'")
    }
    return vc
  }
}
