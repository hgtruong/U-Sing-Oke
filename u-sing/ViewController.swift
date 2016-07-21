//
//  ViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/12/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class ViewController: UIViewController{
    
    
    var composition =  AVMutableComposition()
    var originalTrack:AVMutableCompositionTrack!
    var index = 0
    //array to store all tracks
    var allTracks: [AnyObject] = ["1", "2"]
    var allTracks1: [AnyObject] = ["1","2","3"]
    var newTrack = AVAudioPlayer()
    
    var originalSong = NSBundle.mainBundle().URLForResource("22", withExtension: "m4a")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let arrayOfRecordings : [SongStruct] = [SongStruct(songRef: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("3", ofType: "m4a")!), startTime: CMTimeMakeWithSeconds(15, 1), endTime: CMTimeMakeWithSeconds(25, 1)),SongStruct(songRef: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("2", ofType: "m4a")!), startTime: CMTimeMakeWithSeconds(30, 1), endTime: CMTimeMakeWithSeconds(40, 1)),SongStruct(songRef: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("3", ofType: "m4a")!), startTime: CMTimeMakeWithSeconds(50, 1), endTime: CMTimeMakeWithSeconds(60, 1))]
       let instance = SmashingManager.sharedInstance
        
    //Using semaphore to hold off the for loop so we can complete the mixing process
        let semaphore = dispatch_semaphore_create(0)
        let timeoutLengthInNanoSeconds: Int64 = 10000000000  //Adjust the timeout to suit your case
        let timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutLengthInNanoSeconds)
        for index in arrayOfRecordings{
            instance.genericMash(originalSong!, recording: index, mixedAudioName: "mix.m4a", callback: { (url) in
                self.originalSong = url
                dispatch_semaphore_signal(semaphore)
            })
            
            dispatch_semaphore_wait(semaphore, timeout)
            
        }
        
    }
    

    ////////////////////////setting the background music//////////////////////
    func lowerPartOfSongVolume (){
    
            //let bgMusicUrl:NSURL = NSBundle.mainBundle().URLForResource("1", withExtension: "m4a")!
        
        let bgMusicUrl:NSURL = NSBundle.mainBundle().URLForResource("mixedAudio", withExtension: "m4a")!
    
            do {
                
                newTrack =  try AVAudioPlayer(contentsOfURL:bgMusicUrl)
                newTrack.prepareToPlay()
    
                //setting the volume
                newTrack.volume = 0.05
                
                
                //playing the song
                newTrack.play()
    
            } catch _ {
                print("song is not found.")
            }
        }
  
    //////////////////////////////////////////////////////////////////////////////
       func mashingSongFilesAndPlayBoth(){

        var index = 0
        
        let audioMix: AVMutableAudioMix = AVMutableAudioMix()

        for trackName in allTracks1{
            
            
            let audioAsset: AVURLAsset = AVURLAsset(URL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(trackName as? String, ofType: "m4a")!), options: nil)
            
            let audioTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)

            //starting the merge process
            if (index == 0) {
                print("index = 0")
                do {
                    
                    originalTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
                    
                    try originalTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: kCMTimeZero)
        }
                catch _ {
                    print("didn't wor")
                }
            }
            else if (index > 0) {
                
                
                print("index > 0")
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: CMTimeMakeWithSeconds(CMTimeGetSeconds(kCMTimeZero)+Double(20*index)
                        , audioAsset.duration.timescale))
                    
                    //lowering the volume of the part that should be lowered
                    
                    var audioMixParam: [AVMutableAudioMixInputParameters] = []
                    let assetMusicTrack: AVAssetTrack = audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0]
                    let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: assetMusicTrack)
                    musicParam.trackID = originalTrack.trackID
                    
                    //testing code to lower and raise the volume back up
                    musicParam.setVolumeRampFromStartVolume(0.02, toEndVolume: 1, timeRange: CMTimeRangeMake(CMTimeMake (Int64(20*index), 1), CMTimeMakeWithSeconds(10, 1)))
                    
                    
                    //two comments below is part of working codes
                    audioMixParam.append(musicParam)
                    audioMix.inputParameters = audioMixParam
                    
                    }catch _ {
                    print("didn't wor")
                }
            }
            
           index = index + 1
        }
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
        let mixedAudio: String = "mixedAudio.m4a"
        let exportPath: String = NSTemporaryDirectory().stringByAppendingString(mixedAudio)
        let exportURL: NSURL = NSURL.fileURLWithPath(exportPath)
        if NSFileManager.defaultManager().fileExistsAtPath(exportPath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(exportPath)
            }
            catch _ {
            }
        }
        assetExport.outputFileType = AVFileTypeAppleM4A
        assetExport.audioMix = audioMix
        assetExport.outputURL = exportURL
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronouslyWithCompletionHandler({() -> Void in
            print("Completed Sucessfully")
        })
}

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

