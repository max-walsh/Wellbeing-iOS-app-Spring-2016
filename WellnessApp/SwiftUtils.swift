//
//  SwiftUtils.swift
//  WellnessApp
//
//  Created by Sudip Vhaduri on 7/4/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import Foundation


class SwiftUtils{
    
    static func getDayOfWeek()->Int {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday - 1
        return weekDay
    }

    
    static func getUserDatafromPlist(key:String?)->AnyObject!{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dict:NSMutableDictionary? = appDelegate.userDictionary
        if(dict != nil){
            return dict?.valueForKey(key!) as AnyObject?
        }
        return nil
    }
    
    
    static func setUserDatatoPlist(key:String?, value:AnyObject?){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dict:NSMutableDictionary? = appDelegate.userDictionary
        if(dict != nil){
            dict?.setValue(value, forKey: key!)
            updatePlistFile(dict, plistFile: "user")
        }
    }
    
    static func updatePlistFile(dict:NSMutableDictionary?, plistFile:String){
        dispatch_async(dispatch_get_main_queue(), {
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
            let documentsDirectory = paths.objectAtIndex(0) as! NSString
            let path = documentsDirectory.stringByAppendingPathComponent(plistFile + ".plist")
            
            dict!.writeToFile(path, atomically: true)
            
            let resultDictionary = NSMutableDictionary(contentsOfFile: path)
            print("Saved \(plistFile).plist file is --> \(resultDictionary?.description)")
            
        })
    }
    
    static func stringIsEmpty(checkString:String!)->Bool{
        if let myString = checkString{
            if myString.isEmpty{
                return true
            } else{
                return false
            }
        } else {
            return false
        }
    }
    
    static func isiOS7()->Bool{
        let device = UIDevice.currentDevice()
        let iosVersion = NSString(string: device.systemVersion).doubleValue
        return iosVersion < 8
    }

}