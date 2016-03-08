//
//  AddLocationViewController.swift
//  LoCal
//
//  Created by Tyler Reardon on 3/7/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation

//
//  AddEventViewController.swift
//  LoCal
//
//  Created by Drew Roberts on 3/2/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation
import UIKit



class AddLocationViewController: UIViewController, UITextViewDelegate{
    var backgroundColor = UIColor.whiteColor()
    
    convenience init(backgroundColor: UIColor){
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    override func viewDidLoad() {
        
        let statusBar = UIView()
        let addLocationContainer = UIView()
        let titleLabel = UILabel()
        
        let exitButton = UIButton()
        let iconImageView = UIImageView()
        let headerLabel = UILabel()
        
        self.view.addSubview(statusBar)
        self.view.addSubview(addLocationContainer)
        self.view.addSubview(titleLabel)
        
        addLocationContainer.addSubview(exitButton)
        let exitButtonImage = UIImage(named: "XButton.png")
        exitButton.setImage(exitButtonImage, forState: .Normal)
        exitButton.autoSetDimension(.Height, toSize: 50)
        exitButton.autoSetDimension(.Width, toSize: 50)
        exitButton.autoPinEdge(.Left, toEdge: .Left, ofView: addLocationContainer, withOffset: 10)
        exitButton.autoPinEdge(.Top, toEdge: .Top, ofView: addLocationContainer, withOffset: 10)
        exitButton.addTarget(self, action: "onExit:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        statusBar.backgroundColor = UIColor.whiteColor()
        statusBar.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        statusBar.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        statusBar.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        statusBar.autoSetDimension(.Height, toSize: 20)
        
        
        addLocationContainer.backgroundColor = backgroundColor
        addLocationContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBar)
        addLocationContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        addLocationContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        addLocationContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        
        titleLabel.text = "Add Location"
        titleLabel.font = UIFont.systemFontOfSize(40)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.autoPinEdgeToSuperviewEdge(.Right)
        titleLabel.autoPinEdgeToSuperviewEdge(.Left)
        titleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 100)
      
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
