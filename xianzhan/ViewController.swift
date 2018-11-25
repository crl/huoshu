//
//  ViewController.swift
//  xianzhan
//
//  Created by crl on 2018/11/5.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import WebKit;

class ViewController: BaseWebViewController {
    
    private var rootURL="https://xz-hf-dev.fire233.com/index.html";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        TickManager.Start();
        
        //TickManager.Add(self);
        /*Singleton.Register(TestMediator.self);
        let t=Facade.GetMediator(TestMediator.self);
        t.hello("crl");
        */
   
        sdk.on("load", #selector(doLoad), self);
        
        let loader=URLLoader("https://xz-hf-dev.fire233.com/web.xml");
        loader.defaultEvent(#selector(configHandle),self);
        loader.load();
    }
    
    
    @objc func configHandle(e:EventX) {
        
        if e.type != EventX.COMPLETE
        {
            self.enterGame();
            return;
        }
        //_=e.target as! URLLoader;
        
        let xml=e.data as! Data;
        let dic=XMLUtil.SimpleParse(xml: xml);
        
        
        let key="web.root\(Utils.GetAppVersion())";
        let url:String?=dic[key]?.value;
        
        if let u=url{
            rootURL=u;
        }
        
        self.enterGame();
    }
    
    
    func enterGame() {
        //test;
        rootURL="http://192.168.2.43:6060/simple.html";
        
        let time=Date.timeIntervalSinceReferenceDate;
        let t=Int(time);
        
        var linkChar="?"
        if(rootURL.contains(linkChar)){
            linkChar="&";
        }
        let platform="huoshu";
        let shell="ios";
        
        let querys=linkChar+"platform=\(platform)&t=\(t)&shell=\(shell)";
        // WKWebView加载请求
        loadWeb(rootURL,querys);
    }
    
    @objc override func doInit(e:EventX) {
        //test;
        super.doInit(e: e);
        
        sdk.send(CMD.Login,["open_id":"123"]);
    }
    
    
    @objc override func doLogin(e:EventX) {
        GameCenter.Instance.on(EventX.CHANGE, #selector(onLoginHandle), self);
        GameCenter.Instance.login();
    }
    
    @objc func onLoginHandle(e:EventX){
        let name=e.data as! String;
        sdk.send("login", name);
    }
    
    @objc override func doPay(e:EventX) {
        var productId=e.data as! String;
        
        productId="yb07";
        print(productId);
        let iap=IAP.Instance;
        //iap.add
        iap.pay(productId);
    }
    
    
    @objc func doLoad(e:EventX){
        loadWeb(e.data as! String);
    }
}

