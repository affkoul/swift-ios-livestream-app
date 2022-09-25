//
//  UserDefaults+Helpers.swift
//  Live
//
//  Created by dimi anat on 2020/8/1.
//  Copyright © 2020 com.geniusandcourage. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case isBroadCon
        case isAudCon
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func setIsBroadCon(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isBroadCon.rawValue)
        
    }
    
    func isBroadCon() -> Bool {
        return bool(forKey: UserDefaultsKeys.isBroadCon.rawValue)
    }
    
    func setIsAudCon(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isAudCon.rawValue)
        
    }
    
    func isAudCon() -> Bool {
        return bool(forKey: UserDefaultsKeys.isAudCon.rawValue)
    }
    
    func setRegCreds(regEmail: String, regPassword: String, regUsername: String) {
        set(regEmail, forKey: "RegEmail")
        set(regPassword, forKey: "RegPassword")
        set(regUsername, forKey: "RegUsername")
        synchronize()
    }
    
    func setLogCreds(logEmail: String, logPassword: String, logUsername: String, logUsernameString: String) {
        set(logEmail, forKey: "LogEmail")
        set(logPassword, forKey: "LogPassword")
        set(logUsername, forKey: "LogUsername")
        set(logUsernameString, forKey: "LogUsernameString")
        synchronize()
    }
    
}
