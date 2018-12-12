//
//  HuoShuSDKMgr.h
//  NewSDK
//
//  Created by nothing on 2018/8/31.
//  Copyright © 2018年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HuoShuSDKMgr : NSObject{
    NSString* appId_;
    NSString* appKey_;
    NSString* inviterCode_;
}

+(HuoShuSDKMgr *)getInstance;
+(NSMutableDictionary *)getLoginInfo;


+(void) huoShuSDKInitWithApp_id:(NSString *)appId
                     withAppKey:(NSString *)appKey
                    withGameVer:(NSString *)gameVer
             withIsRequireLogin:(BOOL)isRequireLogin;




-(void)createRoleWithServerId:(NSString *)server_id
                   withRoleId:(NSString *)role_id
                 withRoleName:(NSString *)role_name;

// 角色登录接口
-(void)loginRoleWithServerId:(NSString *)server_id
                  withRoleId:(NSString *)role_id
                withRoleName:(NSString *)role_name
               withRoleLevel:(NSString *)role_level;

// 角色升级接口
-(void)upgradeRoleWithServerId:(NSString *)serverId
                    withRoleId:(NSString *)role_id
                  withRoleName:(NSString *)role_name
                 withRoleLevel:(NSString *)role_level;



// 支付
-(void)openPayWithServerid:(NSString *)serverId
                withRoleId:(NSString *)roleId
             withPayAmount:(NSString *)payAmount
              withCallBack:(NSString *)callBack
                withGoodId:(NSString *)goodId
                 withMoney:(NSString *)money
            withController:(UIViewController *)controller;

@end

