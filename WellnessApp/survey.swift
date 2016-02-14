//
//  survey.swift
//  wellness
//
//  Created by Anna Jo McMahon on 3/17/15.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//

import Foundation
import UIKit

//import SQLite
import Parse
class survey {
    //data pulled from the parse data store:
    var questions : [question] = [question]()
    var surveyName : String!
    var surveyTime : NSDate!
    var sendTime: String
    var surveyActiveDuration: Double = 0
    var versionIdentifier:Double = 0.0
    var active: Bool
    var sendDays: [Int]
    var surveyDescriptor : String
    
    var userEmail: String
    var updated : Bool!
    //displayed on the home screen
    var surveyTimeNiceFormat : String
    var surveyExpirationTimeNiceFormat : String
    var taken = false
    var dailyIterationNumber: Int?
    var expirationTime: NSDate!
    var possibleSendDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var notifications = [UILocalNotification]()
    var completed: Bool
    var surveyCompletedTime: NSDate?
    
    
    init(){
        self.questions = [question]()
        self.surveyName = ""
        self.surveyTime = NSDate()
        self.updated = false
        self.sendTime = ""
        self.surveyDescriptor = ""
        self.surveyTimeNiceFormat = ""
        self.surveyExpirationTimeNiceFormat = ""
        self.userEmail = ""
        sendDays = [0,1,2,3,4,5,6]
        active = true
        completed = false
    }
    
    
    func getProgress()->CGFloat{
        var answered: CGFloat = 0
        for question in self.questions{
            if(question.answerIndex != -1){
                answered++
            }
        }
        let progress: CGFloat = answered/CGFloat(self.questions.count)
        return progress
    }
    func getAnswered()->CGFloat{
        var answered: CGFloat = 0
        for question in self.questions{
            if(question.answerIndex != -1){
                answered++
            }
        }
        return answered
    }
    
