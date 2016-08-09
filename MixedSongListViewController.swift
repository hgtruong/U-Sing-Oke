//
//  MixedSongListViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/26/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit
import MediaPlayer


private var _shareInstance: MixedSongListViewController = MixedSongListViewController()

class MixedSongListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    class public var sharedInstance:MixedSongListViewController {
        return _shareInstance
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //Array to store all mashed songs
    var m4aFileNames:[AnyObject] = []
    var m4aFiles:[AnyObject] = []
    var selectedM4a = NSURL()
    var finalSongName = String()
    var selectedTitle = String()
    var finalM4a = String()
    var songName = String()
    let mixedInstance = FromMixed.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //If need to clear m4a files in libr
//        let instance = VoiceRecord.sharedInstance
//        instance.clearLibFolder()
        
        
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper")!)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes  = titleDict as? [String : AnyObject]
        navigationController!.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "wallpaper")!)
        mixedfilterM4aAndMp3 ()
        
        
        
        mixedInstance.fromMixed = false
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        mixedfilterM4aAndMp3 ()
    }

    func mixedfilterM4aAndMp3 () {
        
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL( documentsUrl, includingPropertiesForKeys: nil, options: [])
            //            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            m4aFiles = directoryContents.filter{ $0.pathExtension == "m4a" }
                        print("m4a mixed urls: \(m4aFiles)")
            m4aFileNames = m4aFiles.flatMap({$0.URLByDeletingPathExtension!})
            print("m4a list in mixedSong View: \(m4aFileNames)")
                        print("m4a mixed count: \(m4aFileNames.count)")
            
             tableView.reloadData()
            
        } catch _ {
            print("Err")
        }
        
       
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("m4a count is: \(m4aFileNames.count)")
        return m4aFileNames.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mixedListCell", forIndexPath: indexPath)
        
//        print("indexPath: \(indexPath)")
        print("m4a names in table cell: \(m4aFileNames[indexPath.row])")
        let songName = m4aFileNames[indexPath.row].absoluteString
//        print("indexPath: \(songName)")
        if let rangOfZero = songName.rangeOfString("Library/", options: NSStringCompareOptions.BackwardsSearch){
            finalSongName = String(songName.characters.suffixFrom(rangOfZero.endIndex))
        }
        print("Final Song name in mixed view is: \(finalSongName)")
        cell.textLabel!.text = finalSongName
        //        cell.textLabel?.textColor = UIColor().HexToColor("#FFFFFF", alpha: 1.0)
        cell.textLabel?.textColor = UIColor().HexToColor("#FB0032", alpha: 1.0)
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper")!)
        

        
        return cell
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Manually calling the play button from here and passing the song selected at the row
        let instance = PlayStopManager.sharedInstance
        
        //getting the title of song at selected row
        let selection = tableView.cellForRowAtIndexPath(indexPath)
        selectedTitle = (selection?.textLabel?.text)!
        
        //Assiging current song for record compare
        let songInstance = CurrentSongname.sharedInstance
        songInstance.songName = selectedTitle
        
        mixedInstance.fromMixed = true
        
        print("Selected Title in mixed did select is:  \(selectedTitle)")
        
        
        //Reading in from library directory
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
          
        } catch _ {
            print("Err")
        }

//        setting the selected song as the original track for VoiceRecord and smashing
        let anotherInstance = VoiceRecord.sharedInstance
        anotherInstance.originalSong = NSURL.fileURLWithPath(finalM4a)
        
        
        //Goes to the player and automatically play the selected song
        NSNotificationCenter.defaultCenter().postNotificationName("didClickOnAMixedSong", object: selectedM4a)
    }
    
    
    
    //Function to set the name of the song play
    func songNameSetter(name: String) {
        
        print("param value: \(name)")
       
        self.songName = name
         print("songname value: \(songName)")
    }
    
    func songNameGetter() -> String {
        return self.songName
    }
    
    
}
