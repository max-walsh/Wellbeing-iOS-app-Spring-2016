//
//  SurveySummaryViewController.swift
//  WellnessApp
//
//  Created by Max Walsh on 2/14/16.
//  Copyright © 2016 anna. All rights reserved.
//

import UIKit

class SurveySummaryViewController: UIViewController {

    @IBOutlet weak var CompletedToday: UILabel!
    @IBOutlet weak var TotalToday: UILabel!
    @IBOutlet weak var SevenDayCompleted: UILabel!
    @IBOutlet weak var SevenDayTotal: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CompletedToday.text? = "\(summary.DailyComplete)"
        TotalToday.text? = "\(summary.DailyTotal)"
        SevenDayCompleted.text? = "\(summary.WeeklyComplete)"
        SevenDayTotal.text? = "\(summary.WeeklyTotal)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
