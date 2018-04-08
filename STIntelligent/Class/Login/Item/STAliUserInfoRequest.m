//
//  STAliUserInfoRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/10/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "STAliUserInfoRequest.h"

@implementation STAliUserInfoRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    self.relativeUrlString = [NSString stringWithFormat:@"/api/Alipay?code=%@",self.code];;
    self.method = BXHRequestMethodGet;
}

@end
