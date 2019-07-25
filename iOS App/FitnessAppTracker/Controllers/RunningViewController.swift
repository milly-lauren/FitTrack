//
//  RunningViewController.swift
//  FitnessAppTracker
//
//  Created by Juan  on 7/23/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import MapKit
import HealthKit

import CoreLocation
import CoreMotion
import Dispatch

import Firebase
import FirebaseCore
import FirebaseFirestore

class RunningViewController: UIViewController
{
    // Labels and Buttons
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    //let running = Running()
    
    // Database with Firestore
    var db: Firestore!
    
    // Setting up the Location Manager and Region
    let locationManager = CLLocationManager()
    let regionMeters: Double = 1000
    
    // Defining Variables
    var seconds = 0.0
    var distance = 0.0
    var currentPace = 0.0
    var averagePace = 0.0
    var trainingStart: Bool = false
    var ownerId: String = ""
    
    
//    lazy var locationManager: CLLocationManager =
//    {
//        var _locationManager = CLLocationManager()
//        _locationManager.delegate = self
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        _locationManager.activityType = .fitness
//        _locationManager.distanceFilter = 10.0
//
//        return _locationManager
//    }()
    
    // Lazy Variable is not calaculated at first time
    // Only will run when the variable is called
    lazy var locations = [CLLocation]()
    lazy var timer = Timer()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Checking Location Services
        checkLocationServices()
        mapView.delegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
            let serviceOffAlert = UIAlertController(title: "Cannot Get Location", message: "Please go to the settings and turn on Location Services", preferredStyle: .alert)
            let serviceOffAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            serviceOffAlert.addAction(serviceOffAction)
            self.present(serviceOffAlert, animated: true, completion: nil)
        }
    }
    
    // Sets Up the Location Services
    func setupLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10.0
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
            locationManager.allowsBackgroundLocationUpdates = true
            break
            
        // Location Services always runs
        case .authorizedAlways:
            mapView.showsUserLocation = true
            centerView()
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            break
            
        // User has not determined what to use.
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        // User can not use Location Services
        case .restricted:
            // Shows Alert how to Turn On Services
            let usageAlert = UIAlertController(title: "Cannot Get Location", message: "Please go to the settings and turn on Location Services", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            usageAlert.addAction(defaultAction)
            self.present(usageAlert, animated: true, completion: nil)
            break
            
        // Denied Access to use Location Services
        case .denied:
            // Shows Alert how to Turn On Services
            let deniedAlert = UIAlertController(title: "Cannot Get Location", message: "Please go to the settings and turn on Location Services", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            deniedAlert.addAction(defaultAction)
            self.present(deniedAlert, animated: true, completion: nil)
            break
            
        // Default Case
        default:
            break
        }
    }
    
    // This function center the view for the User Location
    func centerView()
    {
        if let location = locationManager.location?.coordinate
        {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters * 2.0, longitudinalMeters: regionMeters * 2.0)
            mapView.setRegion(region, animated: true)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool)
//    {
//        super.viewWillAppear(animated)
//
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.activityType = .fitness
//        locationManager.distanceFilter = 10.0
//        locationManager.requestAlwaysAuthorization()
//
//        mapView.showsUserLocation = true
//    }
    
