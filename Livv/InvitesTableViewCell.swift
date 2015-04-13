//
//  InvitesTableViewCell.swift
//  Livv
//
//  Created by Brent Kirkland on 4/11/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Foundation


class InvitesTableViewCell: UITableViewCell {
    
    var button: UIButton! = UIButton()
    var name: UILabel! = UILabel()
    var address: UILabel! = UILabel()
    var tags: UILabel! = UILabel()
    var line: UIView! = UIView()
    var view: TheListiewController!
    var invite: Invite!
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.commonSetup()
//    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, view: TheListiewController!, invite: Invite!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.view = view
        self.invite = invite
        self.commonSetup()
    }
    
    func commonSetup(){
        
        var g: CGFloat! = CGFloat(((arc4random_uniform(255))))
        var r: CGFloat! = CGFloat(((arc4random_uniform(255))))
        var b: CGFloat! = CGFloat(((arc4random_uniform(255))))
        
        line.frame = CGRectMake(10, 0, self.bounds.size.width-10, 1)
        line.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        line.autoresizingMask = .FlexibleWidth
        self.addSubview(line)
        
        button.frame = CGRectMake(10, 10, 60, 60)
        button.backgroundColor = UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: "map", forControlEvents: .TouchUpInside)
        var bi: UIImage! = UIImage(named: "blankicon.png")
        //var biv: UIImageView = UIImageView(image: bi)
        button.setImage(bi, forState: .Normal)
        self.addSubview(button)
        
        name.frame = CGRectMake(80, 10, self.bounds.size.width - 20, 20)
        name.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        name.autoresizingMask = .FlexibleWidth
        self.addSubview(name)
        
        tags.frame = CGRectMake(80, 31, self.bounds.size.width - 20, 20)
        tags.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        tags.autoresizingMask = .FlexibleWidth
        self.addSubview(tags)
        
        address.frame = CGRectMake(80, 51, self.bounds.size.width - 20, 20)
        address.font = UIFont(name: "HelveticaNeue-LightItalic", size: 14)
        address.autoresizingMask = .FlexibleWidth
        self.addSubview(address)
    }
    
    func map(){
        
        //println("taptap")
        
        
        let center = MapViewController()
        center.showSplashScreen = false
        center.inviteLocation = self.invite.location
        let nav = UINavigationController(rootViewController: center)
        self.view.evo_drawerController?.setCenterViewController(nav, withFullCloseAnimation: true, completion: nil)
        
    }
    
}