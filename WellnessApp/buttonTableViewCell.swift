//
//  buttonTableViewCell.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 4/11/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import UIKit

class buttonTableViewCell: UITableViewCell {
	
	var buttonLabel: UILabel?
    var buttonImage: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	func setAnswer(answersOptions: [String] ,answerInd: Int){
		self.buttonLabel = UILabel()
		self.buttonLabel!.text = answersOptions[answerInd]
        //self.buttonLabel!.text = "why"
		let viewsDictionary: [String: UILabel] = ["buttonLabel": self.buttonLabel! ]
		self.buttonLabel!.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(self.buttonLabel!)
		
		
		let centerLabelConstraint = NSLayoutConstraint(item: self.buttonLabel!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
		
		let vertPosLabelConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[buttonLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary)
		let horizontalLabelConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[buttonLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary)
		self.addConstraint(centerLabelConstraint)
		self.addConstraints(vertPosLabelConstraint)
		self.addConstraints(horizontalLabelConstraint)
		
	}
    
    func setAnswerImage(answerInd: Int, leftJustify: Bool) {
        let images = ["veryHappy.png", "happy.png", "sad.png", "angry.png", "veryAngry.png"]
        let img = UIImage(named: images[answerInd])
        //self.buttonImage =
        self.buttonImage = UIImageView(image: img)
        let viewsDictionary: [String: UIImageView] = ["buttonLabel": self.buttonImage!]
        self.buttonImage!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.buttonImage!)
        
        let vertConstraint = NSLayoutConstraint(item: self.buttonImage!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
        let rightHorConstraint = NSLayoutConstraint(item: self.buttonImage!, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1.0, constant: 0.0)
        let leftHorConstraint = NSLayoutConstraint(item: self.buttonImage!, attribute: NSLayoutAttribute.LeadingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1.0, constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: self.buttonImage!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0.3, constant: 0.0)
        //let heightConstraint = NSLayoutConstraint(item: self.buttonImage!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 0.0, constant: 10.0)
        let topConstraint = NSLayoutConstraint(item: self.buttonImage!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        
        
        self.addConstraint(vertConstraint)
        if leftJustify {
            self.addConstraint(leftHorConstraint)
        } else {
            self.addConstraint(rightHorConstraint)
        }
        //self.addConstraint(horConstraint)
        self.addConstraint(widthConstraint)
        //self.addConstraint(heightConstraint)
        self.addConstraint(topConstraint)
        
    }
    
	func display(){
		//self.buttonLabel =
	}
	
		
	

}
