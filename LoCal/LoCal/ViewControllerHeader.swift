//
//  ViewControllerHeader.swift
//  LoCal
//
//  Created by Tyler Reardon on 3/4/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation

class ViewControllerHeader: UIView{
    var title = String()
    var imageFileName = String()
    let headerContainer = UIView(forAutoLayout: ())
    let headerLabel = UILabel(forAutoLayout: ())

    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    convenience init (title: String, imageFileName: String) {
        //self.init(frame:CGRect.zero)
        self.init(forAutoLayout: ())
        self.title = title
        self.imageFileName = imageFileName
        customInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func customInitialization(){
        self.autoSetDimension(.Height, toSize: 100)
        self.addSubview(headerContainer)
        headerContainer.autoCenterInSuperview()
        
        let iconImage = UIImage(named: imageFileName)
        let iconImageView = UIImageView(image: iconImage)
        headerContainer.addSubview(iconImageView)
        iconImageView.autoSetDimension(.Width, toSize: 60)
        iconImageView.autoSetDimension(.Height, toSize: 60)

        headerLabel.text = title
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.adjustsFontSizeToFitWidth = true
        headerContainer.addSubview(headerLabel)
        headerLabel.autoSetDimension(.Width, toSize: 100)
        headerLabel.autoSetDimension(.Height, toSize: 60)
        headerLabel.autoPinEdge(.Left, toEdge: .Right, ofView: iconImageView)
        
        let exitButtonImage = UIImage(named: "XButton.png")
        let exitButton = UIButton(forAutoLayout: ())
        exitButton.setImage(exitButtonImage, forState: .Normal)
        exitButton.autoSetDimension(.Width, toSize: 50)
        exitButton.autoSetDimension(.Height, toSize: 50)
        exitButton.autoPinEdge(.Left, toEdge: .Left, ofView: self, withOffset: 10)
        exitButton.autoPinEdge(.Top, toEdge: .Top, ofView: self, withOffset: 10)
    }
}