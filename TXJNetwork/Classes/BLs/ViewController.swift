//
//  ViewController.swift
//  TXJNetwork
//
//  Created by iOS_BFDL on 2018/12/27.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        
        let req = TXJRequest(methodType: .get, url: "http://10.10.1.32:17100/front-api/goods/phone/template/appHomeList", parameters: nil)
        TXJNetworkManager.sharedInstance.load(req: req)
        
        req.responseDict = {(response) in
         
            print(response)
        }

  
    
    }


}

