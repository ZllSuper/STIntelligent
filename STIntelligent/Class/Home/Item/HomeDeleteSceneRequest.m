//
//  HomeDeleteSceneRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/9.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "HomeDeleteSceneRequest.h"

@implementation HomeDeleteSceneRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_Scene,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}


@end
