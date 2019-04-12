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
    
    private var rootURL="https://xz-ios-usa.fire233.com/index.html?mask=1";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //TickManager.Start();
        //TickManager.Add(self);
        /*Singleton.Register(TestMediator.self);
         let t=Facade.GetMediator(TestMediator.self);
         t.hello("crl");
         */
        
        /**
         游戏标识(app_id)：
         5bf5042956fec80d6268c787
         游戏密钥管理
         客户端密钥：(app_client_key)
         280389b0f74f608f354bb595eb2a6d18
         服务端密钥：(app_server_key)
         ed00a42b41807d7eafe9e16d01a34afc
         */
        
        //UIApplication.shared.isStatusBarHidden=true;
        
        let appid="5bf5042956fec80d6268c787";
        let appkey="280389b0f74f608f354bb595eb2a6d18";
        
        //print("sdk ver:",GameSDKVersionNumber);
        
        
        GameSDKFacade.sdkInit(withGameId: appid, withGameKey: appkey, withGameVersion: "1.0.1", withIsNeedLogin: true, with: self)
        
        
        let notifi=NotificationCenter.default;
        notifi.addObserver(self, selector: #selector(sdkLoginHandle), name: NSNotification.Name(rawValue: hsGameLoginNotify), object: nil);
        notifi.addObserver(self, selector: #selector(sdkPayHandle), name: NSNotification.Name(rawValue: hsGamePaytNotify), object: nil);
        notifi.addObserver(self, selector: #selector(sdkEnterHandle), name: NSNotification.Name(rawValue: hsGameEnterGameNotify), object: nil);
        notifi.addObserver(self, selector: #selector(sdkRegisterHandle), name: NSNotification.Name(rawValue:hsGameRegisterNotify), object: nil);
        
        sdk.on("load", #selector(doLoad), self);
        sdk.router=self;
        
        let time=Date.timeIntervalSinceReferenceDate;
        let t=Int(time);
        let loader=CRLURLLoader("https://xz-hf-dev.fire233.com/web.xml?t=\(t)");
        loader.defaultEvent(#selector(configHandle),self);
        loader.load();
    }
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    @objc func configHandle(e:CRLEvent) {
        
        if e.type != CRLEvent.COMPLETE
        {
            self.enterToGame();
            return;
        }
        
        let key="web.root\(AppUtils.GetAppVersion())";
        
        let xml=e.data as! Data;
        let dic=CRLXMLUtils.SimpleParse(xml: xml);
        
        let url:String?=dic[key]?.value;
        
        if let u=url{
            rootURL=u;
        }else{
            //default url;
            let defurl=dic["web.def"]?.value;
            if let u=defurl{
                rootURL=u;
            }
        }
        self.enterToGame();
    }
    
    
    func enterToGame() {
        //test;
        //rootURL="http://192.168.2.43:6060/simple.html?mask=1";
        //rootURL="http://game.fire2333.com/home/ac?action=/home/game/a/1111/g/200053";
        
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
    
    @objc override func doInit(e:CRLEvent) {
        //test;
        super.doInit(e: e);
        self.present(SDKLoginAty(), animated: true){
        }
    }
    
    @objc override func doPay(e:CRLEvent) {
        let dic=e.data as! [String:Any];
        
        let productRawId=dic.getString("key");
        //IAP.Instance.pay(productId);
        //return;
        
        
        
        let replaceKey="com.mmgame.xianzhan";
        let withKey=AppUtils.GetBundleIdentifier();
        
        let productId=productRawId.replacingOccurrences(of: replaceKey, with: withKey);
        print("\(productId)=\(productRawId)");
        
        
        let server_id=dic.getString("game_server");
        let role_id=dic.getString("role_id");
        
        let mount=dic.getString("payment_amount");
        //let goodID=mount;
        let money=mount;
        
        let order=dic.getString("game_payorder");
        
        let m=GameSDKFacade.getInstance();
        m?.pay(withServerId: server_id, withRoleId: role_id, withCallBack: order, withMoney: money, withGoodId: productId, withPayAmount: "1", with: self);
    }
    
    
    @objc func doLoad(e:CRLEvent){
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
        let dic=GameSDKFacade.getLoginInfo();
        
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
                AppUtils.Alert(d);
            }
        }
        
        print(dic!);
    }
    @objc func sdkPayHandle(e:Notification){
        let dic=e.object;
        print("支付结果为:",dic!);
    }
    
    private var lastServer_id:String="";
    
    func receipt(_ c: String, _ d:Any) {
        switch c {
        case "enterGameLog":
            let dic=d as! [String:Any];
            
            let server_id=dic.getString("server_id");
            let role_id=dic.getString("role_id");
            let nickname=dic.getString("nickname");
            let level=dic.getInt("level");
            
            if server_id == lastServer_id {
                print("duplicate:"+c);
                return;
            }
            lastServer_id=server_id;
            GameSDKFacade.getInstance()?.loginRole(withServerId: server_id, withRoleName: nickname, withRoleId: role_id, withRoleLevel: "\(level)");
            
        case "createRoleLog":
            let dic=d as! [String:Any];
            let server_id=dic.getString("server_id");
            let role_id=dic.getString("role_id");
            let nickname=dic.getString("nickname");
            //let level=dic["level"] as? String;
            GameSDKFacade.getInstance()?.createRole(withServerId: server_id, withRoleName: nickname, withRoleId: role_id);
            
            
        case "levelUpLog":
            let dic=d as! [String:Any];
            let server_id=dic.getString("server_id");
            let role_id=dic.getString("role_id");
            let nickname=dic.getString("nickname");
            let level=dic.getString("level");
            
            GameSDKFacade.getInstance()?.upgradeRole(withServerId: server_id, withRoleName: nickname, withRoleId: role_id, withRoleLevel: level)
        
            
        case "pay":
            //路由一下
            sdk.simpleDispatch(CMD.Pay, d);
            
        default: break
            
        }
    }
}

