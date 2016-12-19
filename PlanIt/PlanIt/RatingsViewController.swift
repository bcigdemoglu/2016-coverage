//
//  RatingsViewController.swift
//  PlanIt
//
//  Created by CS Student on 12/19/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit

class RatingsViewController: UIViewController, UIPickerViewDelegate{//, UIPickerViewDataSource {

    @IBOutlet var locationName: UILabel!
    
    @IBOutlet var ratingPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Input data into Array:
        pickerData = ["1","2","3","4","5"]
    }
    
    var location = String()
    override func viewWillAppear(_ animated: Bool) {
        locationName.text = location
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let strDate = ratingPicker.selectedRow(inComponent: <#T##Int#>)
        
    }
    

}
