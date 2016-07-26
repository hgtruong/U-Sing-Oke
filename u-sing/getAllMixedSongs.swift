//
//  getAllMixedSongs.swift
//  u-sing
//
//  Created by Huy Truong on 7/26/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import Foundation

public class getAllMixedSongs {
    
    var accessUrl = NSBundle.mainBundle().URLsForResourcesWithExtension("m4a", subdirectory: "tmp")
    
    
    func findAllMixedSongs() {
        print("access Url is below:")
        print(accessUrl!)
    }
}