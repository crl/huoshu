//
//  GameCenter.swift
//  xianzhan
//
//  Created by crl on 2018/11/6.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit
import GameKit;

class CRLGameCenter:CRLEventDispatcher,GKGameCenterControllerDelegate {
    var gameCenterEnabled:Bool=false;
    
    var playerID:String?;
    
    private var localPlayer: GKLocalPlayer! = nil;
    
    static let Instance=CRLGameCenter();
    
    func login() {
        
        localPlayer = GKLocalPlayer.local;
        if(localPlayer.isAuthenticated){
            self.loginCallBack();
            return;
        }
        
        if(localPlayer.authenticateHandler != nil){
            return;
        }
        localPlayer.authenticateHandler = self.authenticateHandler;
    }
    
    func authenticateHandler(vc:UIViewController?, error:Error?){
        if(vc != nil) {
            AppUtils.Present(vc!, animated: true, completion: nil)
            return;
        }
        
        var uuid:String?;
        if (localPlayer.isAuthenticated) {
            self.gameCenterEnabled = true;
            uuid=localPlayer.playerID;
        } else {
            self.gameCenterEnabled = false;
            uuid=getOrCreateUUID();
        }
        
        if(self.playerID==uuid){
            return;
        }
        self.playerID=uuid;
        self.loginCallBack();
    }
    
    
    func getOrCreateUUID() -> String {
        var uuid=UserDefaults.standard.string(forKey: "uuid");
        if(uuid==nil){
            uuid=UIDevice.current.identifierForVendor?.uuidString;
            if(uuid==nil){
                uuid=NSUUID().uuidString;
            }
            if(uuid != nil){
                UserDefaults.standard.set(uuid, forKey: "uuid");
            }
        }
        return uuid!;
    }
    
    
    func gameCenterViewControllerDidFinish(_ gcvc: GKGameCenterViewController) {
        gcvc.dismiss(animated: true, completion: nil)
    }
    
    func loginCallBack(){
        if(localPlayer.isAuthenticated){
            playerID=localPlayer.playerID;
        }
        
        var id="";
        if(playerID != nil){
            id=playerID!.replacingOccurrences(of: ":", with: "");
        }
        
        self.simpleDispatch(CRLEvent.CHANGE, id);
    }
    
}
