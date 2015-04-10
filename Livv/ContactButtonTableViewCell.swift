//
//  ContactButtonTableViewCell.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

//
//  ContactButtonTableViewCell.swift
//  Pleeb
//
//  Created by Brent Kirkland on 4/4/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

class ContactButtonTableViewCell: TagButtonViewCell {
    
    var phone: String!
    //let theTag: Tags!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?, view: TagSelectorView, tag: Tags) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.setTitle(tag.title, forState: .Normal)
        super.countNumber = tag.count + tag.userCount
        super.theTag = tag
        super.view = view
        self.commonSetup()
        button.addTarget(self, action: "selectedContact:", forControlEvents: .TouchUpInside)
        self.phone = tag.phone
    }
    
    override func commonSetup(){
        
        button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 1.0), forState: .Normal)
        //button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), forState: .Highlighted)
        //button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        button.sizeToFit()
        button.layer.cornerRadius = 2
        var titleWidth: CGFloat! = (button.titleLabel?.frame.width as CGFloat!) + 10
        var titleHeight: CGFloat! = (button.titleLabel?.frame.size.height as CGFloat!) + 5
        button.frame = CGRect(x: 10, y: 10, width: titleWidth, height: titleHeight)
        contentView.addSubview(button)
        
        count.frame = CGRect(x: self.frame.width + 15, y: 0, width: 30, height: contentView.frame.height)
        count.setTitle("\(countNumber)", forState: .Normal)
        count.addTarget(self, action: "countUpdate:", forControlEvents: .TouchUpInside)
        count.userInteractionEnabled = false
        count.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        count.setTitleColor(UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0), forState: .Normal)
        count.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        count.titleLabel?.textAlignment = .Right
        contentView.addSubview(count)
        
    }
    
    override func countUpdate(sender: UIButton!){
        
        if view.pointsNumber > 0 {
            
            countNumber = countNumber + 1
            count.setTitle("\(countNumber)", forState: .Normal)
            super.view.selectedTags.append("@\(theTag.phone)")
            
            var g: CGFloat! = CGFloat(((arc4random_uniform(255))))
            var r: CGFloat! = CGFloat(((arc4random_uniform(255))))
            var b: CGFloat! = CGFloat(((arc4random_uniform(255))))
            
            println(g)
            println(r)
            println(b)
            
            count.setTitleColor(UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0), forState: .Normal)
        }
    }
    
    func selectedContact(sender: UIButton!){
        
        if button.titleLabel?.textColor == UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 1.0) && button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9){
            
            if view.pointsNumber > 0 {
                
                theTag.isSelected = true
                count.userInteractionEnabled = true
                
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 0.9)
                
                theTag.userCount = theTag.userCount + 1
                countNumber = countNumber + 1
                count.setTitle("\(countNumber)", forState: .Normal)
                //view.decrementAPoint()
                
                super.view.addTag.text = nil
                super.view.fitToSize()
                super.view.addTag.sizeToFit()
                
                //if super.view.selectedTags.count > 0{
                super.view.tags.insert(theTag, atIndex: 0)
                super.view.searchedTags = []
                //}
                
                super.view.selectedTags.append("@\(theTag.phone)")
                super.view.tableView.reloadData()
                
                var g: CGFloat! = CGFloat(((arc4random_uniform(255))))
                var r: CGFloat! = CGFloat(((arc4random_uniform(255))))
                var b: CGFloat! = CGFloat(((arc4random_uniform(255))))
                
                println(g)
                println(r)
                println(b)
                
                count.setTitleColor(UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0), forState: .Normal)
                
                if self.view.selectedTags.count != 0 {
                    
                    self.view.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    self.view.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                    self.view.done.setTitle("Submit", forState: UIControlState.Normal)
                    self.view.fitToSizeDone()
                }
            }
            
        } else if button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.89) {
            
            if view.pointsNumber > 0 {
                
                theTag.isSelected = true
                count.userInteractionEnabled = true
                
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 0.89)
                
                theTag.userCount = theTag.userCount + 1
                countNumber = countNumber + 1
                count.setTitle("\(countNumber)", forState: .Normal)
                //view.decrementAPoint()
                
                var g: CGFloat! = CGFloat(((arc4random_uniform(255))))
                var r: CGFloat! = CGFloat(((arc4random_uniform(255))))
                var b: CGFloat! = CGFloat(((arc4random_uniform(255))))
                
                println(g)
                println(r)
                println(b)
                
                count.setTitleColor(UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0), forState: .Normal)
                
                super.view.selectedTags.append("@\(theTag.title)")
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
            
            button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 50/255, alpha: 1.0), forState: .Normal)
            button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.89)
            
            count.userInteractionEnabled = false
            
            //view.incrementAPoint(theTag.userCount)
            theTag.userCount = 0
            
            count.setTitleColor(UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0), forState: .Normal)
            countNumber = theTag.count - theTag.userCount
            count.setTitle("\(countNumber)", forState: .Normal)
            
            for var i: Int = 0; i < super.view.selectedTags.count; i++ {
                //
                if super.view.selectedTags[i] == "@\(theTag.phone)" {
                    
                    super.view.selectedTags.removeAtIndex(i)
                    i--
                }
                //
            }
            
            if self.view.selectedTags.count == 0 {
                
                self.view.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.view.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                self.view.done.setTitle("Cancel", forState: UIControlState.Normal)
                self.view.fitToSizeDone()
            }
            
            println("selected tags are \(super.view.selectedTags)")
        }
        
        
    }
    
    
    
}
