//
//  RegistrationViewModel.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 9/11/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Foundation

//REGISTRATION VIEW MODEL FOR USERS

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var secret: String?
    
    var beaconId : String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullname?.isEmpty == false
            && username?.isEmpty == false
            && beaconId?.isEmpty == false
        
    }
}
