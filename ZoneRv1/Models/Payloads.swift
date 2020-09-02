//
//  Payloads.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 9/1/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Foundation
import Firebase

struct Payload {
    let text : String
    let beaconId: String
    let deviceId: String
//        uncomment This when further along
//    var timestamp: Timestamp!
    
    var user: User?
    
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]){
        self.text = dictionary["text"] as? String ?? ""
        self.beaconId = dictionary["beaconId"] as? String ?? ""
        self.deviceId = dictionary["deviceId"] as? String ?? ""
//        uncomment This when further along
//        self.timestamp = Timestamp!
        
        self.isFromCurrentUser = deviceId == Auth.auth().currentUser?.uid
    }
}

struct DataPackage {
    let user: User
    let payload: Payload
}
