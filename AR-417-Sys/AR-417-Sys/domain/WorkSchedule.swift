//
//  VirtualObj.swift
//  AR-417-Sys
//
//  Created by Kai on 2018/12/14.
//  Copyright © 2018 AppCode. All rights reserved.
//

import Foundation
class WorkSchedule{
    
    private var _id , _scheduleId, _projectName, _startDate, _endDate, _progress, _superItem, _duration, _superModelGroupId: String, _checkTypeNo: String
    private var _modelName, _groupId, _isStart, _isCheck, _superCheckNo: String
    
    var id: String {
        get {
            return self._id
        }
        set(newValue) {
            self._id = newValue
        }
    }
    var scheduleId: String {
        get {
            return self._scheduleId
        }
        set(newValue) {
            self._scheduleId = newValue
        }
    }
    var projectName: String {
        get {
            return self._projectName
        }
        set(newValue) {
            self._projectName = newValue
        }
    }
    var startDate: String {
        get {
            return self._startDate
        }
        set(newValue) {
            self._startDate = newValue
        }
    }
    var endDate: String {
        get {
            return self._endDate
        }
        set(newValue) {
            self._endDate = newValue
        }
    }
    var progress: String {
        get {
            return self._progress
        }
        set(newValue) {
            self._progress = newValue
        }
    }
    var superItem: String {
        get {
            return self._superItem
        }
        set {
            self._superItem = newValue
        }
    }
    var duration: String {
        get {
            return self._duration
        }
        set {
            self._duration = newValue
        }
    }
    var superModelGroupId: String {
        get {
            return self._superModelGroupId
        }
        set {
            self._superModelGroupId = newValue
        }
    }
    var modelName: String {
        get {
            return self._modelName
        }
        set {
            self._modelName = newValue
        }
    }
    var groupId: String {
        get {
            return self._groupId
        }
        set {
            self._groupId = newValue
        }
    }
    
    var isStart: String {
        get {
            return self._isStart
        }
        set(newValue) {
            self._isStart = newValue
        }
    }
    var isCheck: String {
        get {
            return self._isCheck
        }
        set(newValue) {
            self._isCheck = newValue
        }
    }
    var checkTypeNo: String {
        get {
            return self._checkTypeNo
        }
        set(newValue) {
            self._checkTypeNo = newValue
        }
    }
    var superCheckNo: String {
        get {
            return self._superCheckNo
        }
        set(newValue) {
            self._superCheckNo = newValue
        }
    }
    
    
    init(id: String, scheduleId: String, projectName: String, startDate: String, endDate: String, progress: String, superItem: String, duration: String, superModelGroupId: String, modelName: String, groupId:String, isStart:String, isCheck:String, checkTypeNo:String, superCheckNo:String){
        self._id = id
        self._scheduleId = scheduleId
        self._projectName = projectName
        self._startDate = startDate
        self._endDate = endDate
        self._progress = progress
        self._superItem = superItem
        self._duration = duration
        self._superModelGroupId = superModelGroupId
        self._modelName = modelName
        self._groupId = groupId
        self._isStart = isStart
        self._isCheck = isCheck
        self._checkTypeNo = checkTypeNo
        self._superCheckNo = superCheckNo
    }
}
