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
    
   // var pickerData: [Int] = [Int]()
    var pickerDataInt = [1, 2, 3, 4, 5];
    var pickerDataStrings = ["1", "2", "3", "4", "5"];
    
    var location: String?
    var event: EKEvent?
    var rating: Rating?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingPicker.dataSource = self;
        self.ratingPicker.delegate = self;
        // Do any additional setup after loading the view.
        
        // Input data into Array:
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
        return pickerDataInt.count;
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //let rowString = String(pickerDataInt[row])
        return pickerDataStrings[row]
        //return pickerDataSource[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.rating?.rating = row
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //let strDate =
        
    }
    

}
