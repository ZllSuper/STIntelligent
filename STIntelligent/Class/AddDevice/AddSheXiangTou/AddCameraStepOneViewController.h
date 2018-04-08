//
//  AddCameraStepOneViewController.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/6/6.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger, VCType)
{
    VCTypeWife,
    VCTypeAdd
};

@interface AddCameraStepOneViewController : UIViewController

- (instancetype)initWithVCType:(VCType)type;

@end
