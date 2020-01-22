//
//  LoginModuleViewController.swift
//
//  Created by Rodrigo Nájera on 04/10/2019.
//

import Foundation
import UIKit


class LoginModuleViewController: UIViewController, LoginModuleViewProtocol {

  @IBOutlet weak var mail: UITextField!
  @IBOutlet weak var license: UITextField!
  @IBOutlet weak var mailIcon: UIImageView!
  @IBOutlet weak var licenseIcon: UIImageView!
  @IBOutlet weak var loginButton: UIButton!

  private let mailTextFieldPlaceHolder: String = "Cellphone number"
  private let licenseTextFieldPlaceHolder: String = "License"

  static var storyboardFileName: String {
    return "Login"
  }

  let defaults = UserDefaults.standard
  var presenter: LoginModulePresenterProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    textFieldStyler(textField: mail, with: mailTextFieldPlaceHolder)
    textFieldStyler(textField: license, with: licenseTextFieldPlaceHolder)
    imageStyler(image: mailIcon)
    imageStyler(image: licenseIcon)
    defaults.set(0, forKey: "locationType")

    #if targetEnvironment(simulator)
    mail.text = "5513095068"
    license.text = "1234abcd"
    #endif

    }

  func textFieldStyler(textField: UITextField, with placeholderText: String) {
    textField.attributedPlaceholder = NSAttributedString(string: placeholderText,
     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
    )
    textField.delegate = self
  }

  func imageStyler(image: UIImageView) {
    image.image = image.image?.withRenderingMode(.alwaysTemplate)
    image.tintColor = .white
  }

  @IBAction func loginAction(_ sender: UIButton) {
    guard let mailNotNil = mail.text else { return }
    guard let licenseNotNil = license.text else { return }

    if licenseNotNil.isEmpty {
      presentAlert(with: "Error", and: "You must enter a license to continue", actionTitle: "Accept")
    } else if mailNotNil.isEmpty {
      presentAlert(with: "Error", and: "You must enter your cellphone number to continue", actionTitle: "Accept")
    } else {
      LocationWireFrame.presentLocation(from: self)
      defaults.set(mailNotNil, forKey: "userCellPhone")
      let locationType = defaults.integer(forKey: "locationType")
      guard locationType == 3 else {
      defaults.set(1, forKey: "locationType")
        return
      }
    }
  }

  @IBAction func guestModeAction(_ sender: UIButton) {
    LocationWireFrame.presentLocation(from: self)
    let locationType = defaults.integer(forKey: "locationType")
    guard locationType == 3 else {
      defaults.set(1, forKey: "locationType")
      return
    }
  }

  @IBAction func simulateLowBattery(_ sender: UIButton) {
    defaults.set(3, forKey: "locationType")
    presentAlert(with: "Alert", and: "Your battery level is low, We will change the location type to save battery", actionTitle: "Accept")
  }

  func presentAlert(with title: String, and message: String, actionTitle: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}

extension LoginModuleViewController: UITextFieldDelegate {

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == license {
      license.text = ""
    }
    return true
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField == license {
      guard let licenseNotNil = license.text else { return false }
      license.text = licenseNotNil.separate()
    }

    guard let licenseNotNil = license.text, let mailNotNil = mail.text else { return false }
    if !(licenseNotNil.isEmpty || mailNotNil.isEmpty) {
      mailIcon.image = UIImage(named: "userGreen")
      licenseIcon.image = UIImage(named: "passwordGreen")
      loginButton.setImage(UIImage(named: "loginGreen"), for: .normal)
    } else {
      mailIcon.image = UIImage(named: "userGray")
      licenseIcon.image = UIImage(named: "passwordGray")
      loginButton.setImage(UIImage(named: "loginGray"), for: .normal)
    }
    return true
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let textFieldText = textField.text,
      let rangeOfTextToReplace = Range(range, in: textFieldText) else {
        return false
    }
    let substringToReplace = textFieldText[rangeOfTextToReplace]
    let count = textFieldText.count - substringToReplace.count + string.count
    return count <= 10
  }

}
