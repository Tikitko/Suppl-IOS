import Foundation
import UIKit

class MainViewController: UIViewController, ControllerInfoProtocol {
    
    let name: String = "Музыка"
    let image: UIImage = UIImage(named: "music-7.png") ?? UIImage()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
