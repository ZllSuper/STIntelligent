//
//  WeiboApiManager.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/17.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "WeiboApiManager.h"

@interface WeiboApiManager() <WBHttpRequestDelegate>

@property (nonatomic, copy) WeiboAuthBack authBack;

@property (nonatomic, copy) NSString *userId;

@end

@implementation WeiboApiManager

+ (WeiboApiManager *)shareManager
{
    static dispatch_once_t onceToken;
    static WeiboApiManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[WeiboApiManager alloc] init];
    });
    return manager;
}

#pragma mark - public
- (void)weiboLoginStartCallBack:(WeiboAuthBack)callBack
{
    self.authBack = callBack;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.doshine.com";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    BOOL ret = [WeiboSDK sendRequest:request];
    if (!ret)
    {
        BXHLog(@"微博登录失败");
    }
}

- (void)weiboLogOut
{
//    [WeiboSDK logOutWithToken:<#(NSString *)#> delegate:self withTag:@"user1"];
}
//- (void)ssoOutButtonPressed
//{
//    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [WeiboSDK logOutWithToken:myDelegate.wbtoken delegate:self withTag:@"user1"];
//}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if (self.authBack)
        {
            if (response.statusCode == WeiboSDKResponseStatusCodeSuccess)
            {
                [self getWeiBoUserInfo:[(WBAuthorizeResponse *)response userID] token:[(WBAuthorizeResponse *)response accessToken]];
            }
            else
            {
                self.authBack(NO, @"登录失败", [(WBAuthorizeResponse *)response userID],nil,nil);
            }
        }
    }
}

- (void)getWeiBoUserInfo:(NSString *)uid token:(NSString *)token
{
    self.userId = uid;
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:@{@"uid" : uid, @"access_token": token, @"source" : @"3049638805"} delegate:self withTag:@"me"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *headerImage = dic[@"avatar_large"];
    NSString *nickName = dic[@"name"];
    self.authBack(YES, @"登录成功", self.userId, nickName, headerImage);
}


@end
