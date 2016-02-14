//
//  TestThread.swift
//  WellnessApp
//
//  Created by Wellness App on 2/2/16.
//  Copyright © 2016 anna. All rights reserved.
//

import Foundation

class TestThread: NSThread {
    
    override init() {
        
    }
    override func main() {
        //repeat{
        
        NSThread.sleepForTimeInterval(20)
        NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self)
        
        
        //} while(!self.cancelled)
        NSThread.exit()
    }
}