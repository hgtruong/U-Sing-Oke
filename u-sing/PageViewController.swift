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
    
    //hard coding to create two tabs pages
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        let navi = self.newColoredViewController("songListNavigation") as! UINavigationController
        let mixed = self.newColoredViewController("mixedSongListNavigation") as! UINavigationController
        return [self.newColoredViewController("Player"), navi, mixed]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PageViewController.didClickOnASong), name: "didClickOnASong", object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func didClickOnASong(){
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Reverse,
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