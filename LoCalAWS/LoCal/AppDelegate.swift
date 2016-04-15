//
//  AppDelegate.swift
//  LoCal
//
//  Created by Tyler Reardon on 2/23/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: LocationManager?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        locationManager = LocationManager()
        locationManager?.getAddressFromCurrentLocation({ (location) -> Void in
            if(location != nil){
                print(location!)
            }
        })
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1, identityPoolId:"arn:aws:iam::883016283162:role/Cognito_LoCalAuth_Role")
        
        let defaultServiceConfiguration = AWSServiceConfiguration(
            region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = defaultServiceConfiguration
        
        // Initialize the Cognito Sync client
        let syncClient = AWSCognito.defaultCognito()
        
        // Create a record in a dataset and synchronize with the server
        var dataset = syncClient.openOrCreateDataset("myDataset")
        dataset.setString("myValue", forKey:"myKey")
        dataset.synchronize().continueWithBlock {(task: AWSTask!) -> AnyObject! in
            // Your handler code here
            return nil
            
        }
        
//        let dynamoDB = AWSDynamoDB.defaultDynamoDB()
//        let listTableInput = AWSDynamoDBListTablesInput()
//        dynamoDB.listTables(listTableInput).continueWithBlock{ (task: AWSTask!) -> AnyObject? in
//            if let error = task.error {
//                print("Error occurred: \(error)")
//                return nil
//            }
//            
//            let listTablesOutput = task.result as! AWSDynamoDBListTablesOutput
//            
//            for tableName : AnyObject in listTablesOutput.tableNames! {
//                print("\(tableName)")
//            }
//            
//            return nil
//        }
        
        
        return true
    }
    
    func applicationDidFinishLaunching(application: UIApplication) {
       
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

