//
//  TXJNetworkManager.swift
//  TXJNetwork
//
//  Created by iOS_BFDL on 2018/12/27.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit
import Alamofire

/**
 * 登录失效规则 由用户确定
 * 其他失效规则 由用户确定
 * 网络失效规则 由网络框架确定
 */
protocol TXJNetworkManagerDelegate : NSObjectProtocol {
    func ruleLoginFailure(response: Dictionary<String, Any>) -> Bool
    func ruleFailure(response: Dictionary<String, Any>) -> Bool
}

extension TXJNetworkManagerDelegate {
    func ruleLoginFailure(response: Dictionary<String, Any>) -> Bool {
        return false
    }
    
    func ruleFailure(response: Dictionary<String, Any>) -> Bool {
        return false
    }
}

class TXJNetworkManager: NSObject {

    private static let single = TXJNetworkManager()
    class var sharedInstance: TXJNetworkManager {        
        get {
           return single
        }

    }
    
    var delegate: TXJNetworkManagerDelegate?
    
    //MARK: - public methods
    /**
     *  加载处理块
     */
    func load(pcb: TXJPCB) {
        
        // 待处理
        pcb.state = 1 //预留一个状态
        
        /**
         * 判断是否是上传
         * 若不是上传，判断请求类型
         */
        if pcb.isKind(of: TXJUploadPCB.self) {
            
            uploadPCB(pcb: pcb as! TXJUploadPCB)
            
        } else {
            
            switch pcb.methodType {
            case .get:
                getLoadPCB(pcb: pcb)
                
            case .post:
                postLoadPCB(pcb: pcb)
            }
            
        }
        
    }
    
    /**
     * 调用此系列方法，方法内部会检查操作对象集合，该集合里面的元素是按照某种规则加入的。一般不需要用户手动调用.考虑到极端情况下，需要调用此方法，所以暴漏出来。
     */
    func onceAgainFailureLoad() {
        
        for itemPCB in failureQueue.get() {
            load(pcb: itemPCB)
        }
        failureQueue.removeAll()
        
    }
    
    func onceAgainLoginFailureLoad() {
        
        for itemPCB in loginFailureQueue.get() {
            load(pcb: itemPCB)
        }
        loginFailureQueue.removeAll()
        
    }
    
    func onceAgainNetworkFailureLoad() {
        for itemPCB in networkFailureQueue.get() {
            load(pcb: itemPCB)
        }
        networkFailureQueue.removeAll()
    }
    
    //MARK: - private methods
    /**
     * get方式请求
     */
    private func getLoadPCB(pcb: TXJPCB) {
        /**
         * 1. 调用网络请求类
         * 2. 成功
         * 3. 失败 根据失败原因分别调用不同的失效方法 添加到队列中
         */
        
        // 正在处理
        pcb.state = 2
        Alamofire.request(pcb.URL).response { (response) in
            print(response)
            pcb.responseData?(["String":"string"])
            
        }
    
    }
    
    /**
     * post方式请求
     */
    private func postLoadPCB(pcb: TXJPCB) {
        // 正在处理
        pcb.state = 2
        
        /**
         * 1. 调用网络请求类
         * 2. 成功
         * 3. 失败 根据失败原因分别调用不同的失效方法 添加到队列中
         */
    }
    
    /**
     * 上传图片 or 视频
     */
    private func uploadPCB(pcb: TXJUploadPCB) {
        // 正在处理
        pcb.state = 2
        
        /**
         * 1. 调用网络请求类
         * 2. 成功
         * 3. 失败 根据失败原因分别调用不同的失效方法 添加到队列中
         */
    }
    
    /**
     * 添加因为登录失效也就是没有权限到队列中 做二次请求用
     */
    private func addLoginFailureQueue(pcb: TXJPCB) {
        
        cumulativeCounter(pcb: pcb, queue: loginFailureQueue)
        
        /**
         * 状态为待处理的才能加入队列中
         */
        if pcb.counter == 1 {
            loginFailureQueue.push(pcb: pcb)
        }
        
        
    }
    
    /**
     * 添加因其他原因请求失效到队列中 做二次请求使用
     */
    private func addFailureQueue(pcb: TXJPCB) {
        cumulativeCounter(pcb: pcb, queue: failureQueue)
        /**
         * 状态为待处理的才能加入队列中
         */
        if pcb.counter == 1 {
            failureQueue.push(pcb: pcb)
        }
    }
    
    /**
     * 添加因网络原因请求失效的对象到队列中 做二次请求使用
     */
    private func addNetworkFailureQueue(pcb: TXJPCB) {
        cumulativeCounter(pcb: pcb, queue: networkFailureQueue)
        /**
         * 状态为待处理的才能加入队列中
         */
        if pcb.counter == 1 {
            networkFailureQueue.push(pcb: pcb)
        }
    }
    
    private func cumulativeCounter(pcb: TXJPCB, queue: TXJPCBQueue<TXJPCB>) {
        /**
         * 查找pcb是否包含在队列中
         */
        // 获取索引 若没有则返回-1
        let index = queue.find { (PCB) -> Bool in
            return PCB.URL == pcb.URL
        }
        
        //尝试获取PCB 若有则说明 待添加的pcb已在队列中，获取该pcb的counter 类加然后重新添加到队列末尾
        if let PCB = queue.get(at: index) {
            pcb.counter += PCB.counter
            queue.remove(at: index)
        }
    }
    
    
    //MARK: private
    // 登录失效
    private lazy var loginFailureQueue: TXJPCBQueue<TXJPCB> = {
        
        let _loginFailureQueue = TXJPCBQueue<TXJPCB>()
        return _loginFailureQueue
        
    }()
    
    // 其他原因失效
    private lazy var failureQueue: TXJPCBQueue<TXJPCB> = {
        
        let _failureQueue = TXJPCBQueue<TXJPCB>()
        return _failureQueue
        
    }()
    
    // 网络原因失效
    private lazy var networkFailureQueue: TXJPCBQueue<TXJPCB> = {
        
        let _networkFailureQueue = TXJPCBQueue<TXJPCB>()
        return _networkFailureQueue
        
    }()
    
}
