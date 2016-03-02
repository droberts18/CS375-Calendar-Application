//
//  AddEventViewController.swift
//  LoCal
//
//  Created by Drew Roberts on 3/2/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation
import UIKit



class AddEventViewController: UIViewController{
    let titleTextbox = UITextField()
    let locationTextbox = UITextField()
    let startDate = UIDatePicker()
    let endDate = UIDatePicker()
    let eventType = UIImageView()
    
    override func viewDidLoad() {
        let bg = UIView()
        bg.backgroundColor = UIColor.blueColor()
        bg.autoSetDimension(.Width, toSize: 60)
        bg.autoSetDimension(.Height, toSize: 60)
        bg.layer.cornerRadius = 30
    }
}
