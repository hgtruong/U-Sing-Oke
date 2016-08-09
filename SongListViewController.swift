//
//  SongListViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/18/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import CoreFoundation

class SongListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //Variable declarations
    var mediaQuery = MPMediaQuery()
    var mediaCollections: [AnyObject] = []
    //    var collection = MPMediaItemCollection()
    //    var representativeItem = MPMediaItem()
    var songTitle = String()
    var selectedTitle = String()
    var songPicked:[String] = []
    
    var m4aFileNames:[AnyObject] = []
    var m4aFiles:[AnyObject] = []
    
    var mp3FileNames:[AnyObject] = []
    var mp3Files:[AnyObject] = []
    
    
    var m4aMp3FileNames:[AnyObject] = []
    var m4aMp3Files:[AnyObject] = []
    
    
    var selectedM4a = NSURL()
    var finalSongName = String()
    var documentsUrl = NSURL()
    
    
    
    @IBOutlet weak var searchButton: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var AddSongButton: UIButton!
    
    @IBAction func AddSongButton(sender: AnyObject) {
        
        let mediaPickerController = MPMediaPickerController(mediaTypes: .Music)
        mediaPickerController.delegate = self
        mediaPickerController.showsCloudItems = false
        mediaPickerController.allowsPickingMultipleItems = false
        mediaPickerController.modalPresentationStyle = .Popover
        mediaPickerController.preferredContentSize = CGSizeMake(500,600)
        self.presentViewController(mediaPickerController, animated: true, completion: {})
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting Directiory path
        self.documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        //Finding the music in user's phone
        
        // run a query on song media type
        mediaQuery = MPMediaQuery.songsQuery()
        
        // ensure what we retrieve is on device
        mediaQuery.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
        
        // run query
        mediaCollections = mediaQuery.collections!
        
        
        let mediaPickerController = MPMediaPickerController(mediaTypes: .Music)
        mediaPickerController.delegate = self
        mediaPickerController.showsCloudItems = false
        mediaPickerController.allowsPickingMultipleItems = false
        mediaPickerController.modalPresentationStyle = .Popover
        mediaPickerController.preferredContentSize = CGSizeMake(500,600)
        self.presentViewController(mediaPickerController, animated: true, completion: {})
 
        
       // Use the two lines below whenever we need to clear m4a files in document directory
//        let instance = VoiceRecord.sharedInstance
//        instance.clearDocFolder()
        
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper")!)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        navigationController!.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "wallpaper")!)
//
//        self.tableView.backgroundColor = UIColor().HexToColor("#FCAD4D", alpha: 1.0)

        
//        self.tableView.backgroundColor = UIColor().HexToColor("#FB0032", alpha: 1.0)
        
        tableView.reloadData()
        
    }
    
    
    //Function to filter out m4a files for table view cells
    func filterM4aAndMp3() {
        
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL( documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            m4aFiles = directoryContents.filter{ $0.pathExtension == "m4a"}
            mp3Files = directoryContents.filter{ $0.pathExtension == "mp3"}
            //Combining both m4a and mp3 array into one big array
            m4aMp3Files = m4aFiles + mp3Files
//            print("m4amp3 array is: \(m4aMp3Files) ")
            
//            print("m4aFiles in filter function: \(m4aFiles)")
//            m4aFileNames = m4aFiles.flatMap({$0.URLByDeletingPathExtension!})
//            mp3FileNames = mp3Files.flatMap({$0.URLByDeletingPathExtension!})
            m4aMp3FileNames = m4aMp3Files.flatMap({$0.URLByDeletingPathExtension!})
            
            print("m4aFileNames in filter function: \(m4aMp3FileNames)")
        } catch _ {
            print("Err")
        }
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numOfRows: " + "\(m4aFiles.count)")
//        return m4aFiles.count + mp3Files.count
        return m4aMp3Files.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("songListCell", forIndexPath: indexPath)
        
        
//        print("m4aFiles in TableView: \(m4aFileNames[0])")
//        print("m4aFiles in TableView: \(m4aFileNames[indexPath.row])")
        
        //        print("indexPath = \(indexPath.row)")
//        let songName = m4aFileNames[indexPath.row].absoluteString
        
        
        let songName = m4aMp3FileNames[indexPath.row].absoluteString
        
        if let rangOfZero = songName.rangeOfString("Documents/", options: NSStringCompareOptions.BackwardsSearch){
            finalSongName = String(songName.characters.suffixFrom(rangOfZero.endIndex))
        }
//        print("final song is: \(finalSongName)")
        cell.textLabel!.text = finalSongName
        cell.textLabel?.textColor = UIColor().HexToColor("#FB0032", alpha: 1.0)
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper")!)
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let instance = PlayStopManager.sharedInstance
        selectedM4a = m4aMp3Files[indexPath.row] as! NSURL
        let stringSelectedM4a = selectedM4a.absoluteString
        let finalM4a = stringSelectedM4a.stringByReplacingOccurrencesOfString("file:///", withString: "")
        instance.bgMusicUrl = NSURL.fileURLWithPath(finalM4a)
        instance.setUpNewTrack()
        
        
        //Extracting the selected song name
        let songName = m4aMp3FileNames[indexPath.row].absoluteString
        if let rangOfZero = songName.rangeOfString("Documents/", options: NSStringCompareOptions.BackwardsSearch){
            finalSongName = String(songName.characters.suffixFrom(rangOfZero.endIndex))
        }
        print("finalM4a in song list view is: \(finalSongName)")
//        print("NSURL Fileurl in song list view is: \(NSURL.fileURLWithPath(finalM4a))")
//        print("selectedM4a  in song list view is: \(selectedM4a)")
        instance.selectedTitle = finalSongName
        
        //Assiging current song for record compare
        let songInstance = CurrentSongname.sharedInstance
        songInstance.songName = finalSongName
        
        
        
        // setting the selected song as the original track for VoiceRecord and smashing
        let anotherInstance = VoiceRecord.sharedInstance
        anotherInstance.originalSong = NSURL.fileURLWithPath(finalM4a)
        
        //Goes to the player and automatically play the selected song
        NSNotificationCenter.defaultCenter().postNotificationName("didClickOnASong", object: selectedM4a)
        
        
    }
}

//
// // MARK: - MPMediaPickerController delegate methods

extension SongListViewController : MPMediaPickerControllerDelegate {
    // must implement these, as there is no automatic dismissal
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        print("did pick")
        let player = MPMusicPlayerController.applicationMusicPlayer()
        player.setQueueWithItemCollection(mediaItemCollection)
        
        let object = iPodManagerHelper()
        for i in 0..<mediaItemCollection.items.count {
            //            self.exportAssetAsSourceFormat(mediaItemCollection.items[i])
            object.exportAssetAsSourceFormat(mediaItemCollection.items[i],completion:{
                
                self.filterM4aAndMp3 ()
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
        }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        print("cancel")
        filterM4aAndMp3 ()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension SongListViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
}



