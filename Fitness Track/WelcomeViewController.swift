//
//  ViewController.swift
//  Fitness Track
//
//  Created by Juan  on 6/29/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import MongoSwift
import StitchCore

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        guard let email = emailField.text else {return}
        guard let password = passwordField.text else {return}
        
        signinManager(true)
        
    }

    func signinManager(_ animated: Bool, email, password)
    {
        super.viewDidAppear(animated)
        
        title = "Welcome"
        
        if stitch.auth.isLoggedIn
        {
            self.navigationController?.pushViewController(FitnessTableViewController(), animated: true)
        }
        
        else
        {

            let credential = UserPasswordCredential.init(
                withUsername: email,
                withPassword: password
            )
            
            let alertController = UIAlertController(title: "Login to Stitch", message: "Anonymous Login", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { [unowned self] _ -> Void in
                
                stitch.auth.login(withCredential: credential)
                {
                    [weak self] result in
                    switch result
                    {
                        
                        case .success:
                            DispatchQueue.main.async
                            {
                                self?.navigationController?.pushViewController(FitnessTableViewController(), animated: true)
                            }
                        
                        case .failure(let e):
                            fatalError(e.localizedDescription)
                    }
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Function to Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    
    @IBAction func signinButton(_ sender: Any)
    {
        
    }
    
    
    
}

extension WelcomeViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
