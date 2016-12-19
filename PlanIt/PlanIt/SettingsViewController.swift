//
//  SettingsViewController.swift
//  PlanIt
//
//  Created by CS Student on 12/15/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var nameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Alex: get real user info here
        
        
        nameText.text = User.getDisplayName()
        emailText.text = User.getUserName()
        passwordText.text = User.getUserPassword()
        self.menuButton.target = self.revealViewController()
        self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Do any additional setup after loading the view.
    }

    @IBAction func onSaveButtonTapped(_ sender: AnyObject) {
        
        let userName = nameText.text;
        let userEmail = emailText.text;
        let userPassword = passwordText.text;
        
        if (userName == "" || userEmail == "" || userPassword == "") {
            displayAlertMessage(myMessage:"All fields are required.");
            return;
        }
        
        if isValidEmail(testStr: userEmail!) == false {
            displayAlertMessage(myMessage:"Not a valid email");
            return;
        }
        if (userName != User.getDisplayName()) {
            sendChangeDisplayName(newDisplayName: userName!) {
                str in
                if str != nil {
                    self.displayAlertMessage(myMessage: str!)
                }
            }
        }
        if(userPassword != User.getUserPassword()) {
            sendChangePassword(newPassword: userPassword!) {
                str in
                if str != nil {
                    self.displayAlertMessage(myMessage: str!)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayAlertMessage(myMessage:String) {
        let alertController = UIAlertController(title: "Alert", message: myMessage, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
