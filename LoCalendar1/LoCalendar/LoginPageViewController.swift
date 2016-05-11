//
//  LoginViewController.swift
//  LoCalendar
//
//  Created by Drew Roberts on 5/11/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation
import UIKit

class LoginPage: UIPageViewController {
    
    let cellSelectColor = UIColor(red: 30/255, green: 33/255, blue: 40/255, alpha: 1)
    let darkColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let lightDarkColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    let blueColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
    
    let welcome = UILabel()
    let warning = UILabel()
    let accessLocationServices = UIButton()
    let accessCalendarServices = UIButton()
    let goToCalendar = UIButton()
    
    override func viewDidLoad(){
        
        self.view.backgroundColor = darkColor
        let font = UIFont.systemFontOfSize(50)
        let font2 = UIFont.systemFontOfSize(20)
        
        self.view.addSubview(welcome)
        welcome.text = "LoCal"
        welcome.textColor = UIColor.whiteColor()
        welcome.font = font
        welcome.autoAlignAxis(.Vertical, toSameAxisOfView: self.view)
        welcome.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}