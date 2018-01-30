import Foundation
import UIKit

class SettingsViewController: UIViewController, ControllerInfoProtocol {
    
    let name: String = "Настройки"
    let image: UIImage = UIImage(named: "gear-7.png") ?? UIImage()
    
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
        
        APISingleton.instance.userGet(ikey: 111, akey: 111) { error, data in
            print("+ --------------")
            print("userGet")
            print("ERROR: \(error)")
            print("DATA: \(data)")
            print("--------------")
        }
        /*api.userRegister() { error, data in
         print("--------------")
         print("userRegister")
         print("ERROR: \(error)")
         print("DATA: \(data)")
         print("--------------")
         }
         api.userUpdateEmail(ikey: 111, akey: 111, email: "bns.6587@gmail.com") { error, data in
         print("+ --------------")
         print("userUpdateEmail")
         print("ERROR: \(error)")
         print("DATA: \(data)")
         print("--------------")
         }
         api.userSendResetKey(email: "bns.6587@gmail.com") { error, data in
         print("+ --------------")
         print("userSendResetKey")
         print("ERROR: \(error)")
         print("DATA: \(data)")
         print("--------------")
         }
         api.userReset(resetKey: "11213") { error, data in
         print("--------------")
         print("userReset")
         print("ERROR: \(error)")
         print("DATA: \(data)")
         print("--------------")
         }
         api.audioSearch(ikey: 111, akey: 111, query: "Dragons") { error, data in
         print("+ --------------")
         print("audioSearch")
         print("ERROR: \(error)")
         print("DATA: \(data)")
         print("--------------")
         }
         api.tracklistGet(ikey: 111, akey: 111) { error, data in
         print("+ --------------")
         print("tracklistGet")
         print("ERROR: \(error)")
         print("DATA: \(data)")
         print("--------------")
         }*/
    }
    
    @IBAction func buttonClick(_ sender: Any) {
        navigationController?.pushViewController(MainViewController(), animated: true)
    }
}
