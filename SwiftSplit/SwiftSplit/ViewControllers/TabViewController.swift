// TabViewController

import UIKit
class TabViewController : UITabBarController, UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
}

