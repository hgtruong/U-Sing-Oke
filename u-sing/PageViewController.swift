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
    
    
    
    //Function to generate new ViewController
    private func newColoredViewController(color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("\(color)ViewController")
    }
    
    
    private(set) lazy var navi: UINavigationController = {
        return self.newColoredViewController("songListNavigation") as! UINavigationController
    }()
    
    private(set) lazy var mixed: UINavigationController = {
        return self.newColoredViewController("mixedSongListNavigation") as! UINavigationController
    }()
    
    //hard coding to create two tabs pages
    var orderedViewControllers: [UIViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        orderedViewControllers = [navi, self.newColoredViewController("Player"), mixed]
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PageViewController.didClickOnASong), name: "didClickOnASong", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PageViewController.didClickOnAMixedSong), name: "didClickOnAMixedSong", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PageViewController.didFinishMashing), name: "didFinishMashing", object: nil)
        
//
        // Do any additional setup after loading the view.
    }
    
    
    func didClickOnASong(){
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    
    func didClickOnAMixedSong(){
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Reverse,
                               animated: true,
                               completion: nil)
        }
    }
    
    
    func didFinishMashing(){
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
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
//    func pageViewController(pageViewController: UIPageViewController,
//                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
//            return nil
//        }
//        
//        let previousIndex = viewControllerIndex - 1
//        
//        // User is on the first view controller and swiped left to loop to
//        // the last view controller.
//        guard previousIndex >= 0 else {
//            return orderedViewControllers.last
//        }
//        
//        guard orderedViewControllers.count > previousIndex else {
//            return nil
//        }
//        
//        return orderedViewControllers[previousIndex]
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController,
//                            viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
//            return nil
//        }
//        
//        let nextIndex = viewControllerIndex + 1
//        let orderedViewControllersCount = orderedViewControllers.count
//        
//        // User is on the last view controller and swiped right to loop to
//        // the first view controller.
//        guard orderedViewControllersCount != nextIndex else {
//            return orderedViewControllers.first
//        }
//        
//        guard orderedViewControllersCount > nextIndex else {
//            return nil
//        }
//        
//        return orderedViewControllers[nextIndex]
//    }
    
    //These two functions below are for finite swiping
    //The two functions above are for infinite swiping
    func pageViewController(pageViewController: UIPageViewController,
                            viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
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
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}