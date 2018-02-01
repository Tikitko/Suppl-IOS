import Foundation
import UIKit

class SettingsViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Настройки"
    public let imageName = "gear-7.png"
    
    @IBOutlet weak var button: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        navigationController?.pushViewController(MainViewController(), animated: true)
    }
}
