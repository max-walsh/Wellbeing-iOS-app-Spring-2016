
//  homeTableViewController.swift

import UIKit
import Parse
import SystemConfiguration

class homeTableViewController: UITableViewController {
    
    var otherSurveys: [survey] = [survey]()
    var completedSurveys: [survey] = [survey]()
    var surveysArray: [survey] = [survey]()
    var AllSurveys: [survey] = [survey]()
    var pastSurveyArrays: [survey] = [survey]()
    var futureSurveysArray: [survey] = [survey]()
    var foreverSurveysArray: [survey] = [survey]()
    let cellIdentifier = "homeTableViewCell"
    let cellHeaderIdentifier = "CustomHeaderCell"
    var theSurveySelected = 0;
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var inProgressSurveys: [survey] = [survey]()
    var selectedSurveyGroup = "forever"
    //var currentUser = PFUser.currentUser
    var reset = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true;
        //maketheobjectswithLocalDataStore()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "maketheobjectswithLocalDataStore", name: mySpecialNotificationKey, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "emptyTheArrays", name: updateKey, object: nil)
        
        /*
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
        println("there is a  user")
        } else {
        println("no user")
        self.performSegueWithIdentifier("notAUser", sender: self)
        }*/
        self.tabBarController
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enteredForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        // register hometableview subclass
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellHeaderIdentifier)
        //maketheobjectswithLocalDataStore()
        
        
        if AllSurveys.isEmpty{
            maketheobjectswithLocalDataStore()
        }
        self.tableView.reloadData()
        self.tableView.setNeedsDisplay()
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateTheSurveys"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
    }
    
    func enteredForeground(sender : AnyObject) {
        print("enter foreground home view", terminator: "")
        updateTheSurveys()
        self.tableView.reloadData()
        self.tableView.setNeedsDisplay()
    }
    
    override func viewWillAppear(animated: Bool) {
        updateTheSurveys()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        /*
        //commented for 2 section
        if AllSurveys.isEmpty{
        return 4
        } else{
        return 3
        }
        */
        if AllSurveys.isEmpty{
            return 3
        } else{
            return 2
        }
        
    }
    
    func emptyTheArrays(){
        
        print("emptying arrays, all surevy:\(AllSurveys.count), complete:\(completedSurveys.count), past:\(pastSurveyArrays.count), future:\(futureSurveysArray.count), surveys:\(surveysArray.count), other:\(otherSurveys.count)")
        
        AllSurveys.removeAll(keepCapacity: false)
        completedSurveys.removeAll(keepCapacity: false)
        pastSurveyArrays.removeAll(keepCapacity: false)
        futureSurveysArray.removeAll(keepCapacity: false)
        surveysArray.removeAll(keepCapacity: false)
        foreverSurveysArray.removeAll(keepCapacity: false)
        otherSurveys.removeAll(keepCapacity: false)
        
        //initially this was active line
        //maketheobjectswithLocalDataStore()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        /*
        if(section == 0){
        return surveysArray.count
        }
        else if (section == 1){
        return futureSurveysArray.count
        }
        else if (section == 2){
        return pastSurveyArrays.count
        }
        else{
        if AllSurveys.isEmpty{
        return 1
        }
        //return otherSurveys.count
        return 0
        }*/
        if(section == 0){
            return surveysArray.count
        } else if(section == 1){
            return foreverSurveysArray.count
        }
        else{
            if AllSurveys.isEmpty{
                return 1
            }
            //return otherSurveys.count
            return 0
        }
        
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /*
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! homeTableViewCell? {
            var currentSurvey = survey()
            if (indexPath.section == 0) {
                currentSurvey = surveysArray[indexPath.row]
                //cell.timeLabel.text = "Expires: " + currentSurvey.surveyExpirationTimeNiceFormat
                if currentSurvey.sendDays[0] == 11{
                    cell.timeLabel.text = "24/7, Unlimited Submissions"
                } else{
                    cell.timeLabel.text = currentSurvey.surveyTimeNiceFormat + " - " + currentSurvey.surveyExpirationTimeNiceFormat
                }
                var progress = currentSurvey.getProgress()
                cell.surveyProgressView.setProgress(Float(progress), animated: false)
            }else{
                cell.setDisabledCellLook()
                if (indexPath.section == 1){
                    currentSurvey = futureSurveysArray[indexPath.row]
                    //cell.timeLabel.text = "Begins: " + currentSurvey.surveyTimeNiceFormat
                    cell.timeLabel.text = currentSurvey.surveyTimeNiceFormat + " - " + currentSurvey.surveyExpirationTimeNiceFormat
                }else if(indexPath.section==2){
                    currentSurvey = pastSurveyArrays[indexPath.row]
                    cell.timeLabel.text = "Expired: "+currentSurvey.surveyExpirationTimeNiceFormat
                    
                    if (pastSurveyArrays[indexPath.row].completed){
                        cell.timeLabel.text = "Expired: "+currentSurvey.surveyExpirationTimeNiceFormat+", completed"}
                    else{
                        if contains(currentSurvey.sendDays, SwiftUtils.getDayOfWeek()){
                            cell.timeLabel.text = "Expired: "+currentSurvey.surveyExpirationTimeNiceFormat+", missed"
                        } else{
                            cell.timeLabel.text = "Inactive"
                        }
                    }
                }
            }
            
            
            if (indexPath.section == 3){
                //cell.surveyLabel.text = "Keep your device in wi-fi at night. Survery list will be updated tonight and you will be notified"
                cell.surveyLabel.text = "Keep your device connected to WiFi at night to get surveys from next morning"
                cell.surveyLabel.numberOfLines = 0
                cell.surveyLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                tableView.estimatedRowHeight = 200
            } else{
                cell.surveyLabel.text = currentSurvey.surveyDescriptor
                cell.setCellImage(currentSurvey.surveyDescriptor)
            }
            
            return cell;
        }
        else {
            
            // code most likely will not go here, just a precaution
            return homeTableViewCell( style: UITableViewCellStyle.Default, reuseIdentifier: "Cell" );
        }*/
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! homeTableViewCell? {
            var currentSurvey = survey()
            if (indexPath.section == 0) {
                currentSurvey = surveysArray[indexPath.row]
                let diff = Float(Int(abs(currentSurvey.expirationTime.timeIntervalSinceNow)))
                
                let hour = Int(diff/3600)
                
                let minute = Int((diff - (Float(hour) * 3600))/60)
                //cell.timeLabel.text = currentSurvey.surveyTimeNiceFormat + " - " + currentSurvey.surveyExpirationTimeNiceFormat
                var message = "Expiring in "
                if hour>0 {
                    message += ("\(hour) hour ")
                }
                
                if minute>0 {
                    message += ("\(minute) minutes")
                }
                
                cell.timeLabel.text = message

                let progress = currentSurvey.getProgress()
                cell.surveyProgressView.setProgress(Float(progress), animated: false)
            } else if(indexPath.section == 1){
                currentSurvey = foreverSurveysArray[indexPath.row]
                cell.timeLabel.text = "24/7, Unlimited Submissions"
                let progress = currentSurvey.getProgress()
                cell.surveyProgressView.setProgress(Float(progress), animated: false)
                
            } else{
                cell.setDisabledCellLook()
            }
            
            
            if (indexPath.section == 2){
                //cell.surveyLabel.text = "Keep your device in wi-fi at night. Survery list will be updated tonight and you will be notified"
                cell.surveyLabel.text = "Keep your device connected to WiFi at night to get surveys from next morning"
                cell.surveyLabel.numberOfLines = 0
                cell.surveyLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                tableView.estimatedRowHeight = 200
            } else{
                cell.surveyLabel.text = currentSurvey.surveyDescriptor
                cell.setCellImage(currentSurvey.surveyDescriptor)
            }
            
            return cell;
        }
        else {
            
            // code most likely will not go here, just a precaution
            return homeTableViewCell( style: UITableViewCellStyle.Default, reuseIdentifier: "Cell" );
        }

    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /*
        if let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCell? {
            headerCell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            headerCell.headerLabel.textColor = UIColor.whiteColor()
            if (section == 0){
                headerCell.headerLabel.text = "Current Surveys"
            }
            else if (section == 1){
                headerCell.headerLabel.text = "Future Surveys"
            }
            else if (section == 2){
                headerCell.headerLabel.text = "Past Surveys"
            }
            else{
                //headerCell.headerLabel.text = "other"
                if AllSurveys.isEmpty{
                    headerCell.headerLabel.text = "Message"
                }
                
            }
            return headerCell}
            
        else{
            return CustomHeaderCell( style: UITableViewCellStyle.Default, reuseIdentifier: "HeaderCell" );
        }*/
        if let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCell? {
            headerCell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            headerCell.headerLabel.textColor = UIColor.whiteColor()
            if (section == 0){
                headerCell.headerLabel.text = "Current Surveys"
            } else if(section == 1){
                headerCell.headerLabel.text = "All Time Surveys"
            }else{
                //headerCell.headerLabel.text = "other"
                if AllSurveys.isEmpty{
                    headerCell.headerLabel.text = "Message"
                }
                
            }
            return headerCell}
            
        else{
            return CustomHeaderCell( style: UITableViewCellStyle.Default, reuseIdentifier: "HeaderCell" );
        }
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section==2{
            return 200
        } else{
            return 80
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) ->CGFloat{
        return 50;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0 ){
            theSurveySelected = indexPath.row
            selectedSurveyGroup = "present"
            self.performSegueWithIdentifier("surveySelected", sender: self)
            
        } else if(indexPath.section == 1){
            theSurveySelected = indexPath.row
            selectedSurveyGroup = "forever"
            self.performSegueWithIdentifier("surveySelected", sender: self)
        }
    }
    
    func maketheobjectswithLocalDataStore(){
        //AllSurveys = surveysArray + pastSurveyArrays //
        var survey1 : survey?
        var className = "SurveySummary"
        if SurveySelection == "French" {
            className = "French"
        } else if SurveySelection == "Spanish" {
            className = "Spanish"
        }
        var query = PFQuery(className:className)
        query.fromLocalDatastore()
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                //var query2 = query
                print("where is ghapla..")
                if let objects = objects as? [PFObject] {
                    print("object count:\(objects.count)")
                    if objects.count>0{
                        self.emptyTheArrays()
                    } else{
                        //no object found, so return
                        return
                    }
                    for (var surveyNumber = 0; surveyNumber<objects.count ; surveyNumber++){
                        var duplicate : Bool = false;
                        for survey in self.AllSurveys{
                            if survey.surveyDescriptor == objects[surveyNumber]["Category"] as! String{
                                duplicate=true
                            }
                        }
                        if duplicate == false {
                            var surveyTimes = objects[surveyNumber]["Time"] as! [String]
                            //fix - no time for 11 type (24 hour survey)
                            if let days = objects[surveyNumber]["Days"] as? [Int] {
                                if days[0] == 11{
                                    surveyTimes = ["0:00"]
                                }
                            }
                            //end of fix
                            for (index, time) in surveyTimes.enumerate() {
                                survey1 = survey()
                                survey1!.surveyName = objects[surveyNumber]["Survey"] as! String
                                survey1!.surveyDescriptor = objects[surveyNumber]["Category"] as! String
                                survey1!.active = objects[surveyNumber]["Active"] as! Bool
                                
                                if survey1!.active{
                                    print("survey active:\(survey1!.surveyDescriptor)")
                                } else{
                                    print("survey not active:\(survey1!.surveyDescriptor)")
                                    //continue
                                }
                                
                                if( surveyTimes.count>1){
                                    survey1!.dailyIterationNumber = index+1}
                                survey1!.sendTime = time
                                if let days = objects[surveyNumber]["Days"] as? [Int] {
                                    survey1!.sendDays = days
                                }
                                survey1!.completed = false
                                survey1!.surveyActiveDuration = objects[surveyNumber]["surveyActiveDuration"] as! Double
                                survey1!.versionIdentifier = objects[surveyNumber]["Version"] as! Double
                                survey1!.makeNSdate(true)
                                survey1!.queryParseForSurveyData()
                                self.AllSurveys.append(survey1!)
                                
                            }
                        }
                    }
                    self.updateTheSurveys()
                }else {
                    print("BAD", terminator: "")
                }
                //refresh
                print("refresh the table....")
            }
            else {
                print("FAILED HERE")
                print("Error: \(error) \(error!.userInfo)")
            }
        }
        
    }
    
    func updateTheSurveys(){
        
        
        if !(surveysArray.isEmpty && futureSurveysArray.isEmpty && pastSurveyArrays.isEmpty && foreverSurveysArray.isEmpty){
            AllSurveys = surveysArray + pastSurveyArrays + futureSurveysArray + foreverSurveysArray
            
        } else{
            print("all is empty.....")
        }
        print("will update surveys...\(AllSurveys.count)")
        
        if AllSurveys.count==0{
            print("survey count 0, nothing to update...")
            return
        }
        
        self.surveysArray.removeAll(keepCapacity: false)
        self.futureSurveysArray.removeAll(keepCapacity: false)
        self.pastSurveyArrays.removeAll(keepCapacity: false)
        self.pastSurveyArrays = completedSurveys
        self.foreverSurveysArray.removeAll(keepCapacity: false)
        
        // check the time of each survey created to decide which section it should go in, past , present, or future
        for survey in self.AllSurveys{
            
            if survey.active{
                let surveyState = survey.pastPresentFutureOrForever()
                if(surveyState == "forever"){
                    foreverSurveysArray.append(survey)
                }else if(surveyState == "present"){
                    
                    print("program came here, and survery send days values :\(survey.sendDays)")
                    
                    
                    if(survey.completed){
                        if(survey.sendDays[0] == 11){
                            foreverSurveysArray.append(survey)
                        } else{
                            pastSurveyArrays.append(survey)
                        }
                    } else{
                        surveysArray.append(survey)
                    }
                }
                else if (surveyState == "future"){
                    futureSurveysArray.append(survey)
                }
                else if (surveyState == "past"){
                    pastSurveyArrays.append(survey)
                }
                else if (surveyState == "none"){
                    pastSurveyArrays.append(survey)
                    
                    
                    //otherSurveys.append(survey)
                }
            }
            
        }
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
        self.tableView.setNeedsDisplay()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "surveySelected" {
            let nextView :SurveyTableViewController = segue.destinationViewController as! SurveyTableViewController
            if selectedSurveyGroup == "forever"{
                nextView.currentSurvey = foreverSurveysArray[theSurveySelected]
            } else{
                nextView.currentSurvey = surveysArray[theSurveySelected]
            }
            
        }
    }
}







