//
//  LoginAty.h
//
//  Created by zhaoyun on 2018/9/3.
//  Copyright © 2018年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDKLoginAty : UIViewController{
    NSString *hsGameLoginUserName;
    NSString *hsGameLoginPassword;
    
}

@property(retain,nonatomic) NSString *hsGameLoginUserName;
@property(retain,nonatomic) NSString *hsGameLoginPassword;


+(SDKLoginAty *)hsGameGetInstance;



@end

