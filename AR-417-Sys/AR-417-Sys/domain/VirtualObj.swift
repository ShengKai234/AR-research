//
//  VirtualObj.swift
//  AR-417-Sys
//
//  Created by Kai on 2018/12/14.
//  Copyright © 2018 AppCode. All rights reserved.
//

import Foundation
class VirtualObj{
    
    private var _id ,_code, _objname, _dateStart, _dateEnd, _checkType, _progress, _superItem, _superModel, _duration: String
    private var _isStart, _isCheck: String
    
    var id: String {
        get {
            return self._id
        }
        set(newValue) {
            self._id = newValue
        }
    }
    var code: String {
        get {
            return self._code
        }
        set(newValue) {
            self._code = newValue
        }
    }
    var objname: String {
        get {
            return self._objname
        }
        set(newValue) {
            self._objname = newValue
        }
    }
    var dateStart: String {
        get {
            return self._dateStart
        }
        set(newValue) {
            self._dateStart = newValue
        }
    }
    var dateEnd: String {
        get {
            return self._dateEnd
        }
        set(newValue) {
            self._dateEnd = newValue
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
    var checkType: String {
        get {
            return self._checkType
        }
        set {
            self._checkType = newValue
        }
    }
    var progress: String {
        get {
            return self._progress
        }
        set {
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
    var superModel: String {
        get {
            return self._superModel
        }
        set {
            self._superModel = newValue
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
    
    
    init(id: String, code: String, objname: String, dateStart: String, dateEnd: String, isStart: String, isCheck: String, checkType: String, progress: String, superItem:String, superModel:String, duration:String){
        self._id = id
        self._code = code
        self._objname = objname
        self._dateStart = dateStart
        self._dateEnd = dateEnd
        self._isStart = isStart
        self._isCheck = isCheck
        self._checkType = checkType
        self._progress = progress
        self._superItem = superItem
        self._superModel = superModel
        self._duration = duration
    }
}
