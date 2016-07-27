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
    
    var mix = getAllMixedSongs()
    
    
//    func directoryUrl() -> String? {
//        
//        let fileManager = NSFileManager.defaultManager()
//        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let documentDirectory = urls[0].absoluteString
//        let stringDocumentDirectory = documentDirectory.stringByAppendingString(mixName)
//        let finalDocumentDirectory = stringDocumentDirectory.stringByReplacingOccurrencesOfString("file://", withString: "")
//        //        print("stringdocumen diretory  url is: \(stringDocumentDirectory)")
//        //        print("finalDocument url is: \(finalDocumentDirectory)")
//        return finalDocumentDirectory
//    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assigning media manager
        let fileMngr = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        fileMngr
        
        tableView.reloadData()
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mixedListCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = "TESTING"
        
        return cell
    }
    
}
