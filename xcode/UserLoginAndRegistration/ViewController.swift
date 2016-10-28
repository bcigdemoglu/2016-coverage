//
//  ViewController.swift
//  UserLoginAndRegistration
//
//  Created by Amy He and Naina Rao on 10/17/16.
//  Lots of tears and days of my life went into this. Please be kind
//  Copyright © 2016 Amy He. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //When Protected page loads, present user with login page
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "loginView", sender: self);
    }


}

