//
//  LoginViewController.swift
//  FitnessAppTracker
//
//  Created by Juan  on 6/30/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        
        view.addSubview(loginButton)
        setLoginButton(enable: false)
    
        emailField.delegate = self
        passwordField.delegate = self
        
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @objc func textFieldChanged(_ target: UITextField)
    {
        let email = emailField.text
        let password = passwordField.text
        let formFilled = email != nil && email != "" && password != nil && password != ""
        setLoginButton(enable: formFilled)
    }
    
    // Function to login user with email and password
    @IBAction func loginUser(_ sender: Any)
    {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!)
        {
            (user, error) in
            
            // No errors and the user exist
            if error == nil
            {
                self.performSegue(withIdentifier: "loginToHomeScreen", sender: self)
            }
                
            // The User is not found when loging in
            else
            {
                let loginAlert = UIAlertController(title: "Error Logging In", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                loginAlert.addAction(defaultAction)
                self.present(loginAlert, animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField {
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        
        case passwordField:
            loginUser(textField)
            break
            
        default:
            break
        }
        
        //textField.resignFirstResponder()
        return true
    }
    
    // Function to Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    // Enables and Disable Login Button
    func setLoginButton(enable: Bool)
    {
        if enable
        {
            loginButton.alpha = 1.0
            loginButton.isEnabled = true
        }

        else
        {
            loginButton.alpha = 0.5
            loginButton.isEnabled = false
        }
    }
}
