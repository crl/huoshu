//
//  Utils.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import StoreKit;

class RFAppUtils: NSObject {
    
    static func GetRoot()->UIViewController{
        let w = UIApplication.shared.delegate?.window;
        return (w!!.rootViewController)!;
    }
    
    static var loadingBar:UIActivityIndicatorView?;
    static var _hasLoading=false;
    
    static func HasLoading()->Bool{
        return _hasLoading;
    }
    
    static func Loading(_ b:Bool){
        _hasLoading=b;
        
        if(loadingBar==nil){
            loadingBar=UIActivityIndicatorView(frame: CGRect(x:0,y:0,width:50,height:50));
            loadingBar?.style = .gray;
            loadingBar?.color=UIColor.yellow;
            
            let clr=UIColor.black.withAlphaComponent(0.5);
            loadingBar?.backgroundColor=clr;
        }
        
        if let view=RFAppUtils.GetRoot().view{
            view.addSubview(loadingBar!);
        }
        
        if(b){
            let rect=UIScreen.main.bounds;
            loadingBar!.center=CGPoint(x: rect.size.width/2, y: rect.size.height/2);
            loadingBar!.startAnimating();
        }else{
            loadingBar?.stopAnimating();
            
            if(loadingBar?.subviews != nil){
                loadingBar?.removeFromSuperview();
            }
        }
    }
    
    
    private static var map:Dictionary<String,UIImageView>=[:];
    
    static func ShowImage(_ key:String,_ b:Bool=true){
        var view=map[key];
        
        if b && view == nil{
            let path=Bundle.main.path(forResource: key, ofType: nil);
            
            if RFIOUtils.Exists(path!){
                let image=UIImage(contentsOfFile: path!);
                
                let imageView=UIImageView(image: image!);
                imageView.frame=GetRoot().view.frame;
                imageView.contentMode = .scaleAspectFill;
                
                map[key]=imageView;
                view=imageView;
            }
        }
        
        if let v=view{
            
            if b{
            if let r=RFAppUtils.GetRoot().view{
                r.addSubview(v);
            }
            }else{
                v.removeFromSuperview();
            }
        }
    }
    
    static func GetAppVersion()->String{
        let v = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String;
        return v ?? "1"
    }
    
    static func GetBundleIdentifier()->String{
        return Bundle.main.bundleIdentifier!
    }
    
    /**
     static let infoDictionary = Bundle.main.infoDictionary
     static let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String //App 名称
     static let bundleIdentifier:String = Bundle.main.bundleIdentifier! // Bundle Identifier
     static let appVersion:String = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String// App 版本号
     static let buildVersion : String = Bundle.main.infoDictionary! ["CFBundleVersion"] as! String //Bulid 版本号
     static let iOSVersion:String = UIDevice.current.systemVersion //ios 版本
     static let identifierNumber = UIDevice.current.identifierForVendor //设备 udid
     static let systemName = UIDevice.current.systemName //设备名称
     static let model = UIDevice.current.model // 设备型号
     static let localizedModel = UIDevice.current.localizedModel  //设备区域化型号
     */
    
    
    static func Present(_ vc:UIViewController,animated:Bool,completion: (() -> Swift.Void)? = nil){
        let rootViewC=UIApplication.shared.delegate?.window!?.rootViewController;
        rootViewC?.present(vc, animated: true, completion: completion);
    }
    
    static func OpenUserReviews(appID:String){
        let format=String(format: "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=%@", arguments: [appID]);
        let url=URL(string: format);
        UIApplication.shared.open(url!);
    }
    
    static func OpenHome(appID:String){
        let p=RFStoreProduct();
        p.load(appID: appID);
    }
    
    static func Alert(_ value:String){
        let alert=UIAlertController.init(title: "", message: value, preferredStyle: .alert);
        let action=UIAlertAction.init(title: "ok", style: .cancel) { (action) in
            
        }
        alert.addAction(action);
        GetRoot().present(alert, animated: true, completion: nil);
    }
    
    
    static func handlePayURL(_ url:URL)->URL?{
        let uri=url.absoluteString;
        let alipay="alipay://alipayclient/";
        if uri.hasPrefix(alipay){
            
            var decodePar:String!=url.query ?? "";
            decodePar=decodePar.removingPercentEncoding;
            var dic=RFJSONUtils.Decode(decodePar);
            dic["fromAppUrlScheme"]="com.mmgame.xianzhan";
            
            decodePar=RFJSONUtils.Encode(dic);
            decodePar=decodePar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
            
            let finalStr="\(alipay)?\(decodePar ?? "")";
            
            if let finalUrl=URL(string: finalStr){
                return finalUrl;
            }
            
            return nil;
        }
        
        if uri.hasPrefix("weixin://"){
            
            return url;
        }
        
        
        return nil;
    }
     static func handlePayBackURL(_ url:URL){
        print("payback:",url);
    }
    
    static func doSomething()->UIViewController{
        let s=ViewController2();
        
        
        var vc1 = YRJokeTableViewController()
        vc1.jokeType = .NewestJoke
        var vc2 = YRJokeTableViewController()
        vc2.jokeType = .HotJoke
        var vc3 = YRJokeTableViewController()
        vc3.jokeType = .ImageTruth
        //var vc4 = YRAboutViewController;
        (s as!UITabBarController).viewControllers = [vc1,vc2,vc3]
        
        return s;
    }
}
