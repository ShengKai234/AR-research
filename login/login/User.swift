//
//  User.swift
//  login
//
//  Created by Kai on 2018/12/10.
//  Copyright © 2018 AppCode. All rights reserved.
//

import Foundation

class User
{
    private let username, userid, usersecurity, usermail: String
    
    init(username: String, userid: String, usersecurity: String, usermail: String){
        self.username = username
        self.userid = userid
        self.usersecurity = usersecurity
        self.usermail = usermail
    }
}
