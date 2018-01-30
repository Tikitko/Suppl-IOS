import Foundation
import UIKit

class TracklistViewController: UIViewController, ControllerInfoProtocol {
    
    let name: String = "Плейлист"
    let image: UIImage = UIImage(named: "list-simple-star-7.png") ?? UIImage()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

