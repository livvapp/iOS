//
//  SettingsViewController.swift
//  Livv
//
//  Created by Brent Kirkland on 3/28/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Realm

enum DrawerSection: Int {
    case User
    case Help
    case Logout
}

class SettingsViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    //var separatorLineView: UIView! = UIView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "SettingsViewController"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func viewWillAppear(animated: Bool) {
    //        super.viewWillAppear(animated)
    //        println("Left will appear")
    //    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Left did appear")
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("Left will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("Left did disappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restorationIdentifier = "SettingsViewController"
        
        self.title = "Account"
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.navigationController?.view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        let font = UIFont(name: "HelveticaNeue-Light", size: 22)
        if let font = font {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)]
            //self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(4.5, forBarMetrics: .Default)
        }
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
        self.tableView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.scrollEnabled = false
        //self.tableView.rowHeight = 40
    }
    
    //    override func viewWillAppear(animated: Bool) {
    //            super.viewWillAppear(animated)
    //            self.tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: self.tableView.numberOfSections() - 1)), withRowAnimation: .None)
    //    }
    //
    //    override func contentSizeDidChange(size: String) {
    //            self.tableView.reloadData()
    //    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case DrawerSection.User.rawValue:
            return 2
        case DrawerSection.Help.rawValue:
            return 4
        case DrawerSection.Logout.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = TableViewCell(style: .Default, reuseIdentifier: CellIdentifier)
            //cell.selectionStyle = .Blue
        }
        
        cell.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        
        switch indexPath.section {
            
        case DrawerSection.User.rawValue:
            if indexPath.row == 0 {
                let users = User.allObjects()
                let user = users[UInt(0)] as! User
                cell.textLabel?.text = user.username
                var separatorLineView1: UIView! =  UIView(frame: CGRectMake(0, cell.frame.height, tableView.frame.size.width - 15, 1))
                separatorLineView1.backgroundColor  = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                cell.addSubview(separatorLineView1)
                
            } else {
                cell.textLabel?.text = "UCSB"
            }
            
        case DrawerSection.Help.rawValue:
            if indexPath.row == 0 {
                cell.textLabel?.text = "FAQ"
                var separatorLineView2: UIView! =  UIView(frame: CGRectMake(0, cell.frame.height, tableView.frame.size.width - 15, 1))
                separatorLineView2.backgroundColor  = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                cell.addSubview(separatorLineView2)
                cell.accessoryType = .DisclosureIndicator
            }
            else if indexPath.row == 1 {
                cell.textLabel?.text = "Privacy Policy"
                var separatorLineView3: UIView! =  UIView(frame: CGRectMake(0, cell.frame.height, tableView.frame.size.width - 15, 1))
                separatorLineView3.backgroundColor  = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                cell.addSubview(separatorLineView3)
                cell.accessoryType = .DisclosureIndicator
            }
            else if indexPath.row == 2 {
                cell.textLabel?.text = "Terms and Conditions"
                var separatorLineView4: UIView! =  UIView(frame: CGRectMake(0, cell.frame.height, tableView.frame.size.width - 15, 1))
                separatorLineView4.backgroundColor  = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                cell.addSubview(separatorLineView4)
                cell.accessoryType = .DisclosureIndicator
            }
            else {
                cell.textLabel?.text = "Updates"
                cell.accessoryType = .DisclosureIndicator
            }
        case DrawerSection.Logout.rawValue:
            cell.textLabel?.text = "Logout"
            cell.accessoryType = .DisclosureIndicator
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case DrawerSection.User.rawValue:
            return "User"
        case DrawerSection.Help.rawValue:
            return "Help"
        case DrawerSection.Logout.rawValue:
            return "Leaving?"
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SideDrawerSectionHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.bounds), height: 35.0))
        headerView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        headerView.title = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case DrawerSection.User.rawValue:
            break
        case DrawerSection.Help.rawValue:
            if indexPath.row == 0 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://livv.net/faq")!)
            }
            else if indexPath.row == 1 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://livv.net/privacy")!)
            }
            else if indexPath.row == 2 {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://livv.net/terms")!)
            }
            else {
                UIApplication.sharedApplication().openURL(NSURL(string: "http://twitter.com/livvapp")!)
            }
        case DrawerSection.Logout.rawValue:
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            realm.deleteAllObjects()
            realm.commitWriteTransaction()
            (UIApplication.sharedApplication().delegate as! AppDelegate).switchToLogin()
        default:
            break
        }
        
        
    }
    
    
}
