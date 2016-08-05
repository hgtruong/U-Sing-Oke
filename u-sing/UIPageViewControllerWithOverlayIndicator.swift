//
//  PageViewControllerWithIndicators.swift
//  u-sing
//
//  Created by Huy Truong on 8/5/16.
//  Copyright © 2016 Huy Truong. All rights reserved.
//

import UIKit

class UIPageViewControllerWithOverlayIndicator: UIPageViewController {
    
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubviewToFront(subView)
            }
        }
        super.viewDidLayoutSubviews()
    }
    
}
