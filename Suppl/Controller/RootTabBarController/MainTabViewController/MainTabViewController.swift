import Foundation
import UIKit

class MainTabViewController: UIViewController {
    
    private let mainTitle = "Главная"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = mainTitle
        navigationItem.title = mainTitle
        navigationController?.title = mainTitle
        //tabBarItem = UITabBarItem(title: mainTitle, image: nil, tag: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
                navigationController?.setToolbarHidden(false, animated: true)
        super.viewDidLoad()
    }
    
}
