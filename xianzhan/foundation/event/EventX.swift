//
//  EventX.swift
//  xianzhan
//
//  Created by crl on 2018/11/8.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class EventX: NSObject {
    
    static let COMPLETE="complete";
    static let FAILED="failed";
    
    static let READY="ready";
    static let ENTER="enter";

    static let INIT="init";
    static let EXIT="exit";
    
    static let START="start";
    static let PLAY="play";
    static let STOP="stop";
    static let CHANGE="change";
    static let SUCCESS="success";
    
    static let RELOAD="reload";
    
    static let DATA="data";
    static let TIMEOUT="timeout";
    static let ERROR="error";
    
    static let RENDER="render";
    static let CLEAR="clear";
    
    static let PROGRESS="progress";
    static let CANCEL="cancel";
    static let DISPOSE="dispose";
    static let CLOSE="close"
    
    static let MEDIATOR_READY="mediatorReady";
    static let PROXY_READY="proxyReady";
    
    static let MEDIATOR_SHOW="mediatorShow";
    static let MEDIATOR_HIDE="mediatorHide";
    
    
    static let SHOW="show";
    static let HIDE="hide";
    
    static let ReadyEvent:EventX=EventX(EventX.READY,nil);
    
    private var _type:String!;
    
    var type:String{
        get{
            return _type;
        }
    }
    
    private var _target:IEventDispatcher!=nil;
    var target:IEventDispatcher{
        get{
            return _target;
        }
    }
    
    var data:Any?;
    
    internal var __stopsImmediatePropagation=false;
    internal var __stopsPropagation=false;
    
    public init(_ type:String,_ data:Any?) {
        self._type = type;
        self.data = data;
        
    }
    
    internal func reset(_ type:String,_ data:Any?) {
        self._type = type;
        self.data = data;
    }
    
    func setTarget(_ value:IEventDispatcher) {
        self._target=value;
    }
    
    func stopsImmediatePropagation(){
        __stopsPropagation=true;
        __stopsImmediatePropagation=true;
    }
    
    func stopsPropagation(){
        __stopsPropagation=true;
    }
    
    static var Pool:[EventX]=[];
    static var MAX=200;
    static func FromPool(_ type:String,_ data:Any?=nil)->EventX{
        if Pool.count>0{
            let e = Pool.popLast()!;
            e.reset(type,data);
            return e;
        }
        return EventX(type, data);
    }
    
    static func ToPool(_ e:EventX){
        if(Pool.count<MAX){
            Pool.append(e);
        }
    }

}
