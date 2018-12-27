//
//  TXJPCBQueue.swift
//  TXJNetwork
//
//  Created by iOS_BFDL on 2018/12/27.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

class TXJPCBQueue: NSObject {

    private lazy var queue: Array<TXJPCB> = {
        let _queue = Array<TXJPCB>()
        return _queue
    }()
    
    //MARK: - public
    func addPCB(pcb: TXJPCB) {
        
        // 判断pcb是否存在队列中,若存在pcb counter+1
        if let elementPCB = findPCB(pcb: pcb) {
            
            elementPCB.counter += 1
            
        } else {
            queue.append(pcb)
        }
    }
    
    func findPCB(pcb: TXJPCB) -> TXJPCB? {
        
        var elementPCB: TXJPCB?
        for itemPCB in queue {
            if itemPCB.URL == pcb.URL {
                elementPCB = itemPCB
            }
        }
        
        return elementPCB
    }
    
    func removePCB(at: Int) {
        queue.remove(at: at)
    }
    
}
