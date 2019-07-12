//
//  MapViewController.swift
//  ProtoExercise
//
//  Created by Juan on 6/26/19.
//  Copyright © 2019 Juan Rodriguez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController
{

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionMeters: Double = 100
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkLocationServices()

    }
    
    // This function checks if the User has Location Services Enable
    func checkLocationServices()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            // Calls the functions if Locaton Services Enabled
            setupLocationManager()
            checkLocationAuthorization()
        }
        
        else
        {
            // Show User Alert the Services are Off
        }
    }
    
    // Sets Up the Location Services
    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Checks the Status of Location Services
    func checkLocationAuthorization()
    {
        switch CLLocationManager.authorizationStatus() {
        
        // Location Services run when App is in Use
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerView()
            locationManager.startUpdatingLocation()
            break
            
        // Location Services always runs
        case .authorizedAlways:
            break
            
        // User has not determined what to use.
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        // User can not use Location Services
        case .restricted:
            break
        
        // Denied Access to use Location Services
        case .denied:
            // Shows Alert how to Turn On Services
            // Testing
            print("Denied")
            break
            
        default:
            break
        }
    }

    // This function center the view for the User Location
    func centerView()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// Delegate Methods
extension MapViewController: CLLocationManagerDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // This guards against if location is null
        guard let location = locations.last else { return }
        
        // Centers the Map
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // Assigns the region for the Map
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // Imput Later
    }
    
    // Always checks the Authorization Status of Location Services
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
    
//    func serviceOff(title: String, msg: String, vc: UIViewController)
//    {
//        let alert = UIAlertController(title: "Location Services Are Off", message: "To turn on Location Services, please go to Settings > Privacy > Location Services", preferredStyle: .alert)
//        alert.addAction(title: "OK")
//        vc.present(alert, animated: true)
//    }
}
