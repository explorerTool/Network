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
        
        
        
        
        let queue = TXJPCBQueue()
        
        var pcb = TXJPCB()
        pcb.URL = "baidu"
        queue.push(pcb:pcb)
        
        
        pcb = TXJPCB()
        pcb.URL = "tenxun"
        queue.push(pcb:pcb)
        
        pcb = TXJPCB()
        pcb.URL = "baidu"
        queue.push(pcb:pcb)
        
        pcb = TXJPCB()
        pcb.URL = "tenxun"
        queue.push(pcb:pcb)
        
        
        for item in 1...100 {
            let pcb = TXJPCB()
            pcb.URL = "baidu\(item)"
            queue.push(pcb:pcb)
            
        }
        
        queue.pop()
        queue.pop()
        queue.pop()
        queue.pop()
        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
//        queue.pop()
        
        for item in queue.get() {
            print("\(item.URL!) \(item.counter)")
        }
        
    
    }


}

