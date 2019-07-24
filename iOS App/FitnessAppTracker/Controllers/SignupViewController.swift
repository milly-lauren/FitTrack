//
//  SignupViewController.swift
//  FitnessAppTracker
//
//  Created by Juan  on 6/30/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        signupButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        
        view.addSubview(signupButton)
        setSignupButton(enable: false)
        
        //view.addSubview(activityView)
    
        nameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        nameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
    }
        
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        nameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @objc func textFieldChanged(_ target: UITextField)
    {
        let name = nameField.text
        let email = emailField.text
        let password = passwordField.text
        let formFilled = name != nil && name != "" && email != nil && email != "" && password != nil && password != ""
        setSignupButton(enable: formFilled)
    }
    
    // Enables and Disable Signup Button
    @objc func setSignupButton(enable: Bool)
    {
        if enable
        {
            signupButton.alpha = 1.0
            signupButton.isEnabled = true
        }
            
        else
        {
            signupButton.alpha = 0.5
            signupButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField
        {
            case nameField:
                nameField.resignFirstResponder()
                emailField.becomeFirstResponder()
                break
            
            case emailField:
                emailField.resignFirstResponder()
                passwordField.becomeFirstResponder()
                break
            
            case passwordField:
                createUser()
                break
            
            default:
                break
        }
        
        return true
        
    }
    
    @objc func createUser()
    {
        guard let name = nameField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        setSignupButton(enable: false)
        
        //activityView.startAnimating()
        
        
        Auth.auth().createUser(withEmail: email, password: password)
        {
            user, error in
            
            // If no errors and there is a user entry
            if error == nil && user != nil
            {
                // User Created
                print("User Created")
                
                // Change the name to display name
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges
                {
                    error in
                    
                    // If there is no errors
                    if error == nil
                    {
                        print("Name is now User Display Name")
                        //self.dismiss(animated: false, completion: nil)
                        self.performSegue(withIdentifier: "signupToHomeScreen", sender: nil)
                    }
                    
                    else
                    {
                        let signinAlert = UIAlertController(title: "Error Signing In", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        signinAlert.addAction(defaultAction)
                        self.present(signinAlert, animated: true, completion: nil)
                        
                        //print("Error creating user: \(error!.localizedDescription)")
                    }
                    
                }
            }
            
            else
            {
                let signinAlert = UIAlertController(title: "Error Signing In", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                signinAlert.addAction(defaultAction)
                self.present(signinAlert, animated: true, completion: nil)
                
                //print("Error creating user: \(error!.localizedDescription)")
            }
        }
    }
    
    // Function to Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        nameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
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

//extension LoginViewController: UITextFieldDelegate
//{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//        textField.resignFirstResponder()
//        return true
//    }
//}
