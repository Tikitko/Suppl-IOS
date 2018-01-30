import Foundation
import UIKit

class RootTabBarController: UITabBarController {
    
    convenience init(controllers: [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        viewControllers = controllers
    }
    
    override func tab
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = APIManager()
        api.userGet(ikey: 111, akey: 111) { error, data in
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
}
