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
            print(data)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

