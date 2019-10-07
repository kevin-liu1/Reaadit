//
//  UserDataUpdate.swift
//  Reddit Client
//
//  Created by Kevin Liu on 2019-10-06.
//  Copyright © 2019 kevinliu. All rights reserved.
//

import Foundation

class UserDataUpdate {
    
    func saveData(UserData userdata: UserData) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let paths = Bundle.main.url(forResource: "UserData", withExtension: "plist")
        
        do {
            let data = try encoder.encode(userdata)
            try data.write(to: paths!)
        } catch {
            print(error)
        }
    }
    
}
