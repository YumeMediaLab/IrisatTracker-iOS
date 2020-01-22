//
//  LocationViewController.swift
//  Irisat
//
//  Created by Rodrigo Najera Rivas on 9/3/19.
//  Copyright © 2019 App  Development. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Alamofire

class LocationViewController: UIViewController, LocationViewProtocol, MKMapViewDelegate {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var assistanceButton: UIButton!


  var userAnnotationImage: UIImage?
  var userAnnotation: UserAnnotation?
  var accuracyRangeCircle: MKCircle?
  var polyline: MKPolyline?
  var isZooming: Bool?
  var isBlockingAutoZoom: Bool?
  var zoomBlockingTimer: Timer?
  var didInitialZoom: Bool?
  var assistanceRequested: Bool?

  var locationManager: CLLocationManager = CLLocationManager()


  var presenter: LocationPresenterProtocol?
  let defaults = UserDefaults.standard

  var blueColor: UIColor {
    return UIColor(rgb:0x1b60fe)
  }

  var redColor: UIColor {
    return UIColor(rgb: 0xfe1b1b)
  }

  var greenColor: UIColor {
    return UIColor(rgb: 0x1bfe2e)
  }

  var locationInformation: LocationInformation?


  var setPolylineColor: UIColor {
    let age = defaults.integer(forKey: "locationType")
    switch age {
    case 1:
      return self.blueColor
    case 2:
      return self.redColor
    case 3:
      return self.greenColor
    default:
      return self.greenColor
    }
  }
  
