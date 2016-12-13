//
//  DateViewController.swift
//  PlanIt
//
//  Created by Naina Rao on 10/30/16.
//  Copyright © 2016 Amy He. All rights reserved.
//

import UIKit

class DateViewController: UIViewController{

    @IBOutlet weak var dateField: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new meal.
     */
    
    var itineraries = [Itinerary]()
    
    var itinerary: Itinerary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //if saveButton === sender {        }
        
        
        //let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE MMM dd"
        
        let strDate = dateFormatter.string(from: dateField.date)
        let dateChosen = strDate
        
        let name = dateChosen ?? ""
        //TODO:  Convert Date chosen into the 
        //createEvent(userID: String, start: <#T##String#>, end: <#T##String#>, date: <#T##String#>, completionHandler: <#T##(Int, String?) -> ()#>)
        //TODO:  Make sure this get actually set
        let uid = "newRandomString"
        itinerary = Itinerary(name: name, uid : uid)
        
               
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    

}
