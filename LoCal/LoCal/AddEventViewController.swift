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
    var backgroundColor = UIColor.whiteColor()

    convenience init(backgroundColor: UIColor){
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    override func viewDidLoad() {
        
        let statusBar = UIView()
        let addEventContainer = UIView()
        //let header = ViewControllerHeader(title: "Add Event", imageFileName: "AddEventButtonPlus.png")
        let titleTextbox = UITextField()
        let locationTextbox = UITextField()
        let startDate = UIDatePicker()
        let endDate = UIDatePicker()
        let eventType = UIImageView()
        
        let exitButton = UIButton()
        let iconImageView = UIImageView()
        let headerLabel = UILabel()
        
        self.view.addSubview(statusBar)
        self.view.addSubview(addEventContainer)
        
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
        
//        addEventContainer.addSubview(header)
//        header.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
//        header.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
//        header.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
//        header.autoSetDimension(.Height, toSize: 75)
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    func onExit(sender:UIButton!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
