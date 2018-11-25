//
//  IAP.swift
//  xianzhan
//
//  Created by crl on 2018/11/8.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class IAP: AbstractIAP {

    static let Instance=IAP();
    
    let gameData:[String:Any]=[:];
    
    override func verifyReceipt(_ receipt: String) {
        var url="";
        //test;
        url="";
        
        let data=getPostData(receipt);
        
        let loader=URLLoader(url);
        loader.ons(EventX.COMPLETE,EventX.ERROR, handle: #selector(loaderHandle), self);
        loader.post(data);
    }
    
    //服务端数据返回
    @objc func loaderHandle(e:EventX){
        let loader=e.target as! URLLoader;
        loader.offs(EventX.COMPLETE,EventX.ERROR, handle: #selector(loaderHandle), self);
        
        if(e.type != EventX.COMPLETE){
            return;
        }
        
        let dic=JSONUtil.Decode(loader.getDataString());
        
        let code=Int(dic["code"] as! String);
        
        if(code==1){
            
        }else{
        
        }
        
    }
    
    
    func getPostData(_ receipt:String) -> String {
        
        let userInfo=gameData["userInfo"];
        let productID=gameData["productID"];
        let appID=gameData["appID"] ;
        let productName=gameData["productName"];
        
        let now=Int(Date.timeIntervalSinceReferenceDate);
        let orderID=String(format:"%d",now);
        
        let post=String(format:"receipt=%@&userInfo=%@&orderID=%@&productID=%@&appID=%@&productName=%@",[receipt,userInfo,orderID,productID,appID,productName]);
        
        return post;
    }
    
    
    func saveData(_ data:String){
        let fileName=UUID().uuidString+".plist";
        let prefix=FileUtil.GetDomDirectory("store");
        let fullPath=FileUtil.GetFullPath(fileName, prefix);
        FileUtil.WriteString(data, fullPath: fullPath);
    }
    
    //验证receipt失败,App启动后再次验证
    func sendFailedIapFiles(){
        let prefix=FileUtil.GetDomDirectory("store");
        let list=FileUtil.GetFiles(prefix.path);
        for item in list{
            //如果有plist后缀的文件，说明就是存储的购买凭证
            if(item.hasSuffix(".plist")){
                let filePath=FileUtil.GetFullPath(item, prefix);
                self.sendIapReceipt(filePath);
            }
        }
    }
    
    func sendIapReceipt(_ fullPath:String) {
        let dic=FileUtil.ReadString(fullPath);
        if(dic.isEmpty){
            FileUtil.RemoveFile(fullPath);
            return;
        }
        //self.requestGameServer(postURL: postURL, post: post, failSave: false, deletePath: path, retryCount: 0);
    }
}
