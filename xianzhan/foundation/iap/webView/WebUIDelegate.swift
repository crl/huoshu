//
//  WebUIDelegate.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import WebKit

class WebUIDelegate: EventDispatcher,WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate {
    
    private var webView:WKWebView!;
    let view:UIViewController;
    let sdk:JSSDK;
    
    public init(view:UIViewController) {
        self.view=view;
        self.sdk=JSSDK.Get();
    }
    
    public func bind(_ webView:WKWebView){
        self.webView=webView;
        
        webView.navigationDelegate=self;
        webView.uiDelegate=self;
        let userContent=webView.configuration.userContentController;
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        userContent.add(self, name: "ios");
        
        let path=Bundle.main.path(forResource: "inject", ofType: "js");
        if let t=path {
            let jsCode=FileUtil.ReadString(t);
            
            if !jsCode.isEmpty{
                let script=WKUserScript(source: jsCode, injectionTime: .atDocumentEnd, forMainFrameOnly: true);
                userContent.addUserScript(script);
            }
        }
    }
    
    
    //WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        //Utils.ShowImage("bg.png");
        Utils.Loading(true);
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        //Utils.ShowImage("bg.png",false);
        Utils.Loading(false);
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if(navigationResponse.response .isKind(of: HTTPURLResponse.self)){
            let response = navigationResponse.response as! HTTPURLResponse
            if(response.statusCode == 401){
                print("error")
            }
        }
        decisionHandler(WKNavigationResponsePolicy.allow);
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        print(error);
    }
    
    private var errorImage:UIImage?;
    private var imageView:UIImageView!;
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        if errorImage == nil{
            let path=Bundle.main.path(forResource: "404.jpg", ofType: nil);
            errorImage=UIImage(contentsOfFile: path!);
            
            imageView=UIImageView(image: errorImage!);
            imageView.frame=webView.frame;
            imageView.contentMode = .scaleAspectFit;
            
            imageView.isUserInteractionEnabled=true;
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(refreshHandle));
            imageView.addGestureRecognizer(gestureRecognizer);
        }
        
        //Utils.ShowImage("bg.png",false);
        Utils.Loading(false);
        webView.addSubview(imageView);
        
        print("WKWebView",error);
    }
    
    @objc func refreshHandle(e:UITapGestureRecognizer) {
        
        if let i=imageView{
            i.removeFromSuperview();
        }
        
        simpleDispatch(EventX.RELOAD);
    }
    
    
    
    //WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
        let command:String=message.body as! String;
        let cmd=JSONUtil.Decode(command);
        if cmd.count == 0 {
            return;
        }
        
        let c=String(describing: cmd["c"] ?? "");
        let d=String(describing: cmd["d"] ?? "");
        
        sdk.receipt(c,d);
    }
    
    //WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        
        let alert=UIAlertController.init(title: "", message: message, preferredStyle: .alert);
        let action=UIAlertAction.init(title: "ok", style: .cancel) { (action) in
            completionHandler();
        }
        alert.addAction(action);
        view.present(alert, animated: true, completion: nil);
    }
}
