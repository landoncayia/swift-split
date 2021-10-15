// TabViewController

import UIKit
@MainActor class UITabBarController : UIViewController{
    
    
    // TODO: want to make it so that by default, browse auto loads (when viewDidLoad)
    
    //weak var delegate: UITabBarControllerDelegate? { get set }
    // add segues to the different storyboards
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //performSegue(withIdentifier: "BrowseSegue", //sender: self)
    }
    
}

