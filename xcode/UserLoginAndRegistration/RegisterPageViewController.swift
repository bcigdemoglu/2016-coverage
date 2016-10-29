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
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonTapped(_ sender: AnyObject) {
        let userName = userNameTextField.text;
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let repeatPassword = userPasswordRepeatTextField.text;
        
        if (userName == "" || userEmail == "" || userPassword == "" || repeatPassword == "") {
            displayAlertMessage(myMessage:"All fields are required.");
            return;
        }
        
        if (userPassword != repeatPassword) {
            displayAlertMessage(myMessage:"Passwords do not match.");
            return;
        }
        
        //ALEX: Send registration information to server here. Make sure to check whether the userEmail is already registered. If it is, call displayAlertMessage() with the appropriate error message.
        
        return;
    }
    
    func displayAlertMessage(myMessage:String) {
        let alertController = UIAlertController(title: "Alert", message: myMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    

}
