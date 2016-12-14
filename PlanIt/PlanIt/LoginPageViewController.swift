//
//  LoginPageViewController.swift
//  PlanIt
//
//  Created by Amy He on 10/17/16.
//  Copyright © 2016 Amy He. All rights reserved.
//

import UIKit

class LoginPageViewController: UIViewController {
    
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
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        
        if (userEmail == "" || userPassword == "") {
            displayAlertMessage(myMessage:"All fields are required.");
            return;
        }
        
        self.performSegue(withIdentifier: "homeSegue", sender: nil)
        /*if isValidEmail(testStr: userEmail!) == false {
            displayAlertMessage(myMessage:"Not a valid email");
            return;
        }*/
        
        //Alex: send userName, userEmail, and userPassword to the server here
        //When login not successful, call displayAlertMessage()
        //When login successful, call change page to the ListView
        sendLoginRequest(username: userEmail!, password: userPassword!) {responseString in
            switch responseString {
            case "success" :
                User.createUser(user: userEmail, password: userPassword)
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
            default :
                self.displayAlertMessage(myMessage: responseString)
            }
        }
    }
    
    func displayAlertMessage(myMessage:String) {
        let alertController = UIAlertController(title: "Alert", message: myMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    // Checks if the email entered is valid and returns a boolean
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func registerAccount(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "registerView", sender: nil)
    }
    
}
