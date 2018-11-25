//
//  URLLoader.swift
//  xianzhan
//
//  Created by crl on 2018/11/7.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class URLLoader: EventDispatcher {
    let url:String!;
    var request:URLRequest!;
    
    var data:Data?;
    
    init(_ url:String) {
        self.url=url;
    }
    
    func defaultEvent(_ handle: Selector, _ selfObj: AnyObject?,isBind:Bool=true){
        if isBind{
            self.on(EventX.COMPLETE, handle,selfObj);
            self.on(EventX.ERROR, handle,selfObj);
        }else{
            self.off(EventX.COMPLETE, handle,selfObj);
            self.off(EventX.ERROR, handle,selfObj);
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
    
    
    private func start(_ request:URLRequest){
        let session=URLSession.shared;
        let task=session.dataTask(with: request) { (data, response, error) in
            if(error != nil){
                //todo
                self.data=Data(base64Encoded: error.debugDescription);
                
                self.simpleDispatch(EventX.ERROR, error.debugDescription);
                return;
            }
            
            self.data=data;
            
            self.simpleDispatch(EventX.COMPLETE, self.data);
        }
        
        self.simpleDispatch(EventX.START);
        task.resume();
    }
    
    
    func getDataString()->String {
        if(data == nil){
            return "";
        }
        return String(data: data!, encoding: .utf8)!;
    }
}
