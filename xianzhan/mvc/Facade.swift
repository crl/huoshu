//
//  Facade.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class Facade: EventDispatcherX,IFacade {
    
    private var mvcInjectLock:[String:IMVCHost];
    private var mediators:View<Mediator>;
    private var proxys:View<Proxy>;
    
    private override init(){
        mediators = View<Mediator>();
        proxys = View<Proxy>();
        mvcInjectLock=[:];
        super.init();
    }
    
    private static var ins:IFacade!;
    public static func Get()->IFacade{
        ins = ins ?? Facade();
        return ins;
    }
    
    func registerProxy(_ proxy: Proxy) ->Bool{
        return proxys.register(proxy);
    }
    
    func registerMediator(_ mediator: Mediator)->Bool {
        return mediators.register(mediator);
    }
    
    func getProxy(_ name:String) -> Proxy{
        let host = proxys.get(name);
        if host == nil {
            let cls:AnyClass? = Singleton.GetClass(name);
            if let c=cls {
                let proxy=(c as! Proxy.Type).init(name,self) ;
                unSafeInjectInstance(proxy,name);
                _=registerProxy(proxy);
                return proxy;
            }
        }
        return host!;
    }
    func getMediator(_ name:String) -> Mediator{
        let host=mediators.get(name);
        if(host == nil){
            let cls:AnyClass?=Singleton.GetClass(name);
            if let c=cls {
                let mediator = (c as! Mediator.Type).init(name,self);
                unSafeInjectInstance(mediator,name);
                _=registerMediator(mediator);
                return mediator;
            }
        }
        return host!;
    }
    
    func getProxy<T:Proxy>(_ type:T.Type) -> T{
        let fullClassName=type.self.ClassName;
        let name=Singleton.GetAliasName(fullClassName);
        return getProxy(name) as! T;
    }
    func getMediator<T:Mediator>(_ type:T.Type) -> T{
        let fullClassName=type.self.ClassName;
        let name=Singleton.GetAliasName(fullClassName);
        return getMediator(name) as! T;
    }
    
    
    private func unSafeInjectInstance(_ instance:IMVCHost,_ hostName:String){
        mvcInjectLock[hostName]=instance;
        _=inject(instance as AnyObject);
        mvcInjectLock[hostName]=nil;
    }
    
    
    func registerEventInsterester(_ target: IEventInterester, _ type: InjectEventType, _ isBind: Bool,_ dispatcher:IEventDispatcherX?=nil) {
        
        let l=target.getEventInteresting(type);
        guard let t=l else {
            return;
        }
        var dis:IEventDispatcherX!=dispatcher;
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
    
    
    static func GetMediator<T:Mediator>(_ type:T.Type)->T{
        return Get().getMediator(type);
    }
    
}
