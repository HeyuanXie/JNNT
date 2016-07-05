//
//  ShareSDKThirdLoginHelper.m
//  ZhiMaDi
//
//  Created by haijie on 16/7/4.
//  Copyright © 2016年 ZhiMaDi. All rights reserved.
//

#import "ShareSDKThirdLoginHelper.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

@implementation ShareSDKThirdLoginHelper : NSObject

-(void)login {
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeSinaWeibo
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       NSLog(@"dd%@",user.rawData);
                                       NSLog(@"dd%@",user.credential);
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        
                                    }
                                    
                                }];

}

@end

