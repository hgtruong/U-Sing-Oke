//
//  VoiceRecord.swift
//  u-sing
//
//  Created by Huy Truong on 7/21/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import AVFoundation


private var _shareInstance: VoiceRecord = VoiceRecord()

public class VoiceRecord: NSObject {
    

    
    class public var sharedInstance:VoiceRecord {
        return _shareInstance
    }
    
    //creating a static status variable
    var status: Bool = false
    
    //Variables declarations
    var audioRecorder:AVAudioRecorder!
    
    

    
    //Recording function
    func record() {
        let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                              AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                              AVNumberOfChannelsKey : NSNumber(int: 1),
                              AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
        
        //init
        let audioSession = AVAudioSession.sharedInstance()
        
        //setting up audio recoding session to start recording
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: NSBundle.mainBundle().bundleURL.absoluteURL,
                                                settings: recordSettings)
            audioRecorder.prepareToRecord()
        } catch {
        }
        
        //ask for permission
        if (audioSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("granted")
                    
                    //set category and activate recorder session
                    try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try! audioSession.setActive(true)
                    
                    //setting status of record
                    self.status = true
                    
                    //record
                    try! self.audioRecorder = AVAudioRecorder(URL: NSBundle.mainBundle().bundleURL.absoluteURL, settings: recordSettings)
                    
                } else{
                    print("not granted")
                }
            })
        }
    }
    
        
    //Function to stop the recording
        func stopRecord() {
            
            //init
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setActive(false)
                self.status = false
            } catch {
            }
        }
        
    //Function to create directory to save the recording
    func directoryURL() -> NSURL? {
            let fileManager = NSFileManager.defaultManager()
            let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let documentDirectory = urls[0] as NSURL
            let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
            return soundURL
    }
    
    //Function to return the status of the record
    func returnStatus() -> Bool {
        return status
    }
}