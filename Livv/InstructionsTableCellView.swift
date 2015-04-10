//
//  InstructionsTableCellView.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

class InstructionsTableCellView: UITableViewCell {
    
    var instruction: UILabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.commonSetup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    init(style: UITableViewCellStyle, reuseIdentifier: String?, title: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.instruction.text = title
        self.commonSetup()
        
    }
    
    func commonSetup(){
        
        self.instruction.textColor = UIColor.blackColor()
        self.instruction.backgroundColor = UIColor.whiteColor()
        self.instruction.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        self.instruction.sizeToFit()
        self.instruction.clipsToBounds = true
        self.instruction.layer.cornerRadius = 2
        var titleWidth: CGFloat! = (self.instruction.frame.size.width as CGFloat!) + 10
        self.instruction.frame = CGRect(x: 10, y: 10, width: titleWidth, height: 31)
        contentView.addSubview(self.instruction)
        
    }
    

}