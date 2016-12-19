//
//  RatingsViewController.swift
//  PlanIt
//
//  Created by CS Student on 12/19/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit

class RatingsViewController: UIViewController {

    @IBOutlet var locationName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var location = String()
    override func viewWillAppear(_ animated: Bool) {
        locationName.text = location
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
