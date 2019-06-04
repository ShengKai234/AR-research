//
//  MacroModelController.swift
//  AR-417-Simulation-Animation
//
//  Created by Kai on 2019/6/2.
//  Copyright © 2019 AppCode. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class ModelController{
    
    
    static func timerAction(sceneView: ARSCNView,workSchedules: [WorkSchedule], timeAnimation: Date) {
        let nextTime: TimeInterval = 24*60*60
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        formatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        var timeAnimation = timeAnimation
        // 天數增加
        timeAnimation = timeAnimation.addingTimeInterval(nextTime)
        // 篩選已被下載的點雲，以時間作為點雲顯示依據（顯示隱藏對應的名稱）
        for workSchedule in workSchedules{
            let objectDate = formatter.date(from: workSchedule.endDate.components(separatedBy: ".")[0])
            print(timeAnimation)
            print(objectDate)
            if (timeAnimation > objectDate!){
                sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == workSchedule.modelName {
                        //edit something
                        node.isHidden = false
                    }
                }
            }else{
                sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == workSchedule.modelName {
                        //edit something
                        node.isHidden = true
                    }
                }
            }
        }
    }
}
