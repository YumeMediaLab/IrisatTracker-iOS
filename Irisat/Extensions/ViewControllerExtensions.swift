//
//  ViewControllerExtension.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/2/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import UIKit

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(hideKeyboard))
    view.addGestureRecognizer(tapGesture)
  }

  @objc func hideKeyboard() {
    view.endEditing(true)
  }
}

// Extension used for the location framework

public class SelectionItem<Value> {
  public var title: String
  public var value: Value?

  public init(title: String, value: Value?) {
    self.title = title
    self.value = value
  }
}

extension UIViewController {

  public func showPicker<Value>(title: String, msg: String?,
                                options: [SelectionItem<Value>], onSelect: @escaping ((SelectionItem<Value>) -> Void)) {
    let picker = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)

    for option in options {
      picker.addAction(UIAlertAction(title: option.title, style: .default, handler: { action in
        if let first = options.first(where: { action.title! == $0.title }) {
          onSelect(first)
        }
      }))
    }

    picker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    self.present(picker, animated: true, completion: nil)
  }

}
