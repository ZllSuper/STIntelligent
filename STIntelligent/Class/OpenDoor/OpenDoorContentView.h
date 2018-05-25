//
//  OpenDoorContentView.h
//  STIntelligent
//
//  Created by 步晓虎 on 2017/5/19.
//  Copyright © 2017年 woshishui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenDoorCircleMenu.h"
#import "OpenDoorMenuItem.h"
#import "SUPopupMenu.h"
#import <CoreLocation/CoreLocation.h>

@interface OpenDoorContentView : UIView <SUDropMenuDelegate, STThemeManagerProtcol,OpenDoorCircleMenuProtcol>

@property (nonatomic, strong) OpenDoorCircleMenu *menu;

@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) SUPopupMenu *popupView;

@property (nonatomic, strong) UIImageView *animateImageView;

@property (nonatomic, strong) UILabel *openSuccLabel;

@property (nonatomic, strong) CLLocationManager *locService;

- (void)showFromTabBarController;

@end
