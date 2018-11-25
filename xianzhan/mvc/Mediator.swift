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
            old.off(EventX.READY, #selector(preViewReadyHandle), self);
            bindViewEvent(old,false);
        }
        view=value;
        
        if view != nil {
            return;
        }
        if !view.isReady{
            view.on(EventX.READY, #selector(preViewReadyHandle), self);
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
            view.ons(EventX.SHOW,EventX.HIDE, handle: #selector(stageHandle), self);
        }else{
            view.offs(EventX.SHOW,EventX.HIDE, handle: #selector(stageHandle), self);
        }
    }
    
    @objc func stageHandle(e:EventX) {
        if e.type == EventX.SHOW{
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
    @objc func preViewReadyHandle(_ e:EventX?=nil) {
        if let e=e{
            let v=e.target;
            v.off(EventX.READY, #selector(preViewReadyHandle), self);
        }
        onViewReadyHandle();
        if proxy == nil{
            preMediatorReadyHandle();
            return;
        }
        if !proxy.isReady{
            proxy.on(EventX.READY, #selector(preProxyReadyHandle), self);
            proxy.startSync();
            return;
        }
        preProxyReadyHandle(nil);
    }
    
    func onViewReadyHandle() {
        
    }
    
    
    //proxy;
    @objc func preProxyReadyHandle(_ e:EventX?){
        if let e=e{
            let v=e.target;
            v.off(EventX.READY, #selector(preViewReadyHandle), self);
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
        
        facade.simpleDispatch(EventX.MEDIATOR_READY, name);
        
        bindViewEvent(view);
        if view.isShow{
            stageHandle(e: EventX.FromPool(EventX.SHOW));
        }
    }
    
    func onMediatorReadyHandle(){
        
    }
    
    func preAwaken() {
        onAwaken();
        onUpdateView();
        
        facade.simpleDispatch(EventX.MEDIATOR_SHOW, name);
    }
    func preSleep() {
        onSleep();
        
        facade.simpleDispatch(EventX.MEDIATOR_HIDE, name);
    }
    
    func onAwaken() {
    }
    
    func onUpdateView() {
    }
    
    func onSleep() {
    }
}
