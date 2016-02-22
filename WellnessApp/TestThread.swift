//
//  TestThread.swift
//  WellnessApp
//
//  Created by Max Walsh on 2/22/16.
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
        
        
    //} while(!self.canceled)
    NSThread.exit()
    }
}