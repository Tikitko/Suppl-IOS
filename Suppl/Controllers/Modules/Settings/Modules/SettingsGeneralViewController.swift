import Foundation
import UIKit

class SettingsGeneralViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.title = "Основное"
    }
}

