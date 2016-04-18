//
//  CalendarScrollViewController.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 4/14/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation

import UIKit

class CalendarScrollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    let cellSelectColor = UIColor(red: 30/255, green: 33/255, blue: 40/255, alpha: 1)
    let darkColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    let whiteColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    let lightDarkColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)
    let blueColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
    let greenColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
    
    let calendarContainerHeightMultiplyer = 0.35
    var calendarContainer = UIView()
    var calendarView = CalendarView()
    var forwardMonth = UIButton()
    var backwardMonth = UIButton()
    var dayTable = UITableView(forAutoLayout: ())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(calendarContainer)
        calendarContainer.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        calendarContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        calendarContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        calendarContainer.autoMatchDimension(.Height, toDimension: .Height, ofView: self.view, withMultiplier: CGFloat(calendarContainerHeightMultiplyer))
        calendarContainer.backgroundColor = darkColor
        
        calendarContainer.addSubview(calendarView)
        calendarView.autoCenterInSuperview()
        calendarView.autoMatchDimension(.Width, toDimension: .Width, ofView: calendarContainer, withMultiplier: 0.75)
        calendarView.autoMatchDimension(.Height, toDimension: .Height, ofView: calendarContainer)
//        calendarView.layer.borderWidth = 2
//        calendarView.layer.borderColor = UIColor.redColor().CGColor
        self.updateCalendar()
        
//        calendarContainer.addSubview(forwardMonth)
//        forwardMonth.autoAlignAxisToSuperviewAxis(.Vertical)
//        forwardMonth.autoPinEdge(.Left, toEdge: .Right, ofView: calendarView)
//        forwardMonth.autoMatchDimension(.Height, toDimension: .Height, ofView: calendarView, withMultiplier: 0.5)
//        forwardMonth.autoSetDimension(.Width, toSize: 75)
//        forwardMonth.layer.borderColor = UIColor.blueColor().CGColor
        
        let rightSide = UIView()
        calendarContainer.addSubview(rightSide)
        rightSide.autoPinEdge(.Left, toEdge: .Right, ofView: calendarView)
        rightSide.autoPinEdge(.Right, toEdge: .Right, ofView: calendarContainer)
        rightSide.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        rightSide.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
//        rightSide.layer.borderWidth = 2
//        rightSide.layer.borderColor = UIColor.redColor().CGColor
        rightSide.addSubview(forwardMonth)
        forwardMonth.autoMatchDimension(.Width, toDimension: .Width, ofView: rightSide, withMultiplier: 0.5)
        forwardMonth.autoMatchDimension(.Height, toDimension: .Height, ofView: rightSide, withMultiplier: 0.5)
        forwardMonth.autoCenterInSuperview()
//        forwardMonth.layer.borderWidth = 2
//        forwardMonth.layer.borderColor = UIColor.blueColor().CGColor
        let forwardImage = UIImage(named: "ForwardButton.png")
        let forwardButtonImageView = UIImageView(image: forwardImage)
        self.forwardMonth.addSubview(forwardButtonImageView)
        forwardButtonImageView.autoCenterInSuperview()
        forwardButtonImageView.alpha = 0.25
        self.forwardMonth.addTarget(self, action: #selector(CalendarScrollViewController.goForwardOneMonth(_:)), forControlEvents: .TouchUpInside)
        
        let leftSide = UIView()
        calendarContainer.addSubview(leftSide)
        leftSide.autoPinEdge(.Right, toEdge: .Left, ofView: calendarView)
        leftSide.autoPinEdge(.Left, toEdge: .Left, ofView: calendarContainer)
        leftSide.autoPinEdge(.Top, toEdge: .Top, ofView: calendarContainer)
        leftSide.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: calendarContainer)
        leftSide.addSubview(backwardMonth)
        backwardMonth.autoMatchDimension(.Width, toDimension: .Width, ofView: leftSide, withMultiplier: 0.5)
        backwardMonth.autoMatchDimension(.Height, toDimension: .Height, ofView: leftSide, withMultiplier: 0.5)
        backwardMonth.autoCenterInSuperview()
        let backImage = UIImage(named: "BackButton.png")
        let backButtonImageView = UIImageView(image: backImage)
        self.backwardMonth.addSubview(backButtonImageView)
        backButtonImageView.autoCenterInSuperview()
        backButtonImageView.alpha = 0.25
        self.backwardMonth.addTarget(self, action: #selector(CalendarScrollViewController.goBackwardOneMonth(_:)), forControlEvents: .TouchUpInside)
    
        self.view.addSubview(dayTable)
        dayTable.backgroundColor = lightDarkColor
        dayTable.dataSource = self
        dayTable.delegate = self
        dayTable.autoPinEdge(.Top, toEdge: .Bottom, ofView: calendarContainer)
        dayTable.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        dayTable.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        dayTable.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        dayTable.registerClass(CalendarScrollCell.self, forCellReuseIdentifier: "CalendarScrollCell")
        //dayTable.pagingEnabled = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.dayTable.rowHeight = self.dayTable.frame.height/7
        self.dayTable.reloadData()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //TABLE VIEW FUNCTIONS
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 49
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//      return 75
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var dayCell = tableView.dequeueReusableCellWithIdentifier("CalendarScrollCell", forIndexPath: indexPath) as! CalendarScrollCell
        return dayCell
    }
    
    func onDateButtonTap(sender:UIButton!){
        if let dateSelected = sender.currentTitle{
            print("\(self.calendarView.modifiedMonth)-\(dateSelected)-\(self.calendarView.modifiedYear)")
        }
    }
    
    func updateCalendar(){
        for date in self.calendarView.dateContainers{
            date.button.addTarget(self, action: #selector(CalendarScrollViewController.onDateButtonTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }

    func goForwardOneMonth(sender:UIButton!){
        calendarView.goForwardOneMonth()
        updateCalendar()
    }
    
    func goBackwardOneMonth(sender:UIButton!){
        calendarView.goBackwardOneMonth()
        updateCalendar()
    }
    
    
    
}