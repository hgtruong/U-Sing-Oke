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
    
    
//    var composition =  AVMutableComposition()
//     var originalTrack:AVMutableCompositionTrack!
//    var index = 0
//    //array to store all tracks
//    var allTracks: [AnyObject] = ["1", "2"]
//    var allTracks1: [AnyObject] = ["1","2"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mashingSongFilesAndPlayBoth()
        
        
        
    }
    
    
    ////////////////////////setting the background music//////////////////////
//    func lowerPartOfSongVolume (asset: AVAssetExportSession){
//    
//            let bgMusicUrl:NSURL = NSBundle.mainBundle().URLForResource("1", withExtension: "m4a")!
//    
//            do {
//                originalTrack =  try AVAudioPlayer(contentsOfURL:bgMusicUrl)
//                originalTrack.prepareToPlay()
//    
//                //setting the volume
//                originalTrack.volume = 0.3
//                
//                //playing the song
//                originalTrack.play()
//    
//            } catch _ {
//                print("song is not found.")
//            }
//        }
  
    //////////////////////////////////////////////////////////////////////////////
       func mashingSongFilesAndPlayBoth(){
        
        var allTracks1: [AnyObject] = ["1","2"]
        var composition =  AVMutableComposition()
        var originalTrack:AVMutableCompositionTrack!
        //var originalTrack: AVMutableCompositionTrack!
        var index = 0

        for trackName in allTracks1{
            
            let audioAsset: AVURLAsset = AVURLAsset(URL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(trackName as? String, ofType: "m4a")!), options: nil)
            
            var audioTrack: AVMutableCompositionTrack!
            
            if index == 0 {
                originalTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            }
            else if index == 1{
                audioTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            }
            
            
            //starting the merge process
            if (index == 0) {
                print("index = 0")
                do {
                    try originalTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: kCMTimeZero)
                }
                catch _ {
                    print("didn't wor")
                }
            }
            else if (index == 1) {
                print("index > 0")
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: CMTimeMakeWithSeconds(CMTimeGetSeconds(kCMTimeZero)+50, audioAsset.duration.timescale))
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
        assetExport.outputURL = exportURL
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronouslyWithCompletionHandler({() -> Void in
            print("Completed Sucessfully")
        })

    
}

    //////////////////////////////////////////////////////////////////////////////
//    func mashingSongFilesAndPlayBoth(){
//        
//        
//        
//    
//        
//        for trackName in allTracks1{
//            
//            let audioAsset: AVURLAsset = AVURLAsset(URL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(trackName as? String, ofType: "m4a")!), options: nil)
//            
//            
//            
//            if(index == 0){
//                print("im there")
//                do {
//                    let audioTrack: AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//                    //try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: CMTimeMakeWithSeconds((CMTimeGetSeconds(kCMTimeZero)+40), 1))//audioAsset.duration.timescale))
//                    try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: CMTimeMakeWithSeconds((CMTimeGetSeconds(kCMTimeZero)+20), audioAsset.duration.timescale))
//                    
//                }catch _ {
//                    print("shit, it didn't work")
//                }
//            } else if(index > 0){
//                print("im here'")
//                
//                do {
//                    let originalTrack:AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
//                    try originalTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration), ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0], atTime: kCMTimeZero)
//                }catch _ {
//                    print("shit, it didn't work")
//                }
//            }
//            index = index + 1
//        }
//        
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
//        
//        
//
//        
//    }

    
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    NSArray* tracks = [NSArray arrayWithObjects:@"1", @"2",@"1", nil];
    //    NSString* audioFileType = @"m4a";
    //    int index = 0;
    //    AVMutableCompositionTrack* originalAudioTrack;
    //
    //    AVMutableComposition *composition = [AVMutableComposition composition];
    //    NSArray* tracks = [NSArray arrayWithObjects:@"backingTrack", @"RobotR33", nil];
    //    NSString* audioFileType = @"wav";
    //
    //    for (NSString* trackName in tracks) {
    //    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:trackName ofType:audioFileType]]options:nil];
    //
    //    AVMutableCompositionTrack* audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
    //    preferredTrackID:kCMPersistentTrackID_Invalid];
    //
    //    NSError* error;
    //    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0] atTime:kCMTimeZero error:&error];
    //    if (error)
    //    {
    //    NSLog(@"%@", [error localizedDescription]);
    //    }
    //    }
    //    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    //
    //    NSString* mixedAudio = @"mixedAudio.m4a";
    //
    //    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingString:mixedAudio];
    //    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    //
    //    if ([[NSFileManager defaultManager]fileExistsAtPath:exportPath]) {
    //    [[NSFileManager defaultManager]removeItemAtPath:exportPath error:nil];
    //    }
    //    _assetExport.outputFileType = AVFileTypeAppleM4A;
    //    _assetExport.outputURL = exportURL;
    //    _assetExport.shouldOptimizeForNetworkUse = YES;
    //
    //    [_assetExport exportAsynchronouslyWithCompletionHandler:^{
    //    [self hideActivityIndicator];
    //    NSLog(@"Completed Sucessfully");
    //    }];
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

