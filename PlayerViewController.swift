//
//  PlayerViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/18/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit
import AVFoundation



private var _shareInstance: PlayerViewController = PlayerViewController()


class PlayerViewController: UIViewController {
    
    
    class public var sharedInstance:PlayerViewController {
        return _shareInstance
    }
    
    
    //Variables
    @IBOutlet weak var ImageView: UIImageView!

    @IBOutlet weak var StopPlayLabel: UILabel!
    
    @IBOutlet weak var RecordLabel: UILabel!
    
    @IBOutlet weak var FinishLabel: UILabel!
    
    @IBOutlet weak var NowPlayingLabel: UILabel!
    
    let songInstance = CurrentSongname.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayerViewController.didClickOnASong(_:)), name: "didClickOnASong", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayerViewController.didClickOnAMixedSong(_:)), name: "didClickOnAMixedSong", object: nil)
        
        FinishButton.hidden = true
        FinishLabel.hidden = true
        
        recordButton.hidden = true
        RecordLabel.hidden = true
        
        
        stopPlayButton.hidden = true
        StopPlayLabel.hidden = true
    
        ImageView.image = self.ResizeImage(UIImage(named: "Musical.png")!, targetSize: CGSizeMake(ImageView.frame.size.width, ImageView.frame.size.height))
        
        //Setting nowplayinglabel properties
        NowPlayingLabel.textAlignment = NSTextAlignment.Center
        NowPlayingLabel.textColor = UIColor.whiteColor()
        NowPlayingLabel.font = UIFont.boldSystemFontOfSize(16.0)
        NowPlayingLabel.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper")!)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper")!)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
//        self.navigationController!.navigationBar.titleTextAttributes = (titleDict as! [String : AnyObject])
//        navigationController!.navigationBar.barTintColor = UIColor(patternImage: UIImage(named: "wallpaper")!)

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
//        FinishButton.hidden = true
//        FinishLabel.hidden = true
        
        if songInstance.songName == "nil" {
            NowPlayingLabel.text = "Playing: "
        }else {
            NowPlayingLabel.text = "Playing: \(songInstance.songName)"
        }
        
    }
    
    
    
    var currentSong = String()
    
    
    @IBOutlet weak var stopPlayButton: UIButton!
    
    @IBAction func stopPlayButton(sender: AnyObject) {
        
        let instance = PlayStopManager.sharedInstance
        
    
            if let isNil = instance.newTrack {
                let currentTime = isNil.currentTime
                if currentTime < instance.newTrack.duration || currentTime == 0.0 {
                    switch instance.status {
                    case true:
                        instance.pauseSong()
                        stopPlayButton.selected = true
                    case false:
                        instance.playSong()
                        stopPlayButton.selected = false

                        
                    }
                }
            } else{
            let alertController = UIAlertController(title: "No Song Chosen!", message: "Please select a song to get started!", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
            alertController.show()
        }
       
    }

    @IBOutlet weak var FinishButton: UIButton!
    
    @IBAction func FinishButton(sender: AnyObject) {
        
        //Start smashing when user hits the finish recording
        let playInstance = PlayStopManager.sharedInstance
        let voiceInstance = VoiceRecord.sharedInstance
        let songInstance = CurrentSongname.sharedInstance
        
        
        
        if playInstance.newTrack != nil {
            
            print("Insdie finish condition")
            currentSong = songInstance.songName
            
            print("current song is: \(currentSong)")
            
            if currentSong.rangeOfString("mix") != nil && playInstance.status == true{
                let alertController = UIAlertController(title: "Invalid Task", message: "You ain't got nothing to mix", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                alertController.show()
                
            }else if currentSong.rangeOfString("mix") == nil && playInstance.status == true && (voiceInstance.status == false && voiceInstance.arrayOfRecordings.count >= 1) || voiceInstance.status == true {
                
                recordButton.selected = false
                
                playInstance.stopSong()
                playInstance.finalIndex = 0
                
                //Creating an activity indicator
                let alertView = UIAlertController(title: "Processing...", message: "Don't worry, app did not crash!", preferredStyle: .Alert)
                let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                indicator.startAnimating()
                alertView.popoverPresentationController?.sourceView = self.view
                presentViewController(alertView, animated: true, completion: nil)
                


                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), {() -> Void in
                    
                    playInstance.startSmashing()
        
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        alertView.dismissViewControllerAnimated(true, completion: nil)
                    })

                })
                
                stopPlayButton.hidden = false
                StopPlayLabel.hidden = false
                stopPlayButton.userInteractionEnabled = true
            }else {
                let alertController = UIAlertController(title: "Invalid Task", message: "Please press record", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                alertController.show()
            }
        }else {
            let alertController = UIAlertController(title: "Invalid Task", message: "Plese pick a song first", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
            alertController.show()
        }
    }

    func presentActivityViewController(sourceView: UIView, activityItem: String ) {
        
        let activityViewController = UIActivityViewController(activityItems: [activityItem], applicationActivities: [])
        
        activityViewController.popoverPresentationController?.sourceView = sourceView
        activityViewController.popoverPresentationController?.sourceRect = sourceView.bounds
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func recordButton(sender: AnyObject) {
        
        let instance = VoiceRecord.sharedInstance
        let playInstance = PlayStopManager.sharedInstance
        let songInstance = CurrentSongname.sharedInstance
        
//        print("RIGHT HERE!!!")
        print("Status of recorder is: \(instance.status)")

        if let isNil = playInstance.newTrack{
            
            currentSong = songInstance.songName
            
            print("current song is: \(currentSong)")
            print("play status is: \(playInstance.status)")
            
            if currentSong.rangeOfString("mix") != nil && playInstance.status == true{
                let alertController = UIAlertController(title: "Be nice", message: "Can't record while playing a mix", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                alertController.show()
                
            }else if currentSong.rangeOfString("mix") == nil && playInstance.status == true {
                switch instance.status {
                case true:
                    instance.stopRecord()
                    recordButton.selected = false
                    print("stop recording")
                    
                case false:
                    FinishButton.hidden = false
                    FinishLabel.hidden = false
                    
                    recordButton.selected = true
                    
                    instance.record()
                    
                    print("recording")
                }
            }else {
                let alertController = UIAlertController(title: "No Song Chosen", message: "Please pick a song first!", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                alertController.show()
            }
        }else {
                let alertController = UIAlertController(title: "No Song Chosen", message: "Please pick a song first!", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                alertController.show()
        }
    }
    
    func didClickOnASong(noti:NSNotification){
        
        recordButton.hidden = false
        RecordLabel.hidden = false
        
        stopPlayButton.hidden = true
        StopPlayLabel.hidden = true
        
        let song = noti.object as! NSURL
        let playInstance = PlayStopManager.sharedInstance
        playInstance.bgMusicUrl = song
        playInstance.setUpNewTrack()
        playInstance.playSong()
        
        
    }
    
    func didClickOnAMixedSong(noti:NSNotification){
        let song = noti.object as! NSURL
        
        FinishButton.hidden = true
        FinishLabel.hidden = true
        
        recordButton.hidden = true
        RecordLabel.hidden = true
        
        stopPlayButton.hidden = false
        StopPlayLabel.hidden = false
        
        let playInstance = PlayStopManager.sharedInstance
        playInstance.bgMusicUrl = song
        playInstance.setUpNewTrack()
        playInstance.playSong()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Function to resize Image
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage! {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}


