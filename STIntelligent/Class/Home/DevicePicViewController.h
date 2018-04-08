//
//  DevicePicViewController.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DevicePicType)
{
    DeviceMaoYanPicType,
    DeviceCameraPicType
};

@interface DevicePicViewController : UIViewController

@property (nonatomic, assign) DevicePicType picType;

- (instancetype)initWithDeviceType:(DevicePicType)picType devicModel:(id)deviceModel;

@end

