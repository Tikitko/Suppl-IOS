import Foundation
import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
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
    }
    
    private func auth(ikey: Int, akey: Int) {
        statusLabel.text = "Авторизация..."
        DataSingleton.API.userGet(ikey: ikey, akey: akey) { [unowned self] error, data in
            if let error = error {
                if error.domain == "account_user_not_found" {
                    DataSingleton.identifierKey = nil
                    DataSingleton.accessKey = nil
                }
                self.statusLabel.text = self.errorTitle + error.domain
                self.activity.stopAnimating()
                return
            }
            guard let _ = data else { return }
            self.statusLabel.text = self.okTitle
            self.activity.stopAnimating()
            self.endAuth()
        }
    }
    
    private func reg() {
        statusLabel.text = "Регистрация..."
        DataSingleton.API.userRegister() { error, data in
            if let error = error {
                self.statusLabel.text = self.errorTitle + error.domain
                self.activity.stopAnimating()
                return
            }
            guard let data = data else { return }
            DataSingleton.identifierKey = data.identifierKey
            DataSingleton.accessKey = data.accessKey
            self.statusLabel.text = self.okTitle
            self.activity.stopAnimating()
            self.endAuth()
        }
    }
    
    private func startAuth() {
        statusLabel.text = "Получение информации..."
        activity.startAnimating()
        let ikey = DataSingleton.identifierKey
        let akey = DataSingleton.accessKey
        if let ikey = ikey, let akey = akey {
            auth(ikey: ikey, akey: akey)
        } else {
            reg()
        }
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
