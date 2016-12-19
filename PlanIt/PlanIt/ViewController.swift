//
//  ViewController.swift
//  PlanIt
//
//  Created by Naina Rao on 11/1/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit

//Class Description: Parent class for all the view controllers of this project

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.performSegue(withIdentifier: "loginView", sender: self);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //When Protected page loads, present user with login page
    override func viewDidAppear(_ animated: Bool) {
        //self.performSegue(withIdentifier: "loginView", sender: self);
    }
    
    
}

