//
//  Pedometer.swift
//  ProtoExercise
//
//  Created by Juan on 6/27/19.
//  Copyright © 2019 Juan Rodriguez. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import Dispatch

class Pedometer: UIViewController
{
    private let activityManager = CMMotionActivityManager()
    
    var pedometer = CMPedometer()
    var pedometerData = CMPedometerData()
    
    // Property to Change the Label
    var numberOfSteps: Int! = nil
    {
        didSet
        {
            //stepsCountLabel.text = String(format: "Steps: %i", numberOfSteps)
        }
    }
    
    var timer = Timer()
    
    var distance = 0.0
    var pace = 0.0
    
    var elapsedSeconds = 0.0
    let interval = 0.1
    
    @IBOutlet weak var pedometerStatusLabel: UILabel!
    @IBOutlet weak var stepsCountLabel: UILabel!
    @IBOutlet weak var activityTypeLabel: UILabel!
    @IBOutlet weak var distanceTravelLabel: UILabel!
    @IBOutlet weak var userPaceLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        stepsCountLabel.text = "Steps: Not Available"
        startStopPedometer(startStopButton)
        
    }
    
    @IBAction func startStopPedometer(_ sender: UIButton){
        if sender.titleLabel?.text == "Start"
        {
            pedometerStatusLabel.text = "Pedometer On"
            sender.setTitle("Stop", for: .normal)
            //sender.setTitleColor(UIColor.red, for: .normal)
            
            // Checks if Step Counting is Available
            if CMPedometer.isStepCountingAvailable()
            {
                startTimer()
                pedometer.startUpdates(from: Date(), withHandler:
                { (pedometerData, error) in
                    if let pedometerData = pedometerData{
                        self.pedometerData = pedometerData
                        //self.stepsCountLabel.text = "Steps: \(pedometerData.numberOfSteps)"
                        self.numberOfSteps = Int(pedometerData.numberOfSteps)
                    }
                })
            }
            
            else
            {
                print("Step Counting Not Available")
            }
        }
        
        else
        {
            pedometer.stopUpdates()
            stopTimer()
            pedometerStatusLabel.text = "Pedometer Off"
            sender.setTitle("Start", for: .normal)
            //sender.setTitleColor(UIColor.green, for: .normal)
        }
        
    }
    
    func formatTime(_ seconds: Double) -> String
    {
        let formatMinute = Int(seconds) / 60
        let formatSecond = Int(seconds) % 60
        return String(format: "%02i:%02i", formatMinute, formatSecond)
    }
    
    func startTimer()
    {
        print("Timer \(Date())")
        
        if !timer.isValid
        {
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block:
            {   (timer) in
                self.displayPedometerData()
                self.elapsedSeconds += self.interval
            })
        }
    }
    
    func stopTimer()
    {
        timer.invalidate()
        displayPedometerData()
    }
    
    func calculatedPace() -> Double
    {
        if distance > 0
        {
            return elapsedSeconds / distance
        }
        
        else
        {
            return 0
        }
    }
    
    func displayPedometerData()
    {
        pedometerStatusLabel.text = "Pedometer On: " + formatTime(elapsedSeconds)
        
        if let numberOfSteps = numberOfSteps
        {
            stepsCountLabel.text = String(format:"Steps: %i", numberOfSteps)
        }
        
        if let pedometerDistance = pedometerData.distance
        {
            distance = pedometerDistance as! Double
            distanceTravelLabel.text = String(format: "Distance: %6.2f", distance)
        }
        
        let minutesPerMile = 1609.34
        
        if CMPedometer.isPaceAvailable()
        {
            // Checks if the User is moving
            if pedometerData.averageActivePace != nil
            {
                pace = pedometerData.averageActivePace as! Double
                userPaceLabel.text = String(format: "Pace: %6.2f", formatTime(pace * minutesPerMile))
            }
            
            else
            {
                userPaceLabel.text = "Pace: Not Available"
            }
        }
        
        
        else
        {
            //userPaceLabel.text = "Pace: Not Available"
            userPaceLabel.text = "Average Pace:" + formatTime(calculatedPace() * minutesPerMile)
        }
    }
    
//    private func checkMotionService()
//    {
//        switch CMMotionActivityManager.authorizationStatus()
//        {
//        case CMAuthorizationStatus.denied:
//            activityTypeLabel.text = "Not Available"
//            stepsCountLabel.text = "Not Available"
//
//        default:
//            break
//        }
//    }
//
//    // Shows the Activity Type In Motion
//    private func activityType()
//    {
//        activityManager.startActivityUpdates(to: OperationQueue.main)
//        {
//            [weak self] (activity: CMMotionActivity?) in
//
//            guard let activity = activity else { return }
//
//            DispatchQueue.main.async
//            {
//                // Checks if the User is Stationary
//                if activity.stationary
//                {
//                    self?.activityTypeLabel.text = "Stationary"
//                }
//
//                // Checks if the User is Walking
//                else if activity.walking
//                {
//                    self?.activityTypeLabel.text = "Walking"
//                }
//
//                // Checks if the User is Running
//                else if activity.running
//                {
//                    self?.activityTypeLabel.text = "Running"
//                }
//            }
//        }
//    }
//
//    // This function counts the steps the User takes
//    private func countSteps()
//    {
//        pedometer.startUpdates(from: Date())
//        {
//            [weak self] pedometerData, error in
//
//            // Guard against there being no data
//            guard let pedometerData = pedometerData, error == nil else
//            { return }
//
//            DispatchQueue.main.async
//            {
//                self?.stepsCountLabel.text = pedometerData.numberOfSteps.stringValue
//            }
//        }
//    }
}
