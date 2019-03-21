//
//  Mediator.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class Mediator: MVCHost,IMediator {
    
    var view:IPanel! = nil;
    var proxy:IProxy! = nil;
    
    override func load() {
        if view == nil{
            return;
        }
        if !view.isReady{
            view.startSync();
        }
    }
    
    func setView(value: IPanel) {
        if let old=view{
            old.off(RFEvent.READY, #selector(preViewReadyHandle), self);
            bindViewEvent(old,false);
        }
        view=value;
        
        if view != nil {
            return;
        }
        if !view.isReady{
            view.on(RFEvent.READY, #selector(preViewReadyHandle), self);
            return;
        }
        //bindViewEvent(old,false);
        preViewReadyHandle();
    }
    
    func getView() -> IPanel {
        return self.view;
    }
    
    func setProxy(value: IProxy) {
        self.proxy=value;
    }
    
    func getProxy() -> IProxy {
        return self.proxy;
    }
    
    func bindViewEvent(_ view:IPanel,_ isBind:Bool=true) {
        if(isBind){
            view.ons(RFEvent.SHOW,RFEvent.HIDE, handle: #selector(stageHandle), self);
        }else{
            view.offs(RFEvent.SHOW,RFEvent.HIDE, handle: #selector(stageHandle), self);
        }
    }
    
    @objc func stageHandle(e:RFEvent) {
        if e.type == RFEvent.SHOW{
            facade.registerEventInsterester(self, InjectEventType.Show, true, nil);
            if proxy != nil {
                facade.registerEventInsterester(proxy, InjectEventType.Show, true, nil);
            }
            
            if(isReady){
                preAwaken();
            }
        }else{
            facade.registerEventInsterester(self, InjectEventType.Show, false, nil);
            if proxy != nil {
                facade.registerEventInsterester(proxy, InjectEventType.Show, false, nil);
            }
            if(isReady){
                preSleep();
            }
        }
    }
    
    
    //view;
    @objc func preViewReadyHandle(_ e:RFEvent?=nil) {
        if let e=e{
            let v=e.target;
            v.off(RFEvent.READY, #selector(preViewReadyHandle), self);
        }
        onViewReadyHandle();
        if proxy == nil{
            preMediatorReadyHandle();
            return;
        }
        if !proxy.isReady{
            proxy.on(RFEvent.READY, #selector(preProxyReadyHandle), self);
            proxy.startSync();
            return;
        }
        preProxyReadyHandle(nil);
    }
    
    func onViewReadyHandle() {
        
    }
    
    
    //proxy;
    @objc func preProxyReadyHandle(_ e:RFEvent?){
        if let e=e{
            let v=e.target;
            v.off(RFEvent.READY, #selector(preViewReadyHandle), self);
        }
        onProxyReadyHandle();
        preMediatorReadyHandle();
    }
    func onProxyReadyHandle(){
    }
    
    //mediator;
    func preMediatorReadyHandle(){
        onMediatorReadyHandle();
        dispatchReadyHandle();
        
        facade.simpleDispatch(RFEvent.MEDIATOR_READY, name);
        
        bindViewEvent(view);
        if view.isShow{
            stageHandle(e: RFEvent.FromPool(RFEvent.SHOW));
        }
    }
    
    func onMediatorReadyHandle(){
        
    }
    
    func preAwaken() {
        onAwaken();
        onUpdateView();
        
        facade.simpleDispatch(RFEvent.MEDIATOR_SHOW, name);
    }
    func preSleep() {
        onSleep();
        
        facade.simpleDispatch(RFEvent.MEDIATOR_HIDE, name);
    }
    
    func onAwaken() {
    }
    
    func onUpdateView() {
    }
    
    func onSleep() {
    }
}
