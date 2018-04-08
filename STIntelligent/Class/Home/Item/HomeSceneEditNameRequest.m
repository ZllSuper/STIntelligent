//
//  HomeSceneEditNameRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/4.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomeSceneEditNameRequest.h"

@implementation HomeSceneEditNameRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_Scene,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}

@end
