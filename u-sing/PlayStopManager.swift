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
    
    class public var sharedInstance:PlayStopManager {
        return _shareInstance
    }
    
    //creating a static status variable
    var status: Bool = false
    var newTrack = AVAudioPlayer()
    var currentTime = NSTimeInterval()
    var pauseTime = NSTimeInterval()
    var bgMusicUrl = NSURL()
    var selectedTitle = String()
    var finalIndex = 0
    var numOfFinalMix = 0
    var avPlayer = AVPlayer()
    
    //Function to set up the track to be played selected by the user
    func setUpNewTrack(){
        do{
            
            
            newTrack = try AVAudioPlayer(contentsOfURL: bgMusicUrl)
//            newTrack = AVPlayer(playerItem: AVPlayerItem)
            newTrack.delegate = self
//            avPlayer = AVPlayer(URL: bgMusicUrl)
//            avPlayer.rate = 1.0;
//            avPlayer.play()
            
        }catch _ {
            print("newTrack couldn't be set")
        }
    }


    
    
    //Function to play the song outloud so users can hear and sing too
    func playSong(){
    
            newTrack.prepareToPlay()
            newTrack.play()
//        avPlayer.play()
            status = true
  
    }//end of playSong function
    
    //Function to stop playing song
    func stopSong() {

        newTrack.stop()
        status = false
        
    }//end of stopSong fucntion
    
    
     public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        
        
        //Checking if the mix already exists so we don't mash anything
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        /////////////////////////////////////////////////////////////////////////////////////
        numOfFinalMix = numOfFinalMix + 1
        print("inside audioplayer didfinish playing")
        //3) Starting the mixing procress
        let instance = SmashingManager.sharedInstance
        let voiceInstance = VoiceRecord.sharedInstance
//        print("Selected Title is: \(selectedTitle)")
//        
        //Using semaphore to hold off the for loop so we can complete the mixing process
        let semaphore = dispatch_semaphore_create(0)
        let timeoutLengthInNanoSeconds: Int64 = 100000000000000000  //Adjust the timeout to suit your case
        let timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutLengthInNanoSeconds)
        for index in voiceInstance.arrayOfRecordings{
            finalIndex = finalIndex + 1
            print("\(voiceInstance.arrayOfRecordings.count)")
            print("\(finalIndex)")
            if (finalIndex == voiceInstance.arrayOfRecordings.count) {
                instance.genericMash(voiceInstance.originalSong, recording: index, mixedAudioName: "\(selectedTitle)" + "mix.m4a", callback: { (url) in
                    voiceInstance.originalSong = url
                    dispatch_semaphore_signal(semaphore)
                })
            }else{
            instance.genericMash(voiceInstance.originalSong, recording: index, mixedAudioName: "mix.m4a", callback: { (url) in
                voiceInstance.originalSong = url
                dispatch_semaphore_signal(semaphore)
            })
            }
            dispatch_semaphore_wait(semaphore, timeout)
        }//end of mixing process
        
        

        //Removing all the previous recordings after the song had finished
        voiceInstance.arrayOfRecordings.removeAll()
        voiceInstance.clearTempFolder()
        voiceInstance.clearM4aFile()

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