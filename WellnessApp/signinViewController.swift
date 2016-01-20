//  signinViewController.swift
//  wellness
//
//  Created by Anna Jo McMahon on 3/2/15.
//

import UIKit
import Parse
class signinViewController: UIViewController {
    
    
    @IBOutlet var usernameText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    @IBOutlet var passwordText: UITextField!
    
    @IBOutlet var backView: UIView!
    
    @IBOutlet var signinbackView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameText.hidden = true
        
        
        //Looks for single or multiple taps.
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        signinbackView.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        signinbackView.endEditing(true)
    }
    
    
    
    @IBAction func createButtonAction(sender: UIButton) {
        
        let user = PFUser()
        //user.username = condenseWhitespace(usernameText.text)
        //original
        //user.password = condenseWhitespace(passwordText.text)
        user.password = condenseWhitespace(passwordText.text!)
        // original
        //user.username = condenseWhitespace(emailText.text)
        user.username = condenseWhitespace(emailText.text!)
        
        
        //  		 other fields can be set just like with PFObject
        // original
        /* user["userID"] = UIDevice.currentDevice().identifierForVendor.UUIDString */
        user["userID"] = UIDevice.currentDevice().identifierForVendor!.UUIDString
        user["currentAppVersion"] = "ND-WB-SAV-2015-06-12"
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                print("signed UP")
                self.DismissKeyboard()
                userEmail = user.username!
                let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                appdelegate.window?.rootViewController = (storyboard.instantiateInitialViewController() as! UINavigationController)
                //self.performSegueWithIdentifier("signupSegue", sender: self)
                
                
            } else {
                let errorString = error!.localizedDescription
                //println(errorString)
                // Show the errorString somewhere and let the user try again.
                print("NOT signed UP")
                self.showAlert(errorString)
            }
        }
    }
    func condenseWhitespace(string: String) -> String {
        let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!$0.characters.isEmpty})
        return components.joinWithSeparator(" ")
    }
    
    
    func showAlert(error: NSString){
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        
        createAccountErrorAlert.delegate = self
        createAccountErrorAlert.title = "Sign Up not successful"
        createAccountErrorAlert.message = "Username or Email is already taken"
        createAccountErrorAlert.addButtonWithTitle("OK")
        createAccountErrorAlert.show()
    }
    
    
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
            
        case 0:
            NSLog("Retry");
            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
            
        }
    }
    
    
    
    
    
}
