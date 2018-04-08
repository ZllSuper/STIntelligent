//
//  ODCommunityModel.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODDoorModel.h"

@interface ODCommunityModel : NSObject

@property (nonatomic, strong) NSNumber *comId;

@property (nonatomic, copy) NSString *comName;

@property (nonatomic, copy) NSString *comIntroduce;

@property (nonatomic, strong) NSArray *doorListAll;

@property (nonatomic, strong) NSArray *doorList1;

@property (nonatomic, strong) NSArray *doorList2;

@end
