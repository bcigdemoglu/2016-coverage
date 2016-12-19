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
    
    public var mgcView: MGCDayPlannerEKViewController?
    public var mgc: MGCDayPlannerEKViewControllerDelegate?
    public var data: MGCDayPlannerViewDataSource?
    public var event: EKEvent?
    public var vcEdit: EKEventEditViewController?

    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentA")
//        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
//        self.addChildViewController(self.currentViewController!)
//        self.addSubview(self.currentViewController!.view, toView: self.containerView)
//        super.viewDidLoad()
        
//        let btn2 = UIButton(type: .custom)
//        btn2.setImage(UIImage(named: "Done"), for: .normal)
//        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        btn2.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
//        let item2 = UIBarButtonItem(customView: btn2)
//        
//        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "test.png"), style: .plain, target: self, action: nil)
//        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
//        
//        self.navigationItem.setRightBarButton(item2, animated: true)
        
        tableView.tableFooterView = UIView()
        NSLog("Opening Suggestions");
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        
    }
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
     //   mgc.pop
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //
    //  LocationSearchTable.swift
    //  MapKitTutorial
    //
    //  Created by Robert Chen on 12/28/15.
    //  Copyright © 2015 Thorn Technologies. All rights reserved.
    //
    
    
        
        func parseAddress(_ selectedItem:MKPlacemark) -> String {
            
            // put a space between "4" and "Melrose Place"
            let firstSpace = (selectedItem.subThoroughfare != nil &&
                selectedItem.thoroughfare != nil) ? " " : ""
            
            // put a comma between street and city/state
            let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
                (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
            
            // put a space between "Washington" and "DC"
            let secondSpace = (selectedItem.subAdministrativeArea != nil &&
                selectedItem.administrativeArea != nil) ? " " : ""
            
            let addressLine = String(
                format:"%@%@%@%@%@%@%@",
                // street number
                selectedItem.subThoroughfare ?? "",
                firstSpace,
                // street name
                selectedItem.thoroughfare ?? "",
                comma,
                // city
                selectedItem.locality ?? "",
                secondSpace,
                // state
                selectedItem.administrativeArea ?? ""
            )
            
            return addressLine
        }
        
    }
    

    
    extension LocationSearchTable {
        
//        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: IndexPath) -> NSIndexPath{
//            return matchingItems.count
//        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            let selectedItem = matchingItems[(indexPath as NSIndexPath).row].placemark
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel?.text = parseAddress(selectedItem)
            return cell
        }
        
    }

        
 


