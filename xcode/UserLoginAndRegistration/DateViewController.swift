//
//  DateViewController.swift
//  UserLoginAndRegistration
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //if saveButton === sender {        }
        
        
        //let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE MMM dd"
        
        let strDate = dateFormatter.string(from: dateField.date)
        let dateChosen = strDate
        
        let name = dateChosen ?? ""
        
        itinerary = Itinerary(name: name)
        
        var request = URLRequest(url: URL(string: "http://oose-2016-group-13.herokuapp.com/login")!)
        request.httpMethod = "POST"
        let postString = "Date: " + strDate
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
