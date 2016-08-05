//
//  FromMixed.swift
//  u-sing
//
//  Created by Huy Truong on 8/4/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import Foundation

class FromMixed{
    
    class var sharedInstance: FromMixed {
        struct Static {
            static var instance: FromMixed?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = FromMixed()
        }
        
        return Static.instance!
    }
    
    var fromMixed: Bool?
    
    
}