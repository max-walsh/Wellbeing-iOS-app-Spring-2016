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
    
    func setAnswerImage(/*images: [UIImage], answerInd: Int*/) {
        let img = UIImage(named: "up.png")
        //self.buttonImage =
        self.buttonImage = UIImageView(image: img)
        self.buttonImage!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.buttonImage!)
        let vertConstraint = NSLayoutConstraint(item: self.buttonImage!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)

        
        let horConstraint = NSLayoutConstraint(item: self.buttonImage!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        print("start setAnswerImage called\n\n\n\n\n\n")
        //let widthConstraint = NSLayoutConstraint.
        //self.buttonImage!.addConstraint(vertConstraint)
        //self.buttonImage!.addConstraint(horConstraint)
        self.addConstraint(vertConstraint)
        self.addConstraint(horConstraint)
        print("setAnswerImage called\n\n\n\n\n\n")
    }
    
	func display(){
		//self.buttonLabel =
	}
	
		
	

}
