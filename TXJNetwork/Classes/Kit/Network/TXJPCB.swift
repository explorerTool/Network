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

    var state: Int?                             //任务状态 0:待处理 1:正在处理 2:处理完毕 3: 死亡
    var taskIdentifier: Int?                    //任务标识
    var URL: String!                            //服务器地址
    var parameters: Dictionary<String, Any>?    //参数
    var methodType: MethodType                  //请求类型 默认get请求
    
    var responseBlock: ((Dictionary<String, Any>) -> Void)? //请求成功 响应数据
    
    override init() {
        methodType = .get
        counter = 1
    }
    
    var counter: Int                            //初始化1 记录相同的URL被加载了几次
    
}

class TXJUploadPCB : TXJPCB {
    
}
