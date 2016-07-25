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
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButton(sender: AnyObject) {
    }
    
    
    @IBOutlet weak var stopPlayButton: UIButton!
    
    @IBAction func stopPlayButton(sender: AnyObject) {
        
        let instance = PlayStopManager.sharedInstance
        
        switch instance.status {
        case true:
            instance.stopSong()
        case false:
            instance.playSong()
        }
        
        
    }
    
    @IBOutlet weak var previousSongButton: UIButton!

    @IBAction func previousSongButton(sender: AnyObject) {
    }
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func recordButton(sender: AnyObject) {
        
        let instance = VoiceRecord.sharedInstance
        print("RIGHT HERE!!!")
        print("\(instance.status)")
        
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
