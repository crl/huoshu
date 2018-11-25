//
//  Utils.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import StoreKit;

class Utils: NSObject {
    
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
        
        if let view=Utils.GetRoot().view{
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
            
            if FileUtil.Exists(path!){
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
            if let r=Utils.GetRoot().view{
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
        let p=StoreProduct();
        p.load(appID: appID);
    }
    
    static func Alert(_ value:String){
        let alert=UIAlertController.init(title: "", message: value, preferredStyle: .alert);
        let action=UIAlertAction.init(title: "ok", style: .cancel) { (action) in
            
        }
        alert.addAction(action);
        GetRoot().present(alert, animated: true, completion: nil);
    }
    
    
   
}
