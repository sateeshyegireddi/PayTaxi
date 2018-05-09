//
//  AppDelegate.swift
//  PayTaxiDriver
//
//  Created by Sateesh on 4/30/18.
//  Copyright © 2018 PayTaxi. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - Variables
    var window: UIWindow?
    var longitude = 0.0
    var latitude = 0.0
    let locationManager = CLLocationManager()
    var firstButtonId: String!
    var secondButtonId: String!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        //Init varaiables
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        firstButtonId = ""
        secondButtonId = ""
        
        //Initialise Keychain access instance for only once across the application.
        ///Note: If the keychain service will not work if we are initialising it multiple times, so make sure to use singleton instance whenever we are using it anywhere in the application...
        let _ = Keychain(serviceName: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
        
        //If init value on first launch
        if !UserDefaults.standard.bool(forKey: GlobalConstants.UserDefaultsConstants.kLaunchedBefore) {
            
            // Set UserDefaults
            UserDefaults.standard.set(true, forKey: GlobalConstants.UserDefaultsConstants.kLaunchedBefore)
            UserDefaults.standard.set(false, forKey: GlobalConstants.UserDefaultsConstants.kAutoLogin)
            UserDefaults.standard.synchronize()
            
            //Set language
            UtilityFunctions().saveLanguage(GlobalConstants.Localisation.english)
            
            //Set Keychain
            UtilityFunctions().clearKeychainData()
        }
        
        //Normal mode check of the user is loged aready or not
        if UserDefaults.standard.bool(forKey: GlobalConstants.UserDefaultsConstants.kAutoLogin) {
            
            //Handle on receive push notification
            //On receive remote notification move user to Order screen
            let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
            
            //Extract pushNotification message from notification
            if let notificationDict = notification as? [String: Any] {
                
                if let apsInfo = notificationDict["aps"] as? [String: Any] {
                    
                    let category = apsInfo["category"] as? String ?? ""
                    
                    move(to: category)
                }
            } else {
                
                self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "Splash") as! Splash
            }
        }
        
        //Initialize Fabric/crashlytics
        //        Fabric.with([Crashlytics.self])
        
        //Assign API key to Google Services and Places
        GMSServices.provideAPIKey(GlobalConstants.GoogleKeys.APIKey)
        GMSPlacesClient.provideAPIKey(GlobalConstants.GoogleKeys.APIKey)
        
        //Register app for remote notification
        registerForRemoteNotification()
        
        //Register app for location updates
        registerForLocationUpdates()
        
        return true
    }

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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    //MARK: - Push notifications
    
    func registerForRemoteNotification() {
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                
                print("registerForRemoteNotification")
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            // Fallback on earlier versions
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, .badge, .sound]
            let notificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            DispatchQueue.main.async {
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format: "%02x",byte)
        }
        
        print("Device Token: \(token)")
        
        UtilityFunctions().saveDeviceToken(token)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("User Info = ",userInfo)
    }
    //MARK: - Private Functions
    @available(iOS 10.0, *)
    fileprivate func addNotificationActions(_ userInfo: [String: Any], toCategory category: String) {
        
        //Create custom notification actions array
        var actions = [UNNotificationAction]()
        
        //Create and add notification action to actions array
        if let action1 = userInfo["action1"] as? [String: Any] {
            if let buttonTitle = action1["title"] as? String {
                firstButtonId = buttonTitle.lowercased()
                let action = UNNotificationAction(identifier: buttonTitle.lowercased(), title: buttonTitle, options: [.foreground])
                actions.append(action)
            }
        }
        
        if let action2 = userInfo["action2"] as? [String: Any] {
            if let buttonTitle = action2["title"] as? String {
                secondButtonId = buttonTitle.lowercased()
                let action = UNNotificationAction(identifier: buttonTitle.lowercased(), title: buttonTitle, options: [])
                actions.append(action)
            }
        }
        
        //Check if the actions are exist
        if actions.count > 0 {
            
            //Create notification category with actions
            let category = UNNotificationCategory(identifier: category, actions: actions, intentIdentifiers: [], options: [])
            
            //Register categories to notification center
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }
    }
    
    fileprivate func move(to category: String) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let navigation = storyboard.instantiateViewController(withIdentifier: "Navigation") as! Navigation
        //        window?.rootViewController = navigation
        //
        //        //Move user to associate screen
        //        switch category {
        //
        //        case GlobalConstants.PushNotificationNavigation.electricity.rawValue:
        //            OpenScreen().electricityBillPayments(navigation)
        //
        //        case GlobalConstants.PushNotificationNavigation.gas.rawValue:
        //            OpenScreen().gasBillPaymentsScreen(navigation)
        //
        //        case GlobalConstants.PushNotificationNavigation.landlineBroadband.rawValue:
        //            OpenScreen().landlineBillPayments(navigation)
        //
        //        case GlobalConstants.PushNotificationNavigation.busBooking.rawValue:
        //            OpenScreen().bookedTickets(navigation)
        //
        //        default:
        //            break
        //        }
    }
    
    //MARK: - Core Location
    
    func registerForLocationUpdates() {
        
        // Get Device Location -- get let and long of user location
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PayTaxiDriver")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cadiridris.coreDataTemplate" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "PayTaxiDriver", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("PayTaxiDriver.sqlite")
        print(url.absoluteString)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        if #available(iOS 10.0, *) {
            return persistentContainer.viewContext
        } else {
            let coordinator = self.persistentStoreCoordinator
            var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext.persistentStoreCoordinator = coordinator
            return managedObjectContext
        }
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}

//MARK: - UNUserNotificationCenter Delegate

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //        print("User Info = ",notification.request.content.userInfo)
        
        let bestAttemptContent = (notification.request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            
            if let userInfo = bestAttemptContent.userInfo as? [String: Any] {
                
                addNotificationActions(userInfo, toCategory: bestAttemptContent.categoryIdentifier)
            }
        }
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
        
        //If app is in background/inactive state show alertView on click notification
        //On receive remote notification move user to particular screen
        
        let actionButtonId = response.actionIdentifier
        
        //Check if the first button has been tapped
        if firstButtonId == actionButtonId {
            
            //Move to particular screen
            //TODO: Send the action parameters to particular screen
        }
        
        //Check if the second button has been tapped
        if secondButtonId == actionButtonId {
            
            //Do nothing..!
            return
        }
        
        //Create category object
        let category = response.notification.request.content.categoryIdentifier
        
        //Move user to particular screen
        move(to: category)
    }
}

//MARK: - CLLocationManager Delegate

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Save user location if geo-coordinates are empty
        if latitude == 0.0 && longitude == 0.0 {
            
            let coordinates = manager.location!.coordinate
            print("latitude is:  \(coordinates.latitude) and  longitude is:\(coordinates.longitude)")
            locationManager.stopUpdatingLocation()
            locationManager.pausesLocationUpdatesAutomatically = true
            latitude = coordinates.latitude
            longitude = coordinates.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Failed to Get User Location. Error Is :: \(error.localizedDescription)")
    }
}
