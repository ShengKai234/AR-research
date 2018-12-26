//
//  VirtualObj.swift
//  AR-417-Sys
//
//  Created by Kai on 2018/12/14.
//  Copyright © 2018 AppCode. All rights reserved.
//

import Foundation
class VirtualObj{
    
    private var _objname, _dateStart, _dateEnd, _type: String
    private var _isStart, _isCheck: String
    
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
    var type: String {
        get {
            return self._type
        }
        set {
            self._type = newValue
        }
    }
    
    init(objname: String, dateStart: String, dateEnd: String, isStart: String, isCheck: String, type: String){
        self._objname = objname
        self._dateStart = dateStart
        self._dateEnd = dateEnd
        self._isStart = isStart
        self._isCheck = isCheck
        self._type = type
    }
}
