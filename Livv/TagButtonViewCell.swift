//
//  TagButtonViewCell.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation

class TagButtonViewCell: UITableViewCell {
    
    var view: TagSelectorView!
    
    var theTag: Tags!
    var button: UIButton! = UIButton()
    var count: UIButton! = UIButton()
    var countNumber: Int!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.commonSetup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    init(style: UITableViewCellStyle, reuseIdentifier: String?, view: TagSelectorView, tag: Tags) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.view = view
        self.theTag = tag
        //self.title = title
        countNumber = tag.count + tag.userCount
        button.setTitle(tag.title, forState: .Normal)
        self.commonSetup()
        button.addTarget(self, action: "selectedTag:", forControlEvents: .TouchUpInside)
    }
    deinit {
        theTag = nil
        button = nil
        view = nil
        countNumber = nil
        count = nil
    }
    
    func commonSetup(){
        
        button.setTitleColor(UIColor(red: 50/255, green: 255/255, blue: 255/255, alpha: 1.0), forState: .Normal)
        //button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        button.sizeToFit()
        button.layer.cornerRadius = 2
        var titleWidth: CGFloat! = (button.frame.size.width as CGFloat!) + 10
        //println(button.titleLabel?.frame.size.width)
        //var titleHeight: CGFloat! = (button.frame.size.height as CGFloat!)
        //println(titleHeight)
        button.frame = CGRect(x: 10, y: 10, width: titleWidth, height: 31)
        println(button.frame)
        
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
    
    func countUpdate(sender: UIButton!){
        
        if view.pointsNumber > 0 {
            
            countNumber = countNumber + 1
            count.setTitle("\(countNumber)", forState: .Normal)
            self.view.selectedTags.append(theTag.title)
            
            theTag.userCount = theTag.userCount + 1
            view.decrementAPoint()
            
            //update outside
        }
    }
    
    func selectedTag(sender: UIButton!){
        
        if button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.9) {
            
            if view.pointsNumber > 0 {
                
                theTag.isSelected = true
                
                count.userInteractionEnabled = true
                
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.backgroundColor = UIColor(red: 50/255, green: 255/255, blue: 255/255, alpha: 0.9)
                
                //point counter
                theTag.userCount = theTag.userCount + 1
                countNumber = countNumber + 1
                count.setTitle("\(countNumber)", forState: .Normal)
                view.decrementAPoint()
                
                self.view.addTag.text = nil
                self.view.fitToSize()
                self.view.addTag.sizeToFit()
                
                if self.view.searchedTags.count > 0{
                    self.view.tags.insert(theTag, atIndex: 0)
                    self.view.searchedTags = []
                }
                //reload data?
                self.view.selectedTags.append(theTag.title)
                
                count.setTitleColor(UIColor(red: 50/255, green: 255/255, blue: 255/255, alpha: 1.0), forState: .Normal)
                
                
                if self.view.selectedTags.count != 0 {
                    
                    self.view.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    self.view.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                    self.view.done.setTitle("Submit", forState: UIControlState.Normal)
                    self.view.fitToSizeDone()
                }
            }
            
            //second selection
        } else if button.backgroundColor == UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.89) {
            
            println("reselected")
            
            if view.pointsNumber > 0 {
                
                theTag.isSelected = true
                
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.backgroundColor = UIColor(red: 50/255, green: 255/255, blue: 255/255, alpha: 0.89)
                
                count.userInteractionEnabled = true
                
                theTag.userCount = theTag.userCount + 1
                countNumber = countNumber + 1
                count.setTitle("\(countNumber)", forState: .Normal)
                view.decrementAPoint()
                
                count.setTitleColor(UIColor(red: 50/255, green: 255/255, blue: 255/255, alpha: 1.0), forState: .Normal)
                
                self.view.selectedTags.append(theTag.title)
                self.view.tableView.reloadData()
                println("selected tags are \(self.view.selectedTags)")
                
                if self.view.selectedTags.count != 0 {
                    
                    self.view.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    self.view.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                    self.view.done.setTitle("Submit", forState: UIControlState.Normal)
                    self.view.fitToSizeDone()
                }
            }
            
        }else { //remove
            
            theTag.isSelected = false
            
            button.setTitleColor(UIColor(red: 50/255, green: 255/255, blue: 255/255, alpha: 1.0), forState: .Normal)
            button.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.89)
            
            count.userInteractionEnabled = false
            
            view.incrementAPoint(theTag.userCount)
            theTag.userCount = 0
            
            count.setTitleColor(UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0), forState: .Normal)
            countNumber = theTag.count - theTag.userCount
            count.setTitle("\(countNumber)", forState: .Normal)
            
            for var i: Int = 0; i < self.view.selectedTags.count; i++ {
                
                if self.view.selectedTags[i] == theTag.title {
                    self.view.selectedTags.removeAtIndex(i)
                    i--
                }
                
            }
            
            println("selected tags are \(self.view.selectedTags)")
            
            if self.view.selectedTags.count == 0 {
                
                self.view.done.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.view.done.backgroundColor = UIColor(red: 26/255, green: 26/355, blue: 26/255, alpha: 0.9)
                self.view.done.setTitle("Cancel", forState: UIControlState.Normal)
                self.view.fitToSizeDone()
            }
        }
        
        
    }
    
}
