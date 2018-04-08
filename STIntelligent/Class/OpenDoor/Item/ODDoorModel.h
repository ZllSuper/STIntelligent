//
//  ODDoorModel.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/7/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODDoorModel : NSObject

@property (nonatomic, strong) NSNumber *did;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *isOnline;

@property (nonatomic, copy) NSString *gName;

@property (nonatomic, assign) BOOL select;

@end
