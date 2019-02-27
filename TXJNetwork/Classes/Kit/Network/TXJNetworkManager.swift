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
 * 根据URL处理块
 * 监听网络环境
 * 可插拔三方网络请求
 */

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
    func load(req: TXJRequest) {
        
        // 待处理
        req.state = 1 //预留一个状态
        
        /**
         * 判断是否是上传
         * 若不是上传，判断请求类型
         */
        if req.isKind(of: TXJUploadRequest.self) {
            
            uploadReq(req: req as! TXJUploadRequest)
            
        } else {
            
            switch req.methodType {
            case .get:
                loadReqGet(req: req)
                
            case .post:
                loadReqPost(req: req)
            }
            
        }
        
    }
    
    /**
     * 调用此系列方法，方法内部会检查操作对象集合，该集合里面的元素是按照某种规则加入的。一般不需要用户手动调用.考虑到极端情况下，需要调用此方法，所以暴漏出来。
     */
    func onceAgainFailureLoad() {
        
        for itemReq in failureQueue.get() {
            load(req: itemReq)
        }
        failureQueue.removeAll()
        
    }
    
    func onceAgainLoginFailureLoad() {
        
        for itemReq in loginFailureQueue.get() {
            load(req: itemReq)
        }
        loginFailureQueue.removeAll()
        
    }
    
    func onceAgainNetworkFailureLoad() {
        for itemReq in networkFailureQueue.get() {
            load(req: itemReq)
        }
        networkFailureQueue.removeAll()
    }
    
    //MARK: - private methods
    /**
     * get方式请求
     */
    private func loadReqGet(req: TXJRequest) {
        /**
         * 1. 调用网络请求类
         * 2. 成功
         * 3. 失败 根据失败原因分别调用不同的失效方法 添加到队列中
         */
        
        // 正在处理
        req.state = 2
        
        Alamofire.request(req.URL).response { (response) in
            print(response)
            req.responseDict?(["String":"string"])
            
        }
    
    }
    
    /**
     * post方式请求
     */
    private func loadReqPost(req: TXJRequest) {
        // 正在处理
        req.state = 2
        
        /**
         * 1. 调用网络请求类
         * 2. 成功
         * 3. 失败 根据失败原因分别调用不同的失效方法 添加到队列中
         */
    }
    
    /**
     * 上传图片 or 视频
     */
    private func uploadReq(req: TXJUploadRequest) {
        // 正在处理
        req.state = 2
        
        /**
         * 1. 调用网络请求类
         * 2. 成功
         * 3. 失败 根据失败原因分别调用不同的失效方法 添加到队列中
         */
    }
    
    /**
     * 添加因为登录失效也就是没有权限到队列中 做二次请求用
     */
    private func addLoginFailureQueue(req: TXJRequest) {
        
        cumulativeCounter(req: req, queue: loginFailureQueue)
        
        /**
         * 状态为待处理的才能加入队列中
         */
        if req.counter == 1 {
            loginFailureQueue.push(req: req)
        }
        
        
    }
    
    /**
     * 添加因其他原因请求失效到队列中 做二次请求使用
     */
    private func addFailureQueue(req: TXJRequest) {
        cumulativeCounter(req: req, queue: failureQueue)
        /**
         * 状态为待处理的才能加入队列中
         */
        if req.counter == 1 {
            failureQueue.push(req: req)
        }
    }
    
    /**
     * 添加因网络原因请求失效的对象到队列中 做二次请求使用
     */
    private func addNetworkFailureQueue(req: TXJRequest) {
        cumulativeCounter(req: req, queue: networkFailureQueue)
        /**
         * 状态为待处理的才能加入队列中
         */
        if req.counter == 1 {
            networkFailureQueue.push(req: req)
        }
    }
    
    private func cumulativeCounter(req: TXJRequest, queue: TXJReqQueue) {
        /**
         * 查找pcb是否包含在队列中
         */
        // 获取索引 若没有则返回-1
        let index = queue.find { (REQ) -> Bool in
            return REQ.URL == req.URL
        }
        
        //尝试获取PCB 若有则说明 待添加的pcb已在队列中，获取该pcb的counter 类加然后重新添加到队列末尾
        if let REQ = queue.get(at: index) {
            req.counter += REQ.counter
            queue.remove(at: index)
        }
    }
    
    
    //MARK: private
    // 登录失效
    private lazy var loginFailureQueue: TXJReqQueue = {
        
        let _loginFailureQueue = TXJReqQueue()
        return _loginFailureQueue
        
    }()
    
    // 其他原因失效
    private lazy var failureQueue: TXJReqQueue = {
        
        let _failureQueue = TXJReqQueue()
        return _failureQueue
        
    }()
    
    // 网络原因失效
    private lazy var networkFailureQueue: TXJReqQueue = {
        
        let _networkFailureQueue = TXJReqQueue()
        return _networkFailureQueue
        
    }()
    
}
