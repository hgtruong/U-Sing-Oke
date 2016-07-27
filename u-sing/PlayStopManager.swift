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

public class PlayStopManager: NSObject, AVAudioPlayerDelegate {
    
    //creating a static status variable
    var status: Bool = false
    var newTrack = AVAudioPlayer()
    var currentTime = NSTimeInterval()
    var pauseTime = NSTimeInterval()
    var bgMusicUrl = NSURL()
    var musicUrl = String()
    var index = 0
    
    //Function to set up the track to be played selected by the user
    func setUpNewTrack(){
        do{
            
            newTrack = try AVAudioPlayer(contentsOfURL: bgMusicUrl)
            newTrack.delegate = self
//            musicUrl = bgMusicUrl.absoluteString
//            print("music url is: \(musicUrl)")
//            newTrack = try AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(bgMusicUrl))
            
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
    
    
     public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        index = index + 1
        
        print("inside audioplayer didfinish playing")
        //3) Starting the mixing procress
        let instance = SmashingManager.sharedInstance
        let voiceInstance = VoiceRecord.sharedInstance
        
        //Using semaphore to hold off the for loop so we can complete the mixing process
        let semaphore = dispatch_semaphore_create(0)
        let timeoutLengthInNanoSeconds: Int64 = 100000000000000  //Adjust the timeout to suit your case
        let timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutLengthInNanoSeconds)
        for index in voiceInstance.arrayOfRecordings{
            print("\(voiceInstance.arrayOfRecordings.count)")
            instance.genericMash(voiceInstance.originalSong, recording: index, mixedAudioName: "mix.m4a", callback: { (url) in
                voiceInstance.originalSong = url
                dispatch_semaphore_signal(semaphore)
            })
            dispatch_semaphore_wait(semaphore, timeout)
        }//end of mixing process
    
        //Removing all the previous recordings after the song had finished
        voiceInstance.arrayOfRecordings.removeAll()
    }
    
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