//
//  HomeSceneListRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/31.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomeSceneListRequest.h"

@implementation HomeSceneListRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_Scene,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}

@end
