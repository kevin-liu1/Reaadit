//
//  UserDataExtract.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-06.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

class UserDataExtract {
    
    
    func getAccessToken() -> String {
        if  let path        = Bundle.main.path(forResource: "UserData", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let userdata = try? PropertyListDecoder().decode(UserData.self, from: xml)
        {
            
            return userdata.accessToken
        } else {
            return "extraction didn't work"
        }
    }
    
    func getRefreshToken() -> String {
        if  let path        = Bundle.main.path(forResource: "UserData", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let userdata = try? PropertyListDecoder().decode(UserData.self, from: xml)
        {
            print("This is user data from another view:" + userdata.refreshToken)
            return userdata.refreshToken
        } else {
            return "extraction didn't work"
        }
    }
    
    
    
    func getSubList() -> [String] {
        if  let path        = Bundle.main.path(forResource: "UserData", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let userdata = try? PropertyListDecoder().decode(UserData.self, from: xml)
        {
            print("This is user data from another view:" + userdata.subredditList[0])
            //self.testArray = userdata.subredditList
            return userdata.subredditList
        } else {
            return [""]
        }


    }
    
    func loggedInStatus() -> Bool {
        if  let path        = Bundle.main.path(forResource: "UserData", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let userdata = try? PropertyListDecoder().decode(UserData.self, from: xml)
        {
            
            //print("This is user data from another view:" + userdata.logStatus)
            //self.testArray = userdata.subredditList
            return userdata.logStatus
        } else {
            return false
        }
    }
    
    
    
    
    
}
