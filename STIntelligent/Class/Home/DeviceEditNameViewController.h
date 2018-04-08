//
//  DeviceEditNameViewController.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/8/10.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicePicViewController.h"

@interface DeviceEditNameViewController : UIViewController

@property (nonatomic, assign) DevicePicType type;

- (instancetype)initWithWeakModel:(id)weakModel andType:(DevicePicType)type;

@end
