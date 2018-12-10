//
//  VirtualObject.swift
//  ARKitDemo
//
//  Created by Kai on 2018/11/10.
//  Copyright © 2018 AppCode. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class VirtualObject
{
    var projectName: String
    var dateStart: String
    var dateEnd: String
    var isStart: Bool
    var isCheck: Bool
    
    
    init(projectName: String, dateStart: String, dateEnd: String, isStart: Bool, isCheck: Bool) {
        self.projectName = projectName
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.isStart = isStart
        self.isCheck = isCheck
    }
    
    convenience init() {
        self.init(projectName: "", dateStart: "", dateEnd: "", isStart: false, isCheck: false)
    }
}
