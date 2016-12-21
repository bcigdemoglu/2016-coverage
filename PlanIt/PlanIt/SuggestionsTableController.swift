//
//  LocationSearchTable.swift
//  PlanIt
//
//  Created by Naina Rao on 12/18/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit
import MapKit

@objc class LocationSearchTable: UITableViewController{

    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    weak var currentViewController: UIViewController?
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    
    public var mgcPlanView: MGCDayPlannerView?
    public var mgcParent: WeekViewController = WeekViewController()
    public var mgcView: MGCDayPlannerEKViewController?
    public var mgc: MGCDayPlannerEKViewControllerDelegate?
    public var data: MGCDayPlannerViewDataSource?
    public var event: EKEvent?
    public var ekVC: EKEventViewController?
    public var vcEdit: EKEventEditViewController?
    //public var store: EKEventStore = EKEventStore()
    public var vcEditDel: EKEventEditViewDelegate?
    public var eventTypeNum: UInt = 1
    public var date: NSDate?
    public var eventKit: MGCEventKitSupport = MGCEventKitSupport()
    public var location: String?
    
    
    var suggestions = [SuggestionInfo]()
    var suggestion: SuggestionInfo? //a specific itinerary

    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let d : String = formatter.string(from : date as! Date)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let st : String = formatter.string(from : event!.startDate)
        let en : String = formatter.string(from : event!.endDate)
        
        createEvent(start:st, end: en, date: d) {
            intCode, responseString in
            switch intCode {
            case 201:
                self.askSuggestions(eventId : responseString!, eventQ: self.event!.title) {
                    arrayResponse, responseString in
                    //func askSuggestions(eventId : String, eventQuery : String) {
                    if (arrayResponse != nil) {
                        self.suggestions = arrayResponse!
                        self.tableView.reloadData()
                    }
                }
            default:
                break;
                //print(responseString!)
            }
            
        }
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //var vcEditDel: EKEventEditViewDelegate = (vcEdit?.editViewDelegate)!
        //vcEditDel.didCompleteWithAction(1)
        
        tableView.tableFooterView = UIView()
        NSLog("Opening Suggestions");
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        loadSampleSuggestions()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadSampleSuggestions() {
        let dataString1 = "April 1, 2017"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateValue1 = dateFormatter.date(from: dataString1) as NSDate!
        
        let dataString2 = "December 31, 2017"
        //var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
      //  let dateValue2 = dateFormatter.date(from: dataString2) as NSDate!
        
        
        let sug1 = SuggestionInfo(name: "Location 1", numberStars: 5)
        
        let sug2 = SuggestionInfo(name: "Location 2",numberStars: 4)
        
        let sug3 = SuggestionInfo(name:self.location!, numberStars: 3)

        self.suggestions = [sug1, sug2, sug3]
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.suggestions == nil {
            return 0
        }
        return suggestions.count
    }
    
    //Function to link the cell to appropriate identified and labels of cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SuggestionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SuggestionsTableViewCell
        
        let sug = suggestions[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE MMM dd"
        //let strDate = dateFormatter.string(from: (sug.date as NSDate) as Date as Date)
        
        cell.nameLabel.text = sug.displayName
        
        return cell
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        //self.event?.location = "CHANGED"
        self.bringEditController()
        //vcEditDel?.eventEditViewController(vcEdit!, didCompleteWith: EKEventEditViewAction(rawValue: 1)!)
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        //self.event?.location = "CHANGED"
        
        eventKit.save(self.event, completion: nil)
        print(self.location)
        performSegue(withIdentifier: "backToCalendarView", sender: self)

        //mgcPlanView?.allowsSelection = true
       // mgcPlanView?.selectEvent(of: MGCEventType(rawValue: index)!, at: index, date: self.date as Date!)
        //mgcPlanView?.selectEvent(of: MGCEventType: index, at: 0, date: self.date as Date!)
        
    }
    
