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

    convenience init(backgroundColor: UIColor){
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    override func viewDidLoad() {
        
        let statusBar = UIView()
        let addEventContainer = UIView()
        //let header = ViewControllerHeader(title: "Add Event", imageFileName: "AddEventButtonPlus.png")
        let titleLabel = UILabel()
        let nameOfEventLabel = UILabel()
        let userNameOfEvent = UITextView()
        let locationTextbox = UILabel()
        let userLocation = UITextField()
        let startDate = UIDatePicker()
        let endDate = UIDatePicker()
        let eventType = UIImageView()
        
        let exitButton = UIButton()
        let iconImageView = UIImageView()
        let headerLabel = UILabel()
        
        self.view.addSubview(statusBar)
        self.view.addSubview(addEventContainer)
        self.view.addSubview(titleLabel)
        self.view.addSubview(nameOfEventLabel)
        self.view.addSubview(userNameOfEvent)
        
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
        userNameOfEvent.autoSetDimension(.Height, toSize: 30)
        userNameOfEvent.autoSetDimension(.Width, toSize: 200)
        userNameOfEvent.layer.cornerRadius = 5
        userNameOfEvent.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 10)
        userNameOfEvent.autoPinEdge(.Right, toEdge: .Right, ofView: self.view, withOffset: -30)
        userNameOfEvent.autoPinEdge(.Left, toEdge: .Left, ofView: self.view, withOffset: 30)
        
        
//        addEventContainer.addSubview(header)
//        header.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
//        header.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
//        header.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
//        header.autoSetDimension(.Height, toSize: 75)
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    func textViewDidBeginEditing(textView: UITextView){
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView){
        if textView.text.isEmpty {
            textView.text = "Event Name"
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
