//
//  CallLater.swift
//  xianzhan
//
//  Created by crl on 2018/11/21.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class CallLater: NSObject,ITickable {
    
    static let Instance:CallLater=CallLater();
    
    func tick(now: DispatchTime) {
        
    }
    

    static var list:[ListenerBoxData<DispatchTime>]=[];
    
    static func Add(_ handle:Selector,selfObj:AnyObject,_ delay:DispatchTimeInterval) -> Bool{
        
        let t=DispatchTime.now()+delay;
        
        let hasItem = list.first{$0.equal(handle, selfObj)};
        if let h=hasItem{
            h.data=t;
            return true;
        }
        
        let item=ListenerBoxData<DispatchTime>();
        item.handle=handle;
        item.selfObj=selfObj;
        item.data=t;
        
        if(list.count==1){
            TickManager.Add(Instance);
        }
        
        return true;
    }
    
    static func Remove(_ handle:Selector,selfObj:AnyObject?)->Bool{
        
        let index=list.firstIndex{ $0.equal(handle, selfObj)};
        
        if let index=index{
            list.remove(at: index);
            
            if(list.count==0){
                TickManager.Remove(Instance);
            }
            
            return true;
        }
        
        return false;
    }
}
