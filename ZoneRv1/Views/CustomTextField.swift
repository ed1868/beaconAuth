//
//  CustomTextField.swift
//  ZoneRv1
//
//  Created by Eddie Ruiz on 9/21/20.
//  Copyright © 2020 AI Nomads. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String){
        super.init(frame: .zero)
        
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .white
        keyboardAppearance = .dark
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("THEY MADE ME DO IT, I HAD TO");
    }
    
}
