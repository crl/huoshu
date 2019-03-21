//
//  EventDispatcher.swift
//  xianzhan
//
//  Created by crl on 2018/11/7.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class RFEventDispatcher: NSObject,IRFEventDispatcher {
    private var eventsMap:[String:[RFListenerItem<RFEvent>]]=[:];
    
    func ons(_ events:String..., handle: Selector, _ selfObj: AnyObject?) {
        events.forEach{
            on($0, handle, selfObj);
        }
    }
    func offs(_ events:String..., handle: Selector, _ selfObj: AnyObject?) {
        events.forEach{
            off($0, handle, selfObj);
        }
    }
    
    
    @discardableResult
    func on(_ type: String, _ handle: Selector, _ selfObj: AnyObject?) -> Bool {
        let list=eventsMap[type];
        if let list=list {
            
            let has = list.contains{$0.equal(handle, selfObj)};
            if has{
                return false;
            }
        }else{
            eventsMap[type]=[];
        }
        
        let item=RFListenerItem<RFEvent>();
        item.handle=handle;
        item.selfObj=selfObj;
        eventsMap[type]!.append(item);
        return true;
    }
    @discardableResult
    func off(_ type: String, _ handle: Selector, _ selfObj: AnyObject?) -> Bool {
        let list=eventsMap[type];
        if let list=list{
            
            let index=list.firstIndex{ $0.equal(handle, selfObj)};
            
            if let index=index{
                eventsMap[type]!.remove(at: index);
                return true;
            }
        }
        
        return false;
    }
    
    @discardableResult
    func hasOn(_ type: String) -> Bool {
        let list=eventsMap[type];
        if let list=list{
            return list.count>0;
        }
        
        return false;
    }
    
    @discardableResult
    func dispatchEvent(_ e: RFEvent) -> Bool {
        
        let list=eventsMap[e.type];
        
        guard let l=list else{
            return false;
        }
        
        e.setTarget(self);
        
        for item in l {
            
            item.call(e);
            
            if(e.__stopsImmediatePropagation){
                break;
            }
        }
        
        return true;//e.__stopsPropagation;
    }
    
    @discardableResult
    func simpleDispatch(_ type: String,_ data: Any?=nil) -> Bool {
        
        guard hasOn(type) else {
            return false;
        }
        
        let e=RFEvent.FromPool(type,data);
        let b=dispatchEvent(e);
        
        RFEvent.ToPool(e);
        
        return b;
    }
    
    
    
}
