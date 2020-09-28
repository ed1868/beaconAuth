//
//  User.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 9/1/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let profileImageUrl: String
    let username: String
    let fullname: String
    let email: String
    let beacons : Array<Any>
    let promotion : String
    
    init(dictionary: [String: Any]){
        
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.beacons = dictionary["beacons"] as? Array ?? [""]
        self.promotion = dictionary["promotion"] as? String ?? ""
        
    
        //CHANGE THIS BEFORE PROCEEDING
        return
        
    }
}

