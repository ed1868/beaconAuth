//
//  PayloadsViewModel.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 9/11/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Foundation
import UIKit

struct PayloadViewModel {
    private let payload: Payload
    
    var payloadBackgroundColor : UIColor {
        return payload.isFromCurrentUser ? .lightGray : .systemPurple
    }
    
    var payloadColor: UIColor {
        payload.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool {
        return !payload.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !payload.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return payload.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = payload.user else { return nil }
        return URL(string: user.profileImageUrl)
    }
    
    init(payload: Payload){
        self.payload  = payload
    }
}


