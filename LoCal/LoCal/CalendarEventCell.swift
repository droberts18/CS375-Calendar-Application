//
//  CalendarEventCell.swift
//  LoCal
//
//  Created by Tyler Reardon on 3/6/16.
//  Copyright © 2016 Skysoft. All rights reserved.
//

import Foundation


class CalendarEventCell: UITableViewCell {
    
    let cellSelectColor = UIColor(red: 30/255, green: 33/255, blue: 40/255, alpha: 1)
    let backgColor = UIColor(red: 42/255, green: 44/255, blue: 54/255, alpha: 1)

        
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = backgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func changeBackgroundColorIfSelected(){
        if(self.selected){
            self.backgroundColor = cellSelectColor
        }else{
            self.backgroundColor = backgColor
        }
    }
}