  static var storyboardFileName: String {
    return "Location"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpView()
    createModel()
    UIDevice.current.isBatteryMonitoringEnabled = true
    if #available(iOS 13.0, *) {
        self.isModalInPresentation = true
    }
  }

  func createModel() {
    defaults.set(1, forKey: "event")
    guard let id = defaults.string(forKey: "userCellPhone") else { return }
    let event = defaults.integer(forKey: "event")
    locationInformation = LocationInformation(id: id,
        latitude: "0.0",
        longitude: "-0.0",
        time: "20191009153700",
        speed: 0,
        origin: 280,
        signal: 10,
        sat: 12,
        odm: 255876,
        bat: 9,
        bato: 10,
        acc: 1,
        event: event
       )
  }

  func setUpView() {
    self.title = "Location"
    setUpMap()
  }

  func setUpMap() {
    self.mapView.delegate = self
    self.mapView.showsUserLocation = false
    self.userAnnotationImage = UIImage(named: "user_position_ball")!
    self.accuracyRangeCircle = MKCircle(center: CLLocationCoordinate2D.init(latitude: 41.887, longitude: -87.622), radius: 50)
    self.mapView.addOverlay(self.accuracyRangeCircle!)
    self.didInitialZoom = false
    NotificationCenter.default.addObserver(self, selector: #selector(updateMap(notification:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(showTurnOnLocationServiceAlert(notification:)), name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    LocationService.sharedInstance.useFilter = true
  }

  @objc func showTurnOnLocationServiceAlert(notification: NSNotification){
    let alert = UIAlertController(title: "Turn on Location Service", message: "To use location tracking feature of the app, please turn on the location service from the Settings app.", preferredStyle: .alert)
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
      let settingsUrl = URL(string: UIApplication.openSettingsURLString)
      if let url = settingsUrl {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
    alert.addAction(settingsAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)

  }

  @objc func updateMap(notification: NSNotification){
    if let userInfo = notification.userInfo{
      updatePolylines()
      if let newLocation = userInfo["location"] as? CLLocation{
        zoomTo(location: newLocation)
      }

    }
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if overlay === self.accuracyRangeCircle{
      let circleRenderer = MKCircleRenderer(circle: overlay as! MKCircle)
      circleRenderer.fillColor = UIColor(white: 0.0, alpha: 0.25)
      circleRenderer.lineWidth = 0
      return circleRenderer
    }else{
      let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
      polylineRenderer.strokeColor = setPolylineColor
      polylineRenderer.alpha = 0.5
      polylineRenderer.lineWidth = 5.0
      return polylineRenderer
    }
  }

  func updatePolylines(){
    var coordinateArray = [CLLocationCoordinate2D]()
    guard var locationInformationNotNil = locationInformation else { return }

// Date info
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmss"
    let positionDate = formatter.string(from: date)

// Speed
    var speed: CLLocationSpeed = CLLocationSpeed()
    guard let locationManagerLocation = locationManager.location else { return }
    speed = locationManagerLocation.speed
    let locationSpeed = speed * 3.6

// Battery
    var batteryLevel: Float {
      return UIDevice.current.batteryLevel * 10
    }

// Event type
    let eventType = defaults.integer(forKey: "event")

    for loc in LocationService.sharedInstance.locationDataArray{
      coordinateArray.append(loc.coordinate)
      locationInformationNotNil.latitude = String(loc.coordinate.latitude)
      locationInformationNotNil.longitude = String(loc.coordinate.longitude)
      locationInformationNotNil.time = positionDate
      locationInformationNotNil.speed = Int(locationSpeed)
      locationInformationNotNil.bat = Int(batteryLevel)
      locationInformationNotNil.bato = Int(batteryLevel)
      locationInformationNotNil.event = eventType
    }

    self.clearPolyline()
    self.polyline = MKPolyline(coordinates: coordinateArray, count: coordinateArray.count)
    guard let polyLineNotNil = polyline else { return }
    self.mapView.addOverlay(polyLineNotNil)

    presenter?.postLocation(locationData: locationInformationNotNil)

  }

  func clearPolyline(){
    if self.polyline != nil{
      self.mapView.removeOverlay(self.polyline!)
      self.polyline = nil
    }
  }

  func zoomTo(location: CLLocation){
    if self.didInitialZoom == false{
      let coordinate = location.coordinate
      let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
      self.mapView.setRegion(region, animated: false)
      self.didInitialZoom = true
    }

    if self.isBlockingAutoZoom == false{
      self.isZooming = true
      self.mapView.setCenter(location.coordinate, animated: true)
    }

    var accuracyRadius = 50.0
    if location.horizontalAccuracy > 0{
      if location.horizontalAccuracy > accuracyRadius{
        accuracyRadius = location.horizontalAccuracy
      }
    }

    self.mapView.removeOverlay(self.accuracyRangeCircle!)
    self.accuracyRangeCircle = MKCircle(center: location.coordinate, radius: accuracyRadius as CLLocationDistance)
    self.mapView.addOverlay(self.accuracyRangeCircle!)

    if self.userAnnotation != nil{
      self.mapView.removeAnnotation(self.userAnnotation!)
    }

    self.userAnnotation = UserAnnotation(coordinate: location.coordinate, title: "", subtitle: "")
    self.mapView.addAnnotation(self.userAnnotation!)
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation{
      return nil
    }else{
      let identifier = "UserAnnotation"
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      if annotationView != nil{
        annotationView!.annotation = annotation
      }else{
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      }
      annotationView!.canShowCallout = false
      annotationView!.image = self.userAnnotationImage

      return annotationView
    }
  }

  func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    if self.isZooming == true{
      self.isZooming = false
      self.isBlockingAutoZoom = false
    }else{
      self.isBlockingAutoZoom = true
      if let timer = self.zoomBlockingTimer{
        if timer.isValid{
          timer.invalidate()
        }
      }
      self.zoomBlockingTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { (Timer) in
        self.zoomBlockingTimer = nil
        self.isBlockingAutoZoom = false;
      })
    }
  }

  // Function to change the location type
  
  @IBAction func assistanceButton(_ sender: Any) {
    defaults.set(4, forKey: "event")
    guard let assistanceRequestedNotNil = assistanceRequested else { return }
    if assistanceRequestedNotNil {
      assistanceButton.setTitle("I dont need assistance", for: .normal)
      assistanceRequested = false
      defaults.set(1, forKey: "event")
    } else {
      assistanceButton.setTitle("I need assistance", for: .normal)
      defaults.set(4, forKey: "event")
      assistanceRequested = true
    }


  }
}
