//
//  PageViewController.swift
//  u-sing
//
//  Created by Huy Truong on 7/18/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//


import UIKit
import AVFoundation
import CoreMedia

class PageViewController: UIPageViewController{
    
    var composition =  AVMutableComposition()
    var originalTrack:AVMutableCompositionTrack!
    var index = 0
    var originalSong = NSBundle.mainBundle().URLForResource("22", withExtension: "m4a")
    
    
    //Function to generate new ViewController
    private func newColoredViewController(color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("\(color)ViewController")
    }
    
    //hard coding to create two tabs pages
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        let navi = self.newColoredViewController("songListNavigation") as! UINavigationController
        return [navi,
                self.newColoredViewController("Player")]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let arrayOfRecordings : [SongStruct] = [SongStruct(songRef: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("3", ofType: "m4a")!), startTime: CMTimeMakeWithSeconds(15, 1), endTime: CMTimeMakeWithSeconds(25, 1)),SongStruct(songRef: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("2", ofType: "m4a")!), startTime: CMTimeMakeWithSeconds(30, 1), endTime: CMTimeMakeWithSeconds(40, 1)),SongStruct(songRef: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("3", ofType: "m4a")!), startTime: CMTimeMakeWithSeconds(50, 1), endTime: CMTimeMakeWithSeconds(60, 1))]
        let instance = SmashingManager.sharedInstance
        
        //Using semaphore to hold off the for loop so we can complete the mixing process
        let semaphore = dispatch_semaphore_create(0)
        let timeoutLengthInNanoSeconds: Int64 = 10000000000  //Adjust the timeout to suit your case
        let timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutLengthInNanoSeconds)
        for index in arrayOfRecordings{
            print("\(arrayOfRecordings.count)")
            instance.genericMash(originalSong!, recording: index, mixedAudioName: "mix.m4a", callback: { (url) in
                print("url is before: \(url)")
                self.originalSong = url
                print("url is after: \(url)")
                dispatch_semaphore_signal(semaphore)
            })
            
            dispatch_semaphore_wait(semaphore, timeout)
            
        }
        
        dataSource = self
        //
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
    //
    //    //Swiping functions
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}