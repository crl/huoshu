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
        
        let loader=CRLURLLoader(url);
        loader.ons(CRLEvent.COMPLETE,CRLEvent.ERROR, handle: #selector(loaderHandle), self);
        loader.post(data);
    }
    
    //服务端数据返回
    @objc func loaderHandle(e:CRLEvent){
        let loader=e.target as! CRLURLLoader;
        loader.offs(CRLEvent.COMPLETE,CRLEvent.ERROR, handle: #selector(loaderHandle), self);
        
        if(e.type != CRLEvent.COMPLETE){
            return;
        }
        
        let dic=CRLJSONUtils.Decode(loader.getDataString());
        
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
        let prefix=IOUtils.GetDomDirectory("store");
        let fullPath=IOUtils.GetFullPath(fileName, prefix);
        IOUtils.WriteString(data, fullPath: fullPath);
    }
    
    //验证receipt失败,App启动后再次验证
    func sendFailedIapFiles(){
        let prefix=IOUtils.GetDomDirectory("store");
        let list=IOUtils.GetFiles(prefix.path);
        for item in list{
            //如果有plist后缀的文件，说明就是存储的购买凭证
            if(item.hasSuffix(".plist")){
                let filePath=IOUtils.GetFullPath(item, prefix);
                self.sendIapReceipt(filePath);
            }
        }
    }
    
    func sendIapReceipt(_ fullPath:String) {
        let dic=IOUtils.ReadString(fullPath);
        if(dic.isEmpty){
            IOUtils.RemoveFile(fullPath);
            return;
        }
        //self.requestGameServer(postURL: postURL, post: post, failSave: false, deletePath: path, retryCount: 0);
    }
}
