//
//  URLLoader.swift
//  xianzhan
//
//  Created by crl on 2018/11/7.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class CRLURLLoader: CRLEventDispatcher,URLSessionDelegate {
    let url:String!;
    var request:URLRequest!;
    
    var data:Data?;
    
    init(_ url:String) {
        self.url=url;
    }
    
    func defaultEvent(_ handle: Selector, _ selfObj: AnyObject?,isBind:Bool=true){
        if isBind{
            self.on(CRLEvent.COMPLETE, handle,selfObj);
            self.on(CRLEvent.ERROR, handle,selfObj);
        }else{
            self.off(CRLEvent.COMPLETE, handle,selfObj);
            self.off(CRLEvent.ERROR, handle,selfObj);
        }
    }
    
    func post(_ value:String) {
        
        let data=value.data(using: .ascii, allowLossyConversion: true);
        let postLength=String(format:"%lu",(data?.count)!);
        
        request=URLRequest(url:URL(string: url)!);
        request.httpMethod="POST";
        request.setValue(postLength, forHTTPHeaderField: "Content-Length");
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type");
        
        request.httpBody=data;
        
        start(request);
    }
    
    
    func load() {
        request=URLRequest(url:URL(string: url)!);
        start(request);
    }
    
    var session:URLSession!;
    
    private func start(_ request:URLRequest){
        //let session=URLSession.shared;
        
        if session == nil{
            let configer = URLSessionConfiguration.default;
            session = Foundation.URLSession(configuration: configer, delegate: self, delegateQueue: OperationQueue.main);
        }
        
        let task=session.dataTask(with: request) { (data, response, error) in
            if(error != nil){
                self.data=Data(base64Encoded: error.debugDescription);
                self.simpleDispatch(CRLEvent.ERROR, error.debugDescription);
                return;
            }
            
            self.data=data;
            
            self.simpleDispatch(CRLEvent.COMPLETE, self.data);
        }
        
        self.simpleDispatch(CRLEvent.START);
        task.resume();
    }
    
    
    func getDataString()->String {
        if(data == nil){
            return "";
        }
        return String(data: data!, encoding: .utf8)!;
    }
    
    //URLSessionDelegate
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void){
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return completionHandler(.useCredential, nil);
        }
        let exceptions = SecTrustCopyExceptions(serverTrust);
        SecTrustSetExceptions(serverTrust, exceptions);
        completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
}
