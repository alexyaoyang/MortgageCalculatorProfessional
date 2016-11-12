//
//  MeasurementHelper.swift
//  MortgageCalculatorProfessional
//
//  Created by Alex on 11/2/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import Firebase

class MeasurementHelper: NSObject {
    
    static func sendLoginEvent() {
        FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: nil)
    }
    
    static func sendLogoutEvent() {
        FIRAnalytics.logEvent(withName: "logout", parameters: nil)
    }
    
    static func sendMessageEvent() {
        FIRAnalytics.logEvent(withName: "message", parameters: nil)
    }
}
