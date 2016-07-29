//
//  NSObject+iPodManager.m
//  u-sing
//
//  Created by Huy Truong on 7/29/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

#import "NSObject+iPodManagerHelper.h"
#import "UIKit/UIKit.h"
@import MediaPlayer;
@import AVFoundation;
@implementation iPodManagerHelper



- (void)exportAssetAsSourceFormat:(MPMediaItem *)item {
    
    NSURL *assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    BOOL isCloud = FALSE;
    
        NSNumber *isCloudNumber = [item valueForProperty:MPMediaItemPropertyIsCloudItem];
        isCloud = [isCloudNumber boolValue];
    
    
    
    if(assetURL != nil &&  ![assetURL isKindOfClass:[NSNull class]] && ! isCloud)
    {
        NSLog(@"ASSET URL :%@ ", assetURL);
        
        NSLog(@"\n>>>> assetURL : %@",[assetURL absoluteString]);
        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:songAsset
                                               presetName:AVAssetExportPresetPassthrough];
        
        NSArray *tracks = [songAsset tracksWithMediaType:AVMediaTypeAudio];
        AVAssetTrack *track = [tracks objectAtIndex:0];
        
        id desc = [track.formatDescriptions objectAtIndex:0];
        const AudioStreamBasicDescription *audioDesc = CMAudioFormatDescriptionGetStreamBasicDescription((CMAudioFormatDescriptionRef)desc);
        
        FourCharCode formatID = audioDesc->mFormatID;
        
        NSString *fileType = nil;
        NSString *ex = nil;
        
        switch (formatID) {
                
            case kAudioFormatLinearPCM:
            {
                UInt32 flags = audioDesc->mFormatFlags;
                if (flags & kAudioFormatFlagIsBigEndian) {
                    fileType = @"public.aiff-audio";
                    ex = @"aif";
                } else {
                    fileType = @"com.microsoft.waveform-audio";
                    ex = @"wav";
                }
            }
                break;
                
            case kAudioFormatMPEGLayer3:
                fileType = @"com.apple.quicktime-movie";
                ex = @"mp3";
                break;
                
            case kAudioFormatMPEG4AAC:
                fileType = @"com.apple.m4a-audio";
                ex = @"m4a";
                break;
                
            case kAudioFormatAppleLossless:
                fileType = @"com.apple.m4a-audio";
                ex = @"m4a";
                break;
                
            default:
                break;
        }
        
        exportSession.outputFileType = fileType;
        
        NSString *fileName = nil;
        
        fileName = [NSString stringWithString:[item valueForProperty:MPMediaItemPropertyTitle]];
        
        NSArray *fileNameArray = nil;
        fileNameArray = [fileName componentsSeparatedByString:@" "];
        fileName = [fileNameArray componentsJoinedByString:@""];
        
        // we changed this,be careful
        NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
        
        NSString *filePath = [[docDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:ex];
        
//        int fileNumber = 0;
//        NSString *fileNumberString = nil;
//        NSString *fileNameWithNumber = nil;
//        while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//            fileNumber++;
//            fileNumberString = [NSString stringWithFormat:@"-%02d", fileNumber];
//            fileNameWithNumber = [fileName stringByAppendingString:fileNumberString];
//            filePath = [[docDir stringByAppendingPathComponent:fileNameWithNumber] stringByAppendingPathExtension:ex];
//            NSLog(@"filePath = %@", filePath);
//        }
//        
        // -------------------------------------
        
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
             NSError *deleteErr = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&deleteErr];
        }
        
        
        [self deleteMyFile:filePath];
        filePath = [filePath stringByAppendingString:@".mov"];
        [self deleteMyFile:filePath];
        
        exportSession.outputURL = [NSURL fileURLWithPath:filePath];
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                NSError *error;
                NSString *newpath = [filePath stringByReplacingOccurrencesOfString:@".mov" withString:@""];
                if ([fileMgr moveItemAtPath:filePath toPath:newpath error:&error] != YES)
                    NSLog(@"Unable to move file: %@", [error localizedDescription]);
            }else
            {
                //NSLog(@"export session error");
            }
            
        }];
        }
        
        
    }   
    


-(void)deleteMyFile:(NSString *)path
{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *deleteErr = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&deleteErr];
        if (deleteErr) {
            NSLog (@"Can't delete %@: %@", path, deleteErr);
        }
    }
}


@end
