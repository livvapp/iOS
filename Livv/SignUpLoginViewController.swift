//
//  SignUpLoginViewController.swift
//  Livv
//
//  Created by Brent Kirkland on 2/15/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import UIKit
import Realm
import Alamofire
import SwiftyJSON


class SignUpLoginViewController: UIViewController, UITextFieldDelegate {
    
    private var emailbox: UIView!
    private var emailTextField: UITextField!
    private var emailcodebox: UIView!
    private var emailVerifyField: UITextField!
    private var phoneandpasswordbox: UIView!
    private var phoneTextField: UITextField!
    private var passwordTextField: UITextField!
    
    //verify button
    private var editEmail: UIButton!
    private var sendAgain: UIButton!
    private var verifyEmailCode: UIButton!
    
    //a code has been sent too:
    var emailverifyLabelExplanation: UILabel!
    var phoneverifyLabelExplanation: UILabel!
    
    //verify phone
    
    private var phonecodebox: UIView!
    private var phoneVerifyField: UITextField!
    private var editPhone: UIButton!
    private var sendAgainPhone: UIButton!
    private var verifyPhoneCode: UIButton!
    
    //login
    private var loginbox: UIView!
    private var phoneTextFieldLogin: UITextField!
    //private var passwordTextFieldLogin: UITextField!
    
    //loginverify
    private var loginverifybox: UIView!
    private var loginVerifyField: UITextField!
    
    //explanation windows
    private var contactexplanationbox: UIView!
    private var locationexplanationbox: UIView!
    private var notificationexplanationbox: UIView!
    
    //exit button
    private var exit: UIButton!
    
    //forgot button
    //    private var forgot: UIButton!
    //    private var forgotbox: UIView!
    //    private var emailTextFieldForgot: UITextField!
    
    //error button
    private var error: UILabel!
    
    //keyboard height
    
    private var keyboard: CGFloat! = 216.0
    
    //CURRENT VIEW
    
