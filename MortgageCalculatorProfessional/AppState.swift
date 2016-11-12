//
//  AppState.swift
//  MortgageCalculatorProfessional
//
//  Created by Alex on 11/2/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
}
