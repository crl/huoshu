//
//  AppDelegate.swift
//  xianzhan
//
//  Created by crl on 2018/11/5.
//  Copyright © 2018 lingyu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /**
         游戏标识(app_id)：
         5bf5042956fec80d6268c787
         游戏密钥管理
         客户端密钥：(app_client_key)
         280389b0f74f608f354bb595eb2a6d18
         服务端密钥：(app_server_key)
         ed00a42b41807d7eafe9e16d01a34afc
         */
        
        //UIApplication.shared.isStatusBarHidden=true;
        
        let appid="5bf5042956fec80d6268c787";
        let appkey="280389b0f74f608f354bb595eb2a6d18";
        
        print("sdk ver:",HuoShuSDKVersionNumber)
        
        HuoShuSDKMgr.huoShuSDKInit(withApp_id: appid, withAppKey: appkey, withGameVer: "1.0", withIsRequireLogin: true);
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