    private var current: UIView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    init() {
        super.init(nibName:"SignUpLoginViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    var window: UIWindow!
    
    init(window: UIWindow){
        
        super.init(nibName: nil, bundle: nil)
        
        self.window = window
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.restorationIdentifier = "SignUpLoginViewControllerRestorationKey"
        //NSUserDefaults.standardUserDefaults().setObject("0", forKey: "step")
        
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        
        //keyboard notifer
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        
        //ERROR LABEL
        error = UILabel(frame: CGRectMake(0, 350, self.view.frame.size.width, 50))
        error.text = "Oops something went wrong"
        error.textColor = UIColor.whiteColor()
        error.textAlignment = NSTextAlignment.Center
        error.hidden = true
        self.view.addSubview(error)
        
        
        //VIEW BACKGROUND
        view.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        
        
        //EXIT BUTTON FOR MINI VIEWS
        exit = UIButton(frame: CGRectMake(self.view.frame.width - 70, 20, 50, 50))
        exit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        exit.setTitle("Exit", forState: UIControlState.Normal)
        exit.setTitleColor(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 0.5), forState: UIControlState.Normal)
        exit.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
        exit.hidden = true
        exit.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22.0)
        self.view.addSubview(exit)
        
        
        //Pleeb Title
        var title = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-250))
        title.textAlignment = NSTextAlignment.Center
        title.text = "L I V V"
        title.textColor = UIColor.whiteColor()
        title.font = UIFont(name: "HelveticaNeue-UltraLight",
            size: 66.0)
        self.view.addSubview(title)
        
        //Pleeb Description
        var desc = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-150))
        desc.textAlignment = NSTextAlignment.Center
        desc.text = "The College Community Builder"
        desc.textColor = UIColor.whiteColor()
        desc.font = UIFont(name: "HelveticaNeue-Thin",
            size: 16.0)
        self.view.addSubview(desc)
        
        //signup button
        var signup = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        signup.frame = CGRectMake(50, view.frame.height - 200, view.frame.width - 100, 50)
        signup.backgroundColor = UIColor(red: 140, green: 198, blue: 63, alpha: 1.0)
        signup.layer.cornerRadius = 2.0
        signup.setTitle("Sign Up", forState: UIControlState.Normal)
        signup.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        signup.addTarget(self, action: "signup:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(signup)
        
        //login button
        var login = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        login.frame = CGRectMake(50, view.frame.height - 140, view.frame.width - 100, 50)
        login.backgroundColor = UIColor.clearColor()
        login.layer.cornerRadius = 2.0
        login.layer.borderWidth = 1.0
        login.layer.borderColor = UIColor(red: 140, green: 198, blue: 63, alpha: 1.0).CGColor
        login.setTitle("Login", forState: UIControlState.Normal)
        login.setTitleColor(UIColor(red: 140, green: 198, blue: 63, alpha: 1.0), forState: UIControlState.Normal)
        login.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(login)
        
        
        
        //EMAIL BOX - FIRST BOX OF SIGN UP FORM
        var frame: CGRect = CGRectMake(50, -170, self.view.frame.size.width-100, 170)
        emailbox = UIView(frame: frame)
        emailbox.backgroundColor = UIColor.whiteColor()
        emailbox.layer.cornerRadius = 2.0
        emailbox.hidden = true
        self.view.addSubview(emailbox)
        
        //textfield
        emailTextField = UITextField(frame: CGRectMake(5, emailbox.frame.size.height-110, emailbox.frame.size.width-10, 50))
        emailTextField.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        emailTextField.placeholder = "Email"
        emailTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.None
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        //        emailTextField.leftViewMode = UITextFieldViewMode.Always
        //        emailTextField.leftView = UIView(frame: CGRectMake(0,0,5,5))
        emailTextField.textAlignment = NSTextAlignment.Center
        emailTextField.font = UIFont(name: "HelveticaNeue",
            size: 19.0)
        
        emailbox.addSubview(emailTextField)
        
        //Submit Button
        var emailSubmit: UIButton = UIButton(frame: CGRectMake(5, emailbox.frame.size.height-55, emailbox.frame.size.width-10, 50))
        emailSubmit.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        emailSubmit.setTitle("Verify", forState: UIControlState.Normal)
        emailSubmit.addTarget(self, action: "verify:", forControlEvents: UIControlEvents.TouchUpInside)
        emailbox.addSubview(emailSubmit)
        
        var emailLabel: UILabel = UILabel(frame: CGRectMake(5, 0, emailbox.frame.size.width-10, 40))
        emailLabel.text = "Student Email"
        emailLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 22.0)
        emailLabel.textAlignment = NSTextAlignment.Center
        emailbox.addSubview(emailLabel)
        
        
        var emailLabelExplanation: UILabel = UILabel(frame: CGRectMake(20, 27, emailbox.frame.size.width-40, 30))
        emailLabelExplanation.text = "Livv is currently available for college students."
        emailLabelExplanation.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        emailLabelExplanation.numberOfLines = 2
        emailLabelExplanation.textAlignment = NSTextAlignment.Center
        emailbox.addSubview(emailLabelExplanation)
        
        
        //EMAIL CODE BOX - TO verify box
        
        //var verifyframe: CGRect = CGRectMake(50, 100, self.view.frame.size.width-100, 170)
        emailcodebox = UIView(frame:  frame)
        emailcodebox.backgroundColor = UIColor.whiteColor()
        emailcodebox.layer.cornerRadius = 2.0
        emailcodebox.hidden = true
        self.view.addSubview(emailcodebox)
        
        
        //Field for code
        emailVerifyField = UITextField(frame: CGRectMake(5, emailcodebox.frame.size.height-110, emailcodebox.frame.size.width-10, 50))
        emailVerifyField.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        emailVerifyField.placeholder = "Three Digit Code"
        emailVerifyField.textAlignment = NSTextAlignment.Center
        emailVerifyField.font = UIFont(name: "HelveticaNeue",
            size: 19.0)
        emailVerifyField.keyboardAppearance = UIKeyboardAppearance.Dark
        emailVerifyField.keyboardType = UIKeyboardType.PhonePad
        emailVerifyField.autocapitalizationType = UITextAutocapitalizationType.None
        emailVerifyField.autocorrectionType = UITextAutocorrectionType.No
        emailVerifyField.addTarget(self, action: "changedText:", forControlEvents: UIControlEvents.EditingChanged)
        emailcodebox.addSubview(emailVerifyField)
        
        
        //middle line
        var middleline: UIView = UIView(frame: CGRectMake(emailcodebox.frame.size.width/2, emailcodebox.frame.size.height - 55, 1, 50))
        middleline.backgroundColor = UIColor.blackColor()
        emailcodebox.addSubview(middleline)
        
        //edit email button
        editEmail = UIButton(frame: CGRectMake(5, emailcodebox.frame.size.height-55, emailcodebox.frame.size.width/2 - 10, 50))
        editEmail.setTitle("Edit Email", forState: UIControlState.Normal)
        editEmail.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        editEmail.addTarget(self, action: "editEmail:", forControlEvents: UIControlEvents.TouchUpInside)
        emailcodebox.addSubview(editEmail)
        
        //send again button
        sendAgain = UIButton(frame: CGRectMake(emailcodebox.frame.size.width/2 + 5, emailcodebox.frame.size.height-55, emailcodebox.frame.size.width/2 - 10, 50))
        sendAgain.setTitle("Send Again", forState: UIControlState.Normal)
        sendAgain.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        sendAgain.addTarget(self, action: "sendAgain:", forControlEvents: UIControlEvents.TouchUpInside)
        emailcodebox.addSubview(sendAgain)
        
        //verify code title
        var emailverifyLabel: UILabel = UILabel(frame: CGRectMake(5, 0, emailcodebox.frame.size.width-10, 40))
        emailverifyLabel.text = "Email Code"
        emailverifyLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 22.0)
        emailverifyLabel.textAlignment = NSTextAlignment.Center
        emailcodebox.addSubview(emailverifyLabel)
        
        //verify code description
        emailverifyLabelExplanation = UILabel(frame: CGRectMake(20, 27, emailcodebox.frame.size.width-40, 30))
        emailverifyLabelExplanation.text = "A code has been sent to your email."
        emailverifyLabelExplanation.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        emailverifyLabelExplanation.numberOfLines = 2
        emailverifyLabelExplanation.textAlignment = NSTextAlignment.Center
        emailcodebox.addSubview(emailverifyLabelExplanation)
        
        //verify code button that changes when typed
        verifyEmailCode = UIButton(frame: CGRectMake(5, emailcodebox.frame.size.height-55, emailcodebox.frame.size.width-10, 50))
        verifyEmailCode.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        verifyEmailCode.setTitle("Verify", forState: UIControlState.Normal)
        verifyEmailCode.addTarget(self, action: "verifyemailcode:", forControlEvents: UIControlEvents.TouchUpInside)
        verifyEmailCode.hidden = true
        emailcodebox.addSubview(verifyEmailCode)
        
        
        //PHONE AND PASSWORD MINI VIEW
        phoneandpasswordbox = UIView(frame: frame)
        phoneandpasswordbox.backgroundColor = UIColor.whiteColor()
        phoneandpasswordbox.layer.cornerRadius = 2.0
        phoneandpasswordbox.hidden = true
        self.view.addSubview(phoneandpasswordbox)
        
        phoneTextField = UITextField(frame: CGRectMake(5, 60, phoneandpasswordbox.frame.size.width-10, 50))
        phoneTextField.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        phoneTextField.placeholder = "Phone Number"
        phoneTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        phoneTextField.keyboardType = UIKeyboardType.PhonePad
        phoneTextField.autocapitalizationType = UITextAutocapitalizationType.None
        phoneTextField.autocorrectionType = UITextAutocorrectionType.No
        phoneTextField.delegate = self
        phoneTextField.textAlignment = NSTextAlignment.Center
        phoneTextField.font = UIFont(name: "HelveticaNeue",
            size: 19.0)
        
        
        //spacing for next to textbox
        phoneTextField.leftViewMode = UITextFieldViewMode.Always
        phoneTextField.leftView = UIView(frame: CGRectMake(0,0,5,5))
        
        phoneandpasswordbox.addSubview(phoneTextField)
        
        var phoneLabel: UILabel = UILabel(frame: CGRectMake(5, 0, emailbox.frame.size.width-10, 40))
        phoneLabel.text = "Phone Number"
        phoneLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 22.0)
        phoneLabel.textAlignment = NSTextAlignment.Center
        phoneandpasswordbox.addSubview(phoneLabel)
        
        
        var phoneLabelExplanation: UILabel = UILabel(frame: CGRectMake(20, 27, emailbox.frame.size.width-40, 30))
        phoneLabelExplanation.text = "Just to double check you're human."
        phoneLabelExplanation.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        phoneLabelExplanation.numberOfLines = 2
        phoneLabelExplanation.textAlignment = NSTextAlignment.Center
        phoneandpasswordbox.addSubview(phoneLabelExplanation)
        
        var submitPhoneAndPassword: UIButton = UIButton(frame: CGRectMake(5, emailcodebox.frame.size.height-55, emailcodebox.frame.size.width-10, 50))
        submitPhoneAndPassword.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        submitPhoneAndPassword.setTitle("Submit", forState: UIControlState.Normal)
        submitPhoneAndPassword.addTarget(self, action: "submitPhoneAndPassword:", forControlEvents: UIControlEvents.TouchUpInside)
        phoneandpasswordbox.addSubview(submitPhoneAndPassword)
        
        // VERIFY PHONE FIELD
        
        phonecodebox = UIView(frame:  frame)
        phonecodebox.backgroundColor = UIColor.whiteColor()
        phonecodebox.layer.cornerRadius = 2.0
        phonecodebox.hidden = true
        
        self.view.addSubview(phonecodebox)
        
        //code field
        phoneVerifyField = UITextField(frame: CGRectMake(5, phonecodebox.frame.size.height-110, phonecodebox.frame.size.width-10, 50))
        phoneVerifyField.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        phoneVerifyField.placeholder = "Three Digit Code"
        phoneVerifyField.textAlignment = NSTextAlignment.Center
        phoneVerifyField.font = UIFont(name: "HelveticaNeue",
            size: 19.0)
        phoneVerifyField.keyboardAppearance = UIKeyboardAppearance.Dark
        phoneVerifyField.keyboardType = UIKeyboardType.PhonePad
        phoneVerifyField.autocapitalizationType = UITextAutocapitalizationType.None
        phoneVerifyField.autocorrectionType = UITextAutocorrectionType.No
        phoneVerifyField.addTarget(self, action: "changedTextPhone:", forControlEvents: UIControlEvents.EditingChanged)
        phonecodebox.addSubview(phoneVerifyField)
        
        
        //middle line
        middleline = UIView(frame: CGRectMake(emailcodebox.frame.size.width/2, emailcodebox.frame.size.height - 55, 1, 50))
        middleline.backgroundColor = UIColor.blackColor()
        phonecodebox.addSubview(middleline)
        
        //edit email button
        editPhone = UIButton(frame: CGRectMake(5, emailcodebox.frame.size.height-55, emailcodebox.frame.size.width/2 - 10, 50))
        editPhone.setTitle("Edit Phone", forState: UIControlState.Normal)
        editPhone.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        editPhone.addTarget(self, action: "editPhone:", forControlEvents: UIControlEvents.TouchUpInside)
        phonecodebox.addSubview(editPhone)
        
        //send again button
        sendAgainPhone = UIButton(frame: CGRectMake(emailcodebox.frame.size.width/2 + 5, emailcodebox.frame.size.height-55, emailcodebox.frame.size.width/2 - 10, 50))
        sendAgainPhone.setTitle("Send Again", forState: UIControlState.Normal)
        sendAgainPhone.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        sendAgainPhone.addTarget(self, action: "submitPhoneAndPassword:", forControlEvents: UIControlEvents.TouchUpInside)
        phonecodebox.addSubview(sendAgainPhone)
        
        //verify code title
        var phoneverifyLabel: UILabel = UILabel(frame: CGRectMake(5, 0, emailcodebox.frame.size.width-10, 40))
        phoneverifyLabel.text = "Text Code"
        phoneverifyLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 22.0)
        phoneverifyLabel.textAlignment = NSTextAlignment.Center
        phonecodebox.addSubview(phoneverifyLabel)
        
        //verify code description
        phoneverifyLabelExplanation = UILabel(frame: CGRectMake(20, 27, emailcodebox.frame.size.width-40, 30))
        phoneverifyLabelExplanation.text = "A three digit code was sent to"
        phoneverifyLabelExplanation.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        phoneverifyLabelExplanation.numberOfLines = 2
        phoneverifyLabelExplanation.textAlignment = NSTextAlignment.Center
        phonecodebox.addSubview(phoneverifyLabelExplanation)
        
        //verify code button that changes when typed
        verifyPhoneCode = UIButton(frame: CGRectMake(5, emailcodebox.frame.size.height-55, emailcodebox.frame.size.width-10, 50))
        verifyPhoneCode.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        verifyPhoneCode.setTitle("Verify", forState: UIControlState.Normal)
        verifyPhoneCode.addTarget(self, action: "verifyPhoneCode:", forControlEvents: UIControlEvents.TouchUpInside)
        verifyPhoneCode.hidden = true
        phonecodebox.addSubview(verifyPhoneCode)
        
        
        //REASON FOR CONTACTS
        contactexplanationbox = UIView(frame: CGRectMake(50, -170, self.view.frame.size.width-100, 115))
        contactexplanationbox.backgroundColor = UIColor.whiteColor()
        contactexplanationbox.layer.cornerRadius = 2.0
        contactexplanationbox.hidden = true
        self.view.addSubview(contactexplanationbox)
        
        //verify code title
        var nameverifyLabel: UILabel = UILabel(frame: CGRectMake(5, 0, emailcodebox.frame.size.width-10, 40))
        nameverifyLabel.text = "Grant Contact Access"
        nameverifyLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 22.0)
        nameverifyLabel.textAlignment = NSTextAlignment.Center
        contactexplanationbox.addSubview(nameverifyLabel)
        
        var nameverifyLabelExplanation = UILabel(frame: CGRectMake(20, 27, emailcodebox.frame.size.width-40, 30))
        nameverifyLabelExplanation.text = "Please grant access to the following popup. \nLivv uses your contacts for friends."
        nameverifyLabelExplanation.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        nameverifyLabelExplanation.numberOfLines = 2
        nameverifyLabelExplanation.textAlignment = NSTextAlignment.Center
        contactexplanationbox.addSubview(nameverifyLabelExplanation)
        
        var verifyName = UIButton(frame: CGRectMake(5, contactexplanationbox.frame.size.height-55, contactexplanationbox.frame.size.width-10, 50))
        verifyName.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        verifyName.setTitle("Ok. Got it.", forState: UIControlState.Normal)
        verifyName.addTarget(self, action: "contactProceed:", forControlEvents: UIControlEvents.TouchUpInside)
        contactexplanationbox.addSubview(verifyName)
        
        //BUBBLE COMES UP
        //REASON FOR LOCATION
        //REASON FOR CONTACTS
        locationexplanationbox = UIView(frame: CGRectMake(50, -170, self.view.frame.size.width-100, 115))
        locationexplanationbox.backgroundColor = UIColor.whiteColor()
        locationexplanationbox.layer.cornerRadius = 2.0
        locationexplanationbox.hidden = true
        self.view.addSubview(locationexplanationbox)
        
        //verify code title
        var locationReasonLabel: UILabel = UILabel(frame: CGRectMake(5, 0, emailcodebox.frame.size.width-10, 40))
        locationReasonLabel.text = "Location Services"
        locationReasonLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 22.0)
        locationReasonLabel.textAlignment = NSTextAlignment.Center
        locationexplanationbox.addSubview(locationReasonLabel)
        
        var locationReasonLabelExplanation = UILabel(frame: CGRectMake(20, 27, emailcodebox.frame.size.width-40, 30))
        locationReasonLabelExplanation.text = "Please grant access to the following popup. \nLivv uses your location to find local events."
        locationReasonLabelExplanation.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        locationReasonLabelExplanation.numberOfLines = 2
        locationReasonLabelExplanation.textAlignment = NSTextAlignment.Center
        locationexplanationbox.addSubview(locationReasonLabelExplanation)
        
        var proceedToVerifyLocationServices = UIButton(frame: CGRectMake(5, locationexplanationbox.frame.size.height-55, locationexplanationbox.frame.size.width-10, 50))
        proceedToVerifyLocationServices.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        proceedToVerifyLocationServices.setTitle("Got it!", forState: UIControlState.Normal)
        proceedToVerifyLocationServices.addTarget(self, action: "locationProceed:", forControlEvents: UIControlEvents.TouchUpInside)
        locationexplanationbox.addSubview(proceedToVerifyLocationServices)
        
        //BUBBLE COMES UP
        
        //NOTIFICATION WINDOW
        notificationexplanationbox = UIView(frame: CGRectMake(50, -170, self.view.frame.size.width-100, 115))
        notificationexplanationbox.backgroundColor = UIColor.whiteColor()
        notificationexplanationbox.layer.cornerRadius = 2.0
        notificationexplanationbox.hidden = true
        self.view.addSubview(notificationexplanationbox)
        
        //verify code title
        var notificationReasonLabel: UILabel = UILabel(frame: CGRectMake(5, 0, emailcodebox.frame.size.width-10, 40))
        notificationReasonLabel.text = "Enable Notifications"
        notificationReasonLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 22.0)
        notificationReasonLabel.textAlignment = NSTextAlignment.Center
        notificationexplanationbox.addSubview(notificationReasonLabel)
        
        var notificationReasonLabelExplanation = UILabel(frame: CGRectMake(20, 27, emailcodebox.frame.size.width-40, 30))
        notificationReasonLabelExplanation.text = "Please grant access to the following popup. \nLivv uses notification to alert you about invites."
        notificationReasonLabelExplanation.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        notificationReasonLabelExplanation.numberOfLines = 2
        notificationReasonLabelExplanation.textAlignment = NSTextAlignment.Center
        notificationexplanationbox.addSubview(notificationReasonLabelExplanation)
        
        var proceedToVerifyNotificationServices = UIButton(frame: CGRectMake(5, notificationexplanationbox.frame.size.height-55, notificationexplanationbox.frame.size.width-10, 50))
        proceedToVerifyNotificationServices.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        proceedToVerifyNotificationServices.setTitle("Got it!", forState: UIControlState.Normal)
        proceedToVerifyNotificationServices.addTarget(self, action: "notificationProceed:", forControlEvents: UIControlEvents.TouchUpInside)
        notificationexplanationbox.addSubview(proceedToVerifyNotificationServices)
        
        
        /////////////////////////////////////LOG IN//////////////////////////////////////////
        //LOG IN
        
        loginbox = UIView(frame: CGRectMake(50, -170, self.view.frame.size.width-100, 170))
        loginbox.backgroundColor = UIColor.whiteColor()
        loginbox.layer.cornerRadius = 2.0
        loginbox.hidden = true
        self.view.addSubview(loginbox)
        
        phoneTextFieldLogin = UITextField(frame: CGRectMake(5, 60, loginbox.frame.size.width-10, 50))
        phoneTextFieldLogin.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        phoneTextFieldLogin.placeholder = "Phone Number"
        phoneTextFieldLogin.keyboardAppearance = UIKeyboardAppearance.Dark
        phoneTextFieldLogin.keyboardType = UIKeyboardType.PhonePad
        phoneTextFieldLogin.autocapitalizationType = UITextAutocapitalizationType.None
        phoneTextFieldLogin.autocorrectionType = UITextAutocorrectionType.No
        phoneTextFieldLogin.textAlignment = NSTextAlignment.Center
        phoneTextFieldLogin.font = UIFont(name: "HelveticaNeue",
            size: 19.0)
        phoneTextFieldLogin.delegate = self
        loginbox.addSubview(phoneTextFieldLogin)
        
        
        var submitPhoneLogin:UIButton = UIButton(frame: CGRectMake(5, loginbox.frame.size.height-55, loginbox.frame.size.width-10, 50))
        submitPhoneLogin.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        submitPhoneLogin.setTitle("Login", forState: UIControlState.Normal)
        submitPhoneLogin.addTarget(self, action: "submitLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        loginbox.addSubview(submitPhoneLogin)
        
        
        var phoneLoginLabel: UILabel = UILabel(frame: CGRectMake(5, 0, emailbox.frame.size.width-10, 40))
        phoneLoginLabel.text = "Login"
        phoneLoginLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 22.0)
        phoneLoginLabel.textAlignment = NSTextAlignment.Center
        loginbox.addSubview(phoneLoginLabel)
        
        var phoneLabelExplanationForgot: UILabel = UILabel(frame: CGRectMake(20, 27, emailbox.frame.size.width-40, 30))
        phoneLabelExplanationForgot.text = "Enter your phone. We'll text you a login code."
        phoneLabelExplanationForgot.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        phoneLabelExplanationForgot.numberOfLines = 2
        phoneLabelExplanationForgot.textAlignment = NSTextAlignment.Center
        loginbox.addSubview(phoneLabelExplanationForgot)
        
        
        //VERIFY
        loginverifybox = UIView(frame: CGRectMake(50, -170, self.view.frame.size.width-100, 170))
        loginverifybox.backgroundColor = UIColor.whiteColor()
        loginverifybox.layer.cornerRadius = 2.0
        loginverifybox.hidden = true
        self.view.addSubview(loginverifybox)
        
        var verifyPhone:UIButton = UIButton(frame: CGRectMake(5, loginbox.frame.size.height-55, loginbox.frame.size.width-10, 50))
        verifyPhone.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0)
        verifyPhone.setTitle("Login", forState: UIControlState.Normal)
        verifyPhone.addTarget(self, action: "verifyPhoneLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        loginverifybox.addSubview(verifyPhone)
        
        loginVerifyField = UITextField(frame: CGRectMake(5, 60, loginbox.frame.size.width-10, 50))
        loginVerifyField.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        loginVerifyField.placeholder = "6 Digit Code"
        loginVerifyField.keyboardAppearance = UIKeyboardAppearance.Dark
        loginVerifyField.keyboardType = UIKeyboardType.PhonePad
        loginVerifyField.autocapitalizationType = UITextAutocapitalizationType.None
        loginVerifyField.autocorrectionType = UITextAutocorrectionType.No
        loginVerifyField.textAlignment = NSTextAlignment.Center
        loginVerifyField.font = UIFont(name: "HelveticaNeue",
            size: 19.0)
        loginVerifyField.delegate = self
        loginverifybox.addSubview(loginVerifyField)
        
        
        var phoneVerifyLoginLabel: UILabel = UILabel(frame: CGRectMake(5, 0, emailbox.frame.size.width-10, 40))
        phoneVerifyLoginLabel.text = "Login Code"
        phoneVerifyLoginLabel.font = UIFont(name: "HelveticaNeue-Bold",
            size: 22.0)
        phoneVerifyLoginLabel.textAlignment = NSTextAlignment.Center
        loginverifybox.addSubview(phoneVerifyLoginLabel)
        
        var phoneVerifyLabelExplanationForgot: UILabel = UILabel(frame: CGRectMake(20, 27, emailbox.frame.size.width-40, 30))
        phoneVerifyLabelExplanationForgot.text = "Enter the 6 digit code we texted you."
        phoneVerifyLabelExplanationForgot.font = UIFont(name: "HelveticaNeue",
            size: 9.0)
        phoneVerifyLabelExplanationForgot.numberOfLines = 2
        phoneVerifyLabelExplanationForgot.textAlignment = NSTextAlignment.Center
        loginverifybox.addSubview(phoneVerifyLabelExplanationForgot)
        
        self.buildAgreeTextViewFromString("By using Livv, you agree to the #<ts>terms of service #and #<pp>privacy policy#.")
        
        //OPEN AUTO
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("step")) == nil){

        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "1" {
            var email = (NSUserDefaults.standardUserDefaults().objectForKey("email") as! String)
            self.emailverifyLabelExplanation.text = "A code has been sent to \(email)"
            self.emailcodebox.hidden = false
            self.openWindow(self.emailcodebox)
            self.emailVerifyField.becomeFirstResponder()
            
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "2" {
            self.phoneandpasswordbox.hidden = false
            self.phoneTextField.becomeFirstResponder()
            self.openWindow(self.phoneandpasswordbox)
            
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "3" {
            var phone = (NSUserDefaults.standardUserDefaults().objectForKey("phone") as! String)
            self.phoneverifyLabelExplanation.text = "A code has been sent to \(phone)"
            self.phonecodebox.hidden = false
            self.phoneVerifyField.becomeFirstResponder()
            self.openWindow(self.phonecodebox)
            
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "4" {
            self.contactexplanationbox.hidden = false
            self.openWindow(self.contactexplanationbox)
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "5" {
            self.locationexplanationbox.hidden = false
            self.openWindow(self.locationexplanationbox)
            
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "6" {
            self.notificationexplanationbox.hidden = false
            self.openWindow(self.notificationexplanationbox)
            
        }
        else {
            self.loginverifybox.hidden = false
            self.loginVerifyField.becomeFirstResponder()
            self.openWindow(self.loginverifybox)
        }
    }

    func verifyPhoneLogin(sender: UIButton!){
        
        if count(loginVerifyField.text) != 7 {
            
            error.text = "Please enter a 6 digit code"
            error.hidden = false
        } else {
            
            var phone = (NSUserDefaults.standardUserDefaults().objectForKey("phone") as! String)
            //self.phoneVerifyLabelExplanationForgot.text = "A code has been sent to \(phone)"
            
            let parameters = ["phone": "1\(phone)", "password": "\(loginVerifyField.text.substringWithRange(Range<String.Index>(start: advance(loginVerifyField.text.startIndex, 0), end: advance(loginVerifyField.text.startIndex, 3))) + loginVerifyField.text.substringWithRange(Range<String.Index>(start: advance(loginVerifyField.text.startIndex, 4), end: advance(loginVerifyField.text.endIndex, 0))))"]
            
            Alamofire.request(.POST, "\(globalURL)/auth/local", parameters: parameters, encoding: .JSON).validate(statusCode: 200..<300).responseJSON {
                (request, response, json, error) in
                
                println("Request: \(request)")
                println("Response: \(response)")
                println("Data: \(json)")
                println("Error: \(error)")
                
                if error == nil {
                    
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "step")
                    
                    println(JSON(json!))
                    
                    var myJSON = JSON(json!)
                    
                    //write the user to the database so the user can find it
                    let realm = RLMRealm.defaultRealm()
                    realm.beginWriteTransaction()
                    realm.deleteAllObjects()
                    
                    let newUser = User()
                    
                    //newUser.email = self.emailTextField.text
                    newUser.token = myJSON["token"].string!
                    newUser.phone = "1\(phone)"
                    
                    realm.addObject(newUser)
                    realm.commitWriteTransaction()
                    
                    self.getUsername()
                    
                    
                    
                }else {
                    
                    var error: String = "verifyPhoneLogin error: \(request), response: \(response), data: \(json), error: \(error)"
                    
                    DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                    
                    self.error.hidden = false
                    self.error.text = "Oops! Wrong code!"
                }
                
            }
            
            
        }
        
    }
    
    func getUsername(){
        
        let users = User.allObjects()
        let user = users[UInt(0)] as! User
        
        let URL = NSURL(string:"\(globalURL)/api/users/me")
        let mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        Alamofire.request(mutableURLRequest).validate(statusCode: 200..<305).responseJSON { (req, res, json, error) in
            
            println("Request: \(req)")
            println("Response: \(res)")
            println("JSON Data: \(json)")
            println("Error: \(error)")
            
            if error == nil {
                
                var myJSON = JSON(json!)
                if (myJSON["username"] != nil){
                    let realm = RLMRealm.defaultRealm()
                    realm.beginWriteTransaction()
                    user.username = myJSON["username"].stringValue
                    user.complete = true
                    realm.commitWriteTransaction()
                }
                LoginOrDrawerController(frame: self.window.frame).root(self.window)
                
            }else{
                
                var error: String = "getUsername error! request: \(req), response: \(res), data: \(json), error: \(error)"
                
                DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                
            }
        }
    }
    
    func submitLogin(sender: UIButton!){

        if (phoneTextFieldLogin.text == ""){
            error.hidden = false
            error.text = "Please enter a valid phone number"
        }
        if (count(phoneTextFieldLogin.text.substringWithRange(Range<String.Index>(start: advance(phoneTextFieldLogin.text.startIndex, 1), end: advance(phoneTextFieldLogin.text.startIndex, 4))) + phoneTextFieldLogin.text.substringWithRange(Range<String.Index>(start: advance(phoneTextFieldLogin.text.startIndex, 6), end: advance(phoneTextFieldLogin.text.startIndex, 9))) + phoneTextFieldLogin.text.substringWithRange(Range<String.Index>(start: advance(phoneTextFieldLogin.text.startIndex, 10), end: advance(phoneTextFieldLogin.text.endIndex, 0)))) != 10){
            error.hidden = false
            error.text = "Please enter a ten digit phone number"
            
        } else {
            
            NSUserDefaults.standardUserDefaults().setObject("\(phoneTextFieldLogin.text.substringWithRange(Range<String.Index>(start: advance(phoneTextFieldLogin.text.startIndex, 1), end: advance(phoneTextFieldLogin.text.startIndex, 4))) + phoneTextFieldLogin.text.substringWithRange(Range<String.Index>(start: advance(phoneTextFieldLogin.text.startIndex, 6), end: advance(phoneTextFieldLogin.text.startIndex, 9))) + phoneTextFieldLogin.text.substringWithRange(Range<String.Index>(start: advance(phoneTextFieldLogin.text.startIndex, 10), end: advance(phoneTextFieldLogin.text.endIndex, 0))))", forKey: "phone")
            
//            var email = (NSUserDefaults.standardUserDefaults().objectForKey("email") as! String)
//            self.emailverifyLabelExplanation.text = "A code has been sent to \(email)"
            
            let parameters = ["phone": "1\(phoneTextFieldLogin.text.substringWithRange(Range<String.Index>(start: advance(phoneTextFieldLogin.text.startIndex, 1), end: advance(phoneTextFieldLogin.text.startIndex, 4))) + phoneTextFieldLogin.text.substringWithRange(Range<String.Index>(start: advance(phoneTextFieldLogin.text.startIndex, 6), end: advance(phoneTextFieldLogin.text.startIndex, 9))) + phoneTextFieldLogin.text.substringWithRange(Range<String.Index>(start: advance(phoneTextFieldLogin.text.startIndex, 10), end: advance(phoneTextFieldLogin.text.endIndex, 0))))"]
            
            Alamofire.request(.POST, "\(globalURL)/api/tokens", parameters: parameters, encoding: .JSON).validate(statusCode: 200..<300).response {
                (request, response, data, error) in
                
                println("Request: \(request)")
                println("Response: \(response)")
                println("Data: \(data)")
                println("Error: \(error)")
                
                if error == nil {
                    
                    self.closeWindow(self.loginbox)
                    
                    self.loginverifybox.hidden = false
                    self.loginVerifyField.becomeFirstResponder()
                    
                    self.openWindow(self.loginverifybox)
                    NSUserDefaults.standardUserDefaults().setObject("7", forKey: "step")
                    
                }else {
                    
                    var error: String = "submitLogin phone error! request: \(request), response: \(response), data: \(data), error: \(error)"
                    
                    DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                    
                    self.error.hidden = false
                    self.error.text = "Oops! This phone doesn't exist."
                }
                
            }
            
            
            
        }
        
    }
    
    func submitPhoneAndPassword(sender: UIButton!){
        
        
        
        if (count((phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(phoneTextField.text.startIndex, 1), end: advance(phoneTextField.text.startIndex, 4))) + phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(phoneTextField.text.startIndex, 6), end: advance(phoneTextField.text.startIndex, 9))) + phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(phoneTextField.text.startIndex, 10), end: advance(phoneTextField.text.endIndex, 0))))) == 10){
            
            var email = (NSUserDefaults.standardUserDefaults().objectForKey("email") as! String)
            //self.emailverifyLabelExplanation.text = "A code has been sent to \(email)"
            
            let parameters = [ "phone" : "1\(phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(phoneTextField.text.startIndex, 1), end: advance(phoneTextField.text.startIndex, 4))) + phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(phoneTextField.text.startIndex, 6), end: advance(phoneTextField.text.startIndex, 9))) + phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(phoneTextField.text.startIndex, 10), end: advance(phoneTextField.text.endIndex, 0))))", "email": email, "password": "stoptryingtoreverseengineerourrestapi"]
            
            Alamofire.request(.POST, "\(globalURL)/api/users", parameters: parameters, encoding: .JSON).validate(statusCode: 200..<300).responseJSON {
                (request, response, json, error) in
                
                println("Request: \(request)")
                println("Response: \(response)")
                println("Data: \(json)")
                println("Error: \(error)")
                
                if error == nil {
                    
                    
                    NSUserDefaults.standardUserDefaults().setObject("\(self.phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(self.phoneTextField.text.startIndex, 1), end: advance(self.phoneTextField.text.startIndex, 4))) + self.phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(self.phoneTextField.text.startIndex, 6), end: advance(self.phoneTextField.text.startIndex, 9))) + self.phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(self.phoneTextField.text.startIndex, 10), end: advance(self.phoneTextField.text.endIndex, 0))))", forKey: "phone")
                    
                    self.phoneverifyLabelExplanation.text = "A three digit code was sent to \(self.phoneTextField.text)"
                    
                    var myJSON = JSON(json!)
                    
                    //write the user to the database so the user can find it
                    let realm = RLMRealm.defaultRealm()
                    realm.beginWriteTransaction()
                    realm.deleteAllObjects()
                    
                    let newUser = User()
                    
                    //newUser.email = self.emailTextField.text
                    newUser.token = myJSON["token"].string!
                    
                    println(self.phoneTextField.text)
                    
                    newUser.phone = "1\(self.phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(self.phoneTextField.text.startIndex, 1), end: advance(self.phoneTextField.text.startIndex, 4))) + self.phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(self.phoneTextField.text.startIndex, 6), end: advance(self.phoneTextField.text.startIndex, 9))) + self.phoneTextField.text.substringWithRange(Range<String.Index>(start: advance(self.phoneTextField.text.startIndex, 10), end: advance(self.phoneTextField.text.endIndex, 0))))"
                    
                    realm.addObject(newUser)
                    realm.commitWriteTransaction()
                    
                    self.closeWindow(self.phoneandpasswordbox)
                    
                    //close window and verify it
                    self.phonecodebox.hidden = false
                    self.phoneVerifyField.becomeFirstResponder()
                    self.openWindow(self.phonecodebox)
                    NSUserDefaults.standardUserDefaults().setObject("3", forKey: "step")
                    
                }else {
                    
                    var error: String = "Signup phone error! request: \(request), response: \(response), data: \(json), error: \(error)"
                    
                    DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                    
                    self.error.hidden = false
                    self.error.text = "Oops! Something went wrong!"
                }
                
            }
            
        } else {
            self.error.hidden = false
            self.error.text = "Oops! Enter a correct phone number."
            
        }
        
    }
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue()
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        keyboard = keyboardFrame.height
        
        println("keyboardFrame: \(keyboardFrame.height)")
    }
    
    func signup(sender:UIButton!){
        
        //sender.hidden = true
        
        if ((NSUserDefaults.standardUserDefaults().objectForKey("step")) == nil){
            emailbox.hidden = false
            emailTextField.becomeFirstResponder()
            openWindow(emailbox)
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "1" {
            var email = (NSUserDefaults.standardUserDefaults().objectForKey("email") as! String)
            self.emailverifyLabelExplanation.text = "A code has been sent to \(email)"
            self.emailcodebox.hidden = false
            self.openWindow(self.emailcodebox)
            self.emailVerifyField.becomeFirstResponder()
            
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "2" {
            self.phoneandpasswordbox.hidden = false
            self.phoneTextField.becomeFirstResponder()
            self.openWindow(self.phoneandpasswordbox)
            
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "3" {
            var phone = (NSUserDefaults.standardUserDefaults().objectForKey("phone") as! String)
            self.phoneverifyLabelExplanation.text = "A code has been sent to \(phone)"
            self.phonecodebox.hidden = false
            self.phoneVerifyField.becomeFirstResponder()
            self.openWindow(self.phonecodebox)
            
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "4" {
            self.contactexplanationbox.hidden = false
            self.openWindow(self.contactexplanationbox)
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "5" {
            self.locationexplanationbox.hidden = false
            self.openWindow(self.locationexplanationbox)
            
        }
        else if (NSUserDefaults.standardUserDefaults().objectForKey("step")! as! String) == "6" {
            self.notificationexplanationbox.hidden = false
            self.openWindow(self.notificationexplanationbox)
            
        }
        else {
            emailbox.hidden = false
            emailTextField.becomeFirstResponder()
            openWindow(emailbox)
        }
        
    }
    //todo add other email list
    func verify(sender: UIButton!){
        
        if (emailTextField.text == "" || emailTextField.text.lowercaseString.rangeOfString(".edu") == nil || emailTextField.text.lowercaseString.rangeOfString("@") == nil){
            error.hidden = false
            error.text = "Please enter a valid UCSB email"
        }
        else{
            
            let parameters = [ "email" : emailTextField.text]
            
            Alamofire.request(.POST, "\(globalURL)/api/emails", parameters: parameters, encoding: .JSON).validate(statusCode: 200..<300).response {
                (request, response, data, error) -> Void in
                
                println("Request: \(request)")
                println("Response: \(response)")
                println("Data: \(data)")
                println("Error: \(error)")
                
                if error == nil {
                    NSUserDefaults.standardUserDefaults().setObject("\(self.emailTextField.text)", forKey: "email")
                    
                    self.closeWindow(self.emailbox)
                    
                    var email = (NSUserDefaults.standardUserDefaults().objectForKey("email") as! String)
                    self.emailverifyLabelExplanation.text = "A code has been sent to \(email)"
                    self.emailcodebox.hidden = false
                    self.openWindow(self.emailcodebox)
                    self.emailVerifyField.becomeFirstResponder()
                    
                    NSUserDefaults.standardUserDefaults().setObject("1", forKey: "step")
                    
                }else {
                    
                    var error: String = "Error while getting email! request: \(request), response: \(response), data: \(data), error: \(error)"
                    
                    DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                    
                    self.error.hidden = false
                    self.error.text = "Oops! It appears this email is registered."
                }
                
            }
        }
    }
    
    func editEmail(sender: UIButton!){
        
        closeWindow(emailcodebox)
        emailbox.hidden = false
        emailTextField.becomeFirstResponder()
        openWindow(emailbox)
        
        
    }
    
    func editPhone(sender: UIButton!){
        
        closeWindow(phonecodebox)
        phoneandpasswordbox.hidden = false
        phoneTextField.becomeFirstResponder()
        openWindow(phoneandpasswordbox)
        
        
    }
    
    func sendAgain(sender: UIButton!){
        
        let parameters = [ "email" : emailTextField.text]
        
        Alamofire.request(.POST, "\(globalURL)/api/emails", parameters: parameters, encoding: .JSON).response {
            (request, response, data, error) -> Void in
            
            println("Request: \(request)")
            println("Response: \(response)")
            println("Data: \(data)")
            println("Error: \(error)")
            
        }
        
        error.hidden = false
        error.text = "Thanks, it may take up to a minute."
        
    }
    
    func sendAgainPhone(sender: UIButton!){
        
        let URL = NSURL(string: "\(globalURL)/api/users/1\(phoneTextField.text)/resend")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "PUT"
        
        var JSONSerializationError: NSError? = nil
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue(phoneVerifyField.text, forHTTPHeaderField: "Code")
        
        Alamofire.request(mutableURLRequest).validate(statusCode: 200..<300).response {
            (request, response, data, error) -> Void in
            
            println("Request: \(request)")
            println("Response: \(response)")
            println("Data: \(data)")
            println("Error: \(error)")
            
            if (error == nil){
                
                
            }else {
                
                var error: String = "Error while sending phone number! request: \(request), response: \(response), data: \(data), error: \(error)"
                
                DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                
                self.error.hidden = false
                self.error.text = "Woah there! Wrong code!"
                
            }
            
            //TODO notify user if it's already verified
            
        }
        
    }
    
    func changedText(sender: UITextField!){
        
        if (count(emailVerifyField.text) != 3) {
            
            self.verifyEmailCode.hidden = true
            
        } else {
            
            self.verifyEmailCode.hidden = false
            
        }
        
        
        
    }
    
    func changedTextPhone(sender: UITextField!){
        
        if (count(phoneVerifyField.text) != 3){
            
            verifyPhoneCode.hidden = true
            
        }else {
            
            verifyPhoneCode.hidden = false
        }
        
        
    }
    
    func verifyPhoneCode(sender: UIButton!) {
        
        error.hidden = true
        error.text = ""
        
        var phone = (NSUserDefaults.standardUserDefaults().objectForKey("phone")! as! String)
        
        let URL = NSURL(string: "\(globalURL)/api/users/1\(phone)/activate")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "PUT"
        
        var JSONSerializationError: NSError? = nil
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue(phoneVerifyField.text, forHTTPHeaderField: "Code")
        
        Alamofire.request(mutableURLRequest).validate(statusCode: 200..<300).response {
            (request, response, data, error) -> Void in
            
            println("Request: \(request)")
            println("Response: \(response)")
            println("Data: \(data)")
            println("Error: \(error)")
            
            if (error == nil){
                
                var user: RLMResults = User.allObjects()
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                (user[0] as! User).complete = true
                realm.commitWriteTransaction()
                NSUserDefaults.standardUserDefaults().setObject("0", forKey: "step")
                LoginOrDrawerController(frame: self.window.frame).root(self.window)
                
            }else {
                
                var error: String = "Error while verifyingphone code! request: \(request), response: \(response), data: \(data), error: \(error)"
                
                DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                
                self.error.hidden = false
                self.error.text = "Woah there! Wrong code!"
                
            }
            
            //TODO notify user if it's already verified
            
        }
        
        
    }
    
    func verifyemailcode(sender: UIButton!){
        

        error.hidden = true
        error.text = ""
        
        let parameters = [ "verified" : true]
        
        var email = (NSUserDefaults.standardUserDefaults().objectForKey("email")! as! String)
        
        let URL = NSURL(string: "\(globalURL)/api/emails/\(email)")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "PUT"
        
        //let parameters = ["foo": "bar"]
        var JSONSerializationError: NSError? = nil
        mutableURLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: &JSONSerializationError)
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue(emailVerifyField.text, forHTTPHeaderField: "Code")
        
        Alamofire.request(mutableURLRequest).validate(statusCode: 200..<300).response {
            (request, response, data, error) -> Void in
            
            println("Request: \(request)")
            println("Response: \(response)")
            println("Data: \(data)")
            println("Error: \(error)")
            
            if (error == nil){
                
                self.closeWindow(self.emailcodebox)
                self.phoneandpasswordbox.hidden = false
                self.phoneTextField.becomeFirstResponder()
                self.openWindow(self.phoneandpasswordbox)
                NSUserDefaults.standardUserDefaults().setObject("2", forKey: "step")
                
            }else {
                
                var error: String = "Error while verifying email code! request: \(request), response: \(response), data: \(data), error: \(error)"
                
                DDLogVerbose(error, level: ddLogLevel, asynchronous: true)
                
                self.error.hidden = false
                self.error.text = "Woah there! Wrong code!"
                
            }
            
            //TODO notify user if it's already verified
            
        }
        
    }
    
    func tap(sender: UIButton!){
        
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "step")
        
        if(!emailbox.hidden) { closeWindow(emailbox) }
        if(!emailcodebox.hidden) { closeWindow(emailcodebox)}
        if(!phoneandpasswordbox.hidden) { closeWindow(phoneandpasswordbox)}
        if(!phonecodebox.hidden) { closeWindow(phonecodebox) }
        if(!loginbox.hidden) {closeWindow(loginbox) }
        if(!loginverifybox.hidden) {closeWindow(loginverifybox) }
        //        if(!contactexplanationbox.hidden) {closeWindow(contactexplanationbox)}
        //        if(!locationexplanationbox.hidden) {closeWindow(locationexplanationbox)}
        //        if(!notificationexplanationbox.hidden) {closeWindow(notificationexplanationbox)}
        
        self.view.endEditing(true)
        
    }
    
    //animation functions
    
    func closeWindow(moveView: UIView){
        
        exit.hidden = true
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            moveView.frame = CGRectMake(50, self.view.frame.size.height, self.view.frame.size.width-100, moveView.frame.size.height)
            
            }, completion: ({ success in
                
                moveView.hidden = true
                self.error.hidden = true
                self.error.text = ""
                moveView.frame = CGRectMake(50, -moveView.frame.size.height, self.view.frame.size.width-100, moveView.frame.size.height)
                
            }))
        
    }
    
    func openWindow(moveView: UIView){
        
        exit.hidden = false
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            moveView.frame = CGRectMake(50, (self.view.frame.height-self.keyboard)/2-(moveView.frame.size.height/2), self.view.frame.size.width-100, moveView.frame.size.height)
            
            }, completion: ({ success in
                
                println("Window did appear")
                
            }))
        
    }
    
    func login(sender: UIButton!) {
        
        loginbox.hidden = false
        phoneTextFieldLogin.becomeFirstResponder()
        openWindow(loginbox)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == loginVerifyField) {
            
            var newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            var components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            var decimalString = "".join(components) as NSString
            var length = decimalString.length
            
            if length == 0 || (length > 6)
            {
                var newLength = (textField.text as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 6) ? false : true
            }
            
            var index = 0 as Int
            var formattedString = NSMutableString()
            
            if (length - index > 3) {
                
                var firstCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", firstCode)
                //textField.text = formattedString
                index += 3
                
            }
            
            var remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
            
        }
        
        if (textField == phoneTextField || textField == phoneTextFieldLogin)
        {
            var newString = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
            var components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            var decimalString = "".join(components) as NSString
            var length = decimalString.length
            var hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                var newLength = (textField.text as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            var formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                var areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3
            {
                var prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            var remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        else
        {
            return true
        }
    }
    //        self.buildAgreeTextViewFromString("By using this app you agree to the #<ts>terms of service# and #<pp>privacy policy#")
    func buildAgreeTextViewFromString(localizedString: NSString) -> Void{
        
        // 1. Split the localized string on the # sign:
        var localizedStringPieces: NSArray = localizedString.componentsSeparatedByString("#")
        
        // 2. Loop through all the pieces:
        var msgChunkCount: Int = localizedStringPieces.count
        
        var wordLocation: CGPoint = CGPointMake(0, 0)
        for var i = 0; i < msgChunkCount; i++ {
            
            var chunk: NSString = localizedStringPieces.objectAtIndex(i) as! NSString
            if chunk.isEqualToString(""){
                continue // skip this loop if the chunk is empty
            }
            
            // 3. Determine what type of word this is:
            var isTermsOfServiceLink: Bool = chunk.hasPrefix("<ts>")
            var isPrivacyPolicyLink: Bool = chunk.hasPrefix("<pp>")
            var isLink: Bool = (isTermsOfServiceLink || isPrivacyPolicyLink) as Bool
            
            // 4. Create label, styling dependent on whether it's a link:
            var label: UILabel = UILabel()
            label.font = UIFont.systemFontOfSize(12.0)
            label.text = chunk as String
            label.userInteractionEnabled = isLink
            
            if (isLink){
                
                label.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
                label.highlightedTextColor = UIColor.yellowColor()
                
                // 5. Set tap gesture for this clickable text:
                var selectorAction: Selector  = isTermsOfServiceLink ? Selector("tapOnTermsOfServiceLink:") : Selector("tapOnPrivacyPolicyLink:")
                
                var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selectorAction)
                
                label.addGestureRecognizer(tapGesture)
            }
            
            if (isTermsOfServiceLink){
                label.text = label.text?.stringByReplacingOccurrencesOfString("<ts>", withString:"")
            }
            else if (isPrivacyPolicyLink){
                label.text = label.text?.stringByReplacingOccurrencesOfString("<pp>", withString:"")
            }
            else {
                
                label.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
            }
            
            // 6. Lay out the labels so it forms a complete sentence again:
            
            // If this word doesn't fit at end of this line, then move it to the next
            // line and make sure any leading spaces are stripped off so it aligns nicely:
            
            label.sizeToFit()
            
            if ((self.view.frame.size.width - 100) < wordLocation.x + (label.frame.size.width)) {
                wordLocation.x = 0.0;                       // move this word all the way to the left...
                wordLocation.y += label.frame.size.height;  // ...on the next lin
            }
            
            //            var startingWhiteSpaceRange: NSRange = label.text.rangeOfString("^\\s*", options: .RegularExpressionSearch)
            //
            //            if (startingWhiteSpaceRange.location == 0){
            //
            //                label.text = label.text?.stringByReplacingCharactersInRange
            //
            //            }
            label.frame = CGRectMake(wordLocation.x+50, wordLocation.y+(view.frame.size.height-80), label.frame.size.width, label.frame.size.height)
            
            self.view.addSubview(label)
            
            wordLocation.x += label.frame.size.width
            
        }
        
    }
    
    func tapOnTermsOfServiceLink(tapGesture: UITapGestureRecognizer!){
        if (tapGesture.state == UIGestureRecognizerState.Ended)
        {
            NSLog("User tapped on the Terms of Service link");
            UIApplication.sharedApplication().openURL(NSURL(string: "http://livv.net/terms")!)
        }
        
    }
    func tapOnPrivacyPolicyLink(tapGesture: UITapGestureRecognizer!){
        if (tapGesture.state == UIGestureRecognizerState.Ended)
        {
            NSLog("User tapped on the Privacy Policy link")
            UIApplication.sharedApplication().openURL(NSURL(string: "http://livv.net/privacy")!)
        }
        
    }
    
    
}

