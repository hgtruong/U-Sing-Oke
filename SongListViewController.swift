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
    var selectedM4a = NSURL()
    var finalSongName = String()

    
    
    @IBOutlet weak var searchButton: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
    
        //Finding the music in user's phone
        
        // run a query on song media type
        mediaQuery = MPMediaQuery.songsQuery()
        
        // ensure what we retrieve is on device
        mediaQuery.addFilterPredicate(MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem))
        
        // run query
        mediaCollections = mediaQuery.collections!
        
        
        //setting the media picker delegate
        let mediaPickerController = MPMediaPickerController(mediaTypes: .Music)
        mediaPickerController.delegate = self
        mediaPickerController.showsCloudItems = false
        mediaPickerController.allowsPickingMultipleItems = false
        mediaPickerController.modalPresentationStyle = .Popover
        mediaPickerController.preferredContentSize = CGSizeMake(500,600)
        presentViewController(mediaPickerController, animated: true, completion: {})
        super.viewDidLoad()
//        filterM4a()
    
       
//        Use the two lines below whenever we need to clear m4a files in document directory
//                let instance = VoiceRecord.sharedInstance
//                instance.clearDocFolder()
        tableView.reloadData()
    }
    
    
    //Function to filter out m4a files for table view cells
    func filterM4a() {

        ///////////Getting the songs from the document directory//////////////////
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL( documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            m4aFiles = directoryContents.filter{ $0.pathExtension == "m4a" }
            m4aFileNames = m4aFiles.flatMap({$0.URLByDeletingPathExtension!})
            print("m4aFiles in filter function: \(m4aFiles)")
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numOfRows: " + "\(m4aFiles.count)")
        return m4aFiles.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("songListCell", forIndexPath: indexPath)
        
        print("m4aFiles in TableView: \(m4aFileNames[0])")
        print("m4aFiles in TableView: \(m4aFileNames[indexPath.row])")
        
//        print("indexPath = \(indexPath.row)")
        let songName = m4aFileNames[indexPath.row].absoluteString
        if let rangOfZero = songName.rangeOfString("Documents/", options: NSStringCompareOptions.BackwardsSearch){
            finalSongName = String(songName.characters.suffixFrom(rangOfZero.endIndex))
        }
        print("final song is: \(finalSongName)")
        cell.textLabel!.text = finalSongName
        
        tableView.reloadData()
        
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let instance = PlayStopManager.sharedInstance
        selectedM4a = m4aFiles[indexPath.row] as! NSURL
        let stringSelectedM4a = selectedM4a.absoluteString
        let finalM4a = stringSelectedM4a.stringByReplacingOccurrencesOfString("file:///", withString: "")
        instance.bgMusicUrl = NSURL.fileURLWithPath(finalM4a)
        instance.setUpNewTrack()
        instance.selectedTitle = stringSelectedM4a
        
        
        //        setting the selected song as the original track for VoiceRecord and smashing
        let anotherInstance = VoiceRecord.sharedInstance
        anotherInstance.originalSong = NSURL.fileURLWithPath(finalM4a)
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
            object.exportAssetAsSourceFormat(mediaItemCollection.items[i])
            
            //NSLog(@"for loop : %d", i);
            //NSLog(@"for loop : %d", i);
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        filterM4a()
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        print("cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    
}

extension SongListViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}



