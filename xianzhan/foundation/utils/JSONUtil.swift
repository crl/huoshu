//
//  JsonUtil.swift
//  xianzhan
//
//  Created by crl on 2018/11/7.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class JSONUtil {
    private init(){
        
    }
    
    static func Encode(_ data:Any) -> String {
        
        do {
            let jsonData=try JSONSerialization.data(withJSONObject: data);
            let json=String(data: jsonData, encoding: .utf8);
            
            if let json=json{
                return json;
            }
        } catch {
            print(error);
        }
        
        return "";
    }
    
    static func Decode(_ value:String) -> [String:Any] {
        do{
            let jsonData=value.data(using: .utf8, allowLossyConversion: false)!;
            let json=try JSONSerialization.jsonObject(with: jsonData, options:[]) as! [String:Any];
            return json;
        }catch{
            print(error);
        }
        return [:];
    }
}
