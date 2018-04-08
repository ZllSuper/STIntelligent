//
//  ODCommunityModel.m
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "ODCommunityModel.h"

@implementation ODCommunityModel

- (void)keyValueToObjecDidFinish
{
    NSMutableArray *doorAry = [NSMutableArray array];
    if (self.doorList1.count > 0)
    {
        [doorAry addObjectsFromArray:[ODDoorModel bxhObjectArrayWithKeyValuesArray:self.doorList1]];
    }
    
    for (NSArray *tempAry in self.doorList2)
    {
        [doorAry addObjectsFromArray:[ODDoorModel bxhObjectArrayWithKeyValuesArray:tempAry]];
    }
    self.doorListAll = [NSArray arrayWithArray:doorAry];
}


@end
