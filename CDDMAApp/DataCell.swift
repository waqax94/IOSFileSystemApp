//
//  DataCell.swift
//  CDDMAApp
//
//  Created by Waqas Waheed on 2/5/20.
//  Copyright © 2020 Waqas Waheed. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {

    @IBOutlet weak var makeUI: UILabel!
    
    @IBOutlet weak var modelUI: UILabel!
    
    @IBOutlet weak var yearUI: UILabel!
    
    
    func setDataCell(vehicle: Vehicle){
        
        makeUI.text = vehicle.make
        modelUI.text = vehicle.model
        yearUI.text = String(vehicle.year)

    }
    
}
