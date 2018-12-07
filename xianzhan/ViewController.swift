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
    
    private var rootURL="https://xz-hf-ios.fire233.com/index.html";
    
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
        notifi.addObserver(self, selector: #selector(sdkEnterHandle), name: NSNotification.Name.enterGame, object: nil);
        notifi.addObserver(self, selector: #selector(sdkRegisterHandle), name: NSNotification.Name.huoshuRegister, object: nil);
        
        sdk.on("load", #selector(doLoad), self);
        sdk.router=self;
        
        let loader=URLLoader("https://xz-hf-dev.fire233.com/web.xml");
        loader.defaultEvent(#selector(configHandle),self);
        loader.load();
    }
    override var prefersStatusBarHidden: Bool {
        return true;
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
        //rootURL="http://192.168.2.43:6060/simple.html";
        
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
        self.present(LoginViewController(), animated: true){
        }
    }
    
    @objc override func doPay(e:EventX) {
        let dic=e.data as! [String:Any];
        
        let productId:String=dic.getString("key");
        print(productId);
        
        
        //productId="com.mmgame.xianzhan11";
        //IAP.Instance.pay(productId);
        //return;
        
        let server_id=dic.getString("game_server");
        let role_id=dic.getString("role_id");
        
        let mount=dic.getString("payment_amount");
        //let goodID=mount;
        let money=mount;
        
        let order=dic.getString("game_payorder");
        
        let m=HuoShuSDKMgr.getInstance();
        m?.openPay(withServerid: server_id, withRoleId: role_id, withPayAmount: "1", withCallBack: order, withGoodId: productId, withMoney: money, with: self);
    }
    
    
    @objc func doLoad(e:EventX){
        loadWeb(e.data as! String);
    }
    
    @objc func sdkRegisterHandle(e:Notification){
        DispatchQueue.main.async {
            self.doSdkLogin(e);
        }
    }
    @objc func sdkLoginHandle(e:Notification){
        DispatchQueue.main.async {
            self.doSdkLogin(e);
        }
    }
    
    @objc func sdkEnterHandle(e:Notification){
        DispatchQueue.main.async {
            self.doSdkLogin(e,true);
        }
    }
    
    func doSdkLogin(_ e:Notification,_ enter:Bool=false){
        let dic=HuoShuSDKMgr.getLoginInfo();
        
        if let d=dic{
            let openid=d["openId"];
            
            if let id=openid {
            
                d["open_id"]=id;
                print("openId:",id,enter);
                
                if enter{
                    sdk.send(CMD.Login, d);
                }
            }else{
                let d="loginInfo:\(d)";
                Utils.Alert(d);
            }
        }
        
        print(dic!);
    }
    @objc func sdkPayHandle(e:Notification){
        let dic=e.object;
        print("支付结果为:",dic!);
    }
    
    
    
    func receipt(_ c: String, _ d:Any) {
        switch c {
        case "enterGameLog":
            let dic=d as! [String:Any];
            
            let server_id=dic.getString("server_id");
            let role_id=dic.getString("role_id");
            let nickname=dic.getString("nickname");
            let level=dic.getInt("level");
            
            HuoShuSDKMgr.getInstance()?.loginRole(withServerId: server_id,
                                                  withRoleId: role_id,
                                                  withRoleName:nickname,
                                                  withRoleLevel: "\(level)");
            
        case "createRoleLog":
            let dic=d as! [String:Any];
            let server_id=dic.getString("server_id");
            let role_id=dic.getString("role_id");
            let nickname=dic.getString("nickname");
            //let level=dic["level"] as? String;
            
            HuoShuSDKMgr.getInstance()?.createRole(withServerId: server_id,
                                                   withRoleId: role_id,
                                                   withRoleName: nickname);
            
        case "levelUpLog":
            let dic=d as! [String:Any];
            let server_id=dic.getString("server_id");
            let role_id=dic.getString("role_id");
            let nickname=dic.getString("nickname");
            let level=dic.getString("level");
            
            HuoShuSDKMgr.getInstance()?.upgradeRole(withServerId: server_id,
                                                    withRoleId: role_id,
                                                    withRoleName: nickname,
                                                    withRoleLevel: level);
            
        case "pay":
            //路由一下
            sdk.simpleDispatch(CMD.Pay, d);
            
        default: break
            
        }
    }
}

