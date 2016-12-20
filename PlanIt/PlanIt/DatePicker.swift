//
//  DatePicker.swift
//  UserLoginAndRegistration
//
//  Created by Naina Rao on 10/30/16.
//  Copyright © 2016 Amy He. All rights reserved.
//

import UIKit
import Foundation

//Class Description: View that controls the Date Picker when user wants to add an itinerary

class DatePicker: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.backgroundColor = UIColor.red
        addSubview(button)
    }
    
    
    func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
