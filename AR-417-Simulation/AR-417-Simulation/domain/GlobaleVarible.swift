//
//  GlobaleVarible.swift
//  AR-417-Sys
//
//  Created by Kai on 2019/4/21.
//  Copyright © 2019 AppCode. All rights reserved.
//

import Foundation

class GlobaleVarible:NSObject {
    private var _showAlert: Bool?
    
    var showAlert: Bool {
        get {
            return _showAlert!
        }
        set(newValue) {
            _showAlert = newValue
        }
    }
    
}
