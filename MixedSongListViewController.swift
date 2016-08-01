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
    var selectedM4a = NSURL()
    var finalSongName = String()
    var selectedTitle = String()
    var finalM4a = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let instance = VoiceRecord.sharedInstance
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask).first!
        
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
        
        
        //If need to clear m4a files in libr
//        instance.clearLibFolder()
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
//        print("indexPath: \(songName)")
        if let rangOfZero = songName.rangeOfString("Library/", options: NSStringCompareOptions.BackwardsSearch){
            finalSongName = String(songName.characters.suffixFrom(rangOfZero.endIndex))
        }
        cell.textLabel!.text = finalSongName
        tableView.reloadData()
        return cell
    }
    
//    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Manually calling the play button from here and passing the song selected at the row
        let instance = PlayStopManager.sharedInstance
        
        //getting the title of song at selected row
        let selection = tableView.cellForRowAtIndexPath(indexPath)
        selectedTitle = (selection?.textLabel?.text)!
//        print("Selected Title is \(selectedTitle)")
//
//        let filePath = NSBundle.mainBundle().pathForResource("21mix", ofType: ".m4a")
//        print("filePath is: \(filePath)")
//        instance.bgMusicUrl = NSURL.fileURLWithPath(filePath!)
//        instance.setUpNewTrack()
//        //setting title to be used as final mix name
//        instance.selectedTitle = self.selectedTitle
//        instance.status = false
//        //        print("\(instance.newTrack.duration)")
        
        
        ///////////////////////////////new code to read from document direcotry////////////////////////
        
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL( documentsUrl, includingPropertiesForKeys: nil, options: [])
            //            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            m4aFiles = directoryContents.filter{ $0.pathExtension == "m4a" }
//            print("m4a urls in did select: \(m4aFiles)")
            selectedM4a = m4aFiles[indexPath.row] as! NSURL
            let stringSelectedM4a = selectedM4a.absoluteString
            finalM4a = stringSelectedM4a.stringByReplacingOccurrencesOfString("file:///", withString: "")
            instance.bgMusicUrl = NSURL.fileURLWithPath(finalM4a)
            instance.setUpNewTrack()
            
//            print("m4a list: \(selectedM4a)")
          
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        
//        setting the selected song as the original track for VoiceRecord and smashing
        let anotherInstance = VoiceRecord.sharedInstance
        anotherInstance.originalSong = NSURL.fileURLWithPath(finalM4a)
    }
    
}
