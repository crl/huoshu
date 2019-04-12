//
//  BaseWebViewController.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import WebKit;

class BaseWebViewController: UIViewController {
    var webView:WKWebView!;
    var sdk:RFJSSDK!;
    override func viewDidLoad() {
        super.viewDidLoad()
        // 创建配置
        let config = WKWebViewConfiguration();
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        let userContent = WKUserContentController();
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent;
        
        // 高端的自定义配置创建WKWebView
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: config);
        webView.backgroundColor=UIColor.black;
        
        let uiDelegate=WebUIDelegate(view: self);
        uiDelegate.on(Event.RELOAD, #selector(doReload), self);
        uiDelegate.bind(webView);
        
        sdk=RFJSSDK.Get();
        sdk.initWebView(webView);
        
        sdk.on(CMD.Init,#selector(doInit),self);
        sdk.on(CMD.Login,#selector(doLogin),self);
        sdk.on(CMD.Pay,#selector(doPay),self);
        sdk.on(CMD.Check,#selector(doPay),self);
        
        // 将WebView添加到当前view
        view.addSubview(webView);
    }
    
    @objc func doInit(e:Event){
        sdk.send(e.type,rootQuerys);
    }
    @objc func doLogin(e:Event){
        
    }
    @objc func doPay(e:Event){
        
    }
    
    
    @objc func doReload(e:Event) {
        // 设置访问的URL
        load(uri: rootURI,querys: rootQuerys);
    }
    
    private func load(uri:String,querys:String=""){
        // 设置访问的URL
        
        let url = URL(string: uri+querys);
        // 根据URL创建请求
        let request = URLRequest(url: url!);
        
        webView.load(request);
        
        print("loadURL:",uri,querys);
    }
    
    
    private var rootURI:String!;
    private var rootQuerys:String!;
    func loadWeb(_ uri:String,_ querys:String=""){
        self.rootURI=uri;
        self.rootQuerys=querys;
        
        load(uri: uri,querys:querys);
    }
}
