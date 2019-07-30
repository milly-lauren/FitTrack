//
//  RunningViewController.swift
//  FitnessAppTracker
//
//  Created by Juan  on 7/23/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import HealthKit

import CoreLocation
import CoreMotion
import Dispatch

import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

struct imageKeys
{
    static let imageFolder =  "imageFolder"
    static let imageCollection = "imageCollection"
    static let uid = "uid"
    static let imageURL = "imageURL"
}

class RunningViewController: UIViewController
{
    // Labels and Buttons
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // Database with Firestore
    var db = Firestore.firestore()
    let userID = Auth.auth().currentUser!.uid
    
    // Setting up the Location Manager and Region
    let locationManager = CLLocationManager()
    let regionMeters: Double = 1000
    
    // Setting up Snapshotter
    let snapshotOptions = MKMapSnapshotter.Options()
    var snapshot: MKMapSnapshotter!
    var mapImage: UIImage = UIImage()
    
    // Defining Variables
    var totalSeconds = 0.0
    var seconds = 0.0
    var minutes = 0.0
    var hours = 0.0
    
    var distance = 0.0
    var currentPace = 0.0
    var averagePace = 0.0
    var trainingStart: Bool = false
    
    // Setting Up Time
    var year = Calendar.current.component(.year, from: Date())
    var month = Calendar.current.component(.month, from: Date())
    var day = Calendar.current.component(.day, from: Date())
    var dateHour = Calendar.current.component(.hour, from: Date())
    var dateMinute = Calendar.current.component(.minute, from: Date())

    // Lazy Variable is not calaculated at first time
    // Only will run when the variable is called
    lazy var locations = [CLLocation]()
    lazy var timer = Timer()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Checking Location Services
        checkLocationServices()
        
        // Configure Button for Intial View
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitleColor(UIColor.black, for: .normal)
        startStopButton.backgroundColor = .green
        
        snapshot = MKMapSnapshotter(options: snapshotOptions)
        mapView.delegate = self
        mapView.userTrackingMode = .follow
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
            // Setting up the region
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
            
            snapshotOptions.region = region
        }
    }
    
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
        totalSeconds += 1
        seconds += 1
  
        if (seconds.truncatingRemainder(dividingBy: 60) == 0 && seconds != 0)
        {
            minutes += 1
            seconds = 0.0
        }
        
        if (seconds.truncatingRemainder(dividingBy: 3600) == 0 && seconds != 0.0)
        {
            hours += 1
            minutes = 0.0
            seconds = 0.0
        }
                
        // Update Time Value with Health Kit
        let secondsValue = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
        let minuteValue = HKQuantity(unit: HKUnit.minute(), doubleValue: minutes)
        let hourValue = HKQuantity(unit: HKUnit.hour(), doubleValue: hours)
        
        timeLabel.text = hourValue.description + " " + minuteValue.description + " " + secondsValue.description
        
        // Update Distance Value with Health Kit
        let distanceValue = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)

        distanceLabel.text = distanceValue.description
        
        // Update Pace Value with Health Kit
        let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
        let paceValue = HKQuantity(unit: paceUnit, doubleValue: distance / totalSeconds)
        
        paceLabel.text = paceValue.description
    }
    
    func drawLineOnImage(snapshot: MKMapSnapshotter.Snapshot) -> UIImage {
        let image = snapshot.image
        
        // draw original image into the context
        image.draw(at: CGPoint.zero)
        
        // get the context for CoreGraphics
        let context = UIGraphicsGetCurrentContext()
        
        // set stroking width and color of the context
        context!.setLineWidth(3.0)
        context!.setStrokeColor(UIColor.black.cgColor)
        
        // apply the stroke to the context
        context!.strokePath()
        
        // get the image from the graphics context
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the graphics context
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
    
    func takeSnapshot(){
        
//        var coordinates = [CLLocationCoordinate2D]()
//
//        let polylineSnap = MKPolyline(coordinates: &coordinates, count: coordinates.count)
//        let polylineSnapRegion = MKCoordinateRegion(polylineSnap.boundingMapRect)
        
        // Preparing Size for Snapshot
        //snapshotOptions.region = polylineSnapRegion
        snapshotOptions.size = mapView.frame.size
        snapshotOptions.scale = UIScreen.main.scale
        snapshotOptions.showsPointsOfInterest = true
        
        // Set the size of the image output
        snapshotOptions.size = CGSize(width: 414, height: 424)
        
        // Take a Snapshot of the Map
        snapshot.start
        {
            (snapshot, error) in
            
            //guard let snapshot = snapshot else { return }
            
            //self.mapImage = snapshot
            
            //self.mapImage = self.drawLineOnImage(snapshot: snapshot)
                
            // Take the Snapshot if there is no errors
            if error == nil
            {
                let snapshotImage = snapshot?.image

                if (snapshotImage != nil)
                {
                    self.mapImage = snapshotImage!
                }

                else
                {
                    print("Error: There is no Snapshot")
                }
                    
                let data = self.mapImage.jpegData(compressionQuality: 1.0)
                
                let mapImageName = UUID().uuidString
                    
                let imageReference = Storage.storage().reference().child(imageKeys.imageFolder).child(mapImageName)
                    
                imageReference.putData(data!, metadata: nil)
                {
                    (metadata, error) in
                        
                    if let error = error
                    {
                        print(error)
                    }
                    
                    imageReference.downloadURL
                    {
                        (url, error) in
                        
                        if let error = error
                        {
                            print(error)
                        }
                        
                        //guard let url = url else { return }
                        //let urlString = url.absoluteString
                    }
                }
            }
        }
    }
    
    // Save Run to Database
    func saveRun()
    {
        averagePace = distance / totalSeconds
        
        // Updating Time
        year = Calendar.current.component(.year, from: Date())
        month = Calendar.current.component(.month, from: Date())
        day = Calendar.current.component(.day, from: Date())
        dateHour = Calendar.current.component(.hour, from: Date())
        dateMinute = Calendar.current.component(.minute, from: Date())
    
        //takeSnapshot()
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        view.layer.render(in: context)
        guard let screenshotImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(screenshotImage, nil, nil, nil)
        
        let data = screenshotImage.jpegData(compressionQuality: 1.0)
        
        let imageName = UUID().uuidString
        
        let imageReference = Storage.storage().reference().child(imageKeys.imageFolder).child(imageName)
        
        imageReference.putData(data!, metadata: nil)
        {
            (metadata, error) in
            
            if let error = error
            {
                print(error)
            }
            
            imageReference.downloadURL
                {
                    (url, error) in
                    
                    if let error = error
                    {
                        print(error)
                    }
                    
                    //guard let url = url else { return }
                    
                    //let urlString = url.absoluteString
            }
        }
        
        
    
        var ref: DocumentReference? = nil
        ref = db.collection("users").document(userID).collection("activities").addDocument(data: [
            "distanceValue": distance,
            "distanceUnit": "meters",
            "averagePace": averagePace,
            "userID": userID,
            "hours": hours,
            "minutes": minutes,
            "seconds": seconds,
            "date_month": month,
            "date_day": day,
            "date_year": year,
            "date_hour": dateHour,
            "date_minute": dateMinute,
            "imageName": imageName,
            "timestamp": FieldValue.serverTimestamp()
        ])
        { err in
            if let err = err
            {
                print("Error adding document: \(err)")
            }
            else
            {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    //User presses Sign Out Button
    @IBAction func signoutPressed(_ sender: Any)
    {
        // Successfully Signs Out User
        do
        {
            try Auth.auth().signOut()
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
                    let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
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
