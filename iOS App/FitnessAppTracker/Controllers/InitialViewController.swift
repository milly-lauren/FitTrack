//
//  ViewController.swift
//  FitnessAppTracker
//
//  Created by Juan  on 6/30/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        //self.performSegue(withIdentifier: "toHomeScreen", sender: self)
//
//        if let user = Auth.auth().currentUser
//        {
//            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
//        }
    }


}

