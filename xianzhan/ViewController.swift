//
//  ViewController.swift
//  xianzhan
//
//  Created by crl on 2018/11/5.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import WebKit;

class ViewController: BaseWebViewController,ISDKRouter {
    
    private var rootURL="https://xz-hf-dev.fire233.com/index.html";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        TickManager.Start();
        
        //TickManager.Add(self);
        /*Singleton.Register(TestMediator.self);
         let t=Facade.GetMediator(TestMediator.self);
         t.hello("crl");
         */
        
        
        let notifi=NotificationCenter.default;
        notifi.addObserver(self, selector: #selector(sdkLoginHandle), name: NSNotification.Name.huoshuLogin, object: nil);
        notifi.addObserver(self, selector: #selector(sdkPayHandle), name: NSNotification.Name.huoshuPayt, object: nil);
        
        
        sdk.on("load", #selector(doLoad), self);
        sdk.router=self;
        
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
        
        //sdk.send(CMD.Login,["open_id":"123"]);
        //let m=HuoShuSDKMgr.getInstance();
        //m?.loginRole(withServerId: <#T##String!#>, withRoleId: <#T##String!#>, withRoleName: <#T##String!#>, withRoleLevel: <#T##String!#>)
        
        self.present(LoginViewController(), animated: true){
            
        }
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
       let dic=e.data as! [String:String];
        
        var productId:String;
        
        productId=dic["object_name"]!
        
        productId="yb07";
        print(productId);
        //let iap=IAP.Instance;
        //iap.add
        //iap.pay(productId);
        
        let serverID="";
        let roleID="";
        let payMount="";
        
        let goodID="";
        let money="";
        
        let temp=100000+arc4random()%100000;
        let order="\(temp)huoshuSDk";
        
        let m=HuoShuSDKMgr.getInstance();
        m?.openPay(withServerid: serverID, withRoleId: roleID, withPayAmount: payMount, withCallBack: order, withGoodId: goodID, withMoney: money, with: self)
    }
    
    
    @objc func doLoad(e:EventX){
        loadWeb(e.data as! String);
    }
    
    @objc func sdkLoginHandle(e:Notification){
        let dic=HuoShuSDKMgr.getLoginInfo();
        
        if let d=dic{
            let openid=d["openId"];
            d["open_id"]=openid;
            sdk.send(CMD.Login, d);
        }
        
        print(dic!);
    }
    @objc func sdkPayHandle(e:Notification){
        let dic=e.object;
        
        print(dic!);
    }
    
    
    
    func receipt(_ c: String, _ d:Any) {
        switch c {
        case "enterGameLog":
            let dic=d as! [String:Any];
            HuoShuSDKMgr.getInstance()?.loginRole(withServerId: dic["server_id"] as? String, withRoleId: dic["role_id"] as? String, withRoleName: dic["nickname"] as? String, withRoleLevel: dic["level"] as? String);
            
        case "createRoleLog":
            let dic=d as! [String:Any];
            HuoShuSDKMgr.getInstance()?.createRole(withServerId: dic["server_id"] as? String, withRoleId: dic["role_id"] as? String, withRoleName: dic["nickname"] as? String);
            
        case "levelUpLog":
            let dic=d as! [String:Any];
            HuoShuSDKMgr.getInstance()?.upgradeRole(withServerId: dic["server_id"] as? String, withRoleId: dic["role_id"] as? String, withRoleName: dic["nickname"] as? String, withRoleLevel: dic["level"] as? String);
            
        default: break
            
        }
    }
}
