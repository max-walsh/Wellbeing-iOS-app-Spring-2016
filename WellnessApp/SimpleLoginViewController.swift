//
//  SimpleLoginViewController.swift
//  WellnessApp
//
//  Created by Sudip Vhaduri on 7/4/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import UIKit

class SimpleLoginViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var optionPicker: UIPickerView!
    
    var pickerData = ["English", "Spanish", "French", "Bangla"]
    override func viewDidLoad() {
        super.viewDidLoad()

        optionPicker.delegate = self
        optionPicker.dataSource = self
        textEmail.delegate = self
        // Do any additional setup after loading the view.
        forceLogin()
        
    }

    func forceLogin(){
        
        SurveySelection = "French"
        SwiftUtils.setUserDatatoPlist("email", value: textEmail.text)
        // Original
        //userEmail = textEmail.text
        // Swift2
        userEmail = textEmail.text!
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //appdelegate.window?.rootViewController = (storyboard!.instantiateInitialViewController() as! UINavigationController)
        appdelegate.window?.rootViewController = (storyboard!.instantiateInitialViewController() as! UITabBarController)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func DismissKeyboard() {
        
        self.textEmail.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        DismissKeyboard()
        return false
    }


    @IBAction func loginPressed(sender: AnyObject) {
        let row = optionPicker.selectedRowInComponent(0)
        SurveySelection = self.pickerData[row]
        //print("email from text:\(textEmail.text), option picked:\(self.pickerData[row])")
        SwiftUtils.setUserDatatoPlist("email", value: textEmail.text)
        // Original
        //userEmail = textEmail.text
        // Swift2
        userEmail = textEmail.text!
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //appdelegate.window?.rootViewController = (storyboard!.instantiateInitialViewController() as! UINavigationController)
        appdelegate.window?.rootViewController = (storyboard!.instantiateInitialViewController() as! UITabBarController )

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(self.pickerData[row])"
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    
}
