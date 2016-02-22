//
//  AppDelegate.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 4/11/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import UIKit
import Parse
import Bolts

let mySpecialNotificationKey = "com.amcmaho4.specialNotificationKey"
let updateKey = "com.amcmaho4.updateKey"
var userEmail = ""
var SurveySelection = ""
var summary : SurveySummary = SurveySummary(a: 0, b: 0)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var currentUser: PFUser?
    
    //var surveyFetchEndTime = 23//3    //*************************CHANGE THIS IF NEEDED ********************//
    //var surveyFetchStartTime = 13//0
    
    var window: UIWindow?
    var sendTime: NSDate = NSDate().dateByAddingTimeInterval(10)
    var allNotificationsForApp: [UILocalNotification]?
    var dataShouldBeReset: Bool?
    var Terminated:Bool? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("Terminated") as? Bool
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue!, forKey: "Terminated")
        }
    }
    
    var userDictionary:NSMutableDictionary?
    
    func reset() ->Bool{
        return dataShouldBeReset!
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        userDictionary = loadAppStateData("user")
        dataShouldBeReset = true
        initializeParse()
        setRootViewController();
        //print("launching", terminator: "")
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        //var minfetch = UIApplicationBackgroundFetchIntervalMinimum  // set to the minimum amount
        
        //if application.respondsToSelector("registerUserNotificationSettings:") {
        if SwiftUtils.isiOS7(){
            //do nothing , as local notification is default in ios 7
        } else{
            let types:UIUserNotificationType = ([.Alert, .Badge, .Sound])
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        //application.registerForRemoteNotifications()
        //}
        //initDataLoadingTest()
        
        // It was in initial source code
        //NSNotificationCenter.defaultCenter().postNotificationName(updateKey, object: self)
        
        return true
    }
    
    func application(application: UIApplication,didRegisterUserNotificationSettings
        notificationSettings: UIUserNotificationSettings){
            
            if notificationSettings.types == []{
                /* The user did not allow us to send notifications */
                return
            }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        //Terminated = true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func initializeParse(){
        Parse.enableLocalDatastore()
        Parse.setApplicationId("wFcqaTXYYCeNqKJ8wswlwtXChEzJyFyBV7N5JOZX",
            clientKey: "MomzqWhPQSVPNZ6hNjXtSSs6Lah5OMQCE8p4amsW")
    }
    
    
    func updateParseLocalDataStore(){
        NSLog("@", "I don't think this method has any usage....")
        var querysurveyStrings: [String] = [String]()
        
        let query: PFQuery = PFQuery(className:"French")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    PFObject.pinAllInBackground(objects)
                    for ob in objects{
                        querysurveyStrings.append(ob["Survey"] as! String)
                    }
                    for surveyString in querysurveyStrings{
                        let querysurvey = PFQuery(className: surveyString)
                        querysurvey.findObjectsInBackgroundWithBlock {
                            (objects: [AnyObject]?, error: NSError?) -> Void in
                            if error == nil {
                                if let objects = objects as? [PFObject] {
                                    PFObject.pinAllInBackground(objects)
                                }
                            }
                        }
                    }
                }
            }else {
                //print("FAILED HERE")
                print("Error: \(error) \(error!.userInfo)")
            }
        }
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // not used
        //let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate:  NSDate())
        let currentHour = components.hour
        //print("Time: ", currentHour)
        
        let surveyFetchStartTime = 0 //1//0//0
        let surveyFetchEndTime = 23 //7//24//3    //*************************CHANGE THIS IF NEEDED ********************//
        
        //print("program will start fetching download")
        if(currentHour >= surveyFetchStartTime && currentHour <= surveyFetchEndTime-1){
            //print("started fetch")
            //print("we will rock you.....")
            
            // Reset daily survey totals
            summary.WeeklyComplete.append(summary.DailyComplete)
            summary.WeeklyTotal.append(summary.DailyTotal)
            //summary.WeeklyTotal.append
            summary.DailyComplete = 0
            summary.DailyTotal = 0

            
            application.cancelAllLocalNotifications()
            // not used
            //var querysurveyStrings: [String] = [String]()
            var className = "French" //"SurveySummary"
            if SurveySelection == "French" {
                className = "French"
            } else if SurveySelection == "Spanish" {
                className = "Spanish"
            }
            var query: PFQuery = PFQuery(className:className)
            query.findObjectsInBackground().continueWithSuccessBlock({
                (task: BFTask!) -> AnyObject! in
                //return PFObject.unpinAllObjectsInBackground().continueWithSuccessBlock({
                    //(ignored: BFTask!) -> AnyObject! in
                    let AllSurveys = task.result as? NSArray
                    for ob in AllSurveys! {
                        let surveyString = ob["Survey"] as! String
                        //print("survey:\(surveyString)")
                        query = PFQuery(className: surveyString)
                        query.findObjectsInBackground().continueWithSuccessBlock({
                            (task: BFTask!) -> AnyObject! in
                            //return PFObject.unpinAllObjectsInBackground().continueWithSuccessBlock({
                                //(ignored: BFTask!) -> AnyObject! in
                                let allQuestions = task.result as? NSArray
                                //print("all questions:\(allQuestions?.count)")
                                return PFObject.pinAllInBackground(allQuestions as? [AnyObject])
                            //})
                        })
                        //print("finish inner block 2")
                        
                    }
                    //NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self)
                    //print("Posted special notification....")
                    TestThread().start()
                    return PFObject.pinAllInBackground(AllSurveys as? [AnyObject])
                //})
            })
            completionHandler(UIBackgroundFetchResult.NewData)
        }
        else {
            completionHandler(UIBackgroundFetchResult.NewData)
        }
    }
    
    func setRootViewController(){
        //self.currentUser = PFUser.currentUser()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let email:String? = SwiftUtils.getUserDatafromPlist("email") as? String
        let consent:Bool! = SwiftUtils.getUserDatafromPlist("consent") as? Bool
        //print("email:\(email)")
        
        if(consent == true){
            if(SwiftUtils.stringIsEmpty(email)){
                let simpleLoginViewController = storyboard.instantiateViewControllerWithIdentifier("simplelogin") ;
                self.window!.rootViewController = simpleLoginViewController
                
            } else{
                userEmail = email!
                self.window?.rootViewController = (storyboard.instantiateInitialViewController() as! UINavigationController)
            }
            
        } else{
            let consentFormVC = storyboard.instantiateViewControllerWithIdentifier("consentform") ;
            self.window!.rootViewController = consentFormVC
            
        }
        
        
        /*
        if let cUser = PFUser.currentUser() {
        println("which one will be selected??, \(PFUser.currentUser())")
        var appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.window?.rootViewController = (storyboard.instantiateInitialViewController() as! UINavigationController)
        }
        else{
        //var loginviewController = storyboard.instantiateViewControllerWithIdentifier("loginView") as! UIViewController;
        println("sign in is going to be loaded")
        var signinviewController = storyboard.instantiateViewControllerWithIdentifier("signinView") as! UIViewController;
        self.window!.rootViewController = signinviewController
        }*/
    }
    
    func initDataLoadingTest(){
        //print("we will rock you.....")
        //application.cancelAllLocalNotifications()
        
        //var querysurveyStrings: [String] = [String]()
        var className = "French" //"SurveySummary"
        if SurveySelection == "French" {
            className = "French"
        } else if SurveySelection == "Spanish" {
            className = "Spanish"
        }
        var query: PFQuery = PFQuery(className:className)
        query.findObjectsInBackground().continueWithSuccessBlock({
            (task: BFTask!) -> AnyObject! in
            //return PFObject.unpinAllObjectsInBackground().continueWithSuccessBlock({
                //(ignored: BFTask!) -> AnyObject! in
                let AllSurveys = task.result as? NSArray
                for ob in AllSurveys! {
                    let surveyString = ob["Survey"] as! String
                    //print("survey:\(surveyString)")
                    query = PFQuery(className: surveyString)
                    query.findObjectsInBackground().continueWithSuccessBlock({
                        (task: BFTask!) -> AnyObject! in
                        //return PFObject.unpinAllObjectsInBackground().continueWithSuccessBlock({
                            //(ignored: BFTask!) -> AnyObject! in
                            let allQuestions = task.result as? NSArray
                            //print("all questions:\(allQuestions?.count)")
                            return PFObject.pinAllInBackground(allQuestions as? [AnyObject])
                        //})
                    })
                }
                //NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self)
                TestThread().start()
                return PFObject.pinAllInBackground(AllSurveys as? [AnyObject])
            //})
        })
    }
    
    
    //app state is saved in plist file, it will be loaded at launch time
    func loadAppStateData(plistFileName:String?)->NSMutableDictionary {
        
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = (documentsDirectory as NSString).stringByAppendingPathComponent(plistFileName! + ".plist")
        
        let fileManager = NSFileManager.defaultManager()
        //fileManager.removeItemAtPath(path, error: nil)
        
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource(plistFileName, ofType: "plist") {
                
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle state.plist file is --> \(resultDictionary?.description)")
                
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch _ {
                }
                print("copy")
            } else {
                print("state.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("state.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Loaded state.plist file is --> \(resultDictionary?.description)")
        return resultDictionary!
    }
}

