//
//  LoginViewController.swift
//  FitnessAppTracker
//
//  Created by Juan  on 6/30/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookLogin

class LoginViewController: UIViewController, UITextFieldDelegate
{
    // Place GIDSignInDelegate for Google Sign in
    

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    //@IBOutlet weak var googleButton: GIDSignInButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        emailField.delegate = self
        passwordField.delegate = self
        
        // Issue
        //GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        
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
    
//    // Function to sign in using a Google Account
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        // ...
//        if let error = error {
//            // ...
//            return
//        }
//
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//        // ...
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // Function to Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    //    override func viewWillAppear(_ animated: Bool)
    //    {
    //        super.viewWillAppear(animated)
    //        emailField.becomeFirstResponder()
    //    }
    //
    //    override func viewWillDisappear(_ animated: Bool)
    //    {
    //        super.viewWillDisappear(animated)
    //        emailField.resignFirstResponder()
    //        passwordField.resignFirstResponder()
    //    }
    
    //    @objc func textFieldChanged(_ target: UITextField)
    //    {
    //        let email = emailField.text
    //        let password = passwordField.text
    //        let formFilled = email != nil && email != "" && password != nil && password != ""
    //        setLoginButton(enable: formFilled)
    //    }
    
//    // Enables and Disable Login Button
//    func setLoginButton(enable: Bool)
//    {
//        if enable
//        {
//            loginButton.alpha = 1.0
//            loginButton.isEnabled = true
//        }
//
//        else
//        {
//            loginButton.alpha = 0.5
//            loginButton.isEnabled = false
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
