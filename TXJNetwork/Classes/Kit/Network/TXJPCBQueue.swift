//
//  TXJPCBQueue.swift
//  TXJNetwork
//
//  Created by iOS_BFDL on 2018/12/27.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

class TXJPCBQueue<Type>: NSObject {

    //队列能够保存元素的上限 默认10
    var capacitySize: Int
    
    //MARK: - Init
    override init() {
        capacitySize = 7
    }
    
    //MARK: - public
    /**
     * 添加元素到队列
     */
    func push(pcb: Type) {
        pushPCB(pcb: pcb)
    }
    
    /**
     * 返回队列第一个位置的元素
     * 可能返回空
     */
    func pop() -> Type? {
        return popPCB()
    }
    
    /**
     * 删除元素
     */
    func remove(at postion: Int) {
        removePCB(at: postion)
    }
    
    /**
     * 删除所有元素
     */
    func removeAll() {
        removeAllPCB()
    }
    
    /**
     * 返回队列中所有的元素
     */
    func get() -> Array<Type> {
        return getPCB()
    }
    
    /**
     * 获取指定位置的元素
     */
    func get(at postion: Int) -> Type? {
        return getPCB(at: postion)
    }
    
    /**
     * 查找元素的位置 根据URL判断
     * pcb 网络操作处理控制块
     */
    func find(_ rule: (_ pcb: Type)-> Bool) -> Int {
        
        var i: Int = -1 // -1表示未找到
        
        var cursor: Int = 0
        for itemPCB in queue {
            
            if rule(itemPCB) {
                i = cursor
            }
            cursor += 1
        }
        
        return i
    }
    
    

    
    //MARK: - private
    //创建数组 保存信息
    private lazy var queue: Array<Type> = {
        let _queue = Array<Type>()
        return _queue
    }()
    
    /**
     * 添加元素到队列中
     * pcb: 待添加的元素
     */
    private func pushPCB(pcb: Type) {
        
        /**
         * 判断队列是否满
         */
        if isFull() {
            
            removePCB(at: 0)
            queue.append(pcb)
            
            
        } else {
            queue.append(pcb)
        }

    }
    
    
    /**
     * 返回队列第一个元素
     * 可能为空
     */
    private func popPCB() -> Type? {
        
        let pcb = queue.first
        removePCB(at: 0)
        return pcb
        
    }
    
    /**
     * 获取队列所有的元素
     */
    private func getPCB() -> Array<Type> {
        return queue
    }
    
    /**
     * 获取指定位置的元素
     */
    private func getPCB(at postion: Int) -> Type? {
        var element: Type?
        if !isEmpty() {
            
            if postion > -1 && postion < queue.count {
                element = queue[postion]
            }
        }
        return element
    }

    /**
     * 据位置 删除队列中的元素
     * postion 索引
     */
    private func removePCB(at postion: Int) {
        
        if !isEmpty() && isFull() {
            
            if postion > -1 && postion < queue.count {
                queue.remove(at: postion)
            }
        }
        
    }
    
    /**
     * 删除所有的元素
     */
    private func removeAllPCB() {
        queue.removeAll()
    }
    
    /**
     * 返回队列是否满
     * true 表示满
     */
    private func isFull() -> Bool {
        return (queue.count >= capacitySize)
    }
    
    
    /**
     * 返回是否为空队列
     * true 表示空
     */
    private func isEmpty() -> Bool {
        return (queue.count <= 0)
    }
}
