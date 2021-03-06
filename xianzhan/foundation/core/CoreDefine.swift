//
//  CoreDefine.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

typealias Action = ()->Void;
typealias ActionT<T> = (_ data:T)->Void;
typealias Func<R> = ()->R
typealias FuncT<T,R> = (T)->R;


class RFListenerItem<T> {
    var handle:Selector!;
    var selfObj:AnyObject?;
    
    func equal(_ h:Selector,_ s:AnyObject?) -> Bool {
        return handle == h && selfObj === s;
    }
    
    func call(_ e:T) {
        _=selfObj?.perform(handle, with: e);
    }
}
class RFListenerItemRef<T>:RFListenerItem<T>{
    var data:T!;
}



func GetMemoryAddress(o:AnyObject)->String{
    let str=Unmanaged<AnyObject>.passUnretained(o).toOpaque();
    return String(describing: str);
}

func Equatable(_ f:AnyObject,_ t:AnyObject)->Bool{
    return (GetMemoryAddress(o: f) == GetMemoryAddress(o: t));
}

extension Dictionary{
    
    func getString(_ key:Key,def:String="") -> String {
        let o=self[key];
        if (o != nil) {
            return String(describing: o!);
        }
        return def;
    }
    
    func getInt(_ key:Key,def:Int=0) -> Int {
        let o=self[key];
        if (o != nil) {
            if let t = o as? Int{
                return t;
            }
        }
        return def;
    }
}