//    override func viewDidAppear(_ animated: Bool)
//    {
//        let region: CLLocationDistance = 1000
//        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: region * 2.0, longitudinalMeters: region * 2.0)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
    
    // Stops the Timer from display
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    // Starts calculating (running) when the button is pressed
    @IBAction func startRunning(_ sender: Any)
    {
        // Run has not stated yet
        if trainingStart == false
        {
            // Initialize Variables to Start Run
            trainingStart = true
            seconds = 0.0
            distance = 0.0
            
            // Removes all previous location to start user at extact location
            locations.removeAll(keepingCapacity: false)
            
            // Set up Timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.eachSecond), userInfo: nil, repeats: true)
            
            // Start to update Location
            startLocationUpdates()
            
            // Configure the button
            trainingStart = true
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.setTitleColor(UIColor.black, for: .normal)
            startStopButton.backgroundColor = .red
        }
        
        // Run is already going
        else
        {
            // Stops the Check
            trainingStart = false
            
            // Configure Button
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.setTitleColor(UIColor.black, for: .normal)
            startStopButton.backgroundColor = .green
            
            // Stops the Run and Saves it to the Database
            stopRun()
            saveRun()
        }
    }
    
    // Stops Timer
    func stopTimer()
    {
        timer.invalidate()
        
    }
    
    // Starts Updating the Location
    func startLocationUpdates()
    {
        locationManager.startUpdatingLocation()
    }
    
    // Stops the run completely
    func stopRun()
    {
        stopTimer()
        locationManager.stopUpdatingLocation()
    }
    
    @objc func eachSecond(timer: Timer)
    {
        // Increase seconds by one
        seconds += 1
        
        // Update Seconds Value with Health Kit
        let secondsValue = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
        timeLabel.text = secondsValue.description
        
        // Update Distance Value with Health Kit
        let distanceValue = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        distanceLabel.text = distanceValue.description
        
        // Update Pace Value with Health Kit
        let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
        let paceValue = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        paceLabel.text = paceValue.description
    }
    
//    // Save Run to Database
//    func saveRun()
//    {
//        running.distance = Float(distance)
//        running.duration = Int(seconds)
//        running.timestamp = NSDate()
//
//        for location in locations
//        {
//            let _location = Location()
//            _location.timestamp = location.timestamp as NSDate
//            _location.latitude = location.coordinate.latitude
//            _location.longitude = location.coordinate.longitude
//            //running.locations.append(_location)
//        }

    
    // Save Run to Database
    /// ** Issues with This, Please Help **
    func saveRun()
    {
        averagePace = distance / seconds
        
//        running.distance = Float(distance)
//        running.duration = Int(seconds)
//        running.pace = Float(averagePace)
//        running.timestamp = NSDate()
//
//        for location in locations
//        {
//            let _location = Location()
//            _location.timestamp = location.timestamp as NSDate
//            _location.latitude = location.coordinate.latitude
//            _location.longitude = location.coordinate.longitude
//            //running.locations.append(_location)
//        }
//
//        // Add the info to the database
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "distance": distance,
//            "duration": seconds,
//            "pace": averagePace,
//            "date": NSData()
//        ])
//        { err in
//            if let err = err
//            {
//                print("Error adding document: \(err)")
//            }
//            else
//            {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
    }
    
    //User presses Sign Out Button
    @IBAction func signoutPressed(_ sender: Any)
    {
        // Successfully Signs Out User
        do
        {
            try Auth.auth().signOut()
            
            //GIDSignIn.sharedInstance().signOut()
            
        }
        
        // Error Signing Out
        catch let err
        {
            print("Failed to sign out", err)
        }
        
        // Goes to the main page of the App
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
}

// Extensions Below
extension RunningViewController: CLLocationManagerDelegate
{
    // Checks if the location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        for location in locations
        {
            if location.horizontalAccuracy < 10
            {
                if self.locations.count > 0
                {
                    // Calculates Distance
                    distance += location.distance(from: self.locations.last!)
                    
                    // Sets up User's Coordinates
                    var coordinates = [CLLocationCoordinate2D]()
                    coordinates.append(self.locations.last!.coordinate)
                    coordinates.append(location.coordinate)
                    
                    // Sets up the Current Pace
                    currentPace = location.distance(from: self.locations.last!) / (location.timestamp.timeIntervalSince(self.locations.last!.timestamp))
                    
                    // Sets up Region for Map
                    let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    mapView.setRegion(region, animated: true)
                    
                    // Adds Line
                    mapView.addOverlay(MKPolyline(coordinates: &coordinates, count: coordinates.count))
                }
                
                // Saving the Location
                self.locations.append(location)
            }
        }
    }
    
    // Always checks the Authorization Status of Location Services
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
}

extension RunningViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if overlay is MKPolyline
        {
            // This creates the route / Polyline to track run
            let polytrack = MKPolylineRenderer(overlay: overlay)
            polytrack.strokeColor = UIColor.black
            polytrack.lineWidth = 3
            
            return polytrack
        }
        
        return MKOverlayRenderer()
    }
}

