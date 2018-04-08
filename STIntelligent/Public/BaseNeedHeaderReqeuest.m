//
//  BaseNeedHeaderReqeuest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseNeedHeaderReqeuest.h"
#import "STTokenGetRequest.h"

@implementation BaseNeedHeaderReqeuest

- (NSDictionary *)requestHeaderFieldValueDictionary
{
    NSString *interval = [NSString stringWithFormat:@"%ld",(long)([[NSDate date] timeIntervalSince1970] * 1000)];
    return @{@"staffid": LocalStaffid,@"timestamp" : interval, @"signature":  [[NSUserDefaults standardUserDefaults] objectForKey:LocalTokenCacheKey]};
}

- (void)deserializeHTTPResponse
{
    [super deserializeHTTPResponse];
    
    if ([self.response.code integerValue] == 403)
    {
        [self tokenGet];
    }
}

- (void)tokenGet
{
    STTokenGetRequest *request = [[STTokenGetRequest alloc] init];
    request.staffId = @"100";
    [request requestWithSuccess:^(BXHBaseRequest *request) {
        if ([request.response.code integerValue] == 200)
        {
            [[NSUserDefaults standardUserDefaults] setObject:request.response.data[@"SignToken"] forKey:LocalTokenCacheKey];
        }
        
        
    } failure:^(NSError *error, BXHBaseRequest *request) {

    }];
}


@end
