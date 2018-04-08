//
//  CameraDelRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/3.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "CameraDelRequest.h"

@implementation CameraDelRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_MaoYanAdd,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}


@end
