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
    
    var index: UInt = 1
    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        //var vcEditDel: EKEventEditViewDelegate = (vcEdit?.editViewDelegate)!
        //vcEditDel.didCompleteWithAction(1)
        
        tableView.tableFooterView = UIView()
        NSLog("Opening Suggestions");
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
               //self.event?.location = "CHANGED"

        print(self.location)
        print(String(describing: self.date) as String?)
        print(self.event?.eventIdentifier)
        print(self.event?.calendarItemIdentifier)

        //self.backToEdit()
        //vcEditDel?.eventEditViewController(vcEdit!, didCompleteWith: EKEventEditViewAction(rawValue: 1)!)
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        //self.event?.location = "CHANGED"
        
        eventKit.save(self.event, completion: nil)
        print(self.location)
        print(String(describing: self.date) as String?)
        eventKit.save(self.event, completion: nil)
        
        performSegue(withIdentifier: "backToCalendarView", sender: self)

        mgcPlanView?.allowsSelection = true
        mgcPlanView?.selectEvent(of: MGCEventType(rawValue: index)!, at: index, date: self.date as Date!)
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
    
    //
    //  LocationSearchTable.swift
    //  MapKitTutorial
    //
    //  Created by Robert Chen on 12/28/15.
    //  Copyright © 2015 Thorn Technologies. All rights reserved.
    //
    


        
 


