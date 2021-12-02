// TabViewController

import UIKit
class TabViewController : UITabBarController, UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("tab bar clicked for: ", viewController)
        if viewController is CreateViewController {
            print("Create tab clicked")
        } else if viewController is BudgetViewController {
            print("Budget tab clicked")
        } else if viewController is SettingsViewController {
            print("Settings tab clicked")
        } else {
            print("Unknown tab clicked")
        }
    }

}

