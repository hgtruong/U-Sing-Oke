//
//  TestViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/29/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit
import MediaPlayer

class TestViewController: UIViewController {
    
    @IBAction func doGo (sender:AnyObject!) {
        self.presentPicker(sender)
    }
    
    func presentPicker (sender:AnyObject) {
        let picker = MPMediaPickerController(mediaTypes:.Music)
        picker.showsCloudItems = false
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        picker.modalPresentationStyle = .Popover
        picker.preferredContentSize = CGSizeMake(500,600)
        self.presentViewController(picker, animated: true, completion: nil)
        if let pop = picker.popoverPresentationController {
            if let b = sender as? UIBarButtonItem {
                pop.barButtonItem = b
            }
        }
    }
}

extension TestViewController : MPMediaPickerControllerDelegate {
    // must implement these, as there is no automatic dismissal
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("did pick")
        let player = MPMusicPlayerController.applicationMusicPlayer()
        player.setQueueWithItemCollection(mediaItemCollection)
        
        
        
        let object = iPodManagerHelper()
        for i in 0..<mediaItemCollection.items.count {
            //            self.exportAssetAsSourceFormat(mediaItemCollection.items[i])
            object.exportAssetAsSourceFormat(mediaItemCollection.items[i])
            
            //NSLog(@"for loop : %d", i);
            //NSLog(@"for loop : %d", i);
        }
        player.play()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        print("cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension TestViewController : UIBarPositioningDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
