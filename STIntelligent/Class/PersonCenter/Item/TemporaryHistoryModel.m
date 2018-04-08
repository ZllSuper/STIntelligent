//
//  TemporaryHistoryModel.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "TemporaryHistoryModel.h"

@implementation TemporaryHistoryModel

- (NSDictionary *)bxhReplaceKeyFormPropertyNames
{
    return @{@"listId" : @"Id"};
}

- (void)keyValueToObjecDidFinish
{
    if (self.Doors && self.Doors.count > 0)
    {
       self.Doors = [PCDoorModel bxhObjectArrayWithKeyValuesArray:self.Doors];
    }
}

@end
