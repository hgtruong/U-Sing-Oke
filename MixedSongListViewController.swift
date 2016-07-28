//
//  MixedSongListViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/26/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit
import MediaPlayer

class MixedSongListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    //Array to store all mashed songs
    var mashedSongArray:[AnyObject] = []
    
    
    //    let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    //    let url = NSURL(fileURLWithPath: path)
    //    let filePath = url.URLByAppendingPathComponent("nameOfFileHere").path!
    //    let fileManager = NSFileManager.defaultManager()
    //    if fileManager.fileExistsAtPath(filePath) {
    //    print("FILE AVAILABLE")
    //    } else {
    //    print("FILE NOT AVAILABLE")
    //    }
    //    
    
    
    
    
//    
//    var fileManager: NSFileManager = NSFileManager.defaultManager()
//    var bundleURL: NSURL = NSBundle.mainBundle().bundleURL()
//    var contents: [AnyObject] = try! fileManager.contentsOfDirectoryAtURL(bundleURL, includingPropertiesForKeys: [], options: NSDirectoryEnumerationSkipsHiddenFiles)
//    var predicate: NSPredicate = NSPredicate(format: "pathExtension == 'png'")
//    for fileURL: NSURL in contents.filteredArrayUsingPredicate(predicate) {
//    // Enumerate each .png file in directory
//    // Enumerate each .png file in directory
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Finding all the .m4a mixed files
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let path = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let urls = path[0].absoluteString
        let enumerator = fileManager.enumeratorAtPath(urls)
        while let element = enumerator?.nextObject() as? String {
            if element.hasSuffix(".m4a") {
                print("insdie elemetn")
                mashedSongArray.append(element)
            }
        }
         print("mashed array is: \(mashedSongArray)")
        
        tableView.reloadData()
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mashedSongArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mixedListCell", forIndexPath: indexPath)
        let songName = mashedSongArray[indexPath.row].absoluteString
        print("\(songName)")
//        cell.textLabel!.text =
        
        return cell
    }
    
}
