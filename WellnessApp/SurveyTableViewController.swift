//
//  SurveyTableViewController.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 4/11/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import UIKit
import Parse
import SystemConfiguration
let myUpdateTableKey = "com.amcmaho4.updateKey"

// original
//class SurveyTableViewController: UITableViewController, UIScrollViewDelegate, UITextFieldDelegate {
// Swift2
class SurveyTableViewController: UITableViewController, UITextFieldDelegate {
    var currentSurvey : survey = survey()
    var completed = false
    @IBOutlet var nextbutton: UIBarButtonItem!
    
    @IBOutlet var up: UIBarButtonItem!
    
    @IBOutlet var down: UIBarButtonItem!
    var tap:UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        // Sorts curent Survey
        currentSurvey.questions.sortInPlace({$0.questionID < $1.questionID})
        super.viewDidLoad()
        up.imageInsets.left = self.tableView.frame.width/4
        down.imageInsets.left = 3*self.tableView.frame.width/4
        self.tableView.separatorColor = UIColor.blackColor()
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top)
        self.navigationController?.toolbarHidden = false
        tableView!.rowHeight = UITableViewAutomaticDimension
        tableView!.estimatedRowHeight = 80
        tableView!.sectionHeaderHeight = 100.0
        let dummyViewHeight:CGFloat = 100.0;
        let dummyFrame = CGRectMake(0, 0, self.tableView!.bounds.size.width, dummyViewHeight);
        let dummyView = UIView(frame : dummyFrame)
        self.tableView!.tableHeaderView = dummyView;
        self.tableView!.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
        self.tableView!.allowsMultipleSelection = true
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        print("load the individual survey  view controller", terminator: "")
        completed = false
        
        
        
        tap = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        tableView.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "listenForTap", name: UIKeyboardDidShowNotification, object: nil)
        tap.enabled = false
        
        
        
    }
    func listenForTap(){
        tap.enabled = true
    }
    func DismissKeyboard() {
        
        tableView.endEditing(true)
        tap.enabled = false
        let visiblePaths :NSArray  = tableView.indexPathsForVisibleRows!
        for path in visiblePaths {
            if let cell = tableView.cellForRowAtIndexPath(path as! NSIndexPath) as? textResponseTableViewCell {
                // Original
                //currentSurvey.questions[path.section].answer[0] = cell.responseText.text
                // Swift2
                currentSurvey.questions[path.section].answer[0] = cell.responseText.text!
                // Original
                //if cell.responseText.text.isEmpty{
                // Swift2
                if cell.responseText.text!.isEmpty{
                    currentSurvey.questions[path.section].answerIndex = -1
                } else{
                    currentSurvey.questions[path.section].answerIndex = 99
                }
                //currentSurvey.questions[path.section].answer[0] = "test text"
                //cell.responseText.text
                
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        DismissKeyboard()
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        //updateParseDataStore()
        //println("leaving the individual survey  view controller")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        for question in currentSurvey.questions{
            question.answer = [""]
            question.answerIndex = -1
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentSurvey.questions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSurvey.questions[section].answerType == "Button" {
            return currentSurvey.questions[section].answerOptions.count
        }
        else if currentSurvey.questions[section].answerType == "Checkbox" {
            return currentSurvey.questions[section].answerOptions.count
            
        }
        else{
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentQuestionString = currentSurvey.questions[section].questionString as String
        
        
        let headerView = questionHeaderAnswerView(frame: CGRectMake(10, 10, self.tableView.bounds.width, tableView.sectionHeaderHeight), questionString: currentQuestionString)//
        headerView.displayView()
        return headerView
    }
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        updateVisibleSliderCells()
    }
    
    
    func updateVisibleSliderCells(){
        let visiblePaths :NSArray  = tableView.indexPathsForVisibleRows!
        for path in visiblePaths {
            if let cell = tableView.cellForRowAtIndexPath(path as! NSIndexPath) as? sliderTableViewCell {
                if let time = cell.lastEditedAt as NSDate?{
                    currentSurvey.questions[path.section].answerIndex = Int(cell.questionSlider!.value)
                    currentSurvey.questions[path.section].answer[0] = "\(Int(cell.questionSlider!.value))"
                    //currentSurvey.questions[path.section].answer[0] = String(currentSurvey.questions[path.section].numericScale[Int(cell.questionSlider!.value)])
                    currentSurvey.questions[path.section].timeStamp = time
                }
            }
        }
        
    }
    
    
    @IBAction func pressed(sender: AnyObject) {
        print("bar button action", terminator: "")
        
        // Original
        //var last = tableView.indexPathsForVisibleRows!.last as! NSIndexPath
        // Swift2
        let last = tableView.indexPathsForVisibleRows!.last!
        
        var lastSection = (tableView.indexPathsForVisibleRows?.last!.section)!
        
        if lastSection-1 >= 0{
            // because if only part of a section is showing you want to continue to show it
            lastSection -= 1
        }
        let firstSection = (tableView.indexPathsForVisibleRows?.first!.section)!
        let lastSectionNumberOfRows = tableView.numberOfRowsInSection(lastSection+1)
        
        let rect: CGRect = self.tableView.bounds;
        var distanceToScroll:CGFloat = 0;
        
        if tableView.numberOfSections == lastSection+2 {
            let cellIndexToScroll = NSIndexPath(forRow: lastSectionNumberOfRows-1 , inSection: tableView.numberOfSections-1)
            self.tableView.scrollToRowAtIndexPath(cellIndexToScroll, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
        }
            
        else{
            //var lastRect = tableView.rectForRowAtIndexPath(last)
            
            for (var i=firstSection; i<=lastSection ; i++){
                distanceToScroll += tableView.rectForSection(i).height
                
            }
            let scrollToRect: CGRect = CGRectOffset(rect, 0, distanceToScroll);
            self.tableView.scrollRectToVisible(scrollToRect, animated: true)
        }
        
        
        
    }
    @IBAction func backbutton(sender: AnyObject) {
        print("bar button action", terminator: "")
        let last: AnyObject = tableView.indexPathsForVisibleRows!.last!
        
        var lastSection = (tableView.indexPathsForVisibleRows?.last!.section)!
        if lastSection-1 >= 0{
            lastSection -= 1
        }
        
        //var lastt = tableView.indexPathsForVisibleRows().last
        
        let firstSection = (tableView.indexPathsForVisibleRows?.first!.section)!
        //var lastSectionNumberOfRows = tableView.numberOfRowsInSection(lastSection)
        
        let rect: CGRect = self.tableView.bounds;
        //var lastRect = tableView.rectForRowAtIndexPath(last as! NSIndexPath)
        var distanceToScroll:CGFloat = 0;
        for (var i=firstSection; i<=lastSection ; i++){
            distanceToScroll += tableView.rectForSection(i).height
            let scrollToRect: CGRect = CGRectOffset(rect, 0, -distanceToScroll);
            self.tableView.scrollRectToVisible(scrollToRect, animated: true)
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var reuseIdentifier = "cell"
        if(indexPath.section>currentSurvey.questions.count || indexPath.row>currentSurvey.questions[indexPath.section].answerOptions.count){
            let cell = UITableViewCell()
            cell.tintColor = UIColor.blueColor()
            print("here", terminator: "")
        }
        
        if currentSurvey.questions[indexPath.section].answerType == "Button" {
            let cell = buttonTableViewCell()
            cell.setAnswer(currentSurvey.questions[indexPath.section].answerOptions, answerInd: indexPath.row)
            //test
            cell.setAnswerImage()
            setTheStateAtIndexPath(indexPath) // selects/ deselects the appropriate cells
            return cell
        }
        else if currentSurvey.questions[indexPath.section].answerType == "Checkbox" {
            print("i am here......")
            let cell = buttonTableViewCell()
            cell.selected = false
            cell.setAnswer(currentSurvey.questions[indexPath.section].answerOptions, answerInd: indexPath.row)
            setTheStateAtIndexPathCheck(indexPath) // selects/ deselects the appropriate cells
            return cell
        }
        else if currentSurvey.questions[indexPath.section].answerType == "Textbox" {
            let cell = tableView.dequeueReusableCellWithIdentifier("textCell") as! textResponseTableViewCell!
            //currentSurvey.questions[indexPath.section].answer[0] = cell.responseText.text
            cell.responseText.text = currentSurvey.questions[indexPath.section].answer[0]
            
            if cell.responseText.delegate == nil{
                cell.responseText.delegate = self
            }
            print("tetx box loading.......")
            return cell
        }
        else{
            let cell = sliderTableViewCell()
            cell.display(currentSurvey.questions[indexPath.section])
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if currentSurvey.questions[indexPath.section].answerType == "Button" {
            currentSurvey.questions[indexPath.section].answerIndex = -1
            currentSurvey.questions[indexPath.section].answer = [""]
        }

    }
    
    //override func tableView(tableView: UITableView,
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if currentSurvey.questions[indexPath.section].answerType == "Button" {
            currentSurvey.questions[indexPath.section].answerIndex = indexPath.row
            currentSurvey.questions[indexPath.section].answer[0] = "\(indexPath.row)"

            currentSurvey.questions[indexPath.section].unixTimeStamp = NSDate().timeIntervalSince1970 * 1000
            
            //update the tableview values
            let visiblePaths :NSArray  = tableView.indexPathsForVisibleRows!
            for path in visiblePaths{
                setTheStateAtIndexPath(path as! NSIndexPath)
            }
        }
        else if currentSurvey.questions[indexPath.section].answerType == "Textbox"{
            
            //			let cell = tableView.cellForRowAtIndexPath(indexPath) as! textResponseTableViewCell
            //			var words = cell.responseText.text
            //currentSurvey.questions[indexPath.section].answer.append("hello")
            print("is there any way to print this???")
        }
        else if currentSurvey.questions[indexPath.section].answerType == "Checkbox"{
            //currentSurvey.questions[indexPath.section].answerIndex = indexPath.row
            currentSurvey.questions[indexPath.section].answerIndex = indexPath.row
            
            
            
            let currentAnswers:[String] = currentSurvey.questions[indexPath.section].answer
            currentSurvey.questions[indexPath.section].unixTimeStamp = NSDate().timeIntervalSince1970 * 1000
            
            tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: false)
            
            //let currentSelectedAnswer = String(currentSurvey.questions[indexPath.section].numericScale[indexPath.row])
            let currentSelectedAnswer = "\(indexPath.row)"
            if currentAnswers.contains (currentSelectedAnswer) {
                for (index, a) in currentAnswers.enumerate () {
                    
                    if a == currentSelectedAnswer {
                        currentSurvey.questions[indexPath.section].answer.removeAtIndex(index)
                        continue
                    }
                    
                }
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
            }
            else{
                currentSurvey.questions[indexPath.section].answer.append("\(indexPath.row)")
                //currentSurvey.questions[indexPath.section].answer.append("\(currentSurvey.questions[indexPath.section].numericScale[indexPath.row])")
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            }
            
            //
            //			override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
            //
            //				if currentSurvey.questions[indexPath.section].answerType == "Checkmark" {
            //					var currentAnswers = currentSurvey.questions[indexPath.section].answer
            //					if contains (currentAnswers, "\(indexPath.row)") {
            //						tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
            //						for (index, a) in enumerate (currentAnswers) {
            //							if a == "\(indexPath.row)" {
            //								currentAnswers.removeAtIndex(index)
            //								continue
            //							}
            //						}
            //					}
            //				}
            //}
            //
            //			//update the tableview values
            //			var visiblePaths :NSArray  = tableView.indexPathsForVisibleRows()!
            //			for path in visiblePaths{
            //				setTheStateAtIndexPathCheck(path as! NSIndexPath)
            //			}
        }
            
        else{
            // slider view data is gathered when the user scrolls
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? sliderTableViewCell
            {
                
            }
        }
    }
    
    
    func setTheStateAtIndexPath(path: NSIndexPath){
        if(currentSurvey.questions[path.section].answerIndex != -1 && currentSurvey.questions[path.section].answerIndex == path.row){
            tableView.selectRowAtIndexPath(path, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
        else if currentSurvey.questions[path.section].answer.contains("\(path.row)"){
            tableView.selectRowAtIndexPath(path, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
        else{
            tableView.deselectRowAtIndexPath(path, animated: false)

        }
    }
    

    
    func setTheStateAtIndexPathCheck(path: NSIndexPath){
        
        print("current question:\(currentSurvey.questions[path.section].answer)")
        
        
        if(currentSurvey.questions[path.section].answerIndex != -1 && currentSurvey.questions[path.section].answerIndex == path.row){
            tableView.cellForRowAtIndexPath(path)?.accessoryType = .Checkmark
            print("should select checkmark \(path.row)")
        }
        else if currentSurvey.questions[path.section].answer.contains("\(path.row)"){
            tableView.cellForRowAtIndexPath(path)?.accessoryType = .Checkmark
            print("should select checkmark 2nd way \(path.row)")
        }
        else{
            tableView.cellForRowAtIndexPath(path)?.accessoryType = .None
            print("should select none \(path.row)")
        }
    }
    
    
    
    
    @IBAction func SubmitButtonAction(sender: UIButton){
        
        //DismissKeyboard()
        // check if all the questions have been answered
        updateVisibleSliderCells()
        if(currentSurvey.getProgress() != 1){
            createNotDoneAlertView(currentSurvey.getAnswered())
        }
        else{
            updateParseDataStore()
            currentSurvey.completed = true
            currentSurvey.surveyCompletedTime = NSDate()
            //var notifCount = currentSurvey.notifications.count
            currentSurvey.cancelNotifications()
            currentSurvey.makeNSdate(true)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func createNotDoneAlertView(answered: CGFloat){
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        createAccountErrorAlert.delegate = self
        //createAccountErrorAlert.title = "Are you sure would like to submit?"
        //createAccountErrorAlert.title = "Are you sure to submit the survey PARTIALLY?"
        //createAccountErrorAlert.message = "You have answered \( Int(answered))/\(currentSurvey.questions.count) questions"
        if(Int(answered)>0){
            createAccountErrorAlert.title = "Are you sure to submit the survey PARTIALLY?"
            createAccountErrorAlert.message = "You have answered \( Int(answered)) out of \(currentSurvey.questions.count) questions"
            createAccountErrorAlert.addButtonWithTitle("Submit")
            createAccountErrorAlert.addButtonWithTitle("Continue Working")
        }
        else{
            createAccountErrorAlert.title = "You haven't answered any question"
            //createAccountErrorAlert.message = "You haven't answered any question"
            createAccountErrorAlert.addButtonWithTitle("Okay")
        }
        //createAccountErrorAlert.addButtonWithTitle("Submit")
        //createAccountErrorAlert.addButtonWithTitle("Continue Working")
        createAccountErrorAlert.show()
    }
    
    func updateParseDataStore(){
        for questionN in currentSurvey.questions{
            if(questionN.answerIndex>=0){
                //var surveyResponse = PFObject(className:"testingSurveyDataCollection")
                let surveyResponse = PFObject(className:"TestingNew1")
                surveyResponse["surveyID"] = currentSurvey.versionIdentifier
                surveyResponse["userEmail"] = userEmail
                
                surveyResponse["appID"] = "SB-WB-SAV-2015-11-25"
                // Original
                //surveyResponse["userID"] = UIDevice.currentDevice().identifierForVendor.UUIDString
                // Swift2
                surveyResponse["userID"] = UIDevice.currentDevice().identifierForVendor!.UUIDString
                
                ////surveyResponse["questionResponseString"] = questionN.answerOptions[questionN.answerIndex]
                //surveyResponse["questionResponse"] = questionN.answerIndex
                
                //surveyResponse["questionResponseArray"] = questionN.answer
                if questionN.answerType == "Textbox"{
                    surveyResponse["questionResponse"] = questionN.answer
                } else{
                    let length = questionN.answer.count
                    if length==1 && questionN.answer[0]==""{
                        continue
                    }
                    var transformedAnswer:[String] = []
                    for(var i=0;i<length;i++){
                        let myString : String = questionN.answer[i]
                        let x: Int? = Int(myString)
                        
                        if (x != nil) {
                            // Successfully converted String to Int
                            let transform:String = String(questionN.numericScale[x!])
                            if !transform.isEmpty {
                                transformedAnswer.append(transform)
                            }
                        }
                    }
                    surveyResponse["questionResponse"] = transformedAnswer
                }
                
                surveyResponse["Category"] = currentSurvey.surveyDescriptor
                
                surveyResponse["unixTimeStamp"] = questionN.timeStamp.timeIntervalSince1970*1000
                surveyResponse["questionID"] = questionN.questionID
                surveyResponse.saveEventually()
                
                //clear all answer for next time loading
                questionN.answer = [""]
                questionN.answerIndex = -1
            }
            
        }
        
        let objects: [AnyObject] = currentSurvey.questions
        if let objects = objects as? [PFObject] {
            PFObject.pinAllInBackground(objects)
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        footerView.backgroundColor = UIColor.blackColor()
        
        return footerView
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    //send the entire
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToHomeScreen" {
            let nextView :homeTableViewController = homeTableViewController()
            nextView.inProgressSurveys.append(currentSurvey)
        }
    }
    override func didMoveToParentViewController(parent: UIViewController?){
        if let parent = parent as? homeTableViewController{
            if completed{
                parent.completedSurveys.append(currentSurvey)
            }
            else{
                parent.inProgressSurveys.append(currentSurvey)
            }
        }
    }
    
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        /*
        switch buttonIndex {
        default:
            println("alertView \(buttonIndex) clicked")
            if(Int(currentSurvey.getAnswered())==0){
                println("You didn't answer any question")
            }else{
                println("You have answered \( Int(currentSurvey.getAnswered())) out of \(currentSurvey.questions.count) questions")
            }
        }
        */
        print("alertView \(buttonIndex) clicked")
        switch buttonIndex{
        case 0:
            if(Int(currentSurvey.getAnswered())==0){
                print("You didn't answer any question")
            }else{
                currentSurvey.surveyCompletedTime = NSDate()
                currentSurvey.completed = true;
                currentSurvey.cancelNotifications()
                currentSurvey.makeNSdate(true)
                print("going to update parse store")
                updateParseDataStore()
                //	NSNotificationCenter.defaultCenter().postNotificationName(myUpdateTableKey, object: self)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            /*
            currentSurvey.surveyCompletedTime = NSDate()
            currentSurvey.completed = true;
            currentSurvey.cancelNotifications()
            currentSurvey.makeNSdate(true)
            println("going to update parse store")
            updateParseDataStore()
            //	NSNotificationCenter.defaultCenter().postNotificationName(myUpdateTableKey, object: self)
            self.navigationController?.popToRootViewControllerAnimated(true)
            */
            break;
        case 1:
            NSLog("Retry");
            break;
        default:
            NSLog("Default");
            break;
        }

    }
    
    
}
