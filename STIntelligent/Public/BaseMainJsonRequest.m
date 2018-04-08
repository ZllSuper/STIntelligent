//
//  BaseMainJsonRequest.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "BaseMainJsonRequest.h"

NSString * const MainRequestKey = @"MainRequestKey";

@implementation BaseMainJsonRequest

- (instancetype) init
{
    if (self = [super init])
    {
        BXHNetWorkPartManager *manager = [[[BXHRequestEngine defaultEngine] managers] objectForKey:MainRequestKey];
        if (!manager)
        {
            manager = [BXHNetWorkPartManager mangerWithHost:BaseRequestHost andsessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] valueKey:MainRequestKey];
            [[BXHRequestEngine defaultEngine].managers setValue:manager forKey:MainRequestKey];
        }
        
        self.timeOut = 30;
        self.manager = manager;
        self.requestSerializerType = BXHRequestSerializerTypeJSON;
        self.responseSerializerType = BXHResponseSerializerTypeJSON;
    }
    return self;
}

- (void)setRelativeUrlString:(NSString *)relativeUrlString
{
    relativeUrlString = [[relativeUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [super setRelativeUrlString:relativeUrlString];
}

@end
