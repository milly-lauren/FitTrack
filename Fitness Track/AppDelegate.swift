//
//  AppDelegate.swift
//  Fitness Track
//
//  Created by Juan  on 6/29/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import UIKit
import StitchCore
import StitchRemoteMongoDBService

let stitch = try! Stitch.initializeAppClient(withClientAppID: Constants.STITCH_APP_ID)

var itemsCollection: RemoteMongoCollection<FitnessItem>!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        // Initialize the RemoteMongoClient
        let MongoClient = try! stitch.serviceClient(fromFactory: remoteMongoClientFactory, withName: Constants.ATLAS_SERVICE_NAME)
        
        // Set up Collection
        itemsCollection = MongoClient
            .db(Constants.FITNESS_DATABASE)
            .collection(Constants.FITNESS_ITEMS_COLLECTION, withCollectionType: FitnessItem.self)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>)
    {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
