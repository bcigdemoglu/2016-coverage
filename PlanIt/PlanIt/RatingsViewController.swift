//
//  RatingsViewController.swift
//  PlanIt
//
//  Created by CS Student on 12/19/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit

class RatingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //@available(iOS 2.0, *)

    @IBOutlet var locationName: UILabel!
    
    @IBOutlet var ratingPicker: UIPickerView!
    
   var pickerData: [String] = [String]()
    
    var location: String?
    var event: EKEvent?
    var rating: Rating?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingPicker.dataSource = self;
        self.ratingPicker.delegate = self;
        // Do any additional setup after loading the view.
        
        // Input data into Array:
        pickerData = ["1", "2", "3", "4", "5"]

    }
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
            //Network call to save rating
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationName.text = location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ _pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //let rowString = String(pickerDataInt[row])
        return pickerData[row]
        //return pickerDataSource[row]
    }
    
    //Parameter named row and component represents what was selected
    //Method is triggered whenever user makes a change to the picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.rating?.rating = row + 1
    }
    
    

}
