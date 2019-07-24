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
import CoreMotion
import Firebase

class RunningViewController: UIViewController
{

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let running = Running()
    
    var seconds = 0.0
    var distance = 0.0
    var currentPace = 0.0
    var trainingStart: Bool = false
    
    
    lazy var locationManager: CLLocationManager =
        {
            var _locationManager = CLLocationManager()
            _locationManager.delegate = self
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest
            _locationManager.activityType = .fitness
            _locationManager.distanceFilter = 10.0
            
            return _locationManager
    }()
    
    lazy var locations = [CLLocation]()
    lazy var timer = Timer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10.0
        locationManager.requestAlwaysAuthorization()
        
        mapView.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let region: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: region * 2.0, longitudinalMeters: region * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    @IBAction func startRunning(_ sender: Any)
    {
        if trainingStart == false
        {
            // Initialize Variables to Start Run
            trainingStart = true
            seconds = 0.0
            distance = 0.0
            
            locations.removeAll(keepingCapacity: false)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.eachSecond), userInfo: nil, repeats: true)
            
            startLocationUpdates()
            
            trainingStart = true
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.backgroundColor = .red
        }
            
        else
        {
            trainingStart = false
            startStopButton.backgroundColor = .blue
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
        seconds += 1
        
        let secondsValue = HKQuantity(unit: HKUnit.second(), doubleValue: seconds)
        timeLabel.text = secondsValue.description
        
        let distanceValue = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
        distanceLabel.text = distanceValue.description
        
        let paceUnit = HKUnit.second().unitDivided(by: HKUnit.meter())
        let paceValue = HKQuantity(unit: paceUnit, doubleValue: seconds / distance)
        paceLabel.text = paceValue.description
    }
    
    // Save Run to Database
    func saveRun()
    {
        running.distance = Float(distance)
        running.duration = Int(seconds)
        running.timestamp = NSDate()
        
        for location in locations
        {
            let _location = Location()
            _location.timestamp = location.timestamp as NSDate
            _location.latitude = location.coordinate.latitude
            _location.longitude = location.coordinate.longitude
            //running.locations.append(_location)
        }
        
        print(running)
        
        //        if running.save()
        //        {
        //            print("Run Saved!")
        //        }
        //
        //        else
        //        {
        //            print("Issue with Saving Run")
        //        }
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

// Extensions
extension RunningViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        for location in locations
        {
            if location.horizontalAccuracy < 10
            {
                if self.locations.count > 0
                {
                    distance += location.distance(from: self.locations.last!)
                    
                    var coordinates = [CLLocationCoordinate2D]()
                    coordinates.append(self.locations.last!.coordinate)
                    coordinates.append(location.coordinate)
                    
                    currentPace = location.distance(from: self.locations.last!) / (location.timestamp.timeIntervalSince(self.locations.last!.timestamp))
                    
                    let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    mapView.setRegion(region, animated: true)
                    
                    mapView.addOverlay(MKPolyline(coordinates: &coordinates, count: coordinates.count))
                }
                
                // Saving the Location
                self.locations.append(location)
            }
        }
    }
}

extension RunningViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        if overlay is MKPolyline
        {
            let polytrack = MKPolylineRenderer(overlay: overlay)
            polytrack.strokeColor = UIColor.black
            polytrack.lineWidth = 3
            
            return polytrack
        }
        
        return MKOverlayRenderer()
    }
}

