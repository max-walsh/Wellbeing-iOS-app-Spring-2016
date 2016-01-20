//
//  consentViewController.swift
//  WellnessApp
//
//  Created by Sudip Vhaduri on 11/22/15.
//  Copyright (c) 2015 anna. All rights reserved.
//


import UIKit

class consentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        forceAccept()
        
    }
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func forceAccept(){
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let simpleLoginViewController = storyboard!.instantiateViewControllerWithIdentifier("simplelogin") ;
        appdelegate.window!.rootViewController = simpleLoginViewController
        SwiftUtils.setUserDatatoPlist("consent", value: true)
    }
    
    
    @IBAction func acceptConsent(sender: AnyObject) {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        let simpleLoginViewController = storyboard!.instantiateViewControllerWithIdentifier("simplelogin") ;
        appdelegate.window!.rootViewController = simpleLoginViewController
        SwiftUtils.setUserDatatoPlist("consent", value: true)

    }
}
