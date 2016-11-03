//
//  ViewController.swift
//  UserLoginAndRegistration
//
//  Created by Amy He on 10/17/16.
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

