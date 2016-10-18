//
//  RegisterPageViewController.swift
//  UserLoginAndRegistration
//
//  Created by Amy He on 10/17/16.
//  Copyright © 2016 Amy He. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonTapped(sender: AnyObject) {
        let userName = userNameTextField.text;
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        //Alex: send userName, userEmail, and userPassword to the server here
    }
}