    func queryParseForSurveyData(){
        var tempQuest : question = question()
        let query = PFQuery(className:surveyName)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for (var q = 0; q<objects.count ; q++){
                        tempQuest = question()
                        tempQuest.answerOptions = objects[q]["options"] as! [String]
                        tempQuest.numericScale = objects[q]["numericScale"] as! [Int]
                        
                        tempQuest.answerType = objects[q]["questionType"] as! String
                        tempQuest.questionString = objects[q]["question"] as! String
                        tempQuest.questionID = objects[q]["questionId"] as! Int
                        tempQuest.endPointStrings = objects[q]["endPoints"] as! [String]
                        
                        self.questions.append(tempQuest)
                    }
                }
            } else {
                print("Error: \(error) \(error!.userInfo)")
            }
        }
        
        
        
        
        
    }
    func pastPresentFutureOrForever()->String{
        print("survey name:\(surveyName), survey days:\(sendDays)")
        if(self.active == true){
            if(self.sendDays[0] == 11){
                return "forever"
            }
            if self.sendDays.contains(SwiftUtils.getDayOfWeek()) {
                if( expirationTime.timeIntervalSinceNow > 0 && surveyTime.timeIntervalSinceNow < 0){
                    //print("present survey, expiration time:\(expirationTime), survey time:\(surveyTime)")
                    return "present"
                }
                else if(expirationTime.timeIntervalSinceNow < 0 ){
                    /*
                    println("return past/future , expiration time:\(expirationTime), survey time:\(surveyTime)")
                    var startOfToday:NSDate!
                    
                    if SwiftUtils.isiOS7(){
                        let calendar = NSCalendar.currentCalendar()
                        
                        // define unit flag groupings used to set specific date components
                        var fullDateUnitFlags = NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitDay
                        
                        let currentDateComponents = calendar.components(fullDateUnitFlags, fromDate: NSDate())
                        
                        let sd = NSDateComponents()
                        
                        sd.day = currentDateComponents.day
                        sd.month = currentDateComponents.month
                        sd.year = currentDateComponents.year
                        sd.hour = 0
                        sd.minute = 0
                        
                        startOfToday = calendar.dateFromComponents(sd)

                    } else{
                        startOfToday = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
                    }
                    
                    if startOfToday.timeIntervalSince1970 > expirationTime.timeIntervalSince1970{
                        completed = false
                        makeNSdate(false)
                        return pastPresentFutureOrForever()
                    } else{
                        return "past"
                    }*/
                    completed = false
                    makeNSdate(false)
                    return "past"
                } else {
                    //print("return future, expiration time:\(expirationTime), survey time:\(surveyTime)")
                    return "future"
                }
            }
        }
        //print("return none, expiration time:\(expirationTime), survey time:\(surveyTime)")
        return "none"
    }
    
    
    func makeNSdate(makeNotification:Bool){
        //instantiate a calendar
        let calendar = NSCalendar.currentCalendar()
        
        // define unit flag groupings used to set specific date components
        let fullDateUnitFlags: NSCalendarUnit = [NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Month, NSCalendarUnit.Year, NSCalendarUnit.Day]
        let justTimeUnitFlags: NSCalendarUnit = [NSCalendarUnit.Hour, NSCalendarUnit.Minute]
        
        //get the current time date components from the string retrieved from parse
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let surveyDateTime = dateFormatter.dateFromString(sendTime)
        
        let surveyDateTimeComponents =  calendar.components(justTimeUnitFlags, fromDate: surveyDateTime!)
        
        let currentDate = NSDate()
        let currentDateComponents = calendar.components(fullDateUnitFlags, fromDate: currentDate)
        
        // set survey date time = time of survey retrieved form parse
        //set all other date components to that of the current date
        let surveyDateComponents = NSDateComponents()
        surveyDateComponents.minute = surveyDateTimeComponents.minute
        surveyDateComponents.hour = surveyDateTimeComponents.hour
        if currentDateComponents.hour > surveyDateComponents.hour && completed{
            //surveyDateComponents.day = currentDateComponents.day + 1
            surveyDateComponents.day = currentDateComponents.day + nextSurveyDay()
        } else if (currentDateComponents.hour == surveyDateComponents.hour && currentDateComponents.minute > surveyDateComponents.minute) && completed{
            surveyDateComponents.day = currentDateComponents.day + nextSurveyDay()
        } else{
            
            if self.sendDays.contains(SwiftUtils.getDayOfWeek()) {
                surveyDateComponents.day = currentDateComponents.day
            } else{
                surveyDateComponents.day = currentDateComponents.day + nextSurveyDay()
            }
        }
        
        surveyDateComponents.year = currentDateComponents.year
        surveyDateComponents.month = currentDateComponents.month
        let surveyDate = calendar.dateFromComponents(surveyDateComponents)
        surveyTime = surveyDate!
        self.makeFormatedStringDate()
        self.makeExpirationTime()
        if self.active && makeNotification{
            if self.sendDays[0] == 11{
                //do not need to set notification for 24 hour surveys
            } else{
                makeNotifications()
            }
            
        }
        
    }
    
    func nextSurveyDay()->Int{
        let currentDay = SwiftUtils.getDayOfWeek()
        var result = 0
        if self.sendDays[0] == 11{
            return 0
        }
        for day in self.sendDays{
            if(day>currentDay){
                result = day - currentDay
                if(result<0 && result>6){
                    return 0
                } else{
                    return result
                }
            }
        }
        
        result = (7 - currentDay) + self.sendDays[0]
        if(result<0 && result>6){
            return 0
        } else{
            return result
        }
    }
    
    func makeFormatedStringDate(){
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "E, h:mm a"
        surveyTimeNiceFormat = dayTimePeriodFormatter.stringFromDate(surveyTime)
    }
    
    func makeExpirationTime(){
        self.expirationTime = surveyTime.dateByAddingTimeInterval(surveyActiveDuration*60)
        makeFormatedStringDateExpiration()
    }
    
    func makeFormatedStringDateExpiration(){
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "E, h:mm a"
        surveyExpirationTimeNiceFormat = dayTimePeriodFormatter.stringFromDate(expirationTime)
    }
    func makeNotifications() {
        let timeIntervalToAdd = (surveyActiveDuration/4)*60 //in minutes
        let notificationTimes = [surveyTime,
            surveyTime.dateByAddingTimeInterval(timeIntervalToAdd),
            surveyTime.dateByAddingTimeInterval(timeIntervalToAdd*2),
            surveyTime.dateByAddingTimeInterval(timeIntervalToAdd*3)]
        
        let datefomatter = NSDateFormatter()
        datefomatter.dateFormat = "yy/MM/dd HH:mm:ss"
        let startTime = datefomatter.stringFromDate(surveyTime)
        let endTime = datefomatter.stringFromDate(expirationTime)
        
        for sendTime in notificationTimes {
            let reminder = UILocalNotification()
            reminder.fireDate = sendTime
            reminder.timeZone = NSTimeZone.localTimeZone()
            reminder.alertBody = "s:" + startTime + ", e:" + endTime +  ",Time to take your "+surveyDescriptor + " survey"
            reminder.soundName = UILocalNotificationDefaultSoundName
            reminder.repeatInterval = NSCalendarUnit.Day
            notifications.append(reminder)
            UIApplication.sharedApplication().scheduleLocalNotification(reminder)
        }
    }
    
    func makeNotificationsFromTomorrow(){
        
    }
    
    func cancelNotifications(){
        for notification in notifications{
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    
    
}