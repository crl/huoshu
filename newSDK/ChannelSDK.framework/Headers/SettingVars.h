//
//  SettingVars.h

//
//  Created by zhaoyun on 2018/8/31.
//  Copyright © 2018年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingVars : NSObject

{
    //是否需要登录,默认为yes需要
    BOOL hsGameIsRequireLogin;
    //appid-SDk服务器分配给cp，cp传入给sdk客户端
    NSString *hsGameGameId;
    //appKey-SDk服务器分配给cp，cp传入给sdk客户端
    NSString *hsGameGameKey;
    // 游戏版本号
    NSString *hsGameGameVer;
    // 游戏的角色ID
    NSString *hsGameRoleId;
    // 游戏的角色名称
    NSString *hsGameRoleName;
    // 角色等级
    NSString *hsGameRolelevel;
    // 游戏服务器id
    NSString *hsGameServerId;
    // webview的宽度
    int hsGameWebviewWidth;
    // webview的高度
    int hsGameWebviewHight;
    //苹果支付的商品id，由cp传进来
    NSString *hsGameProductIdentifier;
    //平台的订单tradeId
    NSString *hsGameTradeId;
    // 充值金额，热云统计用到
    NSString *hsGamePayMoney;
    // 游戏订单号
    NSString *hsGamePayCallback;
    
    BOOL hsGameIsDebug;
    
    BOOL hsGameIsSubmiting;
    
    // 支付方式，热云统计用到(add in 0408)
    NSString *hsGamePayType;
    
}

//是否需要登录,默认为yes需要
@property(assign,nonatomic) BOOL hsGameIsNeedLogin;
//appid-SDk服务器分配给cp，cp传入给sdk客户端
@property(retain,nonatomic) NSString *hsGameGameId;
//appKey-SDk服务器分配给cp，cp传入给sdk客户端
@property(retain,nonatomic) NSString *hsGameGameKey;
// 游戏版本号
@property(retain,nonatomic) NSString *hsGameGameVersion;
// webview的宽度
@property(assign,nonatomic) int hsGameWebviewWidth;
// webview的高度
@property(assign,nonatomic) int hsGameWebviewHight;
//游戏的角色名称，由cp传进来
@property(retain,nonatomic) NSString *hsGameRoleName;
//游戏的角色ID，由cp传进来
@property(retain,nonatomic) NSString *hsGameRoleId;
//游戏的角色等级，由cp传进来
@property(retain,nonatomic) NSString *hsGameRolelevel;
//游戏的服务器ID，由cp传进来
@property(retain,nonatomic) NSString *hsGameServerId;
//苹果支付的商品id，由cp传进来
@property(retain,nonatomic) NSString *hsGameProductIdentifier;
//平台的订单tradeId
@property(retain,nonatomic) NSString *hsGameTradeId;
// 充值金额，热云统计用到
@property(retain,nonatomic) NSString *hsGamePayMoney;
// 游戏订单号
@property(retain,nonatomic) NSString *hsGamePayCallback;

@property(assign,nonatomic) BOOL hsGameIsDebug;

@property(assign,nonatomic) BOOL hsGameIsSubmiting;

@property(retain,nonatomic) NSString *hsGamePayType;

+ (SettingVars *)hsGameGetInstance;

// 所有接口都需要传的公共字段
+(NSMutableDictionary *)hsGameGetParameters;
+(NSMutableDictionary *)hsGameGetParameters1:(NSString *)userName andPwd:(NSString *)password;




+ (NSString *)hsGameDealWithParam:(NSMutableDictionary *)param;

+(NSString *) hsGameSortDict:(NSDictionary *) dict;
// md5加密
-(NSString *)hsGameMd5:(NSString *)str;

@end

