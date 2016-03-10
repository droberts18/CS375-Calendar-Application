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
import MapKit



class AddLocationViewController: UIViewController, UITextViewDelegate{
    var backgroundColor = UIColor.whiteColor()
    let sidebColor = UIColor(red: 24/255, green: 26/255, blue: 33/255, alpha: 1)
    var exitButtonConstraint : NSLayoutConstraint = NSLayoutConstraint()
    let searchForLocation = UITextField()
    let nameLocation = UITextField()
    
    let mapContainer = UIView(forAutoLayout: ())
    let myMap = MKMapView(forAutoLayout: ())
    
    convenience init(backgroundColor: UIColor){
        self.init()
        self.backgroundColor = backgroundColor
        registerForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        
        let statusBar = UIView()
        let addLocationContainer = UIView()
        let titleLabel = UILabel()
        
        let exitButton = UIButton(forAutoLayout: ())
        
        self.view.addSubview(statusBar)
        self.view.addSubview(addLocationContainer)
        self.view.addSubview(titleLabel)
        
        
        addLocationContainer.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        exitButton.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        exitButton.backgroundColor = sidebColor
        exitButton.setTitle("Cancel", forState: UIControlState.Normal)
        exitButtonConstraint = exitButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: addLocationContainer, withOffset: 0)
        exitButton.addTarget(self, action: "onExit:", forControlEvents: UIControlEvents.TouchUpInside)

        
//        let exitButtonImage = UIImage(named: "XButton.png")
//        exitButton.setImage(exitButtonImage, forState: .Normal)
//        exitButton.autoSetDimension(.Height, toSize: 50)
//        exitButton.autoSetDimension(.Width, toSize: 50)
//        exitButton.autoPinEdge(.Left, toEdge: .Left, ofView: addLocationContainer, withOffset: 10)
//        exitButton.autoPinEdge(.Top, toEdge: .Top, ofView: addLocationContainer, withOffset: 10)
        
        
        statusBar.backgroundColor = sidebColor
        statusBar.autoPinEdge(.Top, toEdge: .Top, ofView: self.view)
        statusBar.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        statusBar.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        statusBar.autoSetDimension(.Height, toSize: 20)
        
        addLocationContainer.backgroundColor = backgroundColor
        addLocationContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: statusBar)
        addLocationContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        addLocationContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        addLocationContainer.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view)
        
        addLocationContainer.addSubview(searchForLocation)
        searchForLocation.autoPinEdge(.Left, toEdge: .Left, ofView: addLocationContainer)
        searchForLocation.autoPinEdge(.Right, toEdge: .Right, ofView: addLocationContainer)
        searchForLocation.autoPinEdge(.Top, toEdge: .Top, ofView: addLocationContainer)
        searchForLocation.autoSetDimension(.Height, toSize: 50)
        
        addLocationContainer.addSubview(nameLocation)
        nameLocation.autoPinEdge(.Top, toEdge: .Bottom, ofView: searchForLocation)
        nameLocation.autoPinEdge(.Left, toEdge: .Left, ofView: searchForLocation)
        nameLocation.autoPinEdge(.Right, toEdge: .Right, ofView: searchForLocation)
        nameLocation.autoMatchDimension(.Height, toDimension: .Height, ofView: searchForLocation)
        
        addLocationContainer.addSubview(mapContainer)
        mapContainer.autoPinEdge(.Top, toEdge: .Bottom, ofView: nameLocation)
        mapContainer.autoPinEdge(.Left, toEdge: .Left, ofView: self.view)
        mapContainer.autoPinEdge(.Right, toEdge: .Right, ofView: self.view)
        mapContainer.autoPinEdge(.Bottom, toEdge: .Top, ofView: exitButton)
        
        mapContainer.addSubview(myMap)
        myMap.autoPinEdgesToSuperviewEdges()
        
//        titleLabel.text = "Add Location"
//        titleLabel.font = UIFont.systemFontOfSize(40)
//        titleLabel.textColor = UIColor.whiteColor()
//        titleLabel.textAlignment = .Center
//        titleLabel.autoPinEdgeToSuperviewEdge(.Right)
//        titleLabel.autoPinEdgeToSuperviewEdge(.Left)
//        titleLabel.autoPinEdge(.Top, toEdge: .Top, ofView: self.view, withOffset: 100)
      
    }
    
        override func preferredStatusBarStyle() -> UIStatusBarStyle {
            return UIStatusBarStyle.LightContent
        }
    
        
    func onExit(sender:UIButton!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        self.exitButtonConstraint.constant = -keyboardFrame.size.height

        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { finished in
        })
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.exitButtonConstraint.constant = 0
        })
    }
    
    func registerForKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: "UIKeyboardDidShowNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: "UIKeyboardWillHideNotification", object: nil)
    }
}
