//
//  Mediator.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

class CRLMediator: MVCHost,ICRLMediator {
    
    var view:ICRLPanel! = nil;
    var proxy:ICRLProxy! = nil;
    
    override func load() {
        if view == nil{
            return;
        }
        if !view.isReady{
            view.startSync();
        }
    }
    
    func setView(value: ICRLPanel) {
        if let old=view{
            old.off(CRLEvent.READY, #selector(preViewReadyHandle), self);
            bindViewEvent(old,false);
        }
        view=value;
        
        if view != nil {
            return;
        }
        if !view.isReady{
            view.on(CRLEvent.READY, #selector(preViewReadyHandle), self);
            return;
        }
        //bindViewEvent(old,false);
        preViewReadyHandle();
    }
    
    func getView() -> ICRLPanel {
        return self.view;
    }
    
    func setProxy(value: ICRLProxy) {
        self.proxy=value;
    }
    
    func getProxy() -> ICRLProxy {
        return self.proxy;
    }
    
    func bindViewEvent(_ view:ICRLPanel,_ isBind:Bool=true) {
        if(isBind){
            view.ons(CRLEvent.SHOW,CRLEvent.HIDE, handle: #selector(stageHandle), self);
        }else{
            view.offs(CRLEvent.SHOW,CRLEvent.HIDE, handle: #selector(stageHandle), self);
        }
    }
    
    @objc func stageHandle(e:CRLEvent) {
        if e.type == CRLEvent.SHOW{
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
    @objc func preViewReadyHandle(_ e:CRLEvent?=nil) {
        if let e=e{
            let v=e.target;
            v.off(CRLEvent.READY, #selector(preViewReadyHandle), self);
        }
        onViewReadyHandle();
        if proxy == nil{
            preMediatorReadyHandle();
            return;
        }
        if !proxy.isReady{
            proxy.on(CRLEvent.READY, #selector(preProxyReadyHandle), self);
            proxy.startSync();
            return;
        }
        preProxyReadyHandle(nil);
    }
    
    func onViewReadyHandle() {
        
    }
    
    
    //proxy;
    @objc func preProxyReadyHandle(_ e:CRLEvent?){
        if let e=e{
            let v=e.target;
            v.off(CRLEvent.READY, #selector(preViewReadyHandle), self);
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
        
        facade.simpleDispatch(CRLEvent.MEDIATOR_READY, name);
        
        bindViewEvent(view);
        if view.isShow{
            stageHandle(e: CRLEvent.FromPool(CRLEvent.SHOW));
        }
    }
    
    func onMediatorReadyHandle(){
        
    }
    
    func preAwaken() {
        onAwaken();
        onUpdateView();
        
        facade.simpleDispatch(CRLEvent.MEDIATOR_SHOW, name);
    }
    func preSleep() {
        onSleep();
        
        facade.simpleDispatch(CRLEvent.MEDIATOR_HIDE, name);
    }
    
    func onAwaken() {
    }
    
    func onUpdateView() {
    }
    
    func onSleep() {
    }
}
