//
//  TXJPCBQueue.swift
//  TXJNetwork
//
//  Created by iOS_BFDL on 2018/12/27.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

class TXJPCBQueue: NSObject {

    //队列能够保存元素的上限 默认10
    var capacitySize: Int
    
    //MARK: - Init
    override init() {
        capacitySize = 10
    }
    
    //MARK: - public
    /**
     * 添加元素到队列
     */
    func push(pcb: TXJPCB) {
        pushPCB(pcb: pcb)
    }
    
    /**
     * 返回队列第一个位置的元素
     * 可能返回空
     */
    func pop() -> TXJPCB? {
        return popPCB()
    }
    
    /**
     * 删除元素
     */
    func remove(pcb: TXJPCB) {
        removePCB(pcb: pcb)
    }
    
    /**
     * 返回队列中所有的元素
     */
    func get() -> Array<TXJPCB> {
        return getPCB()
    }
    

    
    //MARK: - private
    //创建数组 保存信息
    private lazy var queue: Array<TXJPCB> = {
        let _queue = Array<TXJPCB>()
        return _queue
    }()
    
    /**
     * 添加元素到队列中
     * pcb: 待添加的元素
     */
    private func pushPCB(pcb: TXJPCB) {
        
        /**
         * 判断pcb是否存在队列中,若存在pcb counter+1
         */
        //获取待加入队列的索引 若获取为-1 则未加入
        let elementIndex = index(of: pcb)
        if elementIndex == -1 {
            
            /**
             * 判断队列是否满
             */
            if isFull() {
                
                queue.append(pcb)
                
            } else {
                removePCB(at: 0)
                queue.append(pcb)
            }
            
            
        } else {
            
            pcb.counter += queue[elementIndex].counter
            removePCB(at: elementIndex)
            queue.append(pcb)
            
        }
        
    }
    
    
    /**
     * 返回队列第一个元素
     * 可能为空
     */
    private func popPCB() -> TXJPCB? {
        
        let pcb = queue.first
        removePCB(at: 0)
        return pcb
        
    }
    
    /**
     * 获取队列所有的元素
     */
    private func getPCB() -> Array<TXJPCB> {
        return queue
    }

    /**
     * 从队列中删除元素
     * pcb: 待删除的控制块
     */
    private func removePCB(pcb: TXJPCB) {
        let elementIndex = index(of: pcb)
        removePCB(at: elementIndex)
    }
    
    /**
     * 据位置 删除队列中的元素
     * postion 索引
     */
    private func removePCB(at postion: Int) {
        
        if !isEmpty() && !isFull() {
            
            if postion > -1 && postion < queue.count {
                queue.remove(at: postion)
            }
        }
        
    }
    
    /**
     * 查找元素的位置 根据URL判断
     * pcb 网络操作处理控制块
     */
    private func index(of pcb: TXJPCB) -> Int {
        
        var i: Int = -1 // -1表示未找到
        
        var cursor: Int = 0
        for itemPCB in queue {
            
            if itemPCB.URL == pcb.URL {
                i = cursor
            }
            cursor += 1
        }
        
        return i
    }
    
    
    /**
     * 返回队列是否满
     * true 表示满
     */
    private func isFull() -> Bool {
        return (queue.count > capacitySize)
    }
    
    
    /**
     * 返回是否为空队列
     * true 表示空
     */
    private func isEmpty() -> Bool {
        return (queue.count <= 0)
    }
}
