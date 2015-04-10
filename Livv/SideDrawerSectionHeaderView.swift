//
//  SideDrawerSectionHeaderView.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit

class SideDrawerSectionHeaderView: UIView {
    var title: String? {
        didSet {
            self.label?.text = self.title
        }
    }
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.label = UILabel(frame: CGRect(x: 15, y: CGRectGetMaxY(self.bounds) - 28, width: CGRectGetWidth(self.bounds) - 30, height: 22))
        self.label.font = UIFont(name: "HelveticaNeue-MediumItalic",
            size: 19.0)
        self.label.textColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        self.label.backgroundColor = UIColor.clearColor()
        self.label.autoresizingMask = .FlexibleWidth | .FlexibleTopMargin
        self.addSubview(self.label)
        self.clipsToBounds = false
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let lineColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        CGContextSetLineWidth(context, 1.0)
        CGContextMoveToPoint(context, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5)
        CGContextAddLineToPoint(context, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5)
        CGContextStrokePath(context)
    }
}

