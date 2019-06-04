//
//  User.swift
//  AR-417-Sys
//
//  Created by Kai on 2018/12/12.
//  Copyright © 2018 AppCode. All rights reserved.
//

import Foundation

class User
{
    private var _username, _usersecurity, _usermail: String
    private var _userid: Int
    
    var username: String {
        get {
            return self._username
        }
        set(newValue) {
            self._username = newValue
        }
    }
    var userid: Int {
        get {
            return _userid
        }
        set {
            self._userid = newValue
        }
    }
    var usersecurity: String {
        get {
            return _usersecurity
        }
        set {
            self._usersecurity = newValue
        }
    }
    var usermail: String {
        get {
            return _usermail
        }
        set {
            self._usermail = newValue
        }
    }
    init(username: String, userid: Int, usersecurity: String, usermail: String){
        self._username = username
        self._userid = userid
        self._usersecurity = usersecurity
        self._usermail = usermail
    }
    public func printData()
    {
        print("123213213123")
        print(self._username)
        print(self._userid)
        print(self.usersecurity)
        print(self.usermail)
    }
    
    
//    convenience init() {
//        self.init(username: "", userid: 0, usersecurity: "", usermail: "")
//    }
}