    func backToEdit() {
        
        var btn2 = UIBarButtonItem(
            title: "Dead",
            style: .plain,
            target: self,
            action: #selector(doneButtonPressed(_:))
        )
        var eventController = EKEventEditViewController()
        //let eventController: EKEventEditViewController = self.vcEdit!
        eventController.event = self.event
        let store: EKEventStore = (self.vcEdit?.eventStore)!
        eventController.eventStore = store
        eventController.editViewDelegate = self.vcEditDel
        // called only when event is deleted
        eventController.isModalInPopover = true
        eventController.modalPresentationStyle = .popover
        eventController.presentationController?.delegate = self.mgcView
        eventController.navigationItem.rightBarButtonItem = btn2
        //eventController.delegate = self.delegate;
        // self.mgcParent.presentationController?.delegate
        //vcEditDel.presentationController?
        self.addChildViewController(eventController)
        eventController.view.frame = CGRect(x:0, y:0, width:self.containerView.frame.size.width, height: self.containerView.frame.size.height);
        self.containerView.addSubview(eventController.view)
        eventController.didMove(toParentViewController: self)
    }


//    func navigationController(_ navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
//        if (viewController is UITableViewController) {
//            var tableView = (viewController as! UITableViewController).tableView
//            for j in 0..<tableView?.numberOfSections {
//                for i in 0..<tableView.numberOfRowsInSection(j) {
//                    var cell = tableView.cellForRow(at: IndexPath(row: i, section: j))!
//                    
//                    print("cell => \(cell.textLabel!.text), row => \(i), section => \(j)")
//                    if j == 1 && i == 0 {
//                        //  [cell removeFromSuperview];
//                        var a = UIButton(type: .roundedRect)
//                        var width: CGFloat = cell.frame.size.width
//                        var height: CGFloat = cell.frame.size.height
//                        var x: CGFloat = cell.frame.origin.x
//                        //CGFloat y = cell.frame.origin.y;
//                        a.frame = CGRect(x: x, y: CGFloat(4.5), width: width, height: height)
//                        a.backgroundColor = UIColor.white
//                        a.addTarget(self, action: #selector(self.seeSuggestions), for: .touchUpInside)
//                        a.setTitle("See Suggestions", for: .normal)
//                        cell.addSubview(a)
//                        var switchBtn = UISwitch(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(20), height: CGFloat(10)))
//                        cell.accessoryView! = switchBtn
//                        switchBtn.backgroundColor = UIColor.white
//                        switchBtn.addTarget(self, action: #selector(self.seeSuggestions), for: .valueChanged)
//                        cell.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(14))
//                    }
//
//                }
//            }
//        }
//        else if i == 4 && j == 1 {
//            
//        }
//        
//    }
    
    func askSuggestions(eventId : String, eventQ : String, completionHandler : @escaping ([SuggestionInfo]?, String?) -> ()) {
        getSuggestionsForEvent(eventId: eventId, eventQuery: eventQ ) {
            array, responseString in
            if array != nil {
                completionHandler(array, nil)
            } else {
                completionHandler(nil, responseString)
            }
            
        }
    }
    
    
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
*/
    
    func bringEditController() {
        
        var eventStore = EKEventStore()
        var event = EKEvent(eventStore: eventStore)
        event.startDate = (self.event?.startDate)!
        event.endDate = (self.event?.endDate)!
        event.location = self.location
        
        //event.notes = event_note
        var addController = EKEventEditViewController(nibName: nil, bundle: nil)
        // set the addController's event store to the current event store.
        addController.eventStore = eventStore
        addController.event = event
        // present EventsAddViewController as a modal view controller
        parent?.present(addController, animated: true, completion: nil)
        addController.editViewDelegate = self.mgcView as! EKEventEditViewDelegate?


    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = (segue.destination as! UINavigationController).topViewController as! MainViewController
        destination.calDate = self.date as Date!
        
        //mgcPlanView?.selectEvent(of: MGCEventType(rawValue: UInt(1))!, at: 1, date: self.date as Date!)
       // let mgcevent: MGCEKEventViewController = MGCEKEventViewController()
        //mgcevent.event = self.event!

        //mgcPlanView?.selectEvent(of: MGCEventType(rawValue: self.eventTypeNum)!, at: 0, date: self.date as Date!)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let row = tableView.indexPathForSelectedRow?.row
        
        //let sugg = tableView.cellForRow(at: indexPath)
        //let cellIdentifier = "ItineraryTableViewCell"
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ItineraryTableViewCell
        
        let sugg = suggestions[indexPath.row]
        self.event?.location = sugg.displayName
       // cell.nameLabel.text = strDate
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

}

 


