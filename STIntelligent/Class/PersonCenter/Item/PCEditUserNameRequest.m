//
//  PCEditUserNameRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/24.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCEditUserNameRequest.h"

@implementation PCEditUserNameRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    self.relativeUrlString = @"api/User";
    NSMutableDictionary *sourceDict = [NSMutableDictionary dictionaryWithObject:self.cUserId forKey:@"Id"];
    if (!StringIsEmpty(self.nickName))
    {
        [sourceDict setObject:self.nickName forKey:@"NickName"];
    }
    
    if (!StringIsEmpty(self.HeadImg))
    {
        [sourceDict setObject:self.HeadImg forKey:@"HeadImg"];
    }
    self.reuqestBody = sourceDict;
    self.method = BXHRequestMethodPost;
}


@end
