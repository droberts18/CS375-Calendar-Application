//
//  CalendarScrollViewController.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 4/14/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation

import UIKit

class CalendarScrollViewController: UIViewController {
    
    let calendarContainerHeightMultiplyer = 0.35
    var calendarContainer = UIView()
    var calendarView = CalendarView()
    var dayTable = UITableView(forAutoLayout: ())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(calendarContainer)
        calendarContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        calendarContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        calendarContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        calendarContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: CGFloat(calendarContainerHeightMultiplyer))
        calendarContainer.backgroundColor = UIColor.purpleColor()
        
        calendarContainer.addSubview(calendarView)
        calendarView.autoCenterInSuperview()
        calendarView.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer, withMultiplier: 0.75)
        calendarView.autoMatchDimension(.Height, toDimension: .Height, ofView: calendarContainer)
    
        self.view.addSubview(dayTable)
        dayTable.autoPinEdge(.Top, toEdge: .Bottom, ofView: calendarContainer)
        dayTable.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        dayTable.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        dayTable.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
}