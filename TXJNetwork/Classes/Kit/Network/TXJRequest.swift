//
//  TXJPCB.swift
//  TXJNetwork
//
//  Created by iOS_BFDL on 2018/12/27.
//  Copyright © 2018 AG. All rights reserved.
//

import Foundation

/**
 * 需求类型
 */
enum MethodType {
    case get
    case post
}


enum MultimediaType {
    
}

class TXJRequest: NSObject {
    //任务状态 0:创建 1:待处理 2:正在处理 3:处理完毕 4: 死亡 默认为0:创建
    var state: Int
    var taskIdentifier: Int?                    //任务标识
    var URL: String!                            //服务器地址
    var parameters: Dictionary<String, Any>?    //参数
    var methodType: MethodType                  //请求类型 默认get请求
    
    var responseDict: ((Dictionary<String, Any>) -> Void)? //请求成功 响应数据
    
    convenience override init() {
        
        self.init(methodType: .get, url: "www.txj.com", parameters: nil)
   
    }
    
    convenience init(methodType: MethodType, url: String) {
        self.init(methodType: methodType, url: url, parameters: nil)
    }
    
    init(methodType: MethodType, url: String, parameters: Dictionary<String, Any>?) {
        self.URL = url
        self.methodType = methodType
        self.parameters = parameters
        self.counter = 1
        self.state = 0
    }
    
    //初始化1 记录相同的URL被加载了几次
    var counter: Int {
        didSet {
            if counter > 3 {
                state = 4 //如果当前处理对象已经执行超过3次，则认定死亡，不在做处理
            }
        }
    }
    
}

/**
 * 继承TXJRequest
 * 作为上传需求对象
 */
class TXJUploadRequest : TXJRequest {
    
}

/**
 * 实现保存Request的数据结构
 */
class TXJReqQueue: NSObject {
    
    //队列能够保存元素的上限 默认7
    var capacitySize: Int
    
    //MARK: - Init
    override init() {
        capacitySize = 7
    }
    
    //MARK: - public
    /**
     * 添加元素到队列
     */
    func push(req: TXJRequest) {
        pushReq(req: req)
    }
    
    /**
     * 返回队列第一个位置的元素
     * 可能返回空
     */
    func pop() -> TXJRequest? {
        return popReq()
    }
    
    /**
     * 删除元素
     */
    func remove(at postion: Int) {
        removeReq(at: postion)
    }
    
    /**
     * 删除所有元素
     */
    func removeAll() {
        removeAllReq()
    }
    
    /**
     * 返回队列中所有的元素
     */
    func get() -> Array<TXJRequest> {
        return getReq()
    }
    
    /**
     * 获取指定位置的元素
     */
    func get(at postion: Int) -> TXJRequest? {
        return getReq(at: postion)
    }
    
    /**
     * 查找元素的位置 根据URL判断
     * pcb 网络操作处理控制块
     */
    func find(_ rule: (_ req: TXJRequest)-> Bool) -> Int {
        
        var i: Int = -1 // -1表示未找到
        
        var cursor: Int = 0
        for itemReq in queue {
            
            if rule(itemReq) {
                i = cursor
            }
            cursor += 1
        }
        
        return i
    }
    
    
    
    
    //MARK: - private
    //创建数组 保存信息
    private lazy var queue: Array<TXJRequest> = {
        let _queue = Array<TXJRequest>()
        return _queue
    }()
    
    /**
     * 添加元素到队列中
     * pcb: 待添加的元素
     */
    private func pushReq(req: TXJRequest) {
        
        /**
         * 判断队列是否满
         */
        if isFull() {
            
            removeReq(at: 0)
            queue.append(req)
            
            
        } else {
            queue.append(req)
        }
        
    }
    
    
    /**
     * 返回队列第一个元素
     * 可能为空
     */
    private func popReq() -> TXJRequest? {
        
        let req = queue.first
        removeReq(at: 0)
        return req
        
    }
    
    /**
     * 获取队列所有的元素
     */
    private func getReq() -> Array<TXJRequest> {
        return queue
    }
    
    /**
     * 获取指定位置的元素
     */
    private func getReq(at postion: Int) -> TXJRequest? {
        var element: TXJRequest?
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
    private func removeReq(at postion: Int) {
        
        if !isEmpty() && isFull() {
            
            if postion > -1 && postion < queue.count {
                queue.remove(at: postion)
            }
        }
        
    }
    
    /**
     * 删除所有的元素
     */
    private func removeAllReq() {
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


