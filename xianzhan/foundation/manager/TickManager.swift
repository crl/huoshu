//
//  TickManager.swift
//  xianzhan
//
//  Created by crl on 2018/11/21.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

protocol ITickable:NSObjectProtocol {
    func tick(now:DispatchTime);
}


class TickManager: NSObject {

    private static var list:[ListenerItem<DispatchTime>]=[];
    private static var listType:[ITickable]=[];
    private static var timer:Timer!;
    
    @objc static func update(){
        
        let l=TickManager.list;
        let r=TickManager.listType;
        if(l.count==0 && r.count==0){
            return;
        }
        
        let f=DispatchTime.now();
        
        r.forEach { (i) in
            i.tick(now:f);
        }
        l.forEach { (i) in
            i.call(f);
        }
        
    }
    
    static func Start(delta:TimeInterval=0.1){
        timer=Timer(timeInterval: delta, target:TickManager.self, selector: #selector(update), userInfo: nil, repeats: true);
        RunLoop.current.add(timer, forMode: .default);
        timer.fire();
    }
    
    
    @discardableResult
    static func AddItem(_ tickable:ITickable)->Bool{
        let has = listType.contains{$0 === tickable};
        if has{
            return false;
        }
        listType.append(tickable);
        return true;
    }
    
    @discardableResult
    static func RemoveItem(_ tickable:ITickable)->Bool{
        let index=listType.firstIndex{ $0===tickable};
        
        if let index=index{
            list.remove(at: index);
            return true;
        }
        
        return false;
    }
    
    @discardableResult
    static func Add(_ handle:Selector,selfObj:AnyObject?)->Bool{
        
        let has = list.contains{$0.equal(handle, selfObj)};
        if has{
            return false;
        }
        
        let item=ListenerItem<DispatchTime>();
        item.handle=handle;
        item.selfObj=selfObj;
        list.append(item);
        return true;
    }
    
    @discardableResult
    static func Remove(_ handle:Selector,selfObj:AnyObject?)->Bool{
        
        let index=list.firstIndex{ $0.equal(handle, selfObj)};
        
        if let index=index{
            list.remove(at: index);
            return true;
        }
        
        return false;
    }
}
