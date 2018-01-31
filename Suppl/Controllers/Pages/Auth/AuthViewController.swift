import Foundation
import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    private var timer: Timer?
    
    private let errorTitle = "Ошибка: "
    private let okTitle = "Успешно!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "Загрузка..."
    }
    
    private func endAuth() {
        print(DataSingleton.identifierKey)
        print(DataSingleton.accessKey)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) { [unowned self] in
            self.present(RootTabBarController(), animated: true)
        }
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: authCheck)
    }
    
    func authCheck(timerIn: Timer) -> Void {
        guard let ikey = DataSingleton.identifierKey, let akey = DataSingleton.accessKey else { return }
        DataSingleton.API.userGet(ikey: ikey, akey: akey) { [unowned self] error, data in
            guard let error = error else { return }
            defer { self.timer = nil }
            self.timer?.invalidate()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = AuthViewController()
        }
    }
    
    private func auth(ikey: Int, akey: Int) {
        statusLabel.text = "Авторизация..."
        DataSingleton.API.userGet(ikey: ikey, akey: akey) { [unowned self] error, data in
            guard let error = error else {
                guard let _ = data else { return }
                self.statusLabel.text = self.okTitle
                self.endAuth()
                return
            }
            if error.domain == "account_user_not_found" {
                DataSingleton.identifierKey = nil
                DataSingleton.accessKey = nil
                self.register()
                return
            }
            print(self.statusLabel.text)
            self.statusLabel.text = self.errorTitle + error.domain
            print(self.statusLabel.text)
        }
    }
    
    private func register() {
        statusLabel.text = "Регистрация..."
        DataSingleton.API.userRegister() { [unowned self] error, data in
            if let error = error {
                self.statusLabel.text = self.errorTitle + error.domain
                return
            }
            guard let data = data else { return }
            DataSingleton.identifierKey = data.identifierKey
            DataSingleton.accessKey = data.accessKey
            self.statusLabel.text = self.okTitle
            self.endAuth()
        }
    }
    
    private func startAuth() {
        statusLabel.text = "Получение информации..."
        let ikey = DataSingleton.identifierKey
        let akey = DataSingleton.accessKey
        if let ikey = ikey, let akey = akey {
            auth(ikey: ikey, akey: akey)
            return
        }
        register()
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
}
