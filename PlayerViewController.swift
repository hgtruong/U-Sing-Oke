//
//  PlayerViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/18/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    
    @IBOutlet weak var stopPlayButton: UIButton!
    
    @IBAction func stopPlayButton(sender: AnyObject) {
        
        let instance = PlayStopManager.sharedInstance
        
        
        if instance.newTrack.currentTime < instance.newTrack.duration || instance.newTrack.currentTime == 0.0 {
            switch instance.status {
            case true:
                instance.pauseSong()
            case false:
                instance.playSong()
            }
        }
    }
    
    
    
    
    @IBOutlet weak var FinishButton: UIButton!
    
    @IBAction func FinishButton(sender: AnyObject) {
        
        //Start smashing when user hits the finish recording
        let instance = PlayStopManager.sharedInstance
        instance.startSmashing()
        
        
    }
  
    
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func recordButton(sender: AnyObject) {
        
        let instance = VoiceRecord.sharedInstance
//        print("RIGHT HERE!!!")
        print("Status of recorder is: \(instance.status)")
        
        switch instance.status {
        case true:
            instance.stopRecord()
            print("stop recording")
        case false:
            instance.record()
            print("recording")
        }
    }
    
    @IBOutlet weak var songProgress: NSLayoutConstraint!
    
    @IBAction func songProgress(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
