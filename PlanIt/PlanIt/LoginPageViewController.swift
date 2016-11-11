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
        
        if isValidEmail(testStr: userEmail!) == false {
            displayAlertMessage(myMessage:"Not a valid email");
            return;
        }
        
        //Alex: send userName, userEmail, and userPassword to the server here
        //When login not successful, call displayAlertMessage()
        //When login successful, call change page to the ListView
        //this code was found and altered from: http://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
        var request = URLRequest(url: URL(string: "http://oose-2016-group-13.herokuapp.com/login")!)
        request.httpMethod = "POST"
        let postString = "username: " + userEmail! + ",\npassword: " + userPassword!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        
        task.resume()
        
        self.performSegue(withIdentifier: "ListViewSegue", sender: nil)
       
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
