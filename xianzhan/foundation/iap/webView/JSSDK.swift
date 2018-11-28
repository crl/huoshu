//
//  JSSDK.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit;
import WebKit;

class CMD{
    static let Init="0"
    static let Login="1";
    static let Pay="2";
    static let Check="-1";
}


protocol ISDKRouter {
    func receipt(_ c:String,_ d:Any)->Void;
}

class JSSDK: EventDispatcher {
    
    private var webView:WKWebView!;
    
    var router:ISDKRouter?;
    
    static var ins:JSSDK?=nil;
    static func Get()->JSSDK{
        if(ins==nil){
            ins=JSSDK();
        }
        return ins!;
    }
    
    func initWebView(_ webView:WKWebView) -> Void {
        self.webView=webView;
    }
    
    func send(_ c:String,_ d:Any) {
        if(webView == nil){
            print("sdk webView not init!");
            return;
        }
        
        var t:[String:Any]=[:];
        t["c"]=c;
        t["d"]=d;
        
        let command=JSONUtil.Encode(t);
        
        let cmd="PlatformSDK.Receive('\(command)')";
        
        webView.evaluateJavaScript(cmd){
            (data, error) in
            
            if let d=data{
                print("js:",d);
            }
            if let e=error{
                print("jserror:",e)
            }
        }
    }
    
    func receipt(_ c:String,_ d:Any){
        print("byJS:",c,d);
        
        if let r=router{
            r.receipt(c, d);
        }
        
        self.simpleDispatch(c, d);
    }
    
}
