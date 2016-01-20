//
//  question.swift
//  wellness
//
//  Created by Anna Jo McMahon on 3/17/15.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//

import Foundation

class question {
	
	var answerOptions:[String]!
	var questionString : String!
	var answerType : String!
	var timeStamp : NSDate
	var answerIndex : Int
	var answer : [String]
	var unixTimeStamp: Double
	var questionID :Int
	var endPointStrings: [String]
	var Timestamp: Double {
		get {
			return (NSDate().timeIntervalSince1970 * 1000)
		}
	}
    var numericScale : [Int]
	
	init(){
		self.questionString = ""
		self.answerType = ""
		self.answerOptions = ["", ""]
		self.answerIndex = -1
		self.timeStamp = NSDate()
		self.unixTimeStamp = 0
		self.questionID = 0
		self.endPointStrings = ["", ""]
		self.answer = [""]
        self.numericScale = []
	}
	
	func getLongestStringAnswer() -> (String) {
		var longest: String = answerOptions[0]
		var longestCount = longest.characters.count
		for word in answerOptions {
			let wordCount = word.characters.count;
			if wordCount > longestCount {
				longest = word
				longestCount = wordCount
			}
		}
		
		return (longest)
	}
	
	
	
}