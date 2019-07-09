//
//  AppDelegate.swift
//  Todo
//
//  Created by Manuel Vasquez on 7/1/19.
//  Copyright © 2019 Manuel Vasquez. All rights reserved.
//

import UIKit
import StitchCore
import StitchRemoteMongoDBService
import GoogleSignIn

// set up the Stitch client
let stitch = try! Stitch.initializeAppClient(withClientAppID: Constants.STITCH_APP_ID)

var itemsCollection: RemoteMongoCollection<TodoItem>!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // initialize the RemoteMongoClient
        let MongoClient = try! stitch.serviceClient(fromFactory: remoteMongoClientFactory, withName: Constants.ATLAS_SERVICE_NAME)
        
        // set up collection
        itemsCollection = MongoClient
            .db(Constants.TODO_DATABASE)
            .collection(Constants.TODO_ITEMS_COLLECTION, withCollectionType: TodoItem.self)
        
        // google sign-in
        GIDSignIn.sharedInstance()?.clientID = Constants.GOOGLE_CLIENT_ID
        GIDSignIn.sharedInstance()?.serverClientID = Constants.GOOGLE_SERVER_CLIENT_ID
        GIDSignIn.sharedInstance()?.delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        
        return true
    }
    
    // added for google sign-in
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("error received when logging in with Google: \(error.localizedDescription)")
        } else {
            switch user.serverAuthCode {
            case .some:
                let googleCredential = GoogleCredential.init(withAuthCode: user.serverAuthCode)
                stitch.auth.login(withCredential: googleCredential) { result in
                    switch result {
                    case .success:
                        print("successfully signed in with Google")
                        NotificationCenter.default.post(name: Notification.Name("OAUTH_SIGN_IN"), object: nil, userInfo: nil)
                    case .failure(let error):
                        print("failed logging in Stitch with Google. error: \(error)")
                        // sign out in case of error
                        GIDSignIn.sharedInstance().signOut()
                    }
                }
            case .none:
                // in testing, we found that the serverAuthCode won't be
                // returned if the user is already signed in to this
                // application. This ensures the user is signed out.
                print("serverAuthCode not retreived")
                GIDSignIn.sharedInstance()?.signOut()
            }
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    // boiler plate code below

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

