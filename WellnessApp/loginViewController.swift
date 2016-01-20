//
//  loginViewController.swift
//  wellness
//
//  Created by Anna Jo McMahon on 3/2/15.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//

import UIKit
import Parse

class loginViewController: UIViewController {
	@IBOutlet var usernameText: UITextField!
	@IBOutlet var passwordText: UITextField!
	@IBOutlet var loginButton: UIButton!
	@IBOutlet var createAccountButton: UIButton!
	@IBOutlet var backView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
		let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		backView.addGestureRecognizer(tap)
		
    }
	//Calls this function when the tap is recognized.
	func DismissKeyboard(){
		//Causes the view to resign the first responder status (dismisses the keyboard)
		backView.endEditing(true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func loginButtonAction(sender: UIButton) {
        // Original
		//var username = condenseWhitespace(usernameText.text)
        // Swift2
        let username = condenseWhitespace(usernameText.text!)
        // Original
		//var password = condenseWhitespace(passwordText.text)
        // Swift2
        var password = condenseWhitespace(passwordText.text!)
		PFUser.logInWithUsernameInBackground(username, password:password) {
			(user: PFUser?, error: NSError?) -> Void in
			if user != nil { // if there is a user
				//make an instance of the app delegate
				var appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
				var storyboard = UIStoryboard(name: "Main", bundle: nil)
				//dismiss the current view controller, and have the app delegate instantiate the root view controller (this time it is the Navigation controller)
                //userEmail =
				self.dismissViewControllerAnimated(true, completion:{(Bool)  in
					print("login dismissed")
					})
				appdelegate.window?.rootViewController = (storyboard.instantiateInitialViewController() as! UINavigationController)
			} else {
				print("login failed")
				self.showAlert()
				
			}
		}
	}
	
	
	func showAlert(){
		let createAccountErrorAlert: UIAlertView = UIAlertView()
		createAccountErrorAlert.delegate = self
		createAccountErrorAlert.title = "Error"
		createAccountErrorAlert.message = "That is not an account"
		createAccountErrorAlert.addButtonWithTitle("Create Account")
		createAccountErrorAlert.addButtonWithTitle("Dismiss")
		createAccountErrorAlert.show()
	}
	
	func condenseWhitespace(string: String) -> String {
		let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!$0.characters.isEmpty})
		return components.joinWithSeparator(" ")
	}
	
	func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
		switch buttonIndex{
		case 1:
			NSLog("Retry");
			break;
		case 0:
			self.performSegueWithIdentifier("MakeAccount", sender: self)
			break;
		default:
			NSLog("Default");
			break;
		}
	}
	

}
