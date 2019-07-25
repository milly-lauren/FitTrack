//
//  HomeViewController.swift
//  FitnessAppTracker
//
//  Created by Juan  on 7/1/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

/// ** This Contoller is not used anymore for UI Implementation **
/// ** Please go to RunningViewController.swift for updated info **
/// ** Please do not Delete this since it is used for Reference **

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //User presses sign out
    @IBAction func signoutPressed(_ sender: Any)
    {
        //try! Auth.auth().signOut()
        //self.performSegue(withIdentifier: "logoutToInitial", sender: nil)
        //self.dismiss(animated: false, completion: nil)
        
        do
        {
            try Auth.auth().signOut()
            
            //GIDSignIn.sharedInstance().signOut()
            
            //self.present(initialNavigationController, animated: true, completion: nil)
        }
        catch let err
        {
            print("Failed to sign out", err)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
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
