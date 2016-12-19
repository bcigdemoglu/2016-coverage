//
//  CalendarViewController.swift
//  PlanIt
//
//  Created by CS Student on 12/9/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit

//Class Description: View Controller for the calendar view -- the view an itinerary directly leads to 
//in order to see the 24-hr timeline 

class CalendarViewController: UIViewController {
    
    var date:NSDate?

    @IBOutlet var calendarNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //calendarName will be set by the segue from the itinerary list
    var calendarName = String()
    override func viewWillAppear(_ animated: Bool) {
        calendarNameLabel.text = calendarName
        print("caledarName:")
        print(date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
