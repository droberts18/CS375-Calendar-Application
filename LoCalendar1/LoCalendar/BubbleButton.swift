//
//  BubbleButton.swift
//  LoCalendar
//
//  Created by Tyler Reardon on 5/2/16.
//  Copyright © 2016 Tyler Reardon. All rights reserved.
//

import Foundation

class BubbleButton: NavButton {
    
    //a list of tuples --> .0 is the navButton, .1 is the layout constraints associated with that button
    //var navButtons = [(NavButton,[NSLayoutConstraint])]()
    var navButtons = [NavButton]()
    var navButtonConstraints = [NavButton:[NSLayoutConstraint]]()
    
    
    convenience init(buttonColor:UIColor, imageFileName:String, identifier:String){
        self.init(buttonColor: buttonColor, imageFileName: imageFileName)
        self.addTarget(self, action: #selector(BubbleButton.onSelect(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addNavButton(buttonColor:UIColor,imageFileName:String){
        let newNavButton = NavButton(buttonColor: buttonColor, imageFileName: imageFileName)
        var layoutConstraints = [NSLayoutConstraint]()
        self.navButtons.append(newNavButton)
        self.addSubview(newNavButton)
        newNavButton.hidden = true
        
        //if the current navButton is the only one in the list
        if(navButtons.count <= 1){
            let bottomConstraint = newNavButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self)
            let rightConstraint = newNavButton.autoPinEdge(.Right, toEdge: .Right, ofView: self)
            navButtonConstraints[newNavButton] = layoutConstraints
            navButtonConstraints[newNavButton]?.append(bottomConstraint)
            navButtonConstraints[newNavButton]?.append(rightConstraint)
            
//            layoutConstraints.append(bottomConstraint)
//            layoutConstraints.append(rightConstraint)
        }else{
            let bottomConstraint = newNavButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: navButtons[navButtons.count-2])
            let rightConstraint = newNavButton.autoPinEdge(.Right, toEdge: .Right, ofView: navButtons[navButtons.count-2])
            navButtonConstraints[navButtons[navButtons.count-2]] = layoutConstraints
//            navButtonConstraints[navButtons[navButtons.count-2]] //.append(bottomConstraint)
//            navButtonConstraints[navButtons[navButtons.count-2]].append(rightConstraint)

        }
    }
    
    func onSelect(sender: UIButton!){
        let degrees:CGFloat = 45; //the value in degrees
        if(!self.buttonTapped){
            UIView.animateWithDuration(0.33, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.transform = CGAffineTransformMakeRotation(degrees * CGFloat(M_PI)/180) //rotate the view by n degrees
                self.showButtons()
                }, completion: { (value: Bool) in
            })
            self.buttonTapped = true
        }else{
            UIView.animateWithDuration(0.33, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.transform = CGAffineTransformIdentity //set back to original position
                self.hideButtons()
                }, completion: { (value: Bool) in
            })
            self.buttonTapped = false
        }
    }
    
    func showButtons(){
        for button in self.navButtons{

        }
    }
    
    func hideButtons(){
        for button in self.navButtons{

        }
    }
}