//
//  Panic.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/1/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreMotion


class PanicViewController: UIViewController, PanicViewProtocol {

  @IBOutlet weak var panicView: CircularProgressBar!

  var audioPlayer: AVAudioPlayer?
  let motionManager = CMMotionManager()
  var timer: Timer!

  static var storyboardFileName: String {
    return "Panic"
  }

  var presenter: PanicPresenterProtocol?

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
    panicView.delegate = self
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    guard let player = audioPlayer else { return }
    player.stop()
  }

  func setUpView() {
    // Function used to avoid view being dismissed by drag
    UIDevice.current.isBatteryMonitoringEnabled = true
    if #available(iOS 13.0, *) {
        self.isModalInPresentation = true
    }

    self.title = "Panic"
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    motionManager.startAccelerometerUpdates()
    motionManager.startGyroUpdates()
    motionManager.startMagnetometerUpdates()
    motionManager.startDeviceMotionUpdates()
    timer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(PanicViewController.update), userInfo: nil, repeats: true)
    addLocationSettings()
  }

  @objc func handleTap() {
    panicView.labelSize = 20
    panicView.safePercent = 100
    panicView.setProgress(to: 1, withAnimation: true)
  }

  func addLocationSettings() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "location", style: .done, target: self, action: #selector(self.action(sender:)))
  }

  @objc func action(sender: UIBarButtonItem) {
    LocationWireFrame.presentLocation(from: self)
  }

  func playSound() {
    guard let url = Bundle.main.url(forResource: "alarm_tone", withExtension: "mp3") else { return }

    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

      /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
      audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

      /* iOS 10 and earlier require the following line:
       player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

      guard let player = audioPlayer else { return }

      player.play()

    } catch let error {
      print(error.localizedDescription)
    }
  }

  @objc func update() {
    if let accelerometerData = motionManager.accelerometerData {
      let y = accelerometerData.acceleration.y
      let x = accelerometerData.acceleration.x
      let z = accelerometerData.acceleration.z

      let currentDeviceAcceleration: Float = sqrt(Float(x) * Float(x) + Float(y) * Float(y) + Float(z) * Float(z))
      if (currentDeviceAcceleration > 6.5) {
        //Device felt on ground
        self.view.backgroundColor = .red
        playSound()
      }
    }
  }


}

extension PanicViewController: PanicDidEndDelegate {
  func animation(didEnd: Bool) {
    self.view.backgroundColor = .red
    self.panicView.labelIsHiden = true
    playSound()
  }
  
  func animation(didBegin: Bool) {
    self.view.backgroundColor = .white
    self.panicView.labelIsHiden = false
  }
}
