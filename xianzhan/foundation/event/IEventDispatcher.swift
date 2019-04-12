//
//  IEventDispatcher.swift
//  xianzhan
//
//  Created by crl on 2018/11/7.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

protocol IEventDispatcher {
    
    @discardableResult
    func on(_ type:String,_ handle:Selector,_ selfObj:AnyObject?) -> Bool;
    
    @discardableResult
    func off(_ type:String,_ handle:Selector,_ selfObj:AnyObject?) -> Bool;
    
    @discardableResult
    func hasOn(_ type:String)->Bool;
    
    @discardableResult
    func dispatchEvent(_ e:Event) -> Bool;
    
    @discardableResult
    func simpleDispatch(_ type:String,_ data:Any?) -> Bool;
    
    
    func ons(_ events:String..., handle: Selector, _ selfObj: AnyObject?)->Void;
    func offs(_ events:String..., handle: Selector, _ selfObj: AnyObject?)->Void
}