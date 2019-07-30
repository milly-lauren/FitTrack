//
//  InitialViewController.swift
//  FitnessAppTracker
//
//  Created by Juan  on 6/30/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class InitialViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil
        {
            // Checks if the User is Already Sign In
            self.performSegue(withIdentifier: "signinToHomeScreen", sender: nil)
        }
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    @IBAction func googleButtonPressed(_ sender: Any)
    {
        // Adding Google Sign In
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        // Checks if the user is Sign in with Google Already
        if Auth.auth().currentUser != nil
        {
            self.performSegue(withIdentifier: "googleSigninToHomeScreen", sender: nil)
        }
    }


}

