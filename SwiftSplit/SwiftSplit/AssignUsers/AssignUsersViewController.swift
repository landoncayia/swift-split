//
//  AssignUsersViewController.swift
//  SwiftSplit
//
//  Created by Austin Block on 12/1/21.
//

import UIKit

class AssignUsersViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    // UIViewController <==> AssignPageViewController
    var views: [UIViewController] = []
    
    var pageControl: UIPageControl? {
        for view in view.subviews {
            if view is UIPageControl {
                return view as? UIPageControl
            }
        }
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.view.backgroundColor = UIColor.white
        
        let assignVC = self.storyboard?.instantiateViewController(withIdentifier: "assignPageVC") as! AssignPageViewController
        views.append(assignVC)
        
        let assignVC2 = self.storyboard?.instantiateViewController(withIdentifier: "assignPageVC") as! AssignPageViewController
        views.append(assignVC2)
        
        print("viewDidLoad")
        
        if let firstViewController = views.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            print("setViewControllers")
        }
    }
    
    override func viewDidLayoutSubviews() {
        if let pc = pageControl {
            pc.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            pc.pageIndicatorTintColor = UIColor.lightGray
            pc.currentPageIndicatorTintColor = UIColor(named: "AccentColor")
        }
    }
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //        dataSource = self;
    //        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    //    }
    //
    //    func getViewControllerAtIndex(index: Int) -> AssignPageViewController
    //    {
    //        // Create a new view controller and pass suitable data.
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "assignPageVC") as! AssignPageViewController
    //        return vc
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        // create a view for each person
        
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
