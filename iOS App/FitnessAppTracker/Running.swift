//
//  Workout.swift
//  FitnessAppTracker
//
//  Created by Juan  on 7/23/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore

/// * I do not know if this works it was giving me errors on the main page.
/// * I always get an error with the locations array on line 26.

class Running: UIViewController
{
    var db: Firestore!
    
    var ownerID: String = ""
    dynamic var timestamp = NSDate()
    dynamic var duration = 0
    dynamic var distance: Float = 0
    dynamic var pace: Float = 0
    //var locations = List<Location>()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Add the info to the database
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "duration": duration,
            "distance": distance,
            "pace": pace,
            "date": NSData()
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
}

// class Running: Object
