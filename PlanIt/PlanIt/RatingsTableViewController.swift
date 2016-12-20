//
//  RatingsTableViewController.swift
//  PlanIt
//
//  Created by CS Student on 12/18/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit
import Foundation

class RatingsTableViewController: UITableViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    //var ratings = [Rating]()
    
    var events = [EKEvent]()
    
    var ratings = [Rating]()
    var rating: Rating?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        loadSampleRatings()
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadSampleRatings() {
        
        let eventStore = EKEventStore();

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        
        let event1 = EKEvent(eventStore: eventStore)
        event1.location = "GIANT"
        event1.startDate = dateFormatter.date(from: "2015-01-01")!

        let event2 = EKEvent(eventStore: eventStore)
        event2.location = "GIANT"
        event1.startDate = dateFormatter.date(from: "2016-01-01")!
        
        let rating1 = Rating(event: event1, location: "Giant", uid: "123", rating: 3)
        let rating2 = Rating(event: event2, location: "Brody Learning Commons", uid: "12345", rating: 3)
        self.ratings = [rating1!, rating2!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.ratings == nil {
            return 0
        }
        return ratings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RatingsTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RatingsTableViewCell
        
        let rating = ratings[indexPath.row]
        
        let location = rating.location
        
        cell.nameLabel.text = location
        
        return cell
    }

    //Segue to the calendar view from each itinerary
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("INTO PREPAREFORSEGUE")
        if (segue.identifier == "showRatingsSegue") {
            let destination = segue.destination as! RatingsViewController
            
            let row = tableView.indexPathForSelectedRow?.row
            //let row = (sender as! IndexPath).row;
            
            let rating = ratings[row!]
            //destination.calendarName = iten.name
            destination.location = rating.location
            destination.event = rating.event
            destination.rating = rating
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
