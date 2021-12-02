// TabViewController

import UIKit
class TabViewController : UITabBarController, UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let id = viewController.restorationIdentifier ?? ""
        print("tab bar clicked for: ", id)
        if id == "CreateNavViewController" {
            print("Create tab clicked")
        }
    }

}

