//
//  HomeDeviceView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/8.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STControl.h"

@interface HomeDeviceView : UIView <STThemeManagerProtcol>

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) STControl *maoYanBtn;

@property (nonatomic, strong) STControl *spOneBtn;

@property (nonatomic, strong) STControl *spTwoBtn;

@property (nonatomic, strong) STControl *spThreeBtn;

@property (nonatomic, strong) STControl *spFourBtn;

@property (nonatomic, weak) DeveicePageModel *pageModel;

- (instancetype)init;

- (void)reloadName;

@end
