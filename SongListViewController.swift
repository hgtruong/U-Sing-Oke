//
//  SongListViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/18/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit
import MediaPlayer

class SongListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //Variable declarations
    var mediaQuery = MPMediaQuery()
    var mediaCollections: [AnyObject] = []
//    var collection = MPMediaItemCollection()
//    var representativeItem = MPMediaItem()
    var songTitle = String()
    var selectedTitle = String()
    var m4aFiles: [AnyObject] = []
    var songPicked:[String] = []
    
    
    
    ////////////////////////////////
    

    
    
    
    //////////////////////////////
    
    
    @IBOutlet weak var searchButton: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Finding the music in user's phone
        
        // run a query on song media type
        mediaQuery = MPMediaQuery.songsQuery()
        
        // ensure what we retrieve is on device
        mediaQuery.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
        
        // run query
        mediaCollections = mediaQuery.collections!
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("hello " + "\(mediaCollections.count)")
        return mediaCollections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("songListCell", forIndexPath: indexPath) as UITableViewCell
        
        //Populating the table view cell
        let collection = mediaCollections[indexPath.row] as! MPMediaItemCollection
        let representativeItem = collection.representativeItem!
        songTitle = representativeItem.title!
        cell.textLabel!.text = songTitle
//        print("song title is: \(songTitle)")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Manually calling the play button from here and passing the song selected at the row
        let instance = PlayStopManager.sharedInstance
        
        //getting the title of song at selected row
        let selection = tableView.cellForRowAtIndexPath(indexPath)
        selectedTitle = (selection?.textLabel?.text)!
        print("Selected Title is \(selectedTitle)")
        
        let filePath = NSBundle.mainBundle().pathForResource("\(selectedTitle)", ofType: ".m4a")
        print("FilePath is \(filePath)")
        
        /////////////////////////////////Trying to do it from the phone///////////////////////
        
//        let player = MPMusicPlayerController.systemMusicPlayer()
        let collection = mediaCollections[indexPath.row] as! MPMediaItemCollection
        let representativeItem = collection.representativeItem!
//        let url = representativeItem.valueForProperty(MPMediaItemPropertyAssetURL)
//        print("url is: \(url)")
        
//
//        player.setQueueWithItemCollection(collection)
//        player.nowPlayingItem = representativeItem
//        
//        
//        //getting the fucking url now...hopefully
//        let nowPlayingItem = player.nowPlayingItem
//        
//        let mediaUrl = nowPlayingItem?.valueForProperty(MPMediaItemPropertyAssetURL)
//        
//        print("media Url is: \(mediaUrl!)")
//        
//        let myAVPlayerItem = AVPlayerItem.init(URL: mediaUrl! as! NSURL)
//        
//        let myAVPlayer: AVPlayer = AVPlayer(playerItem: myAVPlayerItem)
//
//        myAVPlayer.play() 
        
        
        print("representativeItem: \(representativeItem)")
        let player = MPMusicPlayerController.systemMusicPlayer()
        player.nowPlayingItem = representativeItem
        let currentSong = player.nowPlayingItem
        let currentSongUrl = currentSong?.valueForProperty(MPMediaItemPropertyAssetURL)
        print("current song url: \(currentSongUrl)")
        
        instance.bgMusicUrl = NSURL.fileURLWithPath((currentSongUrl?.absoluteString)!)
        print("bgmusicurl is: \(instance.bgMusicUrl)")
        instance.setUpNewTrack()
        
        
        
        
        
        
        
        
        
        
        ////////////////////////////////////////////////////////////////////////////////////////
//        instance.bgMusicUrl = NSURL.fileURLWithPath(filePath!)
//        instance.setUpNewTrack()
//        //setting title to be used as final mix name
//        instance.selectedTitle = self.selectedTitle
//        instance.status = false
////        print("\(instance.newTrack.duration)")
//        
//        //setting the selected song as the original track for VoiceRecord and smashing
//        let anotherInstance = VoiceRecord.sharedInstance
//        anotherInstance.originalSong = NSURL.fileURLWithPath(filePath!)
        
    
    }
}

//
// // MARK: - Navigation
//
//extension SongListViewController: UITableViewDataSource{
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath) as! UITableViewCell
//        cell.textLabel?.text = "test"
//        return cell
//    }
//}
