//
//  ViewController.swift
//  Suppl
//
//  Created by Mikita Bykau on 1/26/18.
//  Copyright © 2018 Mikita Bykau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        api.userRegister() { error, data in
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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

