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

class ViewController: UIViewController {
    
    
    var composition =  AVMutableComposition()
    var originalTrack:AVMutableCompositionTrack!
    var index = 0
    //array to store all tracks
    var allTracks: [AnyObject] = ["1", "2"]
    var allTracks1: [AnyObject] = ["1","2"]
    var newTrack = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mashingSongFilesAndPlayBoth()
        
        
        
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
        
//        var allTracks1: [AnyObject] = ["1","2"]
//        var composition =  AVMutableComposition()
//        var originalTrack:AVMutableCompositionTrack!
        //var originalTrack: AVMutableCompositionTrack!
        
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
                    
                    
                    //lowering the volume of the part that should be lowered
                    
                    var audioMixParam: [AVMutableAudioMixInputParameters] = []
                    let assetMusicTrack: AVAssetTrack = audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0]
                    let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: assetMusicTrack)
                    musicParam.trackID = originalTrack.trackID
                    musicParam.setVolume(0.02, atTime: CMTimeMake(20, 1)) //CMTimeGetSeconds(kCMTimeZero)+20, audioAsset.duration.timescale))
                    musicParam.setVolume(1, atTime: CMTimeMake(30, 1))
                    musicParam.setVolume(0.02, atTime: CMTimeMake(35, 1))
                    musicParam.setVolume(1, atTime: CMTimeMake(40, 1))
                    audioMixParam.append(musicParam)
                    
                    //When the comment below is uncommented, it doubles the size of the files
//                    try originalTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: assetMusicTrack, atTime: kCMTimeZero)
                    
                    //Add parameter
                    audioMix.inputParameters = audioMixParam
                }
                catch _ {
                    print("didn't wor")
                }
            }
            else if (index > 0) {
                
                
                print("index > 0")
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: CMTimeMakeWithSeconds(CMTimeGetSeconds(kCMTimeZero)+20
                        , audioAsset.duration.timescale))
                }
                catch _ {
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
        
        //lowering part of the song
        //lowerPartOfSongVolume()
    

    
}

    
//    ////////////////////////mashing all music files together/////////////////////////////
//    func mashingSongFilesAndCutitOff(){
//        
//        var audioTrack :AVMutableCompositionTrack!
//        var originalTrack : AVMutableCompositionTrack!
//        for trackName in allTracks{
//            let audioAsset: AVURLAsset = AVURLAsset(URL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(trackName as? String, ofType: "m4a")!), options: nil)
//            //var audioTrack: AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//            
//            //            originalTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//            
//            if (index == 0) {
//                
//                originalTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//                
//            } else if (index == 1) {
//                audioTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//            }
//            //
//            
//            
//            
//            if(index == 0){
//                print("im there")
//                do {
//                    try originalTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: kCMTimeZero)
//                }catch _ {
//                    print("shit, it didn't work")
//                }
//            }
//            else if(index == 1){
//                print("im here'")
//                
//                do {
//                    try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: CMTimeMakeWithSeconds(CMTimeGetSeconds(kCMTimeZero)+80, audioAsset.duration.timescale))
//                }catch _ {
//                    print("shit, it didn't work")
//                }
//            }
//            index = index + 1
//        }
//        
//        print("before composition")
//        print(composition)
//        
//        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
//        let mixedAudio: String = "mixedAudio.m4a"
//        let exportPath: String = NSTemporaryDirectory().stringByAppendingString(mixedAudio)
//        let exportURL: NSURL = NSURL.fileURLWithPath(exportPath)
//        if NSFileManager.defaultManager().fileExistsAtPath(exportPath) {
//            do {
//                try NSFileManager.defaultManager().removeItemAtPath(exportPath)
//            }
//            catch let error {
//                print(error)
//            }
//        }
//        assetExport.outputFileType = AVFileTypeAppleM4A
//        assetExport.outputURL = exportURL
//        assetExport.shouldOptimizeForNetworkUse = true
//        assetExport.exportAsynchronouslyWithCompletionHandler({() -> Void in
//            print("Completed Sucessfully")
//        })
//    }
    
 
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

