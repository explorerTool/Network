//
//  TXJPCB.swift
//  TXJNetwork
//
//  Created by iOS_BFDL on 2018/12/27.
//  Copyright © 2018 AG. All rights reserved.
//

import Foundation

enum MethodType {
    case get
    case post
}

enum MultimediaType {
    
}

class TXJPCB: NSObject {
    //任务状态 0:创建 1:待处理 2:正在处理 3:处理完毕 4: 死亡 默认为0:创建
    var state: Int
    var taskIdentifier: Int?                    //任务标识
    var URL: String!                            //服务器地址
    var parameters: Dictionary<String, Any>?    //参数
    var methodType: MethodType                  //请求类型 默认get请求
    
    var responseData: ((Dictionary<String, Any>) -> Void)? //请求成功 响应数据
    
    override init() {
        methodType = .get
        counter = 1
        state = 0
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

class TXJUploadPCB : TXJPCB {
    
}

