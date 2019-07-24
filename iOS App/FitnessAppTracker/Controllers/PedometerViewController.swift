//
//  PedometerViewController.swift
//  FitnessAppTracker
//
//  Created by Juan  on 7/11/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import Dispatch

class PedometerViewController: UIViewController {
    
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
    //@IBOutlet weak var activityTypeLabel: UILabel!
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
    
    // Formats Time in Units
    func formatTime(_ seconds: Double) -> String
    {
        let formatMinute = Int(seconds) / 60
        let formatSecond = Int(seconds) % 60
        return String(format: "%02i:%02i", formatMinute, formatSecond)
    }
    
    // Starts the Timer
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
    
    // Stop the Timer
    func stopTimer()
    {
        timer.invalidate()
        displayPedometerData()
    }
    
    // Calcating the Pace of the User
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
    
    // Displays the Pedometer Data to the User
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
