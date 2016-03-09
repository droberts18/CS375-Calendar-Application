//
//  AddEventViewController.swift
//  LoCal
//
//  Created by Drew Roberts on 3/2/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation
import UIKit



class AddEventViewController: UIViewController, UITextViewDelegate{
    var backgroundColor = UIColor.whiteColor()
    var placeholderName : String!
    
    let locationMenu = UIView()
    let datePickerMenu = UIView()
    let date = UIDatePicker()
    let startDateLabel = UILabel()
    let startTimeLabel = UILabel()
    let endDateLabel = UILabel()
    let endTimeLabel = UILabel()


    convenience init(backgroundColor: UIColor){
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    override func viewDidLoad() {
        
        let addEventButtonColor = UIColor(red: 44/255, green: 105/255, blue: 157/255, alpha: 1)
        let addLocationButtonColor = UIColor(red: 96/255, green: 157/255, blue: 44/255, alpha: 1)
        
        let statusBar = UIView()
        let addEventContainer = UIView()
        //let header = ViewControllerHeader(title: "Add Event", imageFileName: "AddEventButtonPlus.png")
        let titleLabel = UILabel()
        let userNameOfEvent = UITextView()
        let userLocation = UITextView()
        let startDateButton = UIButton()
        let endDate = UIDatePicker()
        let endDateButton = UIButton()
        let eventType = UIImageView()
        
        let exitButton = UIButton()
        let iconImageView = UIImageView()
        let headerLabel = UILabel()
        
        let addLocationButton = NavButton(buttonColor: addLocationButtonColor, imageFileName: "AddLocation.png")
        addLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(statusBar)
        self.view.addSubview(addEventContainer)
        self.view.addSubview(titleLabel)
        self.view.addSubview(userNameOfEvent)
        self.view.addSubview(addLocationButton)
        self.view.addSubview(locationMenu)
        self.view.addSubview(userLocation)
        self.view.addSubview(datePickerMenu)
        self.view.addSubview(startDateButton)
        self.view.addSubview(startDateLabel)
        self.view.addSubview(startTimeLabel)
        self.view.addSubview(endDateButton)
        self.view.addSubview(endDateLabel)
        self.view.addSubview(endTimeLabel)
        
        addEventContainer.addSubview(exitButton)
        let exitButtonImage = UIImage(named: "XButton.png")
        exitButton.setImage(exitButtonImage, forState: .Normal)
        exitButton.autoSetDimension(.Height, toSize: 50)
        exitButton.autoSetDimension(.Width, toSize: 50)
        exitButton.autoPinEdge(.Left, toEdge: .Left, ofView: addEventContainer, withOffset: 10)
        exitButton.autoPinEdge(.Top, toEdge: .Top, ofView: addEventContainer, withOffset: 10)
        exitButton.addTarget(self, action: "onExit:", forControlEvents: UIControlEvents.TouchUpInside)

        
        statusBar.backgroundColor = UIColor.whiteColor()
        statusBar.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        statusBar.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        statusBar.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        statusBar.autoSetDimension(.Height, toSize: 20)
        
        
        addEventContainer.backgroundColor = backgroundColor
        addEventContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBar)
        addEventContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        addEventContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        addEventContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        
        titleLabel.text = "Add Your Event!"
        titleLabel.font = UIFont.systemFontOfSize(40)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.autoPinEdgeToSuperviewEdge(.Right)
        titleLabel.autoPinEdgeToSuperviewEdge(.Left)
        titleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 100)
        
//        nameOfEventLabel.text = "Name your event"
//        nameOfEventLabel.font = UIFont.systemFontOfSize(20)
//        nameOfEventLabel.textColor = UIColor.whiteColor()
//        nameOfEventLabel.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: 30)
//        nameOfEventLabel.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
//        nameOfEventLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 10)
        
