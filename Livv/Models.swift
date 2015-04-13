//
//  Models.swift
//  Livv
//
//  Created by Brent Kirkland on 4/9/15.
//  Copyright (c) 2015 Brent Kirkland. All rights reserved.
//

import Realm

class Vote: RLMObject {
    
    dynamic var bump: String = ""
}

class SizeofPoints: RLMObject {
    
    dynamic var length: String = ""
}

class User: RLMObject {
    
    dynamic var phone: String = "(949) 292-6284"
    dynamic var token: String = ""
    dynamic var username: String = ""
    dynamic var lastTag: String = ""
    dynamic var complete: Bool = false
    
}

class Event: RLMObject {
    
    
    dynamic var address: String! = "Default"
    dynamic var points: Int = 0
    dynamic var tags = RLMArray(objectClassName: Tag.className())
}

class Tag: RLMObject {
    
    dynamic var name: String!
    dynamic var weight: Int = 0
    dynamic var userSelectedTag: Int = 0
    
}

class Contacts: RLMObject {
    
    dynamic var name: String! = ""
    dynamic var phone: String! = ""
    
}
