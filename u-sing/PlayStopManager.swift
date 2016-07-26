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
    var bgMusicUrl = NSURL()
    
    func setUpNewTrack(){
        do{
            newTrack = try AVAudioPlayer(contentsOfURL: bgMusicUrl)
        }catch _ {
            print("newTrac couldn't be set")
        }
    }


    class public var sharedInstance:PlayStopManager {
        return _shareInstance
    }
    
    //Function to play the song outloud so users can hear and sing too
    func playSong(){
    
            newTrack.prepareToPlay()
            newTrack.play()
            status = true
  
    }//end of playSong function
    
    //Function to stop playing song
    func stopSong() {

        newTrack.stop()
        status = false
        
    }//end of stopSong fucntion
    
    //Funciton to pause the song
    func pauseSong() {
        newTrack.pause()
        status = false
        
    }
    
    
    
    
    
    //Function to return the current so we know when the user hit the recording button during 
    //when the song is player
    func getCurrentTime() -> NSTimeInterval {
        
        currentTime = newTrack.currentTime
        return currentTime
        
    }//end of getCurrenTime function
    
}