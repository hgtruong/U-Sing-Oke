//
//  VoiceRecord.swift
//  u-sing
//
//  Created by Huy Truong on 7/21/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import AVFoundation
import RealmSwift



private var _shareInstance: VoiceRecord = VoiceRecord()

public class VoiceRecord: NSObject {
    

    
    class public var sharedInstance:VoiceRecord {
        return _shareInstance
    }
    
    //creating a static status variable
    var status: Bool = false
    
    
    
    //Variables declarations
    let realm = try! Realm()
    var index = 0
    var soundIndex = 0
    var start = NSTimeInterval()
    var end = NSTimeInterval()
    var startDiff = NSDate()
    var endDiff = NSDate()
    var duration = NSTimeInterval()
    var startTime: CMTime = CMTimeMake(0, 0)
    var endTime: CMTime = CMTimeMake(0, 0)
    var cmDuration = CMTimeMake(0, 0)
    var audioRecorder:AVAudioRecorder!
    var arrayOfRecordings : [SongStruct] = []
    

    
    //Recording function
    func record() {
        let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                              AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                              AVNumberOfChannelsKey : NSNumber(int: 1),
                              AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
        
        //init
        let instance = PlayStopManager.sharedInstance
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
                    try! self.audioRecorder = AVAudioRecorder(URL: self.directoryUrl()!, settings: recordSettings)
                    self.audioRecorder.record()
                    self.start = instance.getCurrentTime()
                    
                } else{
                    print("not granted")
                }
            })
        }
    }

    
        
    //Function to stop the recording
        func stopRecord() {
            index = index + 1
            
            //variable declaration
            let instance = PlayStopManager.sharedInstance
            self.end = instance.getCurrentTime()
            
            //cov
            
            //init
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setActive(false)
                self.audioRecorder.stop()
                self.status = false
                
                
               /////////////////After recording is finished //////////////////////
                
                
                //1) create a struct for the record
                
                //Finding the duration of the recording, this might turn out to be not needed
                self.duration = endDiff.timeIntervalSinceDate(startDiff)
                
                
                //converting NSTimeInvertal start and end to CMTime
                startTime = CMTimeMakeWithSeconds(start, 1000000)
                endTime = CMTimeMakeWithSeconds(end, 1000000)
                
                //2) append it to the array ofstructs
                arrayOfRecordings.append(SongStruct(songName: "recording" + "\(index)" + ".m4a", songRef: audioRecorder.url, startTime: startTime , endTime: endTime))

                //3) Starting the mixing procress 
                
                
                
                
            } catch {
            }
        }
        
    //Function to create directory to save the recording
    func directoryUrl() -> NSURL? {
        
            soundIndex = soundIndex + 1
            let fileManager = NSFileManager.defaultManager()
            let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let documentDirectory = urls[0] as NSURL
            let soundURL = documentDirectory.URLByAppendingPathComponent("sound" + "\(soundIndex)" + ".m4a")
            print("\(soundURL)")
            return soundURL
    }
    

    //Function to return the status of the record
    func returnStatus() -> Bool {
        return status
    }
}