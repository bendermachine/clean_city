//
//  MapViewController.swift
//  clean city
//
//  Created by Даниил on 08.01.2023.
//

import UIKit
import MapKit
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnable()
    }
    func checkLocationEnable(){ //check allow location
        if CLLocationManager.locationServicesEnabled(){
            setupManager()
            checkAuthorization()
        }
            
        else {
    showAlertLocation(title: "Служба геолокации отключена", message: "Включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    func setupManager(){// location accuracy
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertLocation(title: "Служба геолокации отключена", message: "Включить?", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
//    URL(string: "App-Prefs:root=LOCATION_SERVICES")
    func showAlertLocation(title:String,message:String?,url:URL?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default){
            (alert) in
            if let url = url{
                UIApplication.shared.open(url,options:[:],completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true,completion: nil)
    }
   

}
extension MapViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
          mapView.setRegion(region, animated: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
}

