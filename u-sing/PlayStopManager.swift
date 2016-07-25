//
//  SongPlayStopManager.swift
//  u-sing
//
//  Created by Huy Truong on 7/22/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import AVFoundation
import Foundation

private var _shareInstance: PlayStopManager = PlayStopManager()

public class PlayStopManager {
    
    //creating a static status variable
    var status: Bool = false
    var newTrack = AVAudioPlayer()
    var currentTime = NSTimeInterval()
    var pauseTime = NSTimeInterval()
    let bgMusicUrl:NSURL =  NSBundle.mainBundle().URLForResource("22", withExtension: "m4a")!


    class public var sharedInstance:PlayStopManager {
        return _shareInstance
    }
    
    //Function to play the song outloud so users can hear and sing too
    func playSong(){
        
        
        
        do {
            
            newTrack =  try AVAudioPlayer(contentsOfURL:bgMusicUrl)
            newTrack.prepareToPlay()
            
            if(pauseTime != 0){
                newTrack.playAtTime(pauseTime)
            }else {
            newTrack.play()
            }
            
            
            //setting status
            status = true
        } catch _ {
            print("song is not found.")
        }
    }//end of playSong function
    
    //Function to stop playing song
    func stopSong() {

        newTrack.stop()
        pauseTime = newTrack.currentTime
        status = false
        newTrack.prepareToPlay()
        
    }//end of stopSong fucntion
    
    
    
    
    //Function to return the current so we know when the user hit the recording button during 
    //when the song is player
    func getCurrentTime() -> NSTimeInterval {
        
        currentTime = newTrack.currentTime
        return currentTime
        
    }//end of getCurrenTime function
    
}