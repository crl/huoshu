//
//  Singleton.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//
import UIKit;

class CRLSingleton {
    
    private static var classMap:[String:AnyClass]=[:];
    private static var aliasMap:[String:String]=[:];
    
    static func GetAliasName(_ fullClassName:String)->String{
        
        if(fullClassName.contains(".")){
            return fullClassName.components(separatedBy: ".")[1];
        }
        
        return fullClassName;
    }
    
    static func Register(_ cls:AnyClass,_ aliasName:String?=nil){
        let fullClassName = cls.description();
        classMap[fullClassName]=cls;
        
        var n=aliasName;
        if n == nil {
            n=GetAliasName(fullClassName);
        }
        
        aliasMap[fullClassName]=n!;
        aliasMap[n!]=fullClassName;
    }
    
    static func GetClass(_ name:String) -> AnyClass?{
        var cls:AnyClass?=classMap[name];
        if cls == nil{
            let aliasName=aliasMap[name];
            if let c=aliasName{
                cls=classMap[c];
            }
        }
        return cls;
    }
}
