//
//  SDKNotifications.h
//  ChannelSDK
//

#import <Foundation/Foundation.h>

extern NSString * const hsGameSwitchAccountNotify;
extern NSString * const hsGameEnterGameNotify;
extern NSString * const hsGameRegisterNotify;
extern NSString * const hsGameExitNotify;                  /**<  退出 */
extern NSString * const hsGameLoginNotify;                    /**< 登录完成的通知*/
extern NSString * const hsGamePaytNotify;                  /**< 支付通知 */
extern NSString * const hsGameShareNotify;                 /**<  分享通知 */
extern NSString * const hsGameCenterNotify;                /**<  用户中心通知  */
extern NSString * const hsGameErrorNotify;                 /**<  出错 */

extern NSString * const hsGamePayResultNotify;            /**<  查看支付结果，客户端不要以此发元宝，以服务器通知为准*/


@interface SDKNotifications : NSObject

@end




