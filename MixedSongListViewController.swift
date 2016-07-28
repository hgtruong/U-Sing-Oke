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
    var m4aFileNames:[AnyObject] = []
    var m4aFiles:[AnyObject] = []
    var finalSongName = String()
    var selectedTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL( documentsUrl, includingPropertiesForKeys: nil, options: [])
//            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            m4aFiles = directoryContents.filter{ $0.pathExtension == "m4a" }
//            print("m4a urls: \(m4aFiles)")
            m4aFileNames = m4aFiles.flatMap({$0.URLByDeletingPathExtension!})
//            print("m4a list: \(m4aFileNames)")
//            print("m4a count: \(m4aFileNames.count)")
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("m4a count is: \(m4aFileNames.count)")
        return m4aFileNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mixedListCell", forIndexPath: indexPath)
        
//        print("indexPath: \(indexPath)")
//        print("m4a index: \(m4aFileNames[0])")
        let songName = m4aFileNames[indexPath.row].absoluteString
        if let rangOfZero = songName.rangeOfString("Documents/", options: NSStringCompareOptions.BackwardsSearch){
            finalSongName = String(songName.characters.suffixFrom(rangOfZero.endIndex))
        }
        cell.textLabel!.text = finalSongName
        return cell
    }
    
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        //Manually calling the play button from here and passing the song selected at the row
//        let instance = PlayStopManager.sharedInstance
//        
//        //getting the title of song at selected row
//        let selection = tableView.cellForRowAtIndexPath(indexPath)
//        selectedTitle = (selection?.textLabel?.text)!
//        print("Selected Title is \(selectedTitle)")
//        
//        let filePath = NSBundle.mainBundle().pathForResource("\(selectedTitle)", ofType: ".m4a")
//        instance.bgMusicUrl = NSURL.fileURLWithPath(filePath!)
//        instance.setUpNewTrack()
//        //setting title to be used as final mix name
//        instance.selectedTitle = self.selectedTitle
//        instance.status = false
//        //        print("\(instance.newTrack.duration)")
//        
//        //setting the selected song as the original track for VoiceRecord and smashing
//        let anotherInstance = VoiceRecord.sharedInstance
//        anotherInstance.originalSong = NSURL.fileURLWithPath(filePath!)
//    }
}
