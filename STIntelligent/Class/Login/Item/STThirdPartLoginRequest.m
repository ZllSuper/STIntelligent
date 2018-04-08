//
//  STThirdPartLoginRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/5.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "STThirdPartLoginRequest.h"

@implementation STThirdPartLoginRequest

- (void)serializeHTTPRequest
{
    [super serializeHTTPRequest];
    NSDictionary *sourceDict = [self bxhkeyValues];
    self.relativeUrlString = [NSString stringWithFormat:KURL_Login,[sourceDict httpBody]];;
    self.method = BXHRequestMethodPost;
}



@end
