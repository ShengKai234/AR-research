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

class VirtualObject: SCNReferenceNode
{
    var projectName: String?
    var dateStart: String?
    var dateEnd: String?
    var isStart: String?
    var isCheck: String?
    
    
    func getData(projectName: String, dateStart: String, dateEnd: String, isStart: String, isCheck: String) {
        self.projectName = projectName
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.isStart = isStart
        self.isCheck = isCheck
    }
}
