//
//  PCCommunityListModel.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCCommunityListModel.h"

@implementation PCCommunityListModel


- (NSString *)statueStr
{
    //1通过，2审核中，0未通过
    
    switch ([self.ActivatedState integerValue])
    {
        case 1:
            
            return @"通过";
        case 0:
            
            return @"未通过";

        default:
            return @"审核中";
    }
}

@end
