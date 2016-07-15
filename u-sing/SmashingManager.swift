//
//  SmashingManager.swift
//  u-sing
//
//  Created by Huy Truong on 7/14/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import AVFoundation
import CoreMedia

private var _shareInstance: SmashingManager = SmashingManager()

public class SmashingManager : NSObject {
    
    class public var sharedInstance:SmashingManager {
        return _shareInstance
    }
    
    
    func genericMash(originalSong:NSURL,arrayOfRecordings:[SongStruct],mixedAudioName:String){
        
        let composition =  AVMutableComposition()
        
        //insret original song into composition
        let originalAudioAsset: AVURLAsset = AVURLAsset(URL: originalSong, options: nil)
        let originalTrack:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
        do {
            try originalTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, originalAudioAsset.duration), ofTrack: originalAudioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: kCMTimeZero)

        } catch _ {
            print("error when try to insert the original song into the compsotion")
        }
        
        ////Note: you can only have ONE assetMusicTrack!!!!!!!!///
        //Solution: instead of calling this generic function once and pass the array of struct
        //we call this function three times and pass each individual element in!!!!!////
        
        
        let audioMix: AVMutableAudioMix = AVMutableAudioMix()
//        var audioMixParam: [AVMutableAudioMixInputParameters] = []
        
        //loop through every single recording inside the arrayOfRecordings
        for recording in arrayOfRecordings {
            
            //lower the volume of the original song
            let audioAsset: AVURLAsset = AVURLAsset(URL: recording.songRef, options: nil)
            let assetMusicTrack: AVAssetTrack = audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0]
            print("ASSET MUSIC TRACK \(assetMusicTrack)")
            let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: assetMusicTrack) //you only need one of these
            musicParam.trackID = originalTrack.trackID
            print("start time is \(recording.startTime)")
            print("end time is \(recording.endTime)")
            print("range time is \(recording.endTime - recording.startTime)")
            print("duration of the audio is: \(audioAsset.duration)")
            musicParam.setVolumeRampFromStartVolume(0.02, toEndVolume: 1, timeRange: CMTimeRangeMake(recording.startTime, audioAsset.duration))
            audioMix.inputParameters.append(musicParam)
            
            
            let audioTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            //insert the recording
            do {
                try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: recording.startTime)
            }catch _ {
                print("error when try to insert the recording into the compsotion")
            }
        }

        
//        //testing out stuff starts here
//        let audioAsset: AVURLAsset = AVURLAsset(URL: arrayOfRecordings[0] .songRef, options: nil)
//        let assetMusicTrack: AVAssetTrack = audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0]
//        print("ASSET MUSIC TRACK \(assetMusicTrack)")
//        let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: assetMusicTrack) //you only need one of these
//        musicParam.trackID = originalTrack.trackID
//        print("start time is \(arrayOfRecordings[0].startTime)")
//        print("end time is \(arrayOfRecordings[0].endTime)")
//        print("range time is \(arrayOfRecordings[0].endTime - arrayOfRecordings[0].startTime)")
//        print("duration of the audio is: \(audioAsset.duration)")
//        musicParam.setVolumeRampFromStartVolume(0.02, toEndVolume: 1, timeRange: CMTimeRangeMake(arrayOfRecordings[0].startTime, audioAsset.duration))
//        audioMix.inputParameters.append(musicParam)
//        
//        
//        let audioTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//        //insert the recording
//        do {
//            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: arrayOfRecordings[0].startTime)
//        }catch _ {
//            print("error when try to insert the recording into the compsotion")
//        }
//        
//        
//        
//        ////////testing out stuff again////////////
//        //lower the volume of the original song
//        
//        let audioAsset1: AVURLAsset = AVURLAsset(URL: arrayOfRecordings[1].songRef, options: nil)
//        print("ASSET MUSIC TRACK \(assetMusicTrack)")
//         //you only need one of these
//        musicParam.trackID = originalTrack.trackID
//        print("start time is \(arrayOfRecordings[1].startTime)")
//        print("end time is \(arrayOfRecordings[1].endTime)")
//        print("range time is \(arrayOfRecordings[1].endTime - arrayOfRecordings[1].startTime)")
//        print("duration of the audio is: \(audioAsset1.duration)")
//        musicParam.setVolumeRampFromStartVolume(0.02, toEndVolume: 1, timeRange: CMTimeRangeMake(arrayOfRecordings[1].startTime, audioAsset1.duration))
//        audioMix.inputParameters.append(musicParam)
//        
//        
////        let audioTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//        //insert the recording
//        do {
//            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: arrayOfRecordings[1].startTime)
//        }catch _ {
//            print("error when try to insert the recording into the compsotion")
//        }
//        
//        ///////testing shit again///////////
//        let audioAsset2: AVURLAsset = AVURLAsset(URL: arrayOfRecordings[2].songRef, options: nil)
//        print("ASSET MUSIC TRACK \(assetMusicTrack)")
//        //you only need one of these
//        musicParam.trackID = originalTrack.trackID
//        print("start time is \(arrayOfRecordings[1].startTime)")
//        print("end time is \(arrayOfRecordings[1].endTime)")
//        print("range time is \(arrayOfRecordings[1].endTime - arrayOfRecordings[1].startTime)")
//        print("duration of the audio is: \(audioAsset1.duration)")
//        musicParam.setVolumeRampFromStartVolume(0.02, toEndVolume: 1, timeRange: CMTimeRangeMake(arrayOfRecordings[2].startTime, audioAsset2.duration))
//        audioMix.inputParameters.append(musicParam)
//        
//        
//        //        let audioTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//        //insert the recording
//        do {
//            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: arrayOfRecordings[2].startTime)
//        }catch _ {
//            print("error when try to insert the recording into the compsotion")
//        }
//        
        
        
        
        ///////testing out stuff ends above//////

        //export the compsotion
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)!
        let exportPath: String = NSTemporaryDirectory().stringByAppendingString(mixedAudioName)
        let exportURL: NSURL = NSURL.fileURLWithPath(exportPath)
        if NSFileManager.defaultManager().fileExistsAtPath(exportPath) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(exportPath)
            }
            catch _ {
                print("mixedAudio already exits.Error when try to remove it from disk")
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
}