        userNameOfEvent.delegate = self
        userNameOfEvent.backgroundColor = UIColor.whiteColor()
        userNameOfEvent.text = "Event name"
        userNameOfEvent.textColor = UIColor.lightGrayColor()
        userNameOfEvent.font = UIFont.systemFontOfSize(20)
        userNameOfEvent.autoSetDimension(.Height, toSize: 40)
        userNameOfEvent.layer.cornerRadius = 5
        userNameOfEvent.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 25)
        userNameOfEvent.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -30)
        userNameOfEvent.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
        
        addLocationButton.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
        addLocationButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: userNameOfEvent, withOffset: 20)
        addLocationButton.addTarget(self, action: "onLocationButtonTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        userLocation.delegate = self
        userLocation.backgroundColor = UIColor.whiteColor()
        userLocation.text = "Location"
        userLocation.textColor = UIColor.lightGrayColor()
        userLocation.font = UIFont.systemFontOfSize(20)
        userLocation.autoSetDimension(.Height, toSize: 40)
        userLocation.layer.cornerRadius = 5
        userLocation.autoPinEdge(.Top, toEdge: .Bottom, ofView: userNameOfEvent, withOffset: 25)
        userLocation.autoPinEdge(.Left, toEdge: .Right, ofView: addLocationButton, withOffset: 15)
        userLocation.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -30)
        
        locationMenu.hidden = true
        locationMenu.backgroundColor = UIColor.blackColor()
        locationMenu.layer.borderColor = UIColor.grayColor().CGColor
        locationMenu.layer.borderWidth = 5
        locationMenu.layer.cornerRadius = 5
        locationMenu.autoPinEdge(.Top, toEdge: .Bottom, ofView: addLocationButton, withOffset: 5)
        locationMenu.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
        locationMenu.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -30)
        locationMenu.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view, withOffset: -30)
        
        startDateButton.backgroundColor = UIColor.redColor()
        startDateButton.autoMatchDimension(.Height, toDimension: .Height, ofView: addLocationButton)
        startDateButton.autoMatchDimension(.Width, toDimension: .Width, ofView: addLocationButton)
        startDateButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: addLocationButton, withOffset: 30)
        startDateButton.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
        startDateButton.addTarget(self, action: "onDateTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        endDateButton.backgroundColor = UIColor.yellowColor()
        endDateButton.autoMatchDimension(.Height, toDimension: .Height, ofView: addLocationButton)
        endDateButton.autoMatchDimension(.Width, toDimension: .Width, ofView: addLocationButton)
        endDateButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: startDateButton, withOffset: 30)
        endDateButton.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
        endDateButton.addTarget(self, action: "onDateTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        datePickerMenu.hidden = true
        datePickerMenu.backgroundColor = UIColor.whiteColor()
        datePickerMenu.layer.borderColor = UIColor.darkGrayColor().CGColor
        datePickerMenu.layer.borderWidth = 5
        datePickerMenu.layer.cornerRadius = 5
        datePickerMenu.autoPinEdge(.Top, toEdge: .Bottom, ofView: startDateButton)
        datePickerMenu.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        datePickerMenu.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        datePickerMenu.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        datePickerMenu.addSubview(date)
        
        date.minimumDate = NSDate()
        
        startTimeLabel.text = "No Start Time Selected"
        startTimeLabel.textColor = UIColor.whiteColor()
        startTimeLabel.font = UIFont.systemFontOfSize(20)
        startTimeLabel.autoPinEdge(.Left, toEdge: .Right, ofView: startDateButton, withOffset: 15)
        startTimeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: userLocation, withOffset: 30)
        
        startDateLabel.text = "No Start Date Selected"
        startDateLabel.textColor = UIColor.whiteColor()
        startDateLabel.font = UIFont.systemFontOfSize(20)
        startDateLabel.autoPinEdge(.Left, toEdge: .Right, ofView: startDateButton, withOffset: 15)
        startDateLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: startTimeLabel, withOffset: 5)
        
        endTimeLabel.text = "No End Time Selected"
        endTimeLabel.textColor = UIColor.whiteColor()
        endTimeLabel.font = UIFont.systemFontOfSize(20)
        endTimeLabel.autoPinEdge(.Left, toEdge: .Right, ofView: endDateButton, withOffset: 15)
        endTimeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: startDateLabel, withOffset: 30)
        
        endDateLabel.text = "No End Date Selected"
        endDateLabel.textColor = UIColor.whiteColor()
        endDateLabel.font = UIFont.systemFontOfSize(20)
        endDateLabel.autoPinEdge(.Left, toEdge: .Right, ofView: endDateButton, withOffset: 15)
        endDateLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: endTimeLabel, withOffset: 5)
        

        
//        addEventContainer.addSubview(header)
//        header.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
//        header.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
//        header.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
//        header.autoSetDimension(.Height, toSize: 75)
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    func onLocationButtonTap(sender: UIButton!){
        if(locationMenu.hidden == true){
            locationMenu.hidden = false
            self.view.bringSubviewToFront(locationMenu)
        }
        else{
            locationMenu.hidden = true
        }
    }
    
    func onDateTap(sender: UIButton!){
        if(datePickerMenu.hidden == true){
            self.view.bringSubviewToFront(datePickerMenu)
            datePickerMenu.hidden = false
        }
        else{
            date.datePickerMode = UIDatePickerMode.DateAndTime
            let dateFormatter = NSDateFormatter()
            let timeFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            timeFormatter.timeStyle = NSDateFormatterStyle.LongStyle
            let selectedDate = dateFormatter.stringFromDate(date.date)
            let selectedTime = timeFormatter.stringFromDate(date.date)
            startTimeLabel.text = selectedTime
            startDateLabel.text = selectedDate
            datePickerMenu.hidden = true
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if textView.textColor == UIColor.lightGrayColor() {
            placeholderName = textView.text
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView){
        if textView.text.isEmpty {
            textView.text = placeholderName
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func onExit(sender:UIButton!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
