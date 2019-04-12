//
//  GameSDKFacade.h
//  SDK对外门面类 大部分对外Api均从这调用
//  Created by zhaoyun on 2018/8/31.
//  Copyright © 2018年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface GameSDKFacade : NSObject{
    NSString* appId_;
    NSString* appKey_;
    NSString* inviterCode_;
}

+(GameSDKFacade *)getInstance;
+(NSMutableDictionary *)getLoginInfo;


+(void) SDKInitWithGameId:(NSString *)gameId
                     withGameKey:(NSString *)gameKey
                    withGameVersion:(NSString *)gameVersion
             withIsNeedLogin:(BOOL)isNeedLogin
             withViewController:(UIViewController *)viewController;

- (void)openLoginWithController: (UIViewController *)controller;


-(void)createRoleWithServerId:(NSString *)serverId
                 withRoleName:(NSString *)roleName
                   withRoleId:(NSString *)roleId;


-(void)loginRoleWithServerId:(NSString *)serverId
                withRoleName:(NSString *)roleName
                  withRoleId:(NSString *)roleId
               withRoleLevel:(NSString *)roleLevel;


-(void)upgradeRoleWithServerId:(NSString *)serverId
                  withRoleName:(NSString *)roleName
                    withRoleId:(NSString *)roleId
                 withRoleLevel:(NSString *)roleLevel;





// 支付
-(void)payWithServerId:(NSString *)serverId
            withRoleId:(NSString *)roleId
          withCallBack:(NSString *)callBack
             withMoney:(NSString *)money
            withGoodId:(NSString *)goodId
         withPayAmount:(NSString *)payAmount
        withController:(UIViewController *)controller;




-(void)afterAuthSuccess:(NSNotification *)notification;

-(void)afterGetProductInfo:(NSNotification *)notification;
-(void)afterGetEnterCenterNotify:(NSNotification *)notification;
-(void)afterGetEnterContactHelperNotify:(NSNotification *)notification;
-(UIViewController *)getVc;
-(void)onlineLog;

-(void)initSDK;
-(void)setViewController:(UIViewController *)viewController;

-(void)applePayMessageWithServerId:(NSString *)serverId
                        withGoodId:(NSString *)goodId
                    withGameAmount:(NSString *)gameAmount
                         withMoney:(NSString *)money
                        withRoleId:(NSString *)roleId
                      withCallBack:(NSString *)callBack
                    withController:(UIViewController *)viewController;




@end

