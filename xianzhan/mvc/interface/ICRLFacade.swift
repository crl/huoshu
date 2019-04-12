//
//  IFacade.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

enum InjectEventType:String{
    case Show="s"
    case Always="a"
    case Proxy="p"
}

protocol ICRLFacade : ICRLEventDispatcher{
    func registerProxy(_ proxy:CRLProxy) -> Bool;
    func registerMediator(_ mediator:CRLMediator) -> Bool;
    
    func getProxy(_ name:String) -> CRLProxy;
    func getMediator(_ name:String) -> CRLMediator;
    
    func getProxy<T:CRLProxy>(_ type:T.Type) -> T;
    func getMediator<T:CRLMediator>(_ type:T.Type) -> T;
    
    func registerEventInsterester(_ target:IEventInterester,_ type:InjectEventType,_ isBind:Bool,_ dispatcher:ICRLEventDispatcher?);
}

protocol ICRLMediator:IMVCHost{
    func setView(value:ICRLPanel);
    func getView() -> ICRLPanel;
    
    func setProxy(value:ICRLProxy)
    func getProxy() -> ICRLProxy;
}
protocol ICRLProxy:IMVCHost {
    
}

protocol ICRLPanel:ICRLAsync,ICRLEventDispatcher {
    var isShow:Bool{get};
}

protocol IEventInterester {
    var eventInteresting:[String:[InjectEventTypeHandle]]?{
        get
    }
    func getEventInteresting(_ type:InjectEventType)->[InjectEventTypeHandle]?;
}

protocol ICRLAsync {
    var isReady:Bool{
        get
    }
    
    @discardableResult
    func startSync()->Bool;
    func addReadyHandle(handle:Selector,selfObj:AnyObject);
}

protocol IMVCHost:ICRLAsync,ICRLEventDispatcher,IEventInterester {
    var name:String{
        get
    }
    func onRegister() -> Void;
    func onRemove() -> Void;
    
    func execute<T>(handle:Selector,data:T?);
}

class InjectEventTypeHandle:NSObject {
    var handle:Selector! = nil;
    var events:[String]! = nil;
}

class MVCHost:CRLEventDispatcher,IMVCHost {
    var facade:ICRLFacade;
    private var readyHandles:[RFListenerItem<CRLEvent>]?=nil;
    
    var __eventInteresting: [String : [InjectEventTypeHandle]]?
    var eventInteresting:[String:[InjectEventTypeHandle]]?{
        get{
            return __eventInteresting;
        }
    }
    
    private var __name:String="";
    required init(_ name:String,_ facade:ICRLFacade) {
        __name=name;
        self.facade=facade;
        
        super.init();
    }
    var name: String{
        get{
            return __name;
        }
    }
    
    func getEventInteresting(_ type: InjectEventType) -> [InjectEventTypeHandle]? {
        if(__eventInteresting != nil){
            return nil;
        }
        return __eventInteresting![type.rawValue];
    }
    
    var _isReady: Bool=false;
    var isReady: Bool{
        get{
            return _isReady;
        }
    }
    
    func startSync() -> Bool {
        load();
        return true;
    }
    
    func load(){
        
    }
    
    func addReadyHandle(handle: Selector, selfObj: AnyObject) {
        if(_isReady){
            _=selfObj.perform(handle, with: CRLEvent.ReadyEvent);
            return;
        }
        if readyHandles == nil{
            readyHandles=[];
        }else{
            
            let b = readyHandles!.contains{
                $0.equal(handle,selfObj)
            }
            if b {
                return;
            }
        }
        let e=RFListenerItem<CRLEvent>();
        e.handle=handle;
        e.selfObj=selfObj;
        readyHandles!.append(e);
    }
    
    func dispatchReadyHandle() {
        
        if !_isReady{
            return;
        }
         _isReady=true;
        
        facade.registerEventInsterester(self,InjectEventType.Always,true,nil);
        if readyHandles != nil{
            readyHandles?.forEach{
                _=$0.call(CRLEvent.ReadyEvent);
            }
            readyHandles!.removeAll();
            readyHandles=nil;
        }
        simpleDispatch(CRLEvent.READY);
    }
    
    
    class var ClassName: String{
        get{
            return self.description();
        }
    }
    
    func execute<T>(handle:Selector,data:T?){
        
        self.perform(handle, with: data);
    }
    func onRegister() {
    }
    
    func onRemove() {
    }
}
