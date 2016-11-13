//
//  ItineraryTableViewCell.swift
//  PlanIt
//
//  Created by Naina Rao on 10/30/16.
//  Copyright © 2016 Amy He. All rights reserved.
//

import UIKit

class ItineraryTableViewCell: UITableViewCell {
    
    // MARK: Properties 
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
