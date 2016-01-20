//
//  sliderTableViewCell.swift
//  Swift-TableView-Example
//
//  Created by Anna Jo McMahon on 4/11/15.
//  Copyright (c) 2015 Bilal ARSLAN. All rights reserved.
//

import UIKit

class sliderTableViewCell: UITableViewCell{

	var questionSlider = TLTiltSlider?()
	var sliderLabel = UILabel?()
	var minLabel = UILabel?()
	var maxLabel = UILabel?()
	var viewsDictionary = [String: UIView]()
	let metrics = [ "margin" : 10 , "sliderSize" : 15, "labelSize" : 15, "betweenSliders": 10]
	var sliderAnswers: [String]?
	var sliderQuestion: question?
	var lastEditedAt: NSDate?

	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

	func display(sliderQuestion: question){
	 questionSlider = TLTiltSlider(frame: CGRectMake(50, 50, CGRectGetWidth(self.bounds), 50))
		
		var sliderAnswers = sliderQuestion.answerOptions
		self.selectionStyle = UITableViewCellSelectionStyle.None;
		self.sliderAnswers = sliderAnswers
	
		self.questionSlider?.minimumTrackTintColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
		self.viewsDictionary = ["questionSlider": self.questionSlider! ]
		self.questionSlider!.translatesAutoresizingMaskIntoConstraints = false
		//viewsDictionary["self.questionSlider"] = self.questionSlider
		self.addSubview(self.questionSlider!)
		
		
		var centerLabelConstraint = NSLayoutConstraint(item: self.questionSlider!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
		let horizontalLabelConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[questionSlider]-50-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary)
		self.addConstraint(centerLabelConstraint)
		self.addConstraints(horizontalLabelConstraint)
		self.questionSlider!.maximumValue = Float(self.sliderAnswers!.count - 1)
		self.questionSlider?.value = Float(sliderQuestion.answerIndex)
		
		
		self.sliderLabel?.textColor = UIColor.blackColor().colorWithAlphaComponent(0.4)

		self.sliderLabel = UILabel()
		if(sliderQuestion.answerIndex != -1){
		self.sliderLabel?.text = self.sliderAnswers![ sliderQuestion.answerIndex ]
		}
		else{
			self.sliderLabel?.text = " " // "\(self.sliderAnswers![0]) .... \(self.sliderAnswers![self.sliderAnswers!.count-1])"
		}
		self.sliderLabel!.font = UIFont.systemFontOfSize(20)
		self.sliderLabel!.lineBreakMode = .ByWordWrapping
		self.sliderLabel!.numberOfLines = 0
		self.sliderLabel!.minimumScaleFactor = 0.7
		self.sliderLabel!.textAlignment = .Center
		
		self.sliderLabel!.translatesAutoresizingMaskIntoConstraints = false
		
		viewsDictionary["label"] = self.sliderLabel
		self.addSubview(self.sliderLabel!)
		
		questionSlider!.addTarget(self, action: "sliderAction:", forControlEvents: UIControlEvents.TouchUpInside)
		
		var sliderConstX = NSLayoutConstraint(item: sliderLabel!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        // Original
		//let sliderControlH:  [AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label(>=labelSize)]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: viewsDictionary)
        // Swift2
        let sliderControlH:  [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label(>=labelSize)]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: viewsDictionary)
		self.addConstraint(sliderConstX)
		self.addConstraints(sliderControlH)
		
		
		
		// Make and place the Maximum sider view in the lower left hand corner of the cell
		self.minLabel = UILabel()
		if sliderQuestion.endPointStrings.count > 0 {
			minLabel!.text = sliderQuestion.endPointStrings[0]
		}
		

		self.minLabel!.font = UIFont.systemFontOfSize(12)
		self.minLabel!.lineBreakMode = .ByWordWrapping
		self.minLabel!.numberOfLines = 0
		self.minLabel!.minimumScaleFactor = 0.7
		self.minLabel!.textAlignment = .Center
		self.minLabel!.translatesAutoresizingMaskIntoConstraints = false
		viewsDictionary["minLabel"] = self.minLabel
		self.addSubview(self.minLabel!)
        // Original
		//let minslide:  [AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[minLabel]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: viewsDictionary)
        // Swift2
        let minslide:  [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[minLabel]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: viewsDictionary)
        
		//let minslideV:  [AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:[minLabel]-|", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDictionary)
		self.addConstraints(minslide)
		//self.addConstraints(minslideV)
		
		
		
		// Make and place the Maximum sider view in the lower right hand corner of the cell
		self.maxLabel = UILabel()
		if sliderQuestion.endPointStrings.count > 0 {
			maxLabel!.text = sliderQuestion.endPointStrings[1]
		}
		self.maxLabel!.font = UIFont.systemFontOfSize(12)
		self.maxLabel!.lineBreakMode = .ByWordWrapping
		self.maxLabel!.numberOfLines = 0
		self.maxLabel!.minimumScaleFactor = 0.7
		self.maxLabel!.textAlignment = .Center
		self.maxLabel!.translatesAutoresizingMaskIntoConstraints = false
		viewsDictionary["maxLabel"] = self.maxLabel
		self.addSubview(self.maxLabel!)
        // Original
		//let maxlide:  [AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:[maxLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: viewsDictionary)
        // Swift2
        let maxlide:  [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("H:[maxLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: viewsDictionary)
        
		//let maxlideV:  [AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:[maxLabel]-|", options: NSLayoutFormatOptions(0), metrics: metrics, views: viewsDictionary)
		self.addConstraints(maxlide)
	//	self.addConstraints(maxlideV)
		
        // Original
		//let control_constraintmax:  [AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label(>=labelSize)]-20-[questionSlider]-20-[maxLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary)
        // Swift2
        let control_constraintmax:  [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label(>=labelSize)]-20-[questionSlider]-20-[maxLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary)
		
        // Original
		//let control_constraintmin:  [AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label(>=labelSize)]-20-[questionSlider]-20-[minLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary)
        // Swift2
        let control_constraintmin:  [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label(>=labelSize)]-20-[questionSlider]-20-[minLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: viewsDictionary)
        
		self.addConstraints(control_constraintmax)
		self.addConstraints(control_constraintmin)

		self.sizeToFit()
		
	

		
	
	}
	
	func setValue(curIndex: Int){
		self.questionSlider!.setValue(Float(curIndex), animated: false)
		self.sliderLabel?.text = self.sliderAnswers![ curIndex ]
	}
	
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
		
	}
	
	func sliderAction(sender:UISlider!){
		var indexOfPressed = 0
		sender.setValue(Float(Int(sender.value + 0.5)), animated: false)
		let intval: Int = Int(sender.value)
		self.sliderLabel?.text = self.sliderAnswers![ intval ]
		sliderQuestion?.answerIndex = intval
		sliderQuestion?.answer[0] = "\(intval)"
        //sliderQuestion?.answer[0] = String(sliderQuestion!.numericScale[intval])
		setSelected(true, animated: false)
		self.lastEditedAt = NSDate()
}
	
	
	
	
}



