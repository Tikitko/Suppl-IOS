import Foundation
import UIKit

class SettingsTabViewController: UIViewController {
    
    private let settingsTitle = "Настройки"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = settingsTitle
        //tabBarItem = UITabBarItem(title: settingsTitle, image: nil, tag: 2)
        //tabBarController?.navigationItem.title = settingsTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        //navigationController?.pushViewController(MainTabViewController(), animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
    
}
