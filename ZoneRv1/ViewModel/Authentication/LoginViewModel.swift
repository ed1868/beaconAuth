//
//  LoginViewModel.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 9/11/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Foundation
import UIKit

protocol AuthenticationProtocol {
    var formIsValid: Bool {
        get
    }
}


struct loginViewModel: AuthenticationProtocol {
    var email: String?
    var password : String?
    
     var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}


