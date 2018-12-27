//
//  TXJNetworkManager.swift
//  TXJNetwork
//
//  Created by iOS_BFDL on 2018/12/27.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

class TXJNetworkManager: NSObject {

    //MARK: - public methods
    func loadPCB(pcb: TXJPCB) {
        
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
    
    //MARK: - private methods
    /**
     * get方式请求
     */
    private func getLoadPCB(pcb: TXJPCB) {
    
    }
    
    /**
     * post方式请求
     */
    private func postLoadPCB(pcb: TXJPCB) {
        
    }
    
    /**
     * 上传图片 or 视频
     */
    private func uploadPCB(pcb: TXJUploadPCB) {
        
    }
    
    
}
