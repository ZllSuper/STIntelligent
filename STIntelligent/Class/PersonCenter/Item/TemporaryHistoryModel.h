//
//  TemporaryHistoryModel.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/12.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import "PCDoorModel.h"

@interface TemporaryHistoryModel : NSObject

@property (nonatomic, strong) NSNumber *listId;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *PeopleType;

@property (nonatomic, strong) NSNumber *StartTime;

@property (nonatomic, strong) NSNumber *EndTime;

@property (nonatomic, strong) NSArray *Doors;

@property (nonatomic, strong) NSNumber *Start; //0是已经使用，1是待对方使用 2是待对方确认

@end
