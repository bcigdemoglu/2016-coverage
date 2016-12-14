//
//  ItineraryTableViewController.swift
//  PlanIt
//
//  Created by Naina Rao on 10/30/16.
//  Copyright © 2016 Amy He. All rights reserved.
//

import UIKit
import Foundation


class ItineraryTableViewController: UITableViewController {

    // MARK: Properties 
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var itineraries = [Itinerary]()
    
    var itinerary: Itinerary?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        

        loadRealItineraries()
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        
    
        
 /**       if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rightViewRevealWidth = 150
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            **/
            
     //   }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    func loadSampleItineraries() {
        let it1 = Itinerary(name: "Mon Oct 31", uid : "1234567")!

        let it2 = Itinerary(name: "Halloween", uid : "12345678910xasdf")!
        
        self.itineraries = [it1, it2]
    }
    
    func loadRealItineraries() {
        getItineraryListShells(userID: "alex") { list, errormsg in
            if (list != nil) {
                self.itineraries = list!
                self.tableView.reloadData()
            } else { //might eventually put something here to handle a bad response
                print(errormsg)
                self.displayAlertMessage(myMessage: errormsg)
                //self.loadSampleItineraries()
                //self.tableView.reloadData()
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.itineraries == nil {
            return 0
        }
        return itineraries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ItineraryTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ItineraryTableViewCell
        
        let iten = itineraries[indexPath.row]
        cell.nameLabel.text = iten.name


        return cell
    }
    
    @IBAction func unwindToItineraryList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DateViewController, let itinerary = sourceViewController.itinerary {
            
            let newIndexPath = IndexPath(row: itineraries.count, section: 0)
            itineraries.append(itinerary)
            //tableView.insertRows(at: [newIndexPath], with: .bottom)
        }
        
        
    }

    func displayAlertMessage(myMessage:String) {
        let alertController = UIAlertController(title: "Alert", message: myMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    let calendarSegueIdentifier = "ShowCalendarSegue"
    
    // MARK: - Navigation
    //Segue to the calendar view from each itinerary
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("INTO PREPAREFORSEGUE")
        if  segue.identifier == calendarSegueIdentifier,
            let destination = segue.destination as? CalendarViewController,
            let calendarIndex = tableView.indexPathForSelectedRow?.row
        {
            let iten = itineraries[calendarIndex]
//            destination.calendarName = iten.name
            print("iten.name is", iten.name)
            print(calendarIndex)
        }
    }

    //Test if this works 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Find the selected cell in the usual way
        var cell = self.tableView.cellForRow(at: indexPath as IndexPath)!
        // Check if this is the cell I want to segue from by using the reuseIdenifier
        // which I set in the "Identifier" field in Interface Builder
        // Do my conditional logic - this was the whole point of changing the segue
        let calendarIndex = tableView.indexPathForSelectedRow?.row
        let iten = itineraries[calendarIndex!]
        self.performSegue(withIdentifier: "ShowCalendarSegue", sender: cell)
        
            //            destination.calendarName = iten.name
        print("iten.name is", iten.name)
        print(calendarIndex)
        
    }
        //TO implement later for storage of itineraries
/**
    private func loadItems() {
        if let filePath = pathForItems() , FileManager.default.fileExists(atPath: filePath) {
            if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Itinerary] {
                itineraries = archivedItems
            }
        }
    }
    
    private func pathForItems() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
     
        if let documents = paths.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.appendingPathComponent("items.plist")?.path
        }
        
        return nil
    }
    
    private func saveItems() {
        if let filePath = pathForItems() {
            NSKeyedArchiver.archiveRootObject(itineraries, toFile: filePath)
        }
    }
 **/
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
