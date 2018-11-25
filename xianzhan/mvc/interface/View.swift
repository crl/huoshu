//
//  View.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class View<T:IMVCHost>{
    
    private var dic:[String:T]=[:];
    func get(_ name: String) -> T? {
        return dic[name];
    }
    
    func register(_ host: T) -> Bool {
        let name=host.name;
        
        let t=dic[name];
        if(t != nil){
            print("error duplicate:"+name);
            return false;
        }
        
        dic[name]=host;
        
        return true;
    }
    
    func remove(_ host: T) -> Bool {
        let name=host.name;
        
        let t=dic[name];
        if(t==nil){
            return false;
        }
        
        dic.removeValue(forKey: name);
        return true;
    }
}
