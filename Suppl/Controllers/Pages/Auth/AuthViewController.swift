import Foundation
import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    private let errorTitle = "Ошибка: "
    private let okTitle = "Добро пожаловать!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "Загрузка..."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAuth()
        
        
        
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
    
    private func endAuth() {
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) { [unowned self] in
            self.present(RootTabBarController(), animated: true)
        }
        AuthManager.startAuthCheck()
    }
    
    private func auth(ikey: Int, akey: Int) {
        statusLabel.text = "Авторизация..."
        APIManager.userGet(ikey: ikey, akey: akey) { [unowned self] error, data in
            guard let error = error else {
                guard let _ = data else { return }
                self.statusLabel.text = self.okTitle
                self.endAuth()
                return
            }
            if error.domain == "account_user_not_found" {
                UserDefaultsManager.identifierKey = nil
                UserDefaultsManager.accessKey = nil
                self.register()
                return
            }
            self.statusLabel.text = self.errorTitle + error.domain
        }
    }
    
    private func register() {
        statusLabel.text = "Регистрация..."
        APIManager.userRegister() { [unowned self] error, data in
            if let error = error {
                self.statusLabel.text = self.errorTitle + error.domain
                return
            }
            guard let data = data else { return }
            UserDefaultsManager.identifierKey = data.identifierKey
            UserDefaultsManager.accessKey = data.accessKey
            self.statusLabel.text = self.okTitle
            self.endAuth()
        }
    }
    
    private func startAuth() {
        statusLabel.text = "Получение информации..."
        if let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey {
            auth(ikey: ikey, akey: akey)
            return
        }
        register()
    }
}
