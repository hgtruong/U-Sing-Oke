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

class PageViewController: UIPageViewController { //UIPageViewControllerWithOverlayIndicator {
    
    
    
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
    
    private(set) lazy var player: UINavigationController = {
        return self.newColoredViewController("playerNavigation") as! UINavigationController
    }()
    
    //hard coding to create two tabs pages
    var orderedViewControllers: [UIViewController]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        orderedViewControllers = [navi, player, mixed]
        
        let firstViewController = orderedViewControllers[0]
        let secondViewController = orderedViewControllers[1]
        
        setViewControllers([secondViewController], direction: .Forward, animated: true, completion: nil)
        setViewControllers([firstViewController], direction: .Forward, animated: true, completion: nil)
        
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageControl.backgroundColor = UIColor.darkGrayColor()
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.center = self.view.center
        self.view.addSubview(pageControl)
        
        pageControl.layer.position.y = self.view.frame.height - 10
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PageViewController.didClickOnASong), name: "didClickOnASong", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PageViewController.didClickOnAMixedSong), name: "didClickOnAMixedSong", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PageViewController.didFinishMashing), name: "didFinishMashing", object: nil)
        
    }
    
    
    
    func didClickOnASong(){
        let firstViewController = orderedViewControllers[1]
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
    }
    
    
    func didClickOnAMixedSong(){
        let firstViewController = orderedViewControllers[1]
            setViewControllers([firstViewController],
                               direction: .Reverse,
                               animated: true,
                               completion: nil)
    }
    
    
    func didFinishMashing(){
        let firstViewController = orderedViewControllers[2]
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
    //

    
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