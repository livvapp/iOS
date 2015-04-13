//
//  PrivateButtonTableViewCell.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

class PrivateButtonTableViewCell: TagButtonViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?, view: TagSelectorView, tag: Tags) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.setTitle(tag.title, forState: .Normal)
        self.theTag = tag
        super.countNumber = tag.count + tag.userCount
        super.view = view
        self.commonSetup()
        button.addTarget(self, action: "selectedPrivateTag:", forControlEvents: .TouchUpInside)
        
    }
    
    override func commonSetup(){
        
        button.setTitleColor(UIColor(red: 255/255, green: 50/255, blue: 255/255, alpha: 1.0), forState: .Normal)
        button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        button.sizeToFit()
        button.layer.cornerRadius = 2
        var titleWidth: CGFloat! = (button.frame.size.width as CGFloat!) + 10
        button.frame = CGRect(x: 10, y: 10, width: titleWidth, height: 31)
        contentView.addSubview(button)
        
        count.frame = CGRect(x: self.frame.width - 40, y: 0, width: 30, height: contentView.frame.height)
        count.setTitle("\(countNumber)", forState: .Normal)
        count.addTarget(self, action: "countUpdate:", forControlEvents: .TouchUpInside)
        count.userInteractionEnabled = false
        count.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        count.setTitleColor(UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0), forState: .Normal)
        count.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        count.titleLabel?.textAlignment = .Right
        count.autoresizingMask = .FlexibleWidth
        contentView.addSubview(count)
        
    }
    
    override func countUpdate(sender: UIButton!){
        
        if view.pointsNumber > 0 {
            
            countNumber = countNumber + 1
            count.setTitle("\(countNumber)", forState: .Normal)
            super.view.selectedTags.append("#\(theTag.title)")
            
            theTag.userCount = theTag.userCount + 1
            view.decrementAPoint()
        }
    }
    
    func selectedPrivateTag(sender: UIButton!){
        
        if button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9) {
            
            if view.pointsNumber > 0 {
                
                theTag.isSelected = true
                count.userInteractionEnabled = true
                
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.backgroundColor = UIColor(red: 255/255, green: 50/255, blue: 255/255, alpha: 0.9)
                
                theTag.userCount = theTag.userCount + 1
                countNumber = countNumber + 1
                count.setTitle("\(countNumber)", forState: .Normal)
                view.decrementAPoint()
                
                super.view.addTag.text = nil
                super.view.fitToSize()
                super.view.addTag.sizeToFit()
                
                if super.view.searchedTags.count > 0 {
                    super.view.tags.insert(theTag, atIndex: 0)
                    super.view.searchedTags = []
                }
                
                super.view.selectedTags.append("#\(theTag.title)")
                super.view.tableView.reloadData()
                
                count.setTitleColor(UIColor(red: 255/255, green: 50/255, blue: 255/255, alpha: 1.0), forState: .Normal)
                
                if self.view.selectedTags.count != 0 {
                    
                    self.view.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    self.view.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                    self.view.done.setTitle("Submit", forState: UIControlState.Normal)
                    self.view.fitToSizeDone()
                }
            }
            
        } else if button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.89){
            
            if view.pointsNumber > 0 {
                
                theTag.isSelected = true
                count.userInteractionEnabled = true
                
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.backgroundColor = UIColor(red: 255/255, green: 50/255, blue: 255/255, alpha: 0.89)
                
                theTag.userCount = theTag.userCount + 1
                countNumber = countNumber + 1
                count.setTitle("\(countNumber)", forState: .Normal)
                view.decrementAPoint()
                
                count.setTitleColor(UIColor(red: 255/255, green: 50/255, blue: 255/255, alpha: 1.0), forState: .Normal)
                
                super.view.selectedTags.append("#\(theTag.title)")
                super.view.tableView.reloadData()
                
                if self.view.selectedTags.count != 0 {
                    
                    self.view.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    self.view.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                    self.view.done.setTitle("Submit", forState: UIControlState.Normal)
                    self.view.fitToSizeDone()
                }
            }
        }
        else {
            theTag.isSelected = false
            
            button.setTitleColor(UIColor(red: 255/255, green: 50/255, blue: 255/255, alpha: 1.0), forState: .Normal)
            button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.89)
            
            count.userInteractionEnabled = false
            
            view.incrementAPoint(theTag.userCount)
            theTag.userCount = 0
            
            count.setTitleColor(UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0), forState: .Normal)
            countNumber = theTag.count - theTag.userCount
            count.setTitle("\(countNumber)", forState: .Normal)
            
            for var i: Int = 0; i < super.view.selectedTags.count; i++ {
                
                if super.view.selectedTags[i] == "#\(theTag.title)" {
                    
                    super.view.selectedTags.removeAtIndex(i)
                    i--
                }
                
            }
            
            if self.view.selectedTags.count == 0 {
                
                self.view.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.view.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                self.view.done.setTitle("Cancel", forState: UIControlState.Normal)
                self.view.fitToSizeDone()
            }
        }
    }
}