import Foundation
import UIKit

class MainViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Музыка"
    public let imageName = "music-7.png"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
