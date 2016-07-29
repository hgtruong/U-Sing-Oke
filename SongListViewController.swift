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
    var m4aFiles: [AnyObject] = []
    var songPicked:[String] = []
    
//    var collection = MPMediaItemCollection()
//    var representativeItem = MPMediaItem()
//    var collectionDidSelect = MPMediaItemCollection()
//    var representativeItemDidSelect = MPMediaItem()
    

    
    
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
        
        
        //setting the media picker delegate
        let mediaPickerController = MPMediaPickerController(mediaTypes: .Music)
        mediaPickerController.delegate = self
        mediaPickerController.showsCloudItems = false
        mediaPickerController.allowsPickingMultipleItems = false
        mediaPickerController.modalPresentationStyle = .Popover
        mediaPickerController.preferredContentSize = CGSizeMake(500,600)
        presentViewController(mediaPickerController, animated: true, completion: {})
        
       
        
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
//        print("repre item is: \(representativeItem)")
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
        
        let collectionDidSelect = mediaCollections[indexPath.row] as! MPMediaItemCollection
        let representativeItemDidSelect = collectionDidSelect.representativeItem!
        
        let filePath = NSBundle.mainBundle().pathForResource("\(selectedTitle)", ofType: ".m4a")
        print("FilePath is \(filePath)")
        
        /////////////////////////////////Trying to do it from the phone///////////////////////
        

        //Importing music from the phone to app's document directory
        
        
        
        
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
//        player.play()
        
        //Use the two lines below whenever we need to clear m4a files in document directory
//        let instance = VoiceRecord.sharedInstance
//        instance.clearM4aFile()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        print("cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension SongListViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}



