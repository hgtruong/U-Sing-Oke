//
//  currentSongName.swift
//  u-sing
//
//  Created by Huy Truong on 8/2/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import Foundation

class CurrentSongname{

    class var sharedInstance: CurrentSongname {
        struct Static {
            static var instance: CurrentSongname?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = CurrentSongname()
        }
        
        return Static.instance!
    }
    
    var songName: String?

    
}