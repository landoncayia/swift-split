//
//  AssignUsersViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 12/1/21.
//

import UIKit

class AssignUsersViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    // The subviews of this page view controller
    // UIViewController <==> AssignPageViewController
    var views: [UIViewController] = []
    
    // The page control
    var pageControl: UIPageControl? {
        for view in view.subviews {
            if view is UIPageControl {
                return view as? UIPageControl
            }
        }
        return nil
    }
    
    // The receipt
    var receipt: Receipt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.view.backgroundColor = UIColor.systemBackground
        
        // Setup a view for each person
        for idx in 0...receipt.persons.count-1 {
            print("Creating a subview for", receipt.persons[idx].name)
            
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "assignPageVC") as! AssignPageViewController
            newView.receipt = receipt
            newView.idx = idx
            views.append(newView)
        }
        
        // Prepare the first view
        if let firstViewController = views.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            print("setViewControllers")
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Customize the page control (dots for what page user is on)
        if let pc = pageControl {
            pc.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            pc.pageIndicatorTintColor = UIColor.lightGray
            pc.currentPageIndicatorTintColor = UIColor(named: "AccentColor")
        }
    }
    
}

extension AssignUsersViewController: UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = views.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return views.last
        }
        
        guard views.count > previousIndex else {
            return nil
        }
        
        return views[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = views.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard views.count != nextIndex else {
            return views.first
        }
        
        guard views.count > nextIndex else {
            return nil
        }
        
        return views[nextIndex]
    }
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return views.count
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = views.firstIndex(of: firstViewController) else {
                  return 0
              }
        
        return firstViewControllerIndex
    }
    
    func viewController(at index: Int) -> UIViewController {
        return views[index]
    }
    
}
