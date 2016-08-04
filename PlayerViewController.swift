//
//  PlayerViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/18/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
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
                    case false:
                        instance.playSong()
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
        
        
        if let isNil = playInstance.newTrack {
            
            print("Insdie finish condition")
            currentSong = songInstance.songName!
            
            print("current song is: \(currentSong)")
            
            if currentSong.rangeOfString("mix") != nil && playInstance.status == true{
                let alertController = UIAlertController(title: "Invalid Task", message: "You ain't got nothing to mix", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                alertController.show()
                
            }else if currentSong.rangeOfString("mix") == nil && playInstance.status == true && (voiceInstance.status == false && voiceInstance.arrayOfRecordings.count >= 1) || voiceInstance.status == true {
                voiceInstance.stopRecord()
                playInstance.stopSong()
                playInstance.finalIndex = 0
                playInstance.startSmashing()
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


    
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func recordButton(sender: AnyObject) {
        
        let instance = VoiceRecord.sharedInstance
        let playInstance = PlayStopManager.sharedInstance
        let songInstance = CurrentSongname.sharedInstance
        
//        print("RIGHT HERE!!!")
        print("Status of recorder is: \(instance.status)")

        if let isNil = playInstance.newTrack{
            
            currentSong = songInstance.songName!
            
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
                    print("stop recording")
                case false:
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
    
        
        
        
      
    
    @IBOutlet weak var songProgress: NSLayoutConstraint!
    
    @IBAction func songProgress(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayerViewController.didClickOnASong(_:)), name: "didClickOnASong", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayerViewController.didClickOnAMixedSong(_:)), name: "didClickOnAMixedSong", object: nil)
//        var background: UIColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
//        self.view.backgroundColor = background
//        background.re

    }
    
    func didClickOnASong(noti:NSNotification){
        let song = noti.object as! NSURL
        let playInstance = PlayStopManager.sharedInstance
        playInstance.bgMusicUrl = song
        playInstance.setUpNewTrack()
        playInstance.playSong()
        
    }
    
    func didClickOnAMixedSong(noti:NSNotification){
        let song = noti.object as! NSURL
        let playInstance = PlayStopManager.sharedInstance
        playInstance.bgMusicUrl = song
        playInstance.setUpNewTrack()
        playInstance.playSong()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


