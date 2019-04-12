//
//  Facade.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class CRLFacade: CRLEventDispatcher,ICRLFacade {
    
    private var mvcInjectLock:[String:IMVCHost];
    private var mediators:View<CRLMediator>;
    private var proxys:View<CRLProxy>;
    
    private override init(){
        mediators = View<CRLMediator>();
        proxys = View<CRLProxy>();
        mvcInjectLock=[:];
        super.init();
    }
    
    private static var ins:ICRLFacade!;
    public static func Get()->ICRLFacade{
        ins = ins ?? CRLFacade();
        return ins;
    }
    
    func registerProxy(_ proxy: CRLProxy) ->Bool{
        return proxys.register(proxy);
    }
    
    func registerMediator(_ mediator: CRLMediator)->Bool {
        return mediators.register(mediator);
    }
    
    func getProxy(_ name:String) -> CRLProxy{
        let host = proxys.get(name);
        if host == nil {
            let cls:AnyClass? = CRLSingleton.GetClass(name);
            if let c=cls {
                let proxy=(c as! CRLProxy.Type).init(name,self) ;
                unSafeInjectInstance(proxy,name);
                _=registerProxy(proxy);
                return proxy;
            }
        }
        return host!;
    }
    func getMediator(_ name:String) -> CRLMediator{
        let host=mediators.get(name);
        if(host == nil){
            let cls:AnyClass?=CRLSingleton.GetClass(name);
            if let c=cls {
                let mediator = (c as! CRLMediator.Type).init(name,self);
                unSafeInjectInstance(mediator,name);
                _=registerMediator(mediator);
                return mediator;
            }
        }
        return host!;
    }
    
    func getProxy<T:CRLProxy>(_ type:T.Type) -> T{
        let fullClassName=type.self.ClassName;
        let name=CRLSingleton.GetAliasName(fullClassName);
        return getProxy(name) as! T;
    }
    func getMediator<T:CRLMediator>(_ type:T.Type) -> T{
        let fullClassName=type.self.ClassName;
        let name=CRLSingleton.GetAliasName(fullClassName);
        return getMediator(name) as! T;
    }
    
    
    private func unSafeInjectInstance(_ instance:IMVCHost,_ hostName:String){
        mvcInjectLock[hostName]=instance;
        _=inject(instance as AnyObject);
        mvcInjectLock[hostName]=nil;
    }
    
    
    func registerEventInsterester(_ target: IEventInterester, _ type: InjectEventType, _ isBind: Bool,_ dispatcher:ICRLEventDispatcher?=nil) {
        
        let l=target.getEventInteresting(type);
        guard let t=l else {
            return;
        }
        var dis:ICRLEventDispatcher!=dispatcher;
        if dis == nil{
            dis=self;
        }
        
        if isBind{
            t.forEach{ item in
                item.events.forEach{dis.on($0,item.handle, target as AnyObject)};
            }
        }else{
            t.forEach{ item in
                item.events.forEach{dis.off($0,item.handle, target as AnyObject)};
            }
        }
    }
    
    func inject(_ instance:AnyObject) -> AnyObject {
        
        return instance;
    }
    
    
    static func GetMediator<T:CRLMediator>(_ type:T.Type)->T{
        return Get().getMediator(type);
    }
    
